import subprocess
import time
from flask import Flask, Response

app = Flask(__name__)

# 🎵 RTSP Stream Sources
RTSP_STREAMS = {
    "rahmani_live": "rtsp://tv.tg-gw.com:554/cJbnWSoivEI",
    "asianet_news": "rtsp://tv.tg-gw.com:554/Ko18SgceYX8"
}

# 🔄 Function to process and stream RTSP audio
def generate_rtsp_audio(url):
    process = None
    while True:
        if process:
            process.kill()  # Stop the previous FFmpeg instance

        process = subprocess.Popen(
            [
                "ffmpeg", "-rtsp_transport", "tcp", "-i", url, "-vn",
                "-ac", "1", "-b:a", "64k", "-buffer_size", "1024k", "-f", "mp3", "-"
            ],
            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, bufsize=8192
        )

        print(f"🎧 Streaming RTSP Audio: {url} (Mono, 64kbps)")

        try:
            for chunk in iter(lambda: process.stdout.read(8192), b""):
                yield chunk
        except GeneratorExit:
            process.kill()
            break
        except Exception as e:
            print(f"⚠️ Stream error: {e}")

        print("🔄 FFmpeg stopped, restarting stream...")
        time.sleep(5)

# 🌍 Flask Route to Stream Audio
@app.route("/rtsp/<stream_name>")
def stream_rtsp(stream_name):
    url = RTSP_STREAMS.get(stream_name)
    if not url:
        return "⚠️ RTSP Stream not found", 404

    return Response(generate_rtsp_audio(url), mimetype="audio/mpeg")

# 🚀 Run Flask Server
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)