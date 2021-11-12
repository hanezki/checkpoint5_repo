#! /bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo service apache2 restart
curl -H "Metadata-Flavor:Google" metadata.google.internal/computeMetadata/v1/instance/hostname | sudo tee /var/www/html/index.html
#tän metadata hommanha ois voinu laittaa tonne main.tf vissii mut nyt ei kerenny alkaa sen kans taistelee
#echo '<!doctype html><html><body><h1>Checkpoint5</h1></body></html>' | tee /var/www/html/index.html