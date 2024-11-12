import yaml
import subprocess
import time

# TODO improve this, simple script for now

def load_config():
    with open("./tunnels.yaml", "r") as file:
        return yaml.safe_load(file)

def establish_ssh_tunnel(ssh_host, ssh_user, local_port, remote_host, remote_port):
    try:
        print(f"Forwarding {local_port} to {remote_host}:{remote_port} via {ssh_host}...")
        
        # Command to set up the SSH tunnel over Tailscale
        command = f"ssh -f -N -L {local_port}:{remote_host}:{remote_port} "
                  f"{ssh_user}@{ssh_host} -o StrictHostKeyChecking=no"
        subprocess.run(command, shell=True, check=True)
        
        print(f"Tunnel established for {local_port} -> {remote_host}:{remote_port}")
    except Exception as e:
        print(f"Error establishing tunnel: {e}")

def monitor_tunnels(tunnels):
    while True:
        for tunnel in tunnels:
            establish_ssh_tunnel(
                tunnel['ssh_host'], tunnel['ssh_user'],
                tunnel['local_port'], tunnel['remote_host'], tunnel['remote_port']
            )
        time.sleep(60)

if __name__ == "__main__":
    config = load_config()
    monitor_tunnels(config['tunnels'])

