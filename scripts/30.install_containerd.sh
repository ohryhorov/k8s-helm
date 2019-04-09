apt-get install -y libseccomp2

# Export required environment variables.
export CONTAINERD_VERSION="1.2.0"
export CONTAINERD_SHA256="ee076c6260de140f9aa6dee30b0e360abfb80af252d271e697982d1209ca5dee"

# Download containerd tar.
wget https://storage.googleapis.com/cri-containerd-release/cri-containerd-${CONTAINERD_VERSION}.linux-amd64.tar.gz

# Check hash.
echo "${CONTAINERD_SHA256} cri-containerd-${CONTAINERD_VERSION}.linux-amd64.tar.gz" | sha256sum --check -

# Unpack.
tar --no-overwrite-dir -C / -xzf cri-containerd-${CONTAINERD_VERSION}.linux-amd64.tar.gz

# Start containerd.
systemctl start containerd
