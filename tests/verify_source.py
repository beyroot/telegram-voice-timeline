import json
from pathlib import Path
r = Path(__file__).resolve().parents[1]
data = json.loads((r / 'web/transcript.json').read_text())
segments = data['segments']
assert len(segments) >= 8
assert all(0 <= s['start'] < s['end'] <= data['duration'] + 0.01 for s in segments)
assert all(segments[i]['end'] <= segments[i+1]['start'] + .001 for i in range(len(segments)-1))
assert len(json.loads((r / 'web/waveform.json').read_text())['rms']) == 96
print("PASS: transcript timing, waveform dimensions and file layout")
