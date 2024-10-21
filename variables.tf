variable "region" {
  description = "The region in which the resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment in which the resources will be deployed"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "my-project"

}

variable "instance_type" {
  description = "The instance type to be used for the EC2 instance"
  type        = string
  default     = "t2.micro"

}

variable "public_key" {
  description = "The path to the public key to be used for SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
  ]
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "instances_per_subnet" {
  description = "Number of EC2 instances in each private subnet"
  type        = number
  default     = 2
}

# dummy
# Example Terraform file with various valid variable declarations

# Simple names

variable "enable_monitoring" {
  type    = bool
  default = true
}

# Names with underscores
variable "public_subnet_count" {
  type    = number
  default = 2
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

# Names with numbers
variable "ec2_instance_count" {
  type    = number
  default = 1
}

variable "rds_port_3306" {
  type    = number
  default = 3306
}

variable "retry_attempts_5" {
  type    = number
  default = 5
}

# Descriptive longer names
variable "database_master_password" {
  type      = string
  sensitive = true
}

variable "load_balancer_idle_timeout" {
  type    = number
  default = 60
}

variable "kubernetes_cluster_version" {
  type    = string
  default = "1.21"
}

# Names with environment prefixes
variable "prod_db_name" {
  type    = string
  default = "production_database"
}

variable "dev_api_url" {
  type    = string
  default = "https://api.dev.example.com"
}

variable "stage_worker_count" {
  type    = number
  default = 3
}

# Names with all caps (often used for constants)
variable "MAX_INSTANCES" {
  type    = number
  default = 10
}

variable "DEFAULT_TIMEOUT" {
  type    = number
  default = 300
}

variable "API_VERSION" {
  type    = string
  default = "v1"
}

# Variable starting with underscore
variable "_internal_variable" {
  type    = string
  default = "internal use only"
}
# List
variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

# Set
variable "unique_tags" {
  type    = set(string)
  default = ["production", "web", "public"]
}

# Map
variable "ami_per_region" {
  type = map(string)
  default = {
    "us-west-2" = "ami-0c55b159cbfafe1f0"
    "us-east-1" = "ami-0947d2ba12ee1ff75"
  }
}

# Object
variable "server_config" {
  type = object({
    instance_type = string
    ami_id        = string
    tags          = map(string)
    ebs_volumes   = list(number)
  })
  default = {
    instance_type = "t2.micro"
    ami_id        = "ami-0c55b159cbfafe1f0"
    tags = {
      Environment = "Production"
      Project     = "WebApp"
    }
    ebs_volumes = [10, 20]
  }
}

# Tuple
variable "instance_settings" {
  type    = tuple([string, number, bool])
  default = ["t2.micro", 1, true]
}

# Complex nested structure
variable "network_config" {
  type = object({
    vpc_cidr           = string
    public_subnets     = list(string)
    private_subnets    = list(string)
    enable_nat_gateway = bool
    tags               = map(string)
    routes = list(object({
      cidr_block = string
      gateway_id = string
    }))
  })
  default = {
    vpc_cidr           = "10.0.0.0/16"
    public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
    enable_nat_gateway = true
    tags = {
      Environment = "Production"
      Terraform   = "True"
    }
    routes = [
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = "igw-12345678"
      },
      {
        cidr_block = "172.16.0.0/12"
        gateway_id = "vgw-87654321"
      }
    ]
  }
}
