# create IAM Role

resource "aws_iam_role""ec2-role"{
    name="ec2_role"

assume_role_policy=jsonencode({
	Version="2012-10-17"
	Statement=[
	{
		Action="sts:AssumeRole"
		Effect="Allow"
		Sid=""
		Principal={
			Service="ec2.amazonaws.com"
			}
		      },
    ]
	})
tags={
	tag-key="ec2-role"
	}
}




# Create IAM Instance Profile

resource "aws_iam_instance_profile""ec2-role"{
	name="ec2-role"
	role= aws_iam_role.ec2-role.name
}
	

resource "aws_iam_role""role"{
	name="test_role"
	path="/"
	assume_role_policy=<<EOF
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


# Create Role Policy



resource "aws_iam_role_policy""ec2-role-policy"{
	name="ec2-role-policy"
	role= aws_iam_role.ec2-role.id
	policy=jsonencode(
        {
	    Version="2012-10-17"
	    Statement=[
		    {
			    Action=[
			    "ec2:*",
                     ]
			    Effect="Allow"
			    Resource="*"
            },
                ]
		}
	)
}









