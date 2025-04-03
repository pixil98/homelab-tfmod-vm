output "ip_address" {
  description = "Virtual machine IP address"
  value       = var.vm_network_address
}

output "physical_host" {
  description = "The physical host on which the VM is provisioned."
  value       = var.node
}
