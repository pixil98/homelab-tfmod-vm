data "tls_public_key" "user_publickey" {
  private_key_openssh = var.vm_user_privatekey
}

resource "proxmox_virtual_environment_vm" "vm" {
  name              = format("%s.%s.lab", var.vm_name, var.namespace)
  description       = var.vm_description
  tags              = [ var.namespace ]
  migrate           = true
  node_name         = var.node

  agent {
    enabled = true
  }

  clone {
    node_name = "hobbes"
    vm_id     = 9000
  }

  cpu {
    type         = "host"
    cores        = var.vm_cpu_cores
    sockets      = var.vm_cpu_sockets
    numa         = true
  }

  disk {
    datastore_id = var.vm_disk_class
    interface    = "scsi0"
    #iothread     = true
    size         = var.vm_disk_size
  }

  memory {
    dedicated = var.vm_memory
  }

  operating_system {
    type = "l26"
  }

  on_boot       = true
  pool_id       = var.namespace
  scsi_hardware = "virtio-scsi-pci"

  network_device {
      model           = "virtio"
      bridge          = "vmbr0"
  }

  lifecycle {
      ignore_changes = [
        network_device,
        vga,
      ]
  }

  initialization {
    interface    = "ide2"
    datastore_id = var.vm_disk_class

    ip_config {
      ipv4 {
        address = format("%s/%d", var.vm_network_address, var.vm_network_prefix)
        gateway = var.vm_network_gateway
      }
    }
    user_account {
      username = var.vm_user
      keys     = [ trimspace(data.tls_public_key.user_publickey.public_key_openssh) ]
    }
  }
}

# Apply Puppet role
resource "null_resource" "puppet" {
  depends_on = [ proxmox_virtual_environment_vm.vm ]

  triggers = {
    role = var.puppet_role
    repo = var.puppet_git_repo
    ref  = var.puppet_git_ref
  }

  connection {
    type        = "ssh"
    user        = var.vm_user
    private_key = var.vm_user_privatekey
    host        = var.vm_network_address
    port        = 22
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
