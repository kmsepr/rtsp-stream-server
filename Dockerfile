# Use Ubuntu base image
FROM ubuntu:latest

# Install FFmpeg and dependencies
RUN apt update && apt install -y ffmpeg wget tar

# Download and install RTSP-simple-server (MediaMTX)
RUN wget https://github.com/aler9/mediamtx/releases/latest/download/mediamtx_linux_amd64.tar.gz \
    && tar -xvzf mediamtx_linux_amd64.tar.gz \
    && chmod +x mediamtx

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose RTSP port
EXPOSE 8554

# Run the start script
CMD ["/start.sh"]
