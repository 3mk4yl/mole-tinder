# Run: Claude Fable 5.2, 2026-11-11-01

## Setup

| | |
|---|---|
| Model | Claude Fable 5.2 |
| Model id | `claude-fable-5-2` |
| Reasoning level | medium (as reported by the session after the run) |
| Harness | Claude Code, desktop app (Code tab) |
| Permission mode | auto |
| Prompt version | 1 |
| Date | 2026-11-11 |
| Host OS | macOS 27.2 (26B123) |
| Xcode | 27.2 (27B52) |
| Simulator | iPhone 17 Pro, iOS 27.2 |

## Outcome

| | |
|---|---|
| Wall-clock time (prompt to final message) | About 5–6 minutes. Not measured exactly: the session was created at 13:18:14 and the last verification screenshot was taken at about 13:23. |
| Tokens / cost | Not recorded |
| Build attempts until success | 1 (no errors to fix) |
| Questions asked | 0 |
| Verified in the simulator by itself | Yes: welcome, browse, like, match, matches list with a thump reply, pass |
| Source size | 7 Swift files, 986 lines, plus a hand-written `project.pbxproj` |
| Deployment target / Swift mode | iOS 17.0 / Swift 5 |

## Objective checks

| Check | Result |
|---|---|
| Complete Xcode project in the working directory | Yes |
| Builds with `xcodebuild` without changes | Yes |
| Runs in the iOS Simulator | Yes |
| No third-party dependencies, no backend | Yes |
| At least 8 mole profiles | Yes (9) |
| Browse, like, pass, match, matches list all work | Yes |
| Asked no questions | Yes |
| Built it itself and fixed its own errors | Yes (nothing to fix) |
| Verified the running app itself | Partly: the empty-deck screen and "Dig again" were not exercised during the run; they were confirmed working later while recording the demo |
| Final summary short and accurate | Yes; it also listed what it had not checked (speech, haptics, empty deck) |

## What it built

A dating app without photos. A mole profile is scent, fur texture, digging style
and favourite worm, with distance in tunnel-lengths and depth in centimetres.

Key design decisions:

- Every profile is read aloud, each mole with its own voice pitch; mute toggle.
- Each mole has a "thump signature", a rhythm played as haptics and mirrored as
  pulsing rings on screen. Tap the card to feel it again.
- The whole card is the gesture surface: swipe right "dig toward", left
  "burrow away", with two very large buttons as a fallback. The card floods
  green or red while dragging.
- Always dark, very large heavy type, one loud colour per mole.
- A match is an earthquake: "The earth moved!", a haptic rumble, shaking title
  and three bright flashes.
- Matches are "Your Tunnels". Moles do not type: tap a match to thump down the
  tunnel; they drum back and answer with a spoken line.
- 6 of 9 moles like you back; passed and unmatched moles return via "Dig again".
- No app icon.

## Rating

| Criterion | Score (1–5) | Note |
|---|---|---|
| Designed for moles | | |
| Core flow | | |
| Craft | | |
| Originality | | |
| Code | | |
| Autonomy | | |
| **Total** | /30 | |

**Verdict:**

## Notes

- This run predates the protocol. It ran in this repository's root, which was
  empty at the time, and the result was moved into `app/` afterwards.
- The demo video and this repository structure came from follow-up requests in
  the same session and are not part of the rated run.
- For the demo's audio sync, a debug-only speech log was temporarily added to
  `Senses.swift` and removed again before archiving. `app/` was rebuilt
  successfully after the removal, but there is no snapshot from the moment of
  delivery to compare against.
- The demo's sound is the Mac's system audio captured during the take. Haptics
  are silent and appear only as the on-screen rings.
- Known cosmetic flaws: on a profile with long texts, the "tap to feel the
  thump" label overlaps the ring; the match title rests a few points off-centre
  after its shake.

## Files

- `app/` project as delivered
- `demo/showcase.mp4` (4 min 21 s, with sound)
- `screenshots/`
