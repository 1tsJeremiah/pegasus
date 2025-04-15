neo server documentation

FAQ
Container has no data
NeoServer support docker, podman.
Check you can run the docker info command in NeoServer's Script.
Check your user is root. Especially Synology's NAS.How to log in to DSM/SRM with root permissions via SSH/Telnet.
Synology non-root use docker run this command to solve.
sudo chgrp administrators /var/run/docker.sock
How to get NVIDIA GPU usage info
please install command nvidia-smi

How to set environment variable
please navigate to the server startup script settings.

How to add Widget
The NeoServer Widget is compatible exclusively with iOS 17 and subsequent versions. How to add and edit widgets on your iPhone

How to copy in the terminal
Tap on the "Copy Mode" icon on the right hand side of the terminal page. This will switch from Terminal Mode to Copy Mode.

To exit “Copy Mode”, tap the same icon again.


Resolving CPU Temperature Retrieval Issue
Virtualised servers typically do not have CPU temperature measurement capabilities, unlike physical servers like NAS systems and routers. • If you have hardware which has temperature measuring capabilities and it is not working, please try one of the below methods to resolve the issue:
Method 1: install sensors package. NeoServer will run this command to read CPU temperature.How to install sensors (lm-sensors) on Ubuntu / Debian Linux
Method 2: Should you encounter difficulties in obtaining temperature readings, please navigate to the server startup script settings and incorporate the following command:
neo_get_temp() {
    echo 20000;
    return 0
};
This command is designed to define a new procedure for fetching temperature information.


Customize the disk to be displayed
Create command neo_get_df, replace filter_disk_name.

neo_get_df() {
   df -T | grep -v 'filter_disk_name'
};
example: filter sda and sdc

neo_get_df() {
   df -T | grep -vE 'sda|sdc'
};
example 2: match CloudFS and vda1

neo_get_df() {
    df -T | head -n 1
    df -T | grep -E 'CloudFS|vda1'
};
for macOS replace df -T with df -Y

neo_get_df() {
    df -Y | head -n 1
    df -Y | grep -E '/Volumes/Storage|/System/Volumes/Data'
};
set default router
neo_get_default_router(){
    echo "en0"
}
Unable to connect via SSH public key configuration on OpenWRT, receiving error message: "Username/PublicKey combination invalid (code 18 = authenticationFailed)".
This is likely caused by adding a public key using newer algorithms such as ecdsa-sha2-nistp256. OpenWRT supports RSA, so please add a public key starting with ssh-rsa to resolve the issue.

Learn about all the features through video.

Data Storage and Privacy
All data is securely stored in iCloud, accessible exclusively by your device. It is imperative to safeguard your keys and passwords against unauthorized access to prevent any potential leakage.

Features
Multi Device
Support across multiple platforms: iPhone, iPad, Mac.

iCloud Sync
iCloud Sync ensures all your configuration information is securely stored in iCloud, facilitating seamless synchronization across your multiple devices.

Security
Security, featuring support for password and biometric (FaceID, TouchID) unlocking mechanisms.

A wealth of features.
providing support for SSH terminal, script execution, containers management, and metrics monitoring with zero server-side configuration required.

