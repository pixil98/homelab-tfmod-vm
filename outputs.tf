output "ip_address" {
  description = "Virtual machine IP address"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses[0][0]
}