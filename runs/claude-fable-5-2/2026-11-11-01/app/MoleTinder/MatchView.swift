import SwiftUI

/// "It's a match", mole edition: the whole burrow shakes.
struct MatchView: View {
    @Environment(Senses.self) private var senses
    let mole: Mole
    let onClose: (_ goToTunnels: Bool) -> Void
    @State private var shake = false
    @State private var flash = false

    var body: some View {
        ZStack {
            (flash ? mole.tint : Soil.black).ignoresSafeArea()

            VStack(spacing: 14) {
                Spacer()
                Text("THE EARTH\nMOVED!")
                    .font(Soil.font(60))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(flash ? Soil.black : Soil.glow)
                    .offset(x: shake ? -7 : 7)

                SeismicView(tint: mole.tint)
                    .frame(height: 200)

                Text("YOU AND \(mole.name.uppercased())\nDUG TOWARD EACH OTHER")
                    .font(Soil.font(24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Soil.ink)
                    .minimumScaleFactor(0.6)
                Spacer()

                Button { onClose(true) } label: {
                    Text("GO TO TUNNEL")
                        .font(Soil.font(28))
                        .foregroundStyle(Soil.black)
                        .frame(maxWidth: .infinity, minHeight: 96)
                        .background(Soil.like, in: RoundedRectangle(cornerRadius: 28))
                }
                Button { onClose(false) } label: {
                    Text("KEEP SNIFFING")
                        .font(Soil.font(24))
                        .foregroundStyle(Soil.ink)
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(Soil.dirt, in: RoundedRectangle(cornerRadius: 28))
                }
            }
            .padding(16)
        }
        .onAppear {
            senses.earthquake()
            senses.say("The earth moved! You and \(mole.name) dug toward each other.")
            withAnimation(.linear(duration: 0.07).repeatCount(17, autoreverses: true)) {
                shake = true
            }
            // Three bright flashes: even a mole notices light versus dark.
            Task {
                for _ in 0..<3 {
                    flash = true
                    try? await Task.sleep(for: .seconds(0.12))
                    flash = false
                    try? await Task.sleep(for: .seconds(0.18))
                }
            }
        }
    }
}
