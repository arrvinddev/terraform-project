









resource "aws_instance" "instance" {
  ami                    = data.aws_ami.centos.image_id
  for_each               = var.components
  instance_type          = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]
  tags = {
    Name = each.value["name"]
  }

}



resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id  = "Z05216872DPXAQS543510"
  name     = "${each.value["name"]}-dev.arrvind.tech"
  type     = "A"
  ttl      = 30
  records  = [aws_instance.instance[each.value["name"]].private_ip]
}



