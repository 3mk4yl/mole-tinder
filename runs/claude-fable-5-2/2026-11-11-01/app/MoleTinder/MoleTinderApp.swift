import SwiftUI

@main
struct MoleTinderApp: App {
    @State private var burrow = Burrow()
    @State private var senses = Senses()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(burrow)
                .environment(senses)
                .preferredColorScheme(.dark)   // It is always dark down here.
        }
    }
}

/// Shared look: pitch black, huge type, a few very loud colours.
/// For eyes that can tell light from dark and not much more.
enum Soil {
    static let black = Color.black
    static let dirt = Color(red: 0.13, green: 0.10, blue: 0.07)
    static let like = Color(red: 0.45, green: 1.0, blue: 0.3)
    static let pass = Color(red: 1.0, green: 0.35, blue: 0.25)
    static let ink = Color.white
    static let glow = Color.yellow

    static func font(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .rounded)
    }
}

enum Chamber { case sniff, tunnels }

struct RootView: View {
    @Environment(Burrow.self) private var burrow
    @Environment(Senses.self) private var senses
    @State private var chamber: Chamber = .sniff
    @State private var welcomed = false

    var body: some View {
        ZStack {
            Soil.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Group {
                    switch chamber {
                    case .sniff: SniffView()
                    case .tunnels: TunnelsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                chamberBar
            }

            if let mole = burrow.freshMatch {
                MatchView(mole: mole) { goToTunnels in
                    burrow.freshMatch = nil
                    if goToTunnels { enter(.tunnels) } else { announceCurrent() }
                }
                .transition(.opacity)
                .zIndex(2)
            }

            if !welcomed {
                WelcomeView {
                    welcomed = true
                    announceCurrent()
                }
                .transition(.opacity)
                .zIndex(3)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: welcomed)
        .animation(.easeInOut(duration: 0.25), value: burrow.freshMatch)
    }

    /// Two enormous slabs instead of a tab bar: impossible to miss with a paw.
    private var chamberBar: some View {
        HStack(spacing: 6) {
            chamberButton(.sniff, title: "SNIFF", symbol: "nose.fill")
            chamberButton(.tunnels,
                          title: burrow.tunnels.isEmpty ? "TUNNELS" : "TUNNELS \(burrow.tunnels.count)",
                          symbol: "point.topleft.down.to.point.bottomright.curvepath.fill")
        }
        .padding(.horizontal, 6)
        .padding(.top, 6)
    }

    private func chamberButton(_ target: Chamber, title: String, symbol: String) -> some View {
        let on = chamber == target
        return Button {
            enter(target)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: symbol)
                Text(title)
            }
            .font(Soil.font(22))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .foregroundStyle(on ? Soil.black : Soil.ink)
            .frame(maxWidth: .infinity, minHeight: 68)
            .background(on ? Soil.glow : Soil.dirt, in: RoundedRectangle(cornerRadius: 20))
        }
        .accessibilityAddTraits(on ? .isSelected : [])
    }

    private func enter(_ target: Chamber) {
        chamber = target
        senses.tick()
        switch target {
        case .sniff:
            announceCurrent()
        case .tunnels:
            let n = burrow.tunnels.count
            senses.say(n == 0
                       ? "Your tunnels. None yet. Go and sniff someone out."
                       : "Your tunnels. \(n) \(n == 1 ? "mole" : "moles"). Tap one to thump at them.")
        }
    }

    private func announceCurrent() {
        guard chamber == .sniff else { return }
        if let mole = burrow.current {
            senses.say(mole.spokenProfile, pitch: mole.voicePitch)
            senses.thump(mole.signature, after: 0.3)
        } else {
            senses.say("The soil is quiet. No more moles nearby. Tap dig again to sniff around once more.")
        }
    }
}

/// First launch: explains the paw gestures, out loud.
struct WelcomeView: View {
    @Environment(Senses.self) private var senses
    let onStart: () -> Void

    private let intro = "Welcome to Mole Tinder. No pictures down here. "
        + "Each mole is read to you, and you will feel how they thump. "
        + "Swipe right to dig toward a mole. Swipe left to burrow away. "
        + "Tap to feel their thump again. Tap anywhere to start."

    var body: some View {
        ZStack {
            Soil.black.ignoresSafeArea()
            VStack(spacing: 22) {
                Spacer()
                Text("MOLE\nTINDER")
                    .font(Soil.font(68))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Soil.glow)
                Text("Love is blind.\nSo are we.")
                    .font(Soil.font(28))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Soil.ink)
                Spacer()
                VStack(alignment: .leading, spacing: 14) {
                    hint("arrow.right", "SWIPE RIGHT: DIG TOWARD", Soil.like)
                    hint("arrow.left", "SWIPE LEFT: BURROW AWAY", Soil.pass)
                    hint("hand.tap.fill", "TAP: FEEL THEIR THUMP", Soil.glow)
                }
                Spacer()
                Text("TAP ANYWHERE TO START")
                    .font(Soil.font(26))
                    .foregroundStyle(Soil.black)
                    .frame(maxWidth: .infinity, minHeight: 96)
                    .background(Soil.glow, in: RoundedRectangle(cornerRadius: 28))
            }
            .padding(20)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            senses.hit(1)
            onStart()
        }
        .onAppear { senses.say(intro) }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(intro)
        .accessibilityAddTraits(.isButton)
    }

    private func hint(_ symbol: String, _ text: String, _ color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: symbol).frame(width: 36)
            Text(text).lineLimit(1).minimumScaleFactor(0.5)
        }
        .font(Soil.font(22))
        .foregroundStyle(color)
    }
}
