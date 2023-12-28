apt update -y && apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg |  gpg --dearmor |  tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com buster main" > /etc/apt/sources.list.d/hashicorp.list
apt update -y
apt-get install terraform -y







# #!/bin/bash

# repo="/home/ubuntu/frontend"

# while true; do
#   echo ""
#   echo "Fetching and pulling changes for all branches in the repository at" ${repo}

#   echo ""
#   echo "****** Fetching changes for" $(basename ${repo}) "******"
#   cd "${repo}"

#   git fetch --all
#   echo "******************************************"

#   echo ""

#   echo "****** Pulling changes for all branches in" $(basename ${repo}) "******"
#   if output=$(git pull --all); then
#     echo "$output"
#     if [[ ! "$output" =~ "Already up to date." ]]; then
#       echo "******************************************"
#       echo "No new changes. Ignoring pm2 restart."
      
#     else
#       echo "Changes pulled. Restarting pm2 process..."
#       pm2 start npm -- start
#     fi

#   else
#     echo "******************************************"
#     echo "Git pull failed. Ignoring pm2 restart."
#   fi

#   sleep 60  # sleep for 60 seconds before the next iteration
# done
