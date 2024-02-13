// to declare a variable in terraform we have three optional arguments : description, default value and data type 
variable region{
    description = "defines the region for the resources"
    default = "us-west-2"
    type = string
} 
variable ip{
} 

/* It is not necessary to pass the value of the variable always. If not passed at time of excecution . user will be 
prompted to enter it at time of terraform apply or you can directly pass then as terraform apply --var "<variable_name>=<value>" 
*/ 

// to reference a variable in code
resource "aws_subnet" "subnet-reference" {
  vpc_id = aws_vpc.myVPC.id 
  cidr_block = "10.0.0.0/16"
  availability_zone = var.region // reference of a variable defined 
  tags = {
    Name = "subnet-reference"
  }
}

// terraform automatically looks for terraform.tfvars to find for variables

/* lets say I create another subnet, this time having the value of CIDR Block in a variable and I will
 not give the variable type in command line or while promted . It will take automatically from terraform.tfvars */

resource "aws_subnet" "subnet-reference2" {
  vpc_id = aws_vpc.myVPC.id 
  cidr_block = var.ip
  availability_zone =  "us-west-2"
  tags = {
    Name = "subnet-reference-variable"
  }
}

// you can also define variable types as list and objects