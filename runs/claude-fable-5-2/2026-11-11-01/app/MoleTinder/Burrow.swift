import SwiftUI

/// A tunnel that two moles dug toward each other.
struct Tunnel: Identifiable {
    let mole: Mole
    var lastReply: String?
    var replyIndex = 0
    var id: Int { mole.id }
}

/// App state: the deck of nearby moles, and the tunnels (matches) you share.
@MainActor
@Observable
final class Burrow {
    private(set) var deck: [Mole] = Mole.all
    private(set) var tunnels: [Tunnel] = []
    private(set) var passed: [Mole] = []
    var freshMatch: Mole?

    var current: Mole? { deck.first }

    /// Returns true when the like turned into a match.
    @discardableResult
    func digToward(_ mole: Mole) -> Bool {
        deck.removeAll { $0.id == mole.id }
        guard mole.likesYou else {
            // They did not dig back. They return to the soil for another try later.
            passed.append(mole)
            return false
        }
        tunnels.insert(Tunnel(mole: mole), at: 0)
        freshMatch = mole
        return true
    }

    func burrowAway(_ mole: Mole) {
        deck.removeAll { $0.id == mole.id }
        passed.append(mole)
    }

    /// Bring back every mole you have not matched with.
    func digAgain() {
        deck = passed
        passed = []
    }

    /// Send a thump down a tunnel; returns the mole's reply.
    func thumpAt(_ mole: Mole) -> String {
        guard let i = tunnels.firstIndex(where: { $0.id == mole.id }) else { return "" }
        let reply = mole.replies[tunnels[i].replyIndex % mole.replies.count]
        tunnels[i].replyIndex += 1
        tunnels[i].lastReply = reply
        return reply
    }
}
