terraform {
  # Here we define the "backend" that terraform stores our state in.
  # TODO
  backend {
  }
  # Currently running on linode for free credits, change providers as needed
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.31.0"
    }
  }
}

provider "linode" {
  # linode specific config here
}

# Local variables
locals {
  module_name = "example"
  stage = "production"
}

module "example" {
  source = "git::git@github.com:<your-repo-module-release>"
    
  # example string local variable for the module
  a_local_module_variable = "hi there"
  # local variable passing locals from file
  another_variable = local.stage
}

