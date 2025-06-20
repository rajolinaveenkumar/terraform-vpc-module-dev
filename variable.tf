
variable "project_name" {

}

variable "environment" {

}

variable "common_tags" {

}

variable "vpc_tags" {
    default = {}
}

variable "cidr_range" {

}

variable "enable_dns_hostnames" {
    default = true
}

variable "igw_tags" {
    default = {}
}

variable "public_subnet_cidr" {
    type = list(any)
    validation {
        condition = length(var.public_subnet_cidr) == 2
        error_message = "You should provide 2 valid pulic subnet CIDR"
    }

}

variable "public_subnet_tags" {
    default = {}
}

variable "private_subnet_cidr" {
    type = list(any)
    validation {
        condition = length(var.private_subnet_cidr) == 2
        error_message = "You should provide 2 valid pulic subnet CIDR"
    }

}

variable "private_subnet_tags" {
    default = {}
}

variable "database_subnet_cidr" {
    type = list(any)
    validation {
        condition = length(var.database_subnet_cidr) == 2
        error_message = "You should provide 2 valid pulic subnet CIDR"
    }

}

variable "database_subnet_tags" {
    default = {}
}

variable "eip_tags" {
    default = {}
}

variable "ngw_tags" {
    default = {}
}

variable "public_route_tags" {
    default = {}
}

variable "private_route_tags" {
    default = {}
}

variable "database_route_tags" {
    default = {}
}

variable "is_peering_required" {
    default = false
}

variable "vpc_peering_tags" {
    default = {}
}