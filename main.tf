data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] #canonical
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ec2"
  public_key = file(var.public_key)
}

resource "aws_instance" "app" {

  count         = var.instances_per_subnet * length(var.private_subnet_cidr_blocks)
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = aws_subnet.private[count.index % length(aws_subnet.private)].id
  instance_type = var.instance_type

  user_data = <<-EOF
    sudo apt-get update -y
    sudo apt-get install apache2 -y
    sudo systemctl enable apache2
    sudo systemctl start apache2
    echo "<html><body><div>Hello, world!</div></body></html>" | sudo tee /var/www/html/index.html
    EOF

  tags = {
    Terraform   = "true"
    Project     = var.project_name
    Environment = var.environment
  }
}