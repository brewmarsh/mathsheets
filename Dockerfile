# Stage 1: Build Stage - Install all dependencies (including dev)
FROM python:3.9-bullseye AS builder
WORKDIR /app
COPY requirements.txt requirements-dev.txt pyproject.toml ./
RUN pip install --no-cache-dir -r requirements-dev.txt

# Stage 2: Final Stage - Copy only what's needed for production
FROM python:3.9-slim-bullseye
WORKDIR /app

# Copy only the installed production packages from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# Copy the application code
COPY . .

# Replace 'my_app:create_app()' with the actual entrypoint of your app.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "my_app:create_app()"]
