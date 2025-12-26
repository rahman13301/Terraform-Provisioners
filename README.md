<img width="1082" height="688" alt="image" src="https://github.com/user-attachments/assets/a646d944-cf54-4efa-89d7-031793859e6e" />## Lets dive deeper into the file, remote-exec, and local-exec provisioners in Terraform, along with examples for each.

**1. file Provisioner:**
The file provisioner is used to copy files or directories from the local machine to a remote machine. This is useful for deploying configuration files, scripts, or other assets to a provisioned instance.
Example:
```
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

provisioner "file" {
  source      = "local/path/to/localfile.txt"
  destination = "/path/on/remote/instance/file.txt"
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }
}
```

- In this example, the file provisioner copies the localfile.txt from the local machine to the /path/on/remote/instance/file.txt location on the AWS EC2 instance using an SSH connection.

**2. remote-exec Provisioner:**

The remote-exec provisioner is used to run scripts or commands on a remote machine over SSH or WinRM connections. It's often used to configure or install software on provisioned instances.

Example:
```
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

provisioner "remote-exec" {
  inline = [
    "sudo yum update -y",
    "sudo yum install -y httpd",
    "sudo systemctl start httpd",
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = aws_instance.example.public_ip
  }
}
```

- In this example, the remote-exec provisioner connects to the AWS EC2 instance using SSH and runs a series of commands to update the package repositories, install Apache HTTP Server, and start the HTTP server.

**3. local-exec Provisioner:**

The local-exec provisioner is used to run scripts or commands locally on the machine where Terraform is executed. It is useful for tasks that don't require remote execution, such as initializing a local database or configuring local resources.

Example:
```
resource "null_resource" "example" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "echo 'This is a local command'"
  }
}
```

- In this example, a null_resource is used with a local-exec provisioner to run a simple local command that echoes a message to the console whenever Terraform is applied or refreshed. The timestamp() function ensures it runs each time.

## Deploying an application in remote server (EC2) by utilising Terraform Provisioners:

**- Create a  simple app.py python file:**
```
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, This is mostly use terraform task"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
```
<img width="999" height="325" alt="image" src="https://github.com/user-attachments/assets/cc60307a-f664-403e-a793-1a695f5f9063" />



**- Create an main.tf file and write terraform provisioners code:**


- Command to generate public/private rsa key pair:
```
ssh-keygen -t rsa
```

<img width="747" height="177" alt="image" src="https://github.com/user-attachments/assets/47c10f03-7fbd-47db-bf47-9d1dfa879676" />

- initiate the project, plan the project and apply.

<img width="739" height="454" alt="image" src="https://github.com/user-attachments/assets/8b48e414-576a-440a-a54d-4195c6c70379" />
<img width="659" height="501" alt="image" src="https://github.com/user-attachments/assets/3d53dbd1-be46-465e-895e-15241677aa86" />

- VPC created with subnet, route table and internet gateway.
<img width="1598" height="256" alt="image" src="https://github.com/user-attachments/assets/105a9708-7164-41bd-9330-f08941dde933" />

- EC2 created and connected, simultaniously installing packages.
<img width="1469" height="256" alt="image" src="https://github.com/user-attachments/assets/aeb33e36-3731-4228-8b87-3a2012c81222" />

<img width="1013" height="780" alt="image" src="https://github.com/user-attachments/assets/775dc51b-916a-4fc9-80ca-6bb1c9a91612" />



<img width="1082" height="688" alt="image" src="https://github.com/user-attachments/assets/3e3757ac-8092-42ea-99d3-b8400e1bc61d" />













