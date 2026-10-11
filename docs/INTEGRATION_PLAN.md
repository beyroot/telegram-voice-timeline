# Integration proposal (not implemented)

1. Render Voice Timeline as an expandable part of a voice-message bubble.
2. Reuse Telegram's media/player lifecycle and controls for seeking, buffering, speed and background playback.
3. Generate permissioned timestamp-aligned transcript segments using locally available speech models or a service complying with Telegram's privacy expectations.
4. Index words and time ranges on-device for fast substring search and tap-to-seek.
5. Generate optional overview cards separately, with clear labeling and a fallback when unavailable.
6. Add accessibility labels, VoiceOver focus order, Dynamic Type and RTL coverage.
7. Exercise multi-minute messages, interrupted playback, network loss, out-of-range seeks, malformed transcripts, empty searches and privacy settings before release.

This repository contains a concept implementation, not a production Telegram patch.
