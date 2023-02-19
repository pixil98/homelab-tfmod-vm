data "tls_public_key" "user_publickey" {
  private_key_openssh = var.vm_user_privatekey
}

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
  qemu_os           = "l26"
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
  sshkeys   = trimspace(data.tls_public_key.user_publickey.public_key_openssh)
}

# Apply Puppet role
resource "null_resource" "puppet" {
  triggers = {
    role = var.puppet_role
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
      "sleep 60",
      "sudo apt-get -yqq -o DPkg::Lock::Timeout=-1 dist-upgrade",
      "git clone --quiet ${var.puppet_git_repo} .puppet",
      "git -C .puppet checkout '${var.puppet_git_ref}'",
      "export FACTER_PROVISIONED_USER='${var.vm_user}'",
      "sudo -E /opt/puppetlabs/bin/puppet apply -e 'include role::${var.puppet_role}' --basemodulepath='.puppet/site-modules:.puppet/modules'",
      "rm -rf .puppet"
    ]
  }
}
