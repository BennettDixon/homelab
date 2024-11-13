echo "Done installing docker, would you like to run hello world docker"
read -p "Run hello-world docker image? (Y/n): " confirm
if [[ $confirm == [yY] ]]; then
   sudo docker run hello-world
fi
