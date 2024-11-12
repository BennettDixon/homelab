FROM python:3.12-slim

RUN pip install paramiko pyyaml

WORKDIR /app
COPY tunnel_manager.py /app/tunnel_manager.py
COPY tunnels.yaml /app/tunnels.yaml

CMD ["python", "tunnel_manager.py"]
