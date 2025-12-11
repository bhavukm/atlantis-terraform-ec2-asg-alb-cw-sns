# tf-aws-asg-lb-cw
Automating AWS Infrastructure with Atlantis-based Terraform pipeline. This project deploys a AWS EC2 Instances as part of an AutoScaling Group (ASG). The AutoScaling Group is integrated with an Application Load Balancer (ALB) and a Launch template (LT). The LT utilizes a custom AWS AMI (Amazon Machine Image) that already has a static website code with an Apache web server configured. The ASG also has a Dynamic Scaling policy to increase the number of instances in the ASG automatically when the Average CPU Utilization of the ASG breaches the threshold of 40 percent. The scaling event is triggered via a CloudWatch Alarm that also sends an AWS SNS (Simple Notification Service) -based Email to the users.

**YouTube Video URL:** https://youtu.be/ThEk09lV0vo

![image](https://github.com/user-attachments/assets/c65bda41-84be-45b6-bb74-74add555c2b9)

**Knowledge of concepts that are required before this video have been covered in my earlier YouTube Videos, do check these out:**

AWS EC2 Instance Creation (Manually from UI): https://youtu.be/FOHXylL8e2Q

AWS EC2 Instance Creation (with Terraform script) and Terraform Installation: https://youtu.be/JkxB_d8XLN8

The entire AWS Project Deployed Manually from UI: https://youtu.be/dMUQTQS1l3g

**Steps to use the Terraform script to automatically deploy the infrastructure:**

Resources that should be provisioned before using the Terraform script:

1. An AWS Account with a Bastion Host (EC2 with Amazon Linux 2023 OS) where Terraform is installed and configured. An AWS SSH keypair named "kp".

2. An IAM Role is attached to the Bastion Host with "Administrator" access. For help with IAM Role creation, see the following YouTube Video: https://youtu.be/TF9oisb1QJQ

3. AWS CLI configured on the Bastion Host (In case we need it. Amazon Linux AMI already has AWS CLI installed, so no need to install or configure if you use that AMI).

4. The AMI ID should already be available to be used with the Launch Template. I am keeping it separate from the Terraform project so that when I destroy the project (terraform destroy), the AMI is still available

as I use it with different projects. If help is required to create this AMI, please refer:

YouTube Video: https://youtu.be/FOHXylL8e2Q

or

GitHub Repo: https://github.com/bhavukm/webapp-asg-alb.git

5. The Security Groups for the LT and ALB should already be available. The reason for doing that is the same as in point number 4. If you need help with the creation of Security Groups, please refer to:

YouTube Video: https://youtu.be/FOHXylL8e2Q

6. The infrastructure is deployed in a default VPC and subnets that are available per region (in this case, us-east-1) in an AWS account.

7. An IAM role (for enabling AWS Session Manager) that will be associated with the 2 AWS EC2 Instances that will be part of the LT and ASG, hosting the static Apache website. Again, keeping it separate as I use it in other projects as well. Name the IAM role as: ec2-ssm

Please follow the below steps to configure AWS Session Manager on an AWS EC2 Instance:

   A. Create an IAM Role for EC2 Instance and attach 𝙰𝚖𝚊𝚣𝚘𝚗𝚂𝚂𝙼𝙼𝚊𝚗𝚊𝚐𝚎𝚍𝙸𝚗𝚜𝚝𝚊𝚗𝚌𝚎𝙲𝚘𝚛𝚎 IAM policy to the role.

   B. No need to install the amazon-ssm-agent if you are using Amazon Linux AMI, as it is pre-installed. For other AMIs, refer to: https://docs.aws.amazon.com/systems-manager/latest/userguide/manually-install-ssm-agent-linux.html

   8. SSH to your bastion host and follow the instructions below (commands highlighted in _Italic font_):

      (A). Become root: sudo su -

      (B). Create a directory: _mkdir terraform_

      (C). cd to the new directory: _cd terraform_

      (D). Create the main.tf file: _vim main.tf_ (file is available in this repo - **please fill out the 7 placeholders in the file - MANDATORY STEP**)

      7 Placeholders (subnet-id-1 and subnet-id-2 are at 2 places): your-ami-id, LT-security-group-id, your-email-id, alb-security-group-id, your-vpc-id, subnet-id-1, subnet-id-2

      Note: You may use Terraform variables for all the placeholders.

      (E). Initiate Terraform backend: _terraform init_

      (F). Check Terraform syntax: _terraform validate_

      (G). Perform a dry run to confirm Terraform resources that will be created: _terraform plan_

      (H). Create Terraform resources: _terraform apply_

   10. Head over to your AWS Management console to see the created project resources.

   11. Copy the LB DNS and try accessing the website on a browser. Test if it loads.

   12. Please confirm the AWS SNS Topic subscription by checking your email. This will ensure that you receive the CloudWatch Alarm-based alert email.

   13. SSH into one of the 2 EC2 instances from the AutoScaling Group via AWS Session Manager and then run the following commands to stress out CPU utilization.

       yum install stress -y

       stress --cpu 1 --timeout 800 &

   15. Head over to your ASG Instances section and check if a new EC2 Instance has been created. Also, check your email if you received the alert.

       **This completes the project successfully**

   16. Destroy all terraform resources: _terraform destroy_
