import subprocess
import time
import yaml
import logging
import os

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def load_config(config_file="./tunnels.yaml"):
    """Load configuration from YAML file."""
    try:
        with open(config_file, "r") as file:
            config = yaml.safe_load(file)
            validate_config(config)
            return config
    except Exception as e:
        logging.error(f"Failed to load configuration: {e}")
        raise

def validate_config(config):
    """Validate the structure of the configuration."""
    if 'tunnels' not in config:
        raise ValueError("Missing 'tunnels' key in configuration.")
    required_keys = {'ssh_host', 'ssh_user', 'local_port', 'remote_host', 'remote_port'}
    for tunnel in config['tunnels']:
        if not required_keys.issubset(tunnel):
            raise ValueError(f"Missing keys in tunnel config: {required_keys - tunnel.keys()}")

def establish_ssh_tunnel(ssh_host, ssh_user, local_port, remote_host, remote_port, retries=3):
    """Establish an SSH tunnel using autossh."""
    command = f"ssh -f -N -R {local_port}:{remote_host}:{remote_port} {ssh_user}@{ssh_host} -o StrictHostKeyChecking=no"
    attempt = 0
    while attempt < retries:
        try:
            logging.info(f"Connecting to {ssh_host} as {ssh_user} (attempt {attempt + 1})...")
            subprocess.run(command, shell=True, check=True)
            logging.info(f"Tunnel established: {local_port} -> {remote_host}:{remote_port}")
            return True
        except subprocess.CalledProcessError as e:
            logging.error(f"Error establishing tunnel: {e}")
            attempt += 1
            time.sleep(5)  # Retry delay
    logging.error(f"Failed to establish tunnel after {retries} attempts.")
    return False

def monitor_tunnels(tunnels):
    """Monitor and manage tunnels."""
    established_tunnels = {}
    
    while True:
        for tunnel in tunnels:
            key = (tunnel['ssh_host'], tunnel['local_port'], tunnel['remote_host'], tunnel['remote_port'])
            if key not in established_tunnels or not check_tunnel_active(established_tunnels[key]):
                success = establish_ssh_tunnel(
                    tunnel['ssh_host'], tunnel['ssh_user'],
                    tunnel['local_port'], tunnel['remote_host'], tunnel['remote_port']
                )
                if success:
                    established_tunnels[key] = True
            else:
                logging.info(f"Tunnel already established: {tunnel['local_port']} -> {tunnel['remote_host']}:{tunnel['remote_port']}")
        
        logging.info("Sleeping for 60 seconds before rechecking tunnels...")
        time.sleep(60)

def check_tunnel_active(tunnel):
    """Check if the tunnel is active by pinging the remote port."""
    # TODO: improve tunnel active check
    return tunnel

if __name__ == "__main__":
    config = load_config()  # Load the configuration
    monitor_tunnels(config['tunnels'])  # Start monitoring the tunnels

