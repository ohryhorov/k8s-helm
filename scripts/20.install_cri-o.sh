# Install prerequisites
apt-get update
apt-get install software-properties-common -y

add-apt-repository ppa:projectatomic/ppa -y
apt-get update

# Install CRI-O
apt-get install cri-o-1.11 -y

sleep 10

systemctl start crio
