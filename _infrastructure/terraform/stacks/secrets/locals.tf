locals {
  # we originally create secrets by reading from the .env file, but if secrets change then the difference will be 
  # ignored on the next apply because of the line is secrets.tf `ignore_changes = [secret_string]`
  # the secret_names variable is used to define which secrets we actually want to deploy considering some of 
  # the variables in .env are for development only.
  envs = { for tuple in regexall("(.*)=(.*)", file(var.env_file_path)) : tuple[0] => sensitive(tuple[1]) }
}