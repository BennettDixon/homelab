FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    # openssh & curl for debugging    
    openssh-client curl \
    && rm -rf /var/lib/apt/lists/*


# Copy & install packages (cache as separate layer)
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

# Copy python and YAML
COPY tunnel_manager.py /app/tunnel_manager.py
COPY tunnels.yaml /app/tunnels.yaml

WORKDIR /app

CMD ["python", "tunnel_manager.py"]
