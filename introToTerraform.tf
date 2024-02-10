// Terraform creates and manages resources on cloud platforms and other services through their application 
// programming interfaces (APIs). Providers enable Terraform to work with virtually any platform or service with an accessible API.

/* Providers are like plugin that let us connect to particular set of API's and exposing ressources . It can be an 
IAAS like AWS, Azure, GCP OR PAAS like Heroku OR SAAS like Terraform Cloud */

// Here , we are learning to connect to AWS 
provider "aws" {
  region = "us-west-2b"
  access_key =  "******************"
  secret_key = "********************"
  
}

// Terraform has same syntax for creating or referring resources for different providers 
/* Default syntax is :
    resource "providerName_resourceType" "nameForReferenceInTerraformFile" {
        configuring options as....
        key : "value"
    }
*/

// creating an EC2 instance - Elastic Compute Cloud is a web service that provides secure, 
// resizable compute capacity in the cloud.
resource "aws_instance" "ec2-myFirstServer" {
  ami = "ami-0449c34f967dbf18a"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld_trialServer"
  }
}

// creating an VPC (Virtual Private Network - an private isolated network within an AWS account)
resource "aws_vpc" "vpc-myFirstSpace" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "trialVPC"
  }
}

// creating a Subnet for a VPC  
resource "aws_subnet" "myFirstSubnet" {
  vpc_id = aws_vpc.vpc-myFirstSpace.id 
  // referencing other resources in terraform using id Sample Format ( providerName_resourceType.name.id )
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "trialSubnet"
  }
}