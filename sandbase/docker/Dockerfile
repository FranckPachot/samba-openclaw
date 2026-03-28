# Use official Python slim image
FROM python:3.11-slim

# Set workdir
WORKDIR /app

# Copy requirements and install
COPY ../requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY ../src ./src

# Expose port 80 as requested
EXPOSE 80

# Run the Flask app
CMD [ "python", "-m", "flask", "run", "--host=0.0.0.0", "--port=80" ]
