echo "Upgrading & updating package lists"
sudo apt-get update && sudo apt-get upgrade -y

# Install nginx (local test maybe remove this)
sudo apt-get install -y nginx libnginx-mod-stream

# Install tailscale
echo "Installing tailscale for ubuntu 24.04"
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update && sudo apt-get install -y tailscale
echo "Tailscale has been installed, you will want to run tailscale up --ssh"

# Install docker
# https://docs.docker.com/engine/install/ubuntu/
# Remove old
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Done installing docker, would you like to run hello world docker"
read -p "Run hello-world docker image? (Y/n): " confirm
if [[ $confirm == [yY] ]]; then
   sudo docker run hello-world
fi

echo "All done, you can proceed to configure docker compose :)"
