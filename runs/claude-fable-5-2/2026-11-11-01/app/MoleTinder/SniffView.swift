import SwiftUI

/// Browse nearby moles. The whole screen is one gesture surface:
/// swipe right to dig toward, left to burrow away, tap to feel the thump.
struct SniffView: View {
    @Environment(Burrow.self) private var burrow
    @Environment(Senses.self) private var senses
    @State private var drag: CGSize = .zero
    @State private var leaving = false

    private let threshold: CGFloat = 90

    var body: some View {
        VStack(spacing: 8) {
            header
            if let mole = burrow.current {
                card(for: mole)
                    .id(mole.id)
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
                actionBar(for: mole)
            } else {
                emptySoil
            }
        }
        .padding(.horizontal, 8)
        .animation(.spring(duration: 0.35), value: burrow.current)
    }

    private var header: some View {
        HStack {
            Text("MOLE TINDER")
                .font(Soil.font(20))
                .foregroundStyle(Soil.glow)
            Spacer()
            Button {
                senses.voiceOn.toggle()
                senses.tick()
                if senses.voiceOn { senses.say("Voice on.") }
            } label: {
                Image(systemName: senses.voiceOn ? "speaker.wave.3.fill" : "speaker.slash.fill")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(senses.voiceOn ? Soil.black : Soil.ink)
                    .frame(width: 64, height: 48)
                    .background(senses.voiceOn ? Soil.glow : Soil.dirt, in: Capsule())
            }
            .accessibilityLabel(senses.voiceOn ? "Voice on. Tap to silence." : "Voice off. Tap to hear profiles.")
        }
        .padding(.horizontal, 8)
    }

    // MARK: Card

    private func card(for mole: Mole) -> some View {
        let lean = max(-1, min(1, drag.width / threshold))
        return VStack(spacing: 10) {
            VStack(spacing: 2) {
                Text(mole.name.uppercased())
                    .font(Soil.font(50))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(mole.tint)
                Text("\(mole.seasons) SEASONS · \(mole.tunnelLengthsAway) TUNNELS AWAY · \(mole.depthCm) CM DOWN")
                    .font(Soil.font(15))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(Soil.ink)
            }

            SeismicView(tint: mole.tint)
                .frame(minHeight: 110, maxHeight: 220)
                .overlay(alignment: .bottom) {
                    Text("TAP TO FEEL THE THUMP")
                        .font(Soil.font(13))
                        .foregroundStyle(Soil.ink.opacity(0.7))
                }

            VStack(alignment: .leading, spacing: 10) {
                sense("nose.fill", "SCENT", mole.scent, mole.tint)
                sense("hand.raised.fill", "FUR", mole.fur, mole.tint)
                sense("arrow.down.right.circle.fill", "DIGS", mole.digStyle, mole.tint)
                sense("fork.knife", "WORM", mole.favouriteWorm, mole.tint)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Soil.dirt, in: RoundedRectangle(cornerRadius: 32))
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .strokeBorder(lean > 0 ? Soil.like : Soil.pass, lineWidth: 10)
                .opacity(abs(lean))
        }
        .overlay { verdict(lean: lean) }
        .offset(x: drag.width, y: drag.height * 0.2)
        .rotationEffect(.degrees(drag.width / 22))
        .contentShape(RoundedRectangle(cornerRadius: 32))
        .onTapGesture {
            senses.say(mole.name, pitch: mole.voicePitch)
            senses.thump(mole.signature)
        }
        .gesture(
            DragGesture(minimumDistance: 12)
                .onChanged { value in
                    let wasPast = abs(drag.width) > threshold
                    drag = value.translation
                    // A tick when the paw crosses the point of no return.
                    if (abs(drag.width) > threshold) != wasPast { senses.tick() }
                }
                .onEnded { value in
                    if value.translation.width > threshold {
                        decide(mole, like: true)
                    } else if value.translation.width < -threshold {
                        decide(mole, like: false)
                    } else {
                        withAnimation(.spring(duration: 0.3)) { drag = .zero }
                    }
                }
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(mole.spokenProfile)
        .accessibilityHint("Swipe right to dig toward, left to burrow away.")
        .accessibilityAction(named: "Dig toward") { decide(mole, like: true) }
        .accessibilityAction(named: "Burrow away") { decide(mole, like: false) }
    }

    private func sense(_ symbol: String, _ label: String, _ value: String, _ tint: Color) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 26, weight: .black))
                .foregroundStyle(tint)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(Soil.font(13))
                    .foregroundStyle(tint)
                Text(value)
                    .font(Soil.font(21))
                    .foregroundStyle(Soil.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    /// The word that floods the card while dragging: big enough to be a blur of colour.
    private func verdict(lean: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(lean > 0 ? Soil.like : Soil.pass)
            Text(lean > 0 ? "DIG!" : "NOPE")
                .font(Soil.font(92))
                .foregroundStyle(Soil.black)
        }
        .opacity(Double(abs(lean)) * 0.9)
        .allowsHitTesting(false)
    }

    // MARK: Actions

    private func actionBar(for mole: Mole) -> some View {
        HStack(spacing: 6) {
            Button { decide(mole, like: false) } label: {
                slab("BURROW\nAWAY", "arrow.left", Soil.pass)
            }
            Button { decide(mole, like: true) } label: {
                slab("DIG\nTOWARD", "arrow.right", Soil.like)
            }
        }
    }

    private func slab(_ title: String, _ symbol: String, _ color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: symbol).font(.system(size: 30, weight: .black))
            Text(title).font(Soil.font(22)).multilineTextAlignment(.leading)
        }
        .foregroundStyle(Soil.black)
        .frame(maxWidth: .infinity, minHeight: 92)
        .background(color, in: RoundedRectangle(cornerRadius: 24))
    }

    private func decide(_ mole: Mole, like: Bool) {
        guard !leaving else { return }
        leaving = true
        withAnimation(.easeIn(duration: 0.22)) {
            drag = CGSize(width: like ? 600 : -600, height: 0)
        }
        Task {
            try? await Task.sleep(for: .seconds(0.22))
            var matched = false
            if like {
                matched = burrow.digToward(mole)
                if !matched { senses.digToward() }
            } else {
                burrow.burrowAway(mole)
                senses.burrowAway()
            }
            drag = .zero
            leaving = false
            guard !matched else { return }   // The match screen takes over the talking.
            let verdict = like ? "Dug toward \(mole.name). " : "Burrowed away. "
            if let next = burrow.current {
                senses.say(verdict + "Next. " + next.spokenProfile, pitch: next.voicePitch)
                senses.thump(next.signature, after: 0.9)
            } else {
                senses.say(verdict + "The soil is quiet. No more moles nearby.")
            }
        }
    }

    // MARK: Empty

    private var emptySoil: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 80))
                .foregroundStyle(Soil.glow)
            Text("THE SOIL\nIS QUIET")
                .font(Soil.font(46))
                .multilineTextAlignment(.center)
                .foregroundStyle(Soil.ink)
            Text("No more moles nearby.")
                .font(Soil.font(22))
                .foregroundStyle(Soil.ink.opacity(0.8))
            Spacer()
            if !burrow.passed.isEmpty {
                Button {
                    burrow.digAgain()
                    senses.hit(1)
                    if let next = burrow.current {
                        senses.say("Digging again. " + next.spokenProfile, pitch: next.voicePitch)
                        senses.thump(next.signature, after: 0.9)
                    }
                } label: {
                    Text("DIG AGAIN")
                        .font(Soil.font(30))
                        .foregroundStyle(Soil.black)
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(Soil.glow, in: RoundedRectangle(cornerRadius: 28))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// A seismograph for the eyes: every haptic beat sends a ring through the soil.
/// It stands where a profile photo would be in an app for creatures with eyesight.
struct SeismicView: View {
    @Environment(Senses.self) private var senses
    let tint: Color
    @State private var rings: [Ring] = []

    struct Ring: Identifiable {
        let id: Int
        let strength: Double
    }

    var body: some View {
        ZStack {
            ForEach(rings) { ring in
                RippleRing(tint: tint, strength: ring.strength)
            }
            Circle()
                .fill(tint)
                .frame(width: 54, height: 54)
            Image(systemName: "pawprint.fill")
                .font(.system(size: 26, weight: .black))
                .foregroundStyle(Soil.black)
        }
        .frame(maxWidth: .infinity)
        .onChange(of: senses.beat) { _, beat in
            rings.append(Ring(id: beat, strength: senses.beatStrength))
            Task {
                try? await Task.sleep(for: .seconds(1.0))
                rings.removeAll { $0.id == beat }
            }
        }
        .accessibilityHidden(true)
    }
}

private struct RippleRing: View {
    let tint: Color
    let strength: Double
    @State private var grown = false

    var body: some View {
        Circle()
            .stroke(tint, lineWidth: 4 + 14 * strength)
            .scaleEffect(grown ? 1.0 : 0.25)
            .opacity(grown ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: 0.9)) { grown = true }
            }
    }
}
