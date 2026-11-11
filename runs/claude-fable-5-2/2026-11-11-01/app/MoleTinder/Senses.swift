import SwiftUI
import AVFoundation
import UIKit

/// The app's real interface. Moles can barely see, so everything that matters
/// is delivered as vibration (thumps through the device) and as speech.
/// The screen only mirrors what the paws and ears already know.
@MainActor
@Observable
final class Senses {
    /// Bumped on every beat so views can ripple in time with the haptics.
    private(set) var beat = 0
    private(set) var beatStrength = 1.0
    var voiceOn = true {
        didSet { if !voiceOn { synth.stopSpeaking(at: .immediate) } }
    }

    @ObservationIgnored private let synth = AVSpeechSynthesizer()
    @ObservationIgnored private var thumpTask: Task<Void, Never>?
    @ObservationIgnored private let heavy = UIImpactFeedbackGenerator(style: .heavy)
    @ObservationIgnored private let rigid = UIImpactFeedbackGenerator(style: .rigid)
    @ObservationIgnored private let soft = UIImpactFeedbackGenerator(style: .soft)

    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
    }

    // MARK: Speech

    func say(_ text: String, pitch: Float = 1.0, interrupt: Bool = true) {
        guard voiceOn else { return }
        if interrupt { synth.stopSpeaking(at: .immediate) }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.95
        utterance.pitchMultiplier = min(max(pitch, 0.5), 2.0)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        synth.speak(utterance)
    }

    func hush() {
        synth.stopSpeaking(at: .immediate)
    }

    // MARK: Vibration

    /// Plays a seismic signature: a rhythm of impacts, like paws on a tunnel wall.
    func thump(_ pattern: [Thump], after initialDelay: Double = 0) {
        thumpTask?.cancel()
        thumpTask = Task { [weak self] in
            if initialDelay > 0 {
                try? await Task.sleep(for: .seconds(initialDelay))
            }
            for beat in pattern {
                if beat.delay > 0 {
                    try? await Task.sleep(for: .seconds(beat.delay))
                }
                if Task.isCancelled { return }
                self?.hit(beat.strength)
            }
        }
    }

    /// A single impact.
    func hit(_ strength: Double = 1.0) {
        heavy.impactOccurred(intensity: strength)
        beatStrength = strength
        beat += 1
    }

    /// Dug toward: two firm, rising knocks.
    func digToward() {
        thump([Thump(delay: 0, strength: 0.6), Thump(delay: 0.12, strength: 1)])
    }

    /// Burrowed away: one dull, soft thud.
    func burrowAway() {
        thumpTask?.cancel()
        soft.impactOccurred(intensity: 0.7)
        beatStrength = 0.3
        beat += 1
    }

    /// A match. The earth moves.
    func earthquake() {
        var pattern: [Thump] = []
        for i in 0..<14 {
            pattern.append(Thump(delay: i == 0 ? 0 : 0.07, strength: 0.4 + Double(i) / 14 * 0.6))
        }
        pattern.append(Thump(delay: 0.3, strength: 1))
        pattern.append(Thump(delay: 0.25, strength: 1))
        thump(pattern)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    /// Light tick for navigation.
    func tick() {
        rigid.impactOccurred(intensity: 0.5)
    }
}
