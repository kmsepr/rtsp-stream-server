# Use a lightweight Python image
FROM python:3.10-slim

# Install FFmpeg (needed for streaming)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8080 (same as in Flask app)
EXPOSE 8080

# Start the application using Gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "app:app"]