variable "instance_count" {
  default = "1"
}

resource "aws_key_pair" "spot_key" {
  key_name   = "spot_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_spot_instance_request" "tmp_spot" {
  ami                  = data.aws_ami.amazon-2.id
  spot_price           = "0.006"
  instance_type        = "t2.micro"
  spot_type            = "one-time"
  wait_for_fulfillment = "true"
  key_name             = "spot_key"
  security_groups      = [aws_security_group.allow_my_ip.id]
  subnet_id            = module.tmp_vpc.public_subnets[0]
  count                = var.instance_count

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      # "sudo docker run -ti --rm -d alpine/bombardier -c 100 -d 3600s -l http://www...."
    ]
    on_failure = fail
  }
}
