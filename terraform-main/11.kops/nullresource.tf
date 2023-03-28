resource "aws_s3_bucket" "example" {
  bucket = "clusters.dev.rnstech.com"
  force_destroy = true
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_route53_zone" "private" {
  name = "dev.rnstech.com"
  force_destroy = true

  vpc {
    vpc_id = aws_default_vpc.default.id
  }
}

resource "aws_iam_role" "ec2_assume_access_role" {
  name               = "ec2-assume-admin-role"
  assume_role_policy = "${file("./scripts/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "admin_policy" {
  name        = "admin-policy"
  description = "Admin policy"
  policy      = "${file("./scripts/iam.json")}"
}

resource "aws_iam_policy_attachment" "ec2-attach" {
  name       = "ec2-attachment"
  roles     = ["${aws_iam_role.ec2_assume_access_role.name}"]
  policy_arn = "${aws_iam_policy.admin_policy.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_profile"
  role = "${aws_iam_role.ec2_assume_access_role.name}"
}

resource "null_resource" "running_kops" {
  depends_on = [
    aws_instance.Kops_Node,
    aws_s3_bucket.example,
    aws_route53_zone.private
  ]

  connection {
    type     = "ssh"
    host     = aws_instance.Kops_Node.public_ip
    user     = "devops"
    password = "devops"
  }

  provisioner "file" {
    source      = "scripts/build.sh"
    destination = "/home/devops/build.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /home/devops/build.sh",
      "sed -i -e 's/\r$//' /home/devops/build.sh",
      "/home/devops/build.sh"
    ]
  }

/*  provisioner "remote-exec" {
    when        = destroy
    on_failure  = continue
    inline = ["kops delete cluster --yes"]
  }*/
}
