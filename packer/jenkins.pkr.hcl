packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.2.3"
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
  
  account_file        = "C:/Users/BOBBY/sa-keys/packer-key.json"
}

build {
  sources = ["source.googlecompute.jenkins_image"]

  # 1. Copy your Docker Compose file
  provisioner "file" {
    source      = "../scripts/docker-compose.yaml"
    destination = "/tmp/docker-compose.yaml"
  }

  # 2. Run the installation commands
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
      
      # Docker GPG and Repo
      "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list",
      
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io nginx docker-compose-plugin",
      
      # Prepare Jenkins directories
      "sudo mkdir -p /opt/jenkins /jenkins-storage/tmp",
      "sudo mv /tmp/docker-compose.yaml /opt/jenkins/docker-compose.yaml",
      "sudo chmod -R 777 /jenkins-storage",
      
      # Enable services
      "sudo systemctl enable docker",
      "sudo systemctl enable nginx",

      # Clean up to keep the image small
      "sudo apt-get clean"
    ]
  }
}