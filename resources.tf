resource "aws_key_pair" "example-key-pair" {
  key_name   = "${var.identity}-key"
  public_key = file(var.key_path)
}

resource "aws_instance" "server" {
  ami                         = var.ami
  instance_type               = "t1.micro"
  key_name                    = aws_key_pair.example-key-pair.id
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.server.id]
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = file("install.sh")
  iam_instance_profile        = aws_iam_instance_profile.test_profile.name
  availability_zone           = var.availability_zone

  tags = merge(map("Name", "server"), var.default_tags)
}

resource "aws_kinesis_stream" "PROJECT_test_stream" {
  name             = "PROJECT_test_kinesis"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = merge(map("Name", "PROJECT_test_kinesis"), var.default_tags)
}

resource "aws_s3_bucket" "PROJECT-test" {
  bucket = "PROJECT-test"
  acl = "public-read"

  tags = merge(map("Name", "PROJECT_test_bucket"), var.default_tags)
}

resource "aws_s3_bucket_policy" "yaa-test-bucket-policy" {
  bucket = "${aws_s3_bucket.PROJECT-test.id}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetBucketObjects",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.PROJECT-test.arn}/*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.PROJECT-test.arn}",
                "${aws_s3_bucket.PROJECT-test.arn}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "PROJECT_test_role" {
  name = "PROJECT_test_role"
  path = "/"

  tags = merge(map("Name", "PROJECT_test_role"), var.default_tags)

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "PROJECT_test_profile"
  role = aws_iam_role.PROJECT_test_role.name
}

resource "aws_iam_role_policy" "test_policy" {
  name = "PROJECT_test_policy"
  role = aws_iam_role.PROJECT_test_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.PROJECT-test.arn}*"
    }
  ]
}
EOF
}

