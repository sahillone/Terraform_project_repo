variable "ingressrules" {

  type    = list(number)

  default = [8080, 22]

}
resource "aws_security_group" "web_traffic" {

  name        = "Allow web traffic"

  description = "inbound ports for ssh and standard http and everything outbound"

  dynamic "ingress" {
    
    iterator = port

    for_each = var.ingressrules

    content {

      from_port   = port.value

      to_port     = port.value

      protocol    = "TCP"

      cidr_blocks = ["0.0.0.0/0"]

    }

  }

  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags= {

    Name = "My_security_group"

  }

}



resource "aws_instance" "example_terraform" {

ami           = "ami-04505e74c0741db8d"

instance_type = "t3.micro"

vpc_security_group_ids = [aws_security_group.web_traffic.id]

key_name        = "sahil_terraform_key"

tags= {

   Name = "My_instance"

  }
 provisioner "remote-exec"  {

    inline  = [

      "sudo apt update && upgrade",

      "sudo apt install -y python3.8",

      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",

      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",

      "sudo apt update && sudo apt upgrade -y",

      "sudo apt install default-jre -y",

      "sudo apt install jenkins -y",

      "sudo systemctl start jenkins",

      ]

   }

 connection {

    type         = "ssh"

    host         = self.public_ip

    user         = "ubuntu"

    private_key  = file("/home/sahillone193101/Downloads/sahil_terraform_key.pem" )

   }

}



