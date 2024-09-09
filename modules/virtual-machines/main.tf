resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.prefix}-${var.number}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B4ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "DEV"
  }

  custom_data = base64encode(file("${var.file_path}"))
  # custom_data = base64encode(<<-EOF
  #   #!/bin/bash
  #   apt-get update
  #   apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  #   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  #   add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  #   apt-get update
  #   apt-get install -y docker-ce docker-ce-cli containerd.io
  #   usermod -aG docker adminuser
  #   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  #   install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  #   EOF
  # )
}

resource "azurerm_managed_disk" "disk" {
  name                 = "${var.prefix}-${var.number}-disk"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 128
  tier                 = "P10"

  tags = {
    environment = "DEV"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-${var.number}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-${var.number}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-${var.number}"
}
