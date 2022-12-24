resource "proxmox_vm_qemu" "vm" {
  name              = format("%s.%s.lab", var.vm_name, var.namespace)
  desc              = var.vm_description
  target_node       = var.node
  clone             = "debian-11-cloudinit"
  oncreate          = true
  onboot            = true
  pool              = var.namespace
  agent             = 1
  os_type           = "cloud-init"
  cores             = var.vm_cpu_cores
  sockets           = var.vm_cpu_sockets
  cpu               = "host"
  memory            = var.vm_memory
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  disk {
      size            = var.vm_disk_size
      type            = "scsi"
      storage         = var.vm_disk_class
      iothread        = 0
  }
  network {
      model           = "virtio"
      bridge          = "vmbr0"
  }
  lifecycle {
      ignore_changes  = [
        network,
      ]
  }
  
  # Cloud Init Settings
  ipconfig0 = format("ip=%s/%d,gw=%s", var.vm_network_address, var.vm_network_prefix, var.vm_network_gateway)
  nameserver = var.vm_network_nameserver
  searchdomain = var.vm_network_searchdomain
  ciuser    = var.vm_user
  sshkeys   = var.vm_user_publickey
}

# Apply Puppet role
resource "null_resource" "puppet" {
  triggers = {
    role = var.puppet_role
    repo = var.puppet_gitrepo
    ref  = var.puppet_gitref
  }

  connection {
    type        = "ssh"
    user        = proxmox_vm_qemu.vm.ciuser
    private_key = var.vm_user_privatekey
    host        = proxmox_vm_qemu.vm.ssh_host
    port        = proxmox_vm_qemu.vm.ssh_port
  } 

  provisioner "remote-exec" {
    inline = [ 
      "ssh-keygen -R github.com",
      "echo 'github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl' >> ~/.ssh/known_hosts",
      "echo 'github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=' >> ~/.ssh/known_hosts",
      "echo 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' >> ~/.ssh/known_hosts",
      "ssh-keygen -Hf ~/.ssh/known_hosts",
      "git clone ${var.puppet_gitrepo}${var.puppet_gitref == null ? "" : "?ref=${var.puppet_gitref}"} .puppet",
    ]
  }
}