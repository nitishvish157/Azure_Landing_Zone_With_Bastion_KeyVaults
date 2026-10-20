variable "virtual_machines" {}
variable "subnet_ids" {
  type = map(string)
}
variable "key_vault_id" {
  type = string
}