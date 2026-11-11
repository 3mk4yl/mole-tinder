# Protocol

How to run the benchmark so that runs stay comparable.

## 1. Run

1. Create a **new, empty directory outside this repository**. The model must not
   be able to read earlier runs, this protocol or the rubric.
2. Start a fresh session there: no project instructions, no memory, no earlier
   conversation.
3. Note the model, reasoning level, harness and permission mode before you start.
4. Paste the prompt from [PROMPT.md](PROMPT.md) verbatim as the only message.
5. Do not answer questions and do not send follow-ups. If the model asks
   something, reply only "See the prompt." and note it in the run record.
6. The run ends with the model's final message. Note the wall-clock time from
   sending the prompt to that message, and the token usage if the harness shows it.

## 2. Archive

1. Copy [templates/run.md](templates/run.md) to
   `runs/<model-id>/<yyyy-mm-dd>-<nn>/run.md`.
2. Copy the project **exactly as delivered** into `app/` next to it. Leave out
   build output (`build/`, `DerivedData/`). Never edit `app/` afterwards.
3. Build and launch it yourself once to confirm the model's claims.

## 3. Demo recording

Recorded after the run; it is not part of the run itself.
Save as `demo/showcase.mp4`, with sound where the app makes any.

Shot list, in this order where the app allows it:

1. Launch and any welcome or onboarding screen
2. The first profile, shown long enough to take in
3. Every profile in the deck at least briefly
4. One like by gesture and one by button (if both exist)
5. One pass by gesture and one by button (if both exist)
6. A match moment
7. A like that does not lead to a match (if the app has one)
8. The matches list, including any interaction it offers
9. The empty state when the deck runs out, and any way to restart
10. Any settings or toggles

Also save three to five stills in `screenshots/`.

## 4. Objective checks

Answer each with yes, no or partly in the run record:

- Complete Xcode project in the working directory
- Builds with `xcodebuild` without changes
- Runs in the iOS Simulator
- No third-party dependencies, no backend
- At least 8 mole profiles
- Browse, like, pass, match and matches list all work
- Asked no questions
- Built it itself and fixed its own errors
- Verified the running app itself (not only the build)
- Final summary is short and accurate

## 5. Rating

Four criteria, 1 (poor) to 5 (excellent) each, 20 points in total. Keep the
rubric fixed so that runs stay comparable.

| Criterion | What to look at |
|---|---|
| Designed for moles | Does it take "nearly blind, underground" seriously: non-visual channels, touch targets, contrast, what a profile consists of? Or is it a human app with mole names? |
| Core flow | Is browse, like, pass, match, matches list complete, coherent and free of dead ends? |
| Craft | Layout, animation, empty states, edge cases, accessibility, overall polish. |
| Originality | Ideas and writing that are specific and surprising rather than generic. |

Add a one-paragraph verdict. One run is one sample: where it matters, run a
model two or three times and keep every run.
