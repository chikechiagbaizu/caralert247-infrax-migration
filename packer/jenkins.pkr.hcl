packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "jenkins_image" {
  project_id          = "caralert247-488712"
  source_image_family = "debian-12"
  zone                = "europe-west2-c"
  ssh_username        = "packer"
  image_name          = "jenkins-golden-image-${formatdate("YYYYMMDD-hhmm", timestamp())}"
  image_family        = "caralert247-jenkins"
  credentials_file    = "C:/Users/BOBBY/sa-keys/packer-key.json"
}

build {
  sources = ["source.googlecompute.jenkins_image"]

  provisioner "file" {
    source      = "../scripts/docker-compose.yaml"
    destination = "/tmp/docker-compose.yaml"
  }

  provisioner "shell" {
    pause_before = "30s"
    inline = [
      # 1. Wait for cloud-init (No strict timeout)
      "echo 'Waiting for cloud-init to complete...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Still waiting...'; sleep 10; done",
      
      # 2. Prevent interactive prompts and handle locks
      "export DEBIAN_FRONTEND=noninteractive",
      "sudo fuser -ku /var/lib/apt/lists/lock || true",

      # 3. Install Docker & Dependencies
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
      
      "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list",
      
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io nginx docker-compose-plugin",
      
      # 4. Directory and User Setup
      "sudo mkdir -p /opt/jenkins /jenkins-storage",
      "sudo mv /tmp/docker-compose.yaml /opt/jenkins/docker-compose.yaml",
      
      # Ensure Jenkins container (UID 1000) can write to storage
      "sudo chown -R 1000:1000 /jenkins-storage",
      
      # Setup User Home for future GKE configs
      "sudo useradd -m -s /bin/bash charleschiagbaizu || true",
      "sudo chown -R charleschiagbaizu:charleschiagbaizu /home/charleschiagbaizu",

      # 5. Services and Cleanup
      "sudo systemctl disable docker", 
      "sudo systemctl enable nginx",
      "sudo apt-get clean"
    ]
  }
}