packer {

    required_version = ">= 1.8.5"

    required_plugins {
        vsphere = {
            version = " >= v1.1.1"
            source = "github.com/hashicorp/vsphere"
        }
    }

    required_plugins{
        windows-update = {
            version =" >= 0.14.3"
            source = "github.com/rgl/windows-update"
        }
    }
}


source "vsphere-iso" "win2019" {

    # vCenter Credentials

    username = var.vcenter_username
    password = var.vcenter_password

    # vCenter Details

    vcenter_server = var.vcenter_server
    insecure_connection = var.vcenter_sslconnection
    datacenter = var.vcenter_datacenter
    cluster = var.vcenter_cluster
    datastore = var.vcenter_datastore
    folder= var.vcenter_folder

    # VM Hardware Configuration

    vm_name = var.vm_name
    notes = "Version: ${ local.build_version }\nBuild Time: ${ local.build_date }"
    guest_os_type = var.vm_os_type
    firmware = var.vm_firmware
    vm_version = var.vm_hardware_version
    CPUs = var.vm_cpu_sockets
    cpu_cores = var.vm_cpu_cores
    RAM = var.vm_ram
    network_adapters {
        network_card = var.vm_nic_type
        network = var.vm_network
    }
    disk_controller_type = var.vm_disk_controller
    storage {
        disk_size = var.vm_disk_size
        disk_thin_provisioned = var.vm_disk_thin
    }
    configuration_parameters = var.config_parameters

    # Removable Media Configuration

    iso_paths = [
        "[${ var.vcenter_iso_datastore }] ${ var.os_iso_path }/${ var.os_iso_file }",
        "[${ var.vcenter_iso_datastore }] ${ var.vmtools_iso_path }/${ var.vmtools_iso_file }"
    ]

    floppy_files = [
        "../unattend/standard/autounattend.xml"
    ]

    cd_files = [
        "../scripts/install-vmtools64.cmd",
        "../scripts/initial-setup.ps1",
        "../scripts/set-ip.ps1",
        "../scripts/update.ps1",
        "../scripts/check_update.ps1",
        "../scripts/shutdown.bat"
    ]

    remove_cdrom = var.vm_cdrom_remove
    convert_to_template = var.vm_convert_template

    # Build Settings

    boot_command = [
        "<spacebar>",
        "<wait450>"
    ]
    boot_wait = "3s"

    ip_wait_timeout = "20m"
    communicator = "winrm"
    winrm_timeout = "2h"
    winrm_username = var.winrm_username
    winrm_password = var.winrm_password
    #shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Build Complete\""
    #shutdown_command = "f:/shutdown.bat"
    shutdown_timeout = "2h"
    disable_shutdown = true
}

build {
  sources = ["source.vsphere-iso.win2019"]

  #provisioner "windows-shell" {
  #  inline           = ["powershell -ExecutionPolicy Bypass -File f:\\update.ps1"]
  #}

}
