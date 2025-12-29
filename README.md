## Lets dive deeper into the file, remote-exec, and local-exec provisioners in Terraform, along with examples for each.

**Provisioner allows you to excecute scripts and commands on a resource (like EC2) during creation and destruction. By using remote-exec you can connect to the instance while instance is creating and we can run and install application like python, java or node js.**   

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

**- initiate the project, plan the project and apply:**

<img width="785" height="365" alt="image" src="https://github.com/user-attachments/assets/2ecf889c-39c9-42d4-9329-7e61519b07ad" />

<img width="1263" height="652" alt="image" src="https://github.com/user-attachments/assets/fa92d4a2-b871-47bc-ada9-d29814bd2a97" />

<img width="1474" height="651" alt="image" src="https://github.com/user-attachments/assets/0199568b-e039-4ef2-a80a-b8129d863691" />

<img width="1046" height="556" alt="image" src="https://github.com/user-attachments/assets/0593ffa2-aa98-4411-a68b-23ab72b281c0" />



**- VPC created with subnet, route table and internet gateway:**
  

<img width="1648" height="739" alt="image" src="https://github.com/user-attachments/assets/f59c59cd-71ec-4a42-b562-1aa3e93958ee" />


- EC2 created and connected, simultaniously installing packages.
  
<img width="1105" height="612" alt="image" src="https://github.com/user-attachments/assets/c1271bfc-64a7-47d1-9647-d24f001b817c" />
  
<img width="953" height="744" alt="image" src="https://github.com/user-attachments/assets/2004f760-2acd-4d8f-9335-1eccf2613932" />

<img width="1101" height="739" alt="image" src="https://github.com/user-attachments/assets/be9fff2a-a1b5-4456-a26d-ff1cb4ea1f4b" />

<img width="1001" height="745" alt="image" src="https://github.com/user-attachments/assets/4c26efcc-72f3-412a-9048-d2b6968706e9" />

**- Try login to the EC2 instance manually and check if python.py copied, preset working directory and python installed**

<img width="859" height="773" alt="image" src="https://github.com/user-attachments/assets/6ccc8ae6-b966-4edb-bda2-7d8d11761d66" />
<img width="1213" height="167" alt="image" src="https://github.com/user-attachments/assets/7570f2ad-6ed7-49e7-a63f-92462e3551af" />

**- **Try access the output with public ip of EC2 instance i,e** http://54.147.114.138:80**:

<img width="723" height="175" alt="image" src="https://github.com/user-attachments/assets/10938a18-52fa-47ca-bf09-07d5cfcaab3b" />
  

**Project successfully deployed by utilizing Terraform Provisioners.**








