# Architecture

## Browser
Plain HTML, CSS and JavaScript. The UI owns media controls and transcript DOM. A separate pure timeline-core.js handles segment lookup, search, seek math and validation and is covered by Node tests. The original audio is played using an HTMLAudioElement. Waveform bars are generated from a precomputed amplitude envelope derived from the same sample audio. No network services are required at runtime other than the local static file server.

## iOS
SwiftUI presentation layer backed by AVAudioPlayer for playback, seek and rate control. Segments are currently embedded sample data. An official integration would reuse Telegram's audio playback stack and native voice-message component instead of introducing another player.

## Production architecture direction
A transcript service or client-side pipeline can yield timed tokens or segments, indexed locally for rapid text search. Playback state should remain a single source of truth. Audio, transcript and overview must have explicit independent loading/error/privacy states. Local retention and consent are essential for transcription. No Telegram integration is included.
