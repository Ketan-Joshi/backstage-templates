FROM python:${{ values.pythonVersion }}-slim AS base

# Security: run as non-root
RUN groupadd -r pipeline && useradd -r -g pipeline pipeline

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/

USER pipeline

CMD ["python", "-m", "src.main"]
