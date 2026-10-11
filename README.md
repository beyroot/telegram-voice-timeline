# Voice Timeline

An interactive Telegram-inspired voice-message navigation prototype, built for the Designers × AI feature call.

## Working features
- Searchable, timestamped transcript
- Tap a transcript segment to seek and play
- Seekable waveform generated from the example voice note
- 1× / 1.5× / 2× playback speeds
- Editorial key moments (not AI-generated)

## Run the web prototype
Run `python -m http.server 8765` from the repository root and open `http://localhost:8765/web/`. The example audio is available separately in the [downloadable submission package](../../releases) until a publishable demo asset is included here.

## Tests
`node --test tests/timeline-core.test.cjs`

## iOS prototype
See `ios/` for SwiftUI source and XcodeGen project configuration. Native compilation has **not** been verified.

## Scope and limitations
The browser prototype was screen-recorded running in Safari on an iPhone. The transcript uses approximately aligned, manually edited segments. This is not an official Telegram integration. Automated transcription and AI summarization are not implemented. The source package does not include personal recordings.

No open-source license is granted by default.