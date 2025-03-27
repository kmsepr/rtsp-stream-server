# Use official Python image
FROM python:3.10

# Set working directory
WORKDIR /app

# Install FFmpeg
RUN apt-get update && apt-get install -y ffmpeg

# Copy application files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8080 for Flask
EXPOSE 8080

# Start the Flask app with Gunicorn
CMD ["gunicorn", "-w", "4", "-t", "300", "-b", "0.0.0.0:8080", "app:app"]