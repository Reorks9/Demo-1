# Windows Template for Packer

### Introduction

This repository contains Windows template that can be used to create boxes for Vagrant using Packer.

### Packer Version

Packer 1.3.5

### Windows Version

Windows 2016

### VirtualBox Version

VirtualBox 6.0.6

### Product Keys

The `Autounattend.xml` files are configured to work correctly with trial ISOs (which will be downloaded and cached for you the first time you perform a `packer build`). If you would like to use retail or volume license ISOs, you need to update the `UserData`>`ProductKey` element as follows:

* Uncomment the `<Key>...</Key>` element
* Insert your product key into the `Key` element

### Windows Updates

The scripts in this repo will install all Windows updates – by default – during Windows Setup. This is a _very_ time consuming process, depending on the age of the OS and the quantity of updates released since the last service pack. You might want to do yourself a favor during development and disable this functionality, by commenting out the `WITH WINDOWS UPDATES` section and uncommenting the `WITHOUT WINDOWS UPDATES` section in `Autounattend.xml`:

```xml
<!-- WITHOUT WINDOWS UPDATES -->
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\openssh.ps1 -AutoStart</CommandLine>
    <Description>Install OpenSSH</Description>
    <Order>99</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
<!-- END WITHOUT WINDOWS UPDATES -->
<!-- WITH WINDOWS UPDATES -->
<!--
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c a:\microsoft-updates.bat</CommandLine>
    <Order>98</Order>
    <Description>Enable Microsoft Updates</Description>
</SynchronousCommand>
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\win-updates.ps1</CommandLine>
    <Description>Install Windows Updates</Description>
    <Order>100</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
-->
<!-- END WITH WINDOWS UPDATES -->
```

Doing so will give you hours back in your day, which is a good thing.

### OpenSSH / WinRM

Currently, [Packer](http://packer.io) has a single communicator that uses SSH. This means we need an SSH server installed on Windows - which is not optimal as we could use WinRM to communicate with the Windows VM. In the short term, everything works well with SSH; in the medium term, work is underway on a WinRM communicator for Packer.

If you have serious objections to OpenSSH being installed, you can always add another stage to your build pipeline:

* Build a base box using Packer
* Create a Vagrantfile, use the base box from Packer, connect to the VM via WinRM (using the [vagrant-windows](https://github.com/WinRb/vagrant-windows) plugin) and disable the 'sshd' service or uninstall OpenSSH completely
* Perform a Vagrant run and output a .box file

### Using .box Files With Vagrant

The generated box files include a Vagrantfile template that is suitable for
use with Vagrant 2.2.4, which includes native support for Windows and uses
WinRM or SSH to communicate with the box.

### Getting Started

Trial version of Windows 2016 is used by default. This image can be used for 180 days without activation.

Alternatively – if you have access to [MSDN](http://msdn.microsoft.com) or [TechNet](http://technet.microsoft.com/) – you can download retail or volume license ISO images and place them in the `iso` directory. If you do, you should supply appropriate values for `iso_url` (e.g. `./iso/<path to your iso>.iso`) and `iso_checksum` (e.g. `<the md5 of your iso>`) to the Packer command. For example, to use the Windows 2016 retail ISO:

1. Download the Windows Server 2016 (x64) - DVD (English) ISO (`14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO`)
2. Verify that `14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO` has an MD5 hash of `70721288bbcdfe3239d8f8c0fae55f1f`
3. Clone this repo to a local directory
4. Move `14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO` to the `iso` directory
5. Run:
    
    ```
    packer build \
        -var iso_url=./iso/14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO \
        -var iso_checksum=70721288bbcdfe3239d8f8c0fae55f1f windows_2016.json
    ```

### Variables

The Packer templates support the following variables:

| Name                | Description                                                      |
| --------------------|------------------------------------------------------------------|
| `iso_url`           | Path or URL to ISO file                                          |
| `iso_checksum`      | Checksum (see also `iso_checksum_type`) of the ISO file          |
| `iso_checksum_type` | The checksum algorithm to use (out of those supported by Packer) |
| `autounattend`      | Path to the Autounattend.xml file                                |

### Contributing

Pull requests welcomed.

GUID by Serhii Mykhailiuk!!!

1.  All actions were performed on Windows 10 x64.
2.  Installing chocolatey from the link
https://chocolatey.org/docs/installation#installing-chocolatey

3.  All done in PowerShell. I used to install the command
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

4.  In PowerShell
choco istall chocolatey

5.  Install the packer with chocolatey (also in PowerShell)
Choko install packer

6.  You can also install VirtualBox
choco install virtualbox

7.  Check compatibility virtualbox and packer
choco upgrade virtualbox

8.  Download the build from GitHub
https://github.com/joefitzgerald/packer-windows

9.  For convenience, create a folder, for example, Win16. In it we put assembly with GitHub. Here it is 
unpacked. It turns out all the .template and .json files are on the path
C: \ Win16 \ packer-windows-master \
Above, we downloaded the archive with the Packer. Unpack the archive. The file Packer.exe is copied to
C: \ Win16 \ packer-windows-master \ (Not necessary .. without packer.exe works, already checked).
In the command line, go to the directory
C: \ Win16 \ packer-windows-master \ (so that all files are created in this folder).
The corresponding .json file is editable. Remove the first block with VMware boot.


10. In the command line, write the command
packer build windows_2016.json

11. A windows_2016_virtualbox.box file is created.
What we seen in PowerShell:
Virtualbox-iso: virtualbox provider box: windows_2016_virtualbox.box

12. In the command line, write the command
Vagrant init win16
What we seen in PowerShell:
A vagrantfile has been placed in this directory.

13. A vagrantfile file has been created. We edit it. It should turn out like this:
Vagrant.require_version ">= 1.6.2"
Vagrant.configure("2") do |config|
    config.vm.define "vagrant-windows-2016"
    config.vm.box = "windows_2016_virtualbox.box"
    config.vm.communicator = "winrm"
    # Admin user name and password
    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"
    config.vm.guest = :windows
    config.windows.halt_timeout = 15
    config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
    config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    config.vm.synced_folder "../../Application/", "C:/Application"
    config.vm.synced_folder "../../for_sql/", "C:/Program Files/Microsoft SQL Server/MSSQL14.SQLEXPRESS/MSSQL/DATA"
    config.vm.provider :virtualbox do |v, override|
        #vb.gui = true
        v.customize ["modifyvm", :id, "--memory", 8192]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
end

14. In line
v.customize ["modifyvm", :id, "--memory", 8192] 
you can specify your value of allocated RAM.

15.  In the command line, write the command
Vagrant box add windows_2016_virtualbox.box windows_2016_virtualbox.box
What we seen in PowerShell:
Box: successfully added box windows_2016_virtualbox.box (v0) for virtualbox

16. In the command line, write the command
Vagrant up
The virtual machine starts in VirtualBox.
