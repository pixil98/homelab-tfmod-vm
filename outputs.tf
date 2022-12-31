output "ip_address" {
  description = "Virtual machine IP address"
  value       = proxmox_vm_qemu.vm.ssh_host
}
