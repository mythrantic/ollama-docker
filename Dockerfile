FROM python:3.14-slim

# Prevents Python from writing .pyc files & forces unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /code
COPY ./requirements.txt .

# Install minimal build deps in one layer; clean apt cache
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      gcc g++ make cmake pkg-config git curl \
 && rm -rf /var/lib/apt/lists/*

# Upgrade build tooling, then install deps
RUN python -m pip install --upgrade pip setuptools wheel \
 && pip install -r requirements.txt

# Copy app code
COPY ./src ./src

EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]