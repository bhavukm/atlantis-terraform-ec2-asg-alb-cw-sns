# tf-aws-asg-lb-cw
Automating AWS Infrastructure with Atlantis-based Terraform pipeline. This project deploys a AWS EC2 Instances as part of an AutoScaling Group (ASG). The AutoScaling Group is integrated with an Application Load Balancer (ALB) and a Launch template (LT). The LT utilizes a custom AWS AMI (Amazon Machine Image) that already has a static website code with an Apache web server configured. The ASG also has a Dynamic Scaling policy to increase the number of instances in the ASG automatically when the Average CPU Utilization of the ASG breaches the threshold of 40 percent. The scaling event is triggered via a CloudWatch Alarm that also sends an AWS SNS (Simple Notification Service) -based Email to the users.

**YouTube Video URL:** https://youtu.be/ThEk09lV0vo

![image](https://github.com/user-attachments/assets/c65bda41-84be-45b6-bb74-74add555c2b9)

**Knowledge of concepts that are required before this video have been covered in my earlier YouTube Videos, do check these out:**

AWS EC2 Instance Creation (Manually from UI): https://youtu.be/FOHXylL8e2Q

AWS EC2 Instance Creation (with Terraform script) and Terraform Installation: https://youtu.be/JkxB_d8XLN8

The entire AWS Project Deployed Manually from UI: https://youtu.be/dMUQTQS1l3g

**Steps to use the Terraform script to deploy the infrastructure: automatically via Atlantis Pipeline**

Please refer to this GitHub Repo for Atlantis setup: https://github.com/bhavukm/terraform-atlantis-pipeline-demo.git
