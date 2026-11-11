import SwiftUI

/// One beat of a mole's seismic signature: wait, then hit the tunnel wall.
struct Thump: Hashable {
    let delay: Double      // seconds to wait before this beat
    let strength: Double   // 0...1
}

/// A mole profile. There are no photos: nobody here could see them anyway.
/// A mole is known by scent, fur, and the way they drum on the earth.
struct Mole: Identifiable, Hashable {
    let id: Int
    let name: String
    let seasons: Int
    let species: String
    let tunnelLengthsAway: Int
    let depthCm: Int
    let scent: String
    let fur: String
    let digStyle: String
    let favouriteWorm: String
    let bio: String
    let replies: [String]
    let signature: [Thump]
    let tint: Color
    let voicePitch: Float
    let likesYou: Bool

    /// What the app reads aloud when this mole surfaces in the deck.
    var spokenProfile: String {
        "\(name). \(seasons) seasons old. \(species). "
        + "\(tunnelLengthsAway) tunnel lengths away, \(depthCm) centimetres down. "
        + "Smells of \(scent). Fur: \(fur). Digs \(digStyle). "
        + "Favourite worm: \(favouriteWorm). \(bio)"
    }

    static func == (a: Mole, b: Mole) -> Bool { a.id == b.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension Mole {
    private static func beats(_ pairs: (Double, Double)...) -> [Thump] {
        pairs.map { Thump(delay: $0.0, strength: $0.1) }
    }

    static let all: [Mole] = [
        Mole(id: 1, name: "Gertrude", seasons: 3, species: "European mole",
             tunnelLengthsAway: 12, depthCm: 40,
             scent: "wet loam and crushed clover root",
             fur: "dense velvet, brushes both ways",
             digStyle: "slow and thorough",
             favouriteWorm: "fat lobworm, still wriggling",
             bio: "I keep a tidy larder and I am looking for someone to share it with.",
             replies: ["Thump received. My whiskers are tingling.",
                       "Come by my larder. I have four hundred worms and no one to bite them for.",
                       "I felt that one in my whole tunnel."],
             signature: beats((0, 1), (0.45, 0.5), (0.45, 1)),
             tint: .yellow, voicePitch: 1.2, likesYou: true),

        Mole(id: 2, name: "Bartholomew", seasons: 4, species: "European mole",
             tunnelLengthsAway: 30, depthCm: 65,
             scent: "old oak root and iron-rich clay",
             fur: "coarse, with a bald patch from a badger",
             digStyle: "deep, straight, no nonsense",
             favouriteWorm: "anything, I am not fussy",
             bio: "Survived a badger. Will tell you about it.",
             replies: ["Did I mention the badger?",
                       "Strong thump. I respect that.",
                       "Meet me under the oak. You will smell it."],
             signature: beats((0, 1), (0.7, 1), (0.7, 1)),
             tint: .orange, voicePitch: 0.7, likesYou: false),

        Mole(id: 3, name: "Stella", seasons: 2, species: "Star-nosed mole",
             tunnelLengthsAway: 7, depthCm: 20,
             scent: "marsh water and mint",
             fur: "sleek, always a little damp",
             digStyle: "fast, and she swims too",
             favouriteWorm: "aquatic larvae, by the dozen",
             bio: "Twenty-two nose tentacles. Yes, I will touch your face. That is how I say hello.",
             replies: ["Boop. That was my nose. All of it.",
                       "I can smell underwater. Can you? Come and find out.",
                       "You thump like someone with excellent paws."],
             signature: beats((0, 0.6), (0.15, 0.6), (0.15, 0.6), (0.15, 0.6), (0.4, 1)),
             tint: .pink, voicePitch: 1.5, likesYou: true),

        Mole(id: 4, name: "Mortimer", seasons: 5, species: "European mole",
             tunnelLengthsAway: 55, depthCm: 90,
             scent: "dry chalk and last autumn's leaves",
             fur: "silvering, very soft behind the shoulders",
             digStyle: "patient, with long pauses",
             favouriteWorm: "aged brandling, from the compost heap",
             bio: "An old mole with a deep tunnel and nowhere to be.",
             replies: ["Ah. A visitor. How nice.",
                       "I shall put a worm aside for you.",
                       "Take your time. The soil is not going anywhere."],
             signature: beats((0, 0.8), (1.0, 0.8)),
             tint: .cyan, voicePitch: 0.6, likesYou: true),

        Mole(id: 5, name: "Clementine", seasons: 2, species: "European mole",
             tunnelLengthsAway: 18, depthCm: 35,
             scent: "fresh molehill and dandelion",
             fur: "short, springy, recently groomed",
             digStyle: "upward, she loves making hills",
             favouriteWorm: "small red wigglers",
             bio: "Forty molehills on one lawn in a single night. The gardener still talks about me.",
             replies: ["Race you to the surface!",
                       "I made a hill for you. You cannot see it. Neither can I.",
                       "Thump thump yourself."],
             signature: beats((0, 0.5), (0.2, 0.7), (0.2, 1), (0.5, 0.5), (0.2, 1)),
             tint: .green, voicePitch: 1.4, likesYou: false),

        Mole(id: 6, name: "Digby", seasons: 3, species: "European mole",
             tunnelLengthsAway: 4, depthCm: 50,
             scent: "peat, rain, and a little bit of beetle",
             fur: "thick and warm, slightly muddy",
             digStyle: "enthusiastic, in every direction",
             favouriteWorm: "whichever one you are having",
             bio: "My tunnels are a mess but they all lead somewhere good.",
             replies: ["You are only four tunnel lengths away! I am digging already.",
                       "Sorry, hit a rock. Still coming.",
                       "I can feel you through the wall."],
             signature: beats((0, 1), (0.25, 1), (0.25, 0.4), (0.25, 1)),
             tint: .mint, voicePitch: 1.0, likesYou: true),

        Mole(id: 7, name: "Hyacinth", seasons: 4, species: "Eastern mole",
             tunnelLengthsAway: 41, depthCm: 25,
             scent: "sandy soil warmed from above",
             fur: "fine, pale, smooth as silt",
             digStyle: "shallow and elegant",
             favouriteWorm: "grubs, lightly chewed",
             bio: "I only dig in well-drained ground. Standards matter.",
             replies: ["Acceptable thump.",
                       "Wipe your paws before you come in.",
                       "You may approach from the east tunnel."],
             signature: beats((0, 0.4), (0.3, 0.4), (0.6, 0.9)),
             tint: .purple, voicePitch: 1.3, likesYou: false),

        Mole(id: 8, name: "Rufus", seasons: 1, species: "European mole",
             tunnelLengthsAway: 9, depthCm: 15,
             scent: "new grass roots and his mother's nest",
             fur: "baby-soft, not fully grown in",
             digStyle: "wobbly but getting better",
             favouriteWorm: "has only tried two kinds so far",
             bio: "Just left the nest. This is my first tunnel. Please be kind.",
             replies: ["Oh! Hello! Was that for me?",
                       "I dug the wrong way. One moment.",
                       "I like your thump very much."],
             signature: beats((0, 0.3), (0.2, 0.5), (0.35, 0.3), (0.15, 0.8)),
             tint: .teal, voicePitch: 1.6, likesYou: true),

        Mole(id: 9, name: "Agnes", seasons: 3, species: "Hairy-tailed mole",
             tunnelLengthsAway: 23, depthCm: 45,
             scent: "pine needles and cold stone",
             fur: "long guard hairs, and that famous tail",
             digStyle: "at night, under the forest floor",
             favouriteWorm: "millipedes, for the crunch",
             bio: "I come up after dark to forage. I would rather not do it alone.",
             replies: ["Meet me under the pines when the ground cools.",
                       "I heard you. I always hear you.",
                       "Bring a millipede."],
             signature: beats((0, 0.9), (0.2, 0.3), (0.2, 0.3), (0.5, 0.9)),
             tint: .indigo, voicePitch: 0.9, likesYou: true),
    ]
}
