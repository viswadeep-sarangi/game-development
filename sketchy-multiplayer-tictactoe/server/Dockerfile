# Use a slim Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Pre-install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy dependencies first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy your app code
COPY . .

# Expose port (Fly uses 8080 internally)
EXPOSE 8000

# Set entrypoint to run FastAPI via uvicorn
CMD ["uvicorn", "main_server:app", "--host", "0.0.0.0", "--port", "8000"]
