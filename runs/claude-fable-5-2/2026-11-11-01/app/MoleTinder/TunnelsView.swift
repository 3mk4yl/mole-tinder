import SwiftUI

/// Your matches. Moles do not type: you thump down the tunnel and they answer.
struct TunnelsView: View {
    @Environment(Burrow.self) private var burrow
    @Environment(Senses.self) private var senses
    @State private var active: Int?

    var body: some View {
        VStack(spacing: 8) {
            Text("YOUR TUNNELS")
                .font(Soil.font(34))
                .foregroundStyle(Soil.glow)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 4)

            if burrow.tunnels.isEmpty {
                empty
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(burrow.tunnels) { tunnel in
                            row(tunnel)
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
    }

    private func row(_ tunnel: Tunnel) -> some View {
        let mole = tunnel.mole
        return Button {
            thump(at: mole)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(mole.tint)
                    if active == mole.id {
                        SeismicView(tint: Soil.ink)
                    } else {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 30, weight: .black))
                            .foregroundStyle(Soil.black)
                    }
                }
                .frame(width: 76, height: 76)

                VStack(alignment: .leading, spacing: 4) {
                    Text(mole.name.uppercased())
                        .font(Soil.font(30))
                        .foregroundStyle(mole.tint)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    Text(tunnel.lastReply ?? "Smells of \(mole.scent). Tap to thump.")
                        .font(Soil.font(18))
                        .foregroundStyle(Soil.ink)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
            .background(Soil.dirt, in: RoundedRectangle(cornerRadius: 26))
            .overlay {
                RoundedRectangle(cornerRadius: 26)
                    .strokeBorder(mole.tint, lineWidth: active == mole.id ? 6 : 0)
            }
        }
        .accessibilityLabel("\(mole.name). \(tunnel.lastReply ?? "No thumps yet.")")
        .accessibilityHint("Tap to thump at them.")
    }

    /// Your knock goes down the tunnel, then they drum back and answer.
    private func thump(at mole: Mole) {
        active = mole.id
        let reply = burrow.thumpAt(mole)
        let knock = [Thump(delay: 0, strength: 1), Thump(delay: 0.18, strength: 1)]
        let pause = [Thump(delay: 0.7, strength: mole.signature.first?.strength ?? 1)]
        senses.thump(knock + pause + mole.signature.dropFirst())
        senses.say("\(mole.name) says: \(reply)", pitch: mole.voicePitch)
        Task {
            try? await Task.sleep(for: .seconds(3))
            if active == mole.id { active = nil }
        }
    }

    private var empty: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(systemName: "circle.dotted")
                .font(.system(size: 90, weight: .black))
                .foregroundStyle(Soil.glow)
            Text("NO TUNNELS\nYET")
                .font(Soil.font(44))
                .multilineTextAlignment(.center)
                .foregroundStyle(Soil.ink)
            Text("Dig toward a mole.\nIf they dig back, your tunnels meet.")
                .font(Soil.font(20))
                .multilineTextAlignment(.center)
                .foregroundStyle(Soil.ink.opacity(0.8))
            Spacer()
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
