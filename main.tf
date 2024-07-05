# Read the State File
# This data block reads the contents of the first .tfstate file found in the .terraform directory.
# It uses the fileset function to locate all files ending with .tfstate in the .terraform directory.
# The join function is used to concatenate the list of files into a single string.
# The chomp function removes any trailing newline characters.
# The split function splits the string back into a list based on newline characters.
# The element function retrieves the first element of the list, assuming there's only one .tfstate file.
data "local_file" "terraform_state_file" {
  filename = "${path.root}/.terraform/${element(split("\n", chomp(join("", fileset("${path.root}/.terraform", "*.tfstate")))), 0)}"
}

# Decode the State File JSON
locals {
  terraform_state = jsondecode(data.local_file.terraform_state_file.content)
  backend_key     = local.terraform_state.backend.config.key
}

# Assert Provider for Validation
data "assert_test" "backend_key_check" {
  test  = can(regex(var.expected_state_key, local.backend_key))
  throw = "The backend key does not match the expected state key."
}
