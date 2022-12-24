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
    host = var.puppet_git_host
    repo = var.puppet_git_repo
    ref  = var.puppet_git_ref
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
      "ssh-keygen -R ${var.puppet_git_host}",
      "echo '${var.puppet_git_host} ${var.puppet_git_fingerprint}' >> ~/.ssh/known_hosts",
      "ssh-keygen -Hf ~/.ssh/known_hosts",
      "git clone git@${var.puppet_git_host}/${var.puppet_git_repo}?ref=${var.puppet_git_ref} .puppet",
      
            
      "rm -rf .puppet"
    ]
  }
}