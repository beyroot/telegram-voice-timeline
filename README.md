# Voice Timeline

**A working Telegram-inspired voice-message navigation concept for Designers × AI.**

Voice Timeline turns long voice notes into searchable, timestamped conversations. Tap transcript lines to seek to specific moments, scrub the waveform, or change playback speed.

## Feature matrix

| Capability | Browser prototype | SwiftUI source |
|---|---|---|
| Audio player | Implemented | Implemented in source; build not verified |
| Seekable timeline | Implemented | Implemented in source |
| Timestamped searchable transcript | Implemented | Implemented in source |
| Tap sentence to play | Implemented | Implemented in source |
| Variable playback speed | Implemented | Implemented in source |
| Automated speech transcription | Not implemented | Not implemented |
| AI summaries | Editorial preview only | Not implemented |
| Native Telegram integration | Not implemented | Not implemented |

## Quick start — Windows, macOS, Linux

Download the source repository. You will also need the **separately supplied example voice recording** for audio playback, since the personal recording is intentionally excluded from the public source.

Place `original-voice-message.m4a` at `media/original-voice-message.m4a`.

Run:

```bash
python -m http.server 8765
```

Then open `http://localhost:8765/web/`.

On Windows, `START-WINDOWS.bat` can serve it on a trusted LAN for iPhone Safari testing; see [Windows/iPhone guide](WINDOWS-IPHONE-GUIDE.md). Never port-forward this development server to the public internet.

### Automated tests

```bash
node --test tests/timeline-core.test.cjs
python tests/verify_source.py
```

A GitHub Actions workflow also runs JavaScript syntax checks and the Node unit-test suite on pushes and pull requests. A successfully completed remote Actions run has **not** yet been independently verified.

### Native iOS source

The `ios/` directory provides a SwiftUI implementation with an XcodeGen project specification. It must be built on macOS using Xcode, and needs the recording placed at `ios/VoiceTimeline/original-voice-message.m4a`. iOS compilation has **not** yet been verified.

## Layout

- `web/` — browser interface, time helpers, waveform visualization, transcript data
- `ios/` — native SwiftUI prototype source
- `tests/` — Node test suite and data validation
- `docs/` — implementation notes, QA boundaries, integration roadmap and submission copy
- `media/` — asset placement instructions

## Demo evidence and scope

Two real iPhone Safari screen recordings were used to produce the submission demo: playback, seeking, speed control and transcript search were shown. The finished demo MP4 is a separate submission asset rather than a generated simulation of the native app.

Transcript segments were edited manually with approximate alignment. The summary panel is editorial, not machine-generated. This is not an official Telegram feature or a production-ready client patch.

See [limitations](docs/LIMITATIONS.md) and [integration proposal](docs/INTEGRATION_PLAN.md).

## License

No open-source license is granted by default. Contact the repository owner about reuse.
