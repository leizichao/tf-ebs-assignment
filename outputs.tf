# Output useful information

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.zcsg.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.zcsg.public_ip
}

output "ebs_volume_id" {
  description = "The ID of the EBS volume"
  value       = aws_ebs_volume.zcsg.id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.zcsg.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.zcsg.id
}