import SwiftUI
import AVFoundation
import Combine

struct TranscriptSegment: Identifiable {
    let id: Int
    let start: Double
    let end: Double
    let text: String
}

@MainActor final class VoicePlayer: ObservableObject {
    @Published var current: Double = 0
    @Published var duration: Double = 0
    @Published var playing = false
    @Published var speed: Float = 1
    private var player: AVAudioPlayer?
    private var timer: Timer?

    init() {
        if let url = Bundle.main.url(forResource: "original-voice-message", withExtension: "m4a") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.enableRate = true
            player?.prepareToPlay()
            duration = player?.duration ?? 0
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.current = self.player?.currentTime ?? 0
                self.playing = self.player?.isPlaying ?? false
            }
        }
    }
    deinit { timer?.invalidate() }
    func toggle() {
        guard let player else { return }
        if player.isPlaying { player.pause() } else {
            if player.currentTime >= player.duration { player.currentTime = 0 }
            player.rate = speed
            player.play()
        }
        playing = player.isPlaying
    }
    func seek(_ seconds: Double, resume: Bool = false) {
        guard let player else { return }
        player.currentTime = min(max(0, seconds), player.duration)
        current = player.currentTime
        if resume && !player.isPlaying { player.rate = speed; player.play() }
        playing = player.isPlaying
    }
    func cycleSpeed() {
        speed = speed == 1 ? 1.5 : speed == 1.5 ? 2 : 1
        player?.rate = speed
    }
}

struct ContentView: View {
    @StateObject private var audio = VoicePlayer()
    @State private var query = ""
    private let blue = Color(red: 0.20, green: 0.56, blue: 0.93)
    private let segments: [TranscriptSegment] = [
        .init(id: 0, start: 0.000, end: 5.700, text: "Hey Telegram, we have a situation here."),
        .init(id: 1, start: 5.700, end: 18.000, text: "When we send a big and long story in a voice message,"),
        .init(id: 2, start: 18.000, end: 32.400, text: "we want to play it and know every single timeline in it."),
        .init(id: 3, start: 32.400, end: 43.700, text: "We need access to a summary or something like that"),
        .init(id: 4, start: 43.700, end: 56.700, text: "to improve it and get the results in a short time."),
        .init(id: 5, start: 56.700, end: 69.000, text: "That helps us have a better experience responding to long voice messages."),
        .init(id: 6, start: 69.000, end: 80.200, text: "When we send long voice messages, users can use this feature"),
        .init(id: 7, start: 80.200, end: 92.700, text: "to access summaries and timelines and make a better response"),
        .init(id: 8, start: 92.700, end: 102.891, text: "to long voice messages in less time.")
    ]
    private var filtered: [TranscriptSegment] {
        query.isEmpty ? segments : segments.filter { $0.text.localizedCaseInsensitiveContains(query) }
    }
    private func stamp(_ t: Double) -> String {
        let n = max(0, Int(t)); return String(format: "%02d:%02d", n / 60, n % 60)
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.94, green: 0.96, blue: 0.98).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill").font(.system(size: 44)).foregroundStyle(blue)
                            VStack(alignment: .leading) {
                                Text("Designers × AI").font(.headline)
                                Text("Original 1:43 voice message").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("VOICE TIMELINE").font(.caption.bold()).tracking(1.4).foregroundStyle(blue)
                                Spacer()
                                Label("Live playback", systemImage: "waveform").font(.caption2).foregroundStyle(.secondary)
                            }
                            GeometryReader { geo in
                                Waveform(progress: audio.duration > 0 ? audio.current / audio.duration : 0, color: blue)
                                    .contentShape(Rectangle())
                                    .gesture(DragGesture(minimumDistance: 0).onChanged { value in
                                        let ratio = min(max(value.location.x / max(1, geo.size.width), 0), 1)
                                        audio.seek(ratio * audio.duration)
                                    })
                            }.frame(height: 62)
                            HStack {
                                Button { audio.toggle() } label: {
                                    Image(systemName: audio.playing ? "pause.fill" : "play.fill")
                                        .font(.title2).foregroundStyle(.white)
                                        .frame(width: 52, height: 52).background(blue, in: Circle())
                                }.accessibilityLabel(audio.playing ? "Pause audio" : "Play audio")
                                Text("\(stamp(audio.current)) / \(stamp(audio.duration))")
                                    .monospacedDigit().font(.subheadline).foregroundStyle(.secondary)
                                Spacer()
                                Button { audio.cycleSpeed() } label: {
                                    Text(String(format: "%g×", audio.speed)).font(.subheadline.bold())
                                        .padding(.horizontal, 13).padding(.vertical, 9)
                                        .background(blue.opacity(0.1), in: Capsule())
                                }
                            }
                        }.padding(20).background(.white, in: RoundedRectangle(cornerRadius: 24))
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Transcript").font(.title2.bold())
                                Spacer()
                                Text("Tap to jump").font(.caption).foregroundStyle(.secondary)
                            }
                            HStack {
                                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                                TextField("Search inside voice message", text: $query)
                                    .textInputAutocapitalization(.never)
                            }.padding(13).background(.white, in: RoundedRectangle(cornerRadius: 13))
                            if filtered.isEmpty {
                                ContentUnavailableView.search(text: query)
                            }
                            ForEach(filtered) { segment in
                                let active = audio.current >= segment.start && audio.current < segment.end
                                Button { audio.seek(segment.start, resume: true) } label: {
                                    HStack(alignment: .top, spacing: 12) {
                                        Text(stamp(segment.start)).font(.caption.monospacedDigit())
                                            .foregroundStyle(active ? blue : .secondary)
                                            .frame(width: 43, alignment: .leading).padding(.top, 3)
                                        Text(segment.text).font(.body)
                                            .foregroundStyle(active ? blue : Color.primary)
                                            .multilineTextAlignment(.leading)
                                        Spacer(minLength: 0)
                                        if active { Image(systemName: "waveform").foregroundStyle(blue) }
                                    }.padding(14)
                                        .background(active ? blue.opacity(0.10) : .white,
                                                    in: RoundedRectangle(cornerRadius: 14))
                                }.buttonStyle(.plain)
                                    .accessibilityLabel("Jump to \(stamp(segment.start)), \(segment.text)")
                            }
                        }
                    }.padding(18)
                }
            }
            .navigationTitle("Voice Timeline")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Waveform: View {
    let progress: Double
    let color: Color
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 2) {
                ForEach(0..<72, id: \.self) { index in
                    let value = abs(sin(Double(index) * 1.19) * cos(Double(index) * 0.37))
                    Capsule()
                        .fill(Double(index) / 72 <= progress ? color : Color.gray.opacity(0.32))
                        .frame(maxWidth: .infinity)
                        .frame(height: 8 + value * 49)
                }
            }.frame(height: geometry.size.height)
        }.accessibilityLabel("Audio waveform, \(Int(progress * 100)) percent played")
    }
}