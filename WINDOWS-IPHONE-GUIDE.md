# Run on Windows and view on iPhone

1. Download this repository as ZIP and extract it.
2. Place the separately supplied example file at `media/original-voice-message.m4a`.
3. On Windows with Python 3, run `START-WINDOWS.bat` (or `python -m http.server 8765 --bind 0.0.0.0`).
4. On the PC, open `http://localhost:8765/web/`.
5. Connect PC and iPhone to the same trusted Wi-Fi.
6. Run `ipconfig` and find the PC's IPv4 address. In iPhone Safari open `http://YOUR_PC_IP:8765/web/`.
7. If Windows Firewall requests access, allow only the private network. Do not port-forward this server to the internet.

## Tests
`node --test tests/timeline-core.test.cjs` and `python tests/verify_source.py`.

## Native source
On macOS with Xcode and XcodeGen, open `ios/`, run `xcodegen generate` and build. The recording must also be in `ios/VoiceTimeline/original-voice-message.m4a`. Native compilation remains unverified.
