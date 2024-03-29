# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

ARG PYTHON_VERSION=3.11.4
FROM python:${PYTHON_VERSION}-alpine as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install PostgreSQL development files.
RUN apk add --no-cache python3-dev postgresql-dev build-base

# Run as a non-privileged user
RUN adduser -D -u 1001 app
RUN chown -R app:app /app
USER app

# Copy the source code into the container.
COPY --chown=app:app . /app

# Install Python dependencies.
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that the application listens on.
EXPOSE 8000

# Run the application.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
