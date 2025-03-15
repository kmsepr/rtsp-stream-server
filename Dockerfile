# Use Ubuntu base image
FROM ubuntu:latest

# Install FFmpeg, wget, curl, and tar
RUN apt update && apt install -y ffmpeg wget curl tar

# Set MediaMTX version
ENV MEDIAMTX_VERSION=v1.11.3

# Download and install MediaMTX
RUN wget https://github.com/bluenviron/mediamtx/releases/download/v1.11.3/mediamtx_v1.11.3_linux_amd64.tar.gz \
  && tar -xvzf mediamtx_v1.11.3_linux_amd64.tar.gz \
  && mv mediamtx /usr/local/bin/ \
  && chmod +x /usr/local/bin/mediamtx

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose RTSP port
EXPOSE 8554

# Run the start script
CMD ["/start.sh"]
