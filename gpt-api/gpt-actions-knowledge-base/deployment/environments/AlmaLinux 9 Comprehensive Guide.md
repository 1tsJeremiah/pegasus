AlmaLinux 9 Comprehensive Offline Guide
Installation and System Requirements
AlmaLinux 9 is a binary-compatible replacement for CentOS/RHEL 9, providing a stable enterprise Linux environment. Before installing, ensure your system meets the minimum requirements:
CPU Architecture: x86_64 (Intel/AMD 64-bit), ARM64 (aarch64), IBM PowerPC (ppc64le), or IBM Z (s390x) are supported.
Memory: 1.5 GB RAM minimum (2 GB or more recommended).
Storage: 10 GB disk space minimum (20 GB recommended for a basic installation).
Boot Firmware: Supports both legacy BIOS and UEFI systems.
Installation Media: AlmaLinux provides several ISO images:
DVD ISO – Full offline installation image (~8 GB) containing nearly all packages.
Minimal ISO – Smaller image (~2 GB) with a basic set of packages for a minimal install.
Boot ISO – Network boot image (~700 MB) that fetches packages from online repositories during install.
Choose an ISO based on your needs. For example, use the DVD ISO for offline installs, or the Boot ISO for a network-based installation (downloads packages on the fly). After downloading an ISO, it’s highly recommended to verify its integrity:
Checksum Verification: Download the SHA256 checksum file and GPG signature from the AlmaLinux site. Import the AlmaLinux GPG public key and verify the checksum file’s signature. Then compute the SHA256 of the ISO and compare with the official checksum. This ensures your ISO is not corrupted or tampered with.
Write to Installation Media: Use a tool to create bootable media. On Linux, you can use dd (be careful to target the correct device):
bash
Copy
Edit
sudo dd if=AlmaLinux-9.x-x86_64-dvd.iso of=/dev/sdX bs=4M status=progress
On Windows, tools like Rufus or Balena Etcher can create a bootable USB.
Booting the Installer: Insert the bootable USB or mount the ISO for a virtual machine and boot the system. At the initial AlmaLinux boot menu, you can typically choose “Test this media & install AlmaLinux 9” (recommended to verify media integrity) or “Install AlmaLinux 9” to skip media testing. After a short loading time, the graphical installer (Anaconda) will start. Basic Installation Steps:
Language Selection – Choose the language/locale for the installer and the target system.
Installation Summary – This hub screen lets you configure various options before proceeding. Sections marked in red need attention before you can begin installation. Key sections include:
Localization: Set Keyboard layout, Language Support, and Time & Date (Timezone).
Software: Select the Installation Source (defaults to the connected AlmaLinux media or nearest mirror) and Software Selection (choose the environment and package set). AlmaLinux 9 offers environment options like Server, Server with GUI, Workstation, Minimal Install, etc. Choose one, and optionally add add-ons (additional package groups) in the right-hand list.
System: Configure Installation Destination (disk partitioning) – by default automatic partitioning is selected. You can switch to custom partitioning for manual control (LVM, custom mount points, encryption, etc.). If you want to encrypt the disk, check Encrypt my data (you will be prompted for a passphrase). Also review KDUMP (kernel crash dumping, enabled by default), Network & Hostname (enable/disable network interfaces, set system hostname)​
WIKI.ALMALINUX.ORG
, and Security Profile (select a predefined security policy, e.g., PCI-DSS, DISA STIG, etc., or leave as Default which applies no special policy).
User Settings: Set the Root Password for the root user (the superuser account). You should choose a strong password. Optionally, create a normal User account. You can mark this user as an administrator (in Anaconda, that adds the user to the wheel group for sudo privileges).
After all required sections are configured (no items remain marked in red), click Begin Installation. The installer will format disks and install packages. You can monitor progress on the progress bar. While installing, you may still set root password or create users if you skipped those earlier.
Reboot – Upon completion, remove installation media and reboot into your new AlmaLinux system.
On first boot, if a graphical desktop was installed, you may be greeted by a setup wizard or login screen for the created user. For server installs (no GUI), you will land on a text console login. Log in as root or the user you created.
Command-Line Usage Basics
After installation, it's important to become familiar with AlmaLinux’s command-line interface (CLI) for administration. AlmaLinux 9 uses the Bash shell by default. If you installed a GUI, you can open a Terminal application. On a server or minimal install, you’ll interact via a text console or SSH. Some fundamental CLI tips and commands:
Getting Root Privileges: For administrative tasks, you need superuser rights. AlmaLinux allows direct root login if you set a root password. Alternatively, use sudo to run single commands as root (your user must be in the wheel group). For example:
bash
Copy
Edit
sudo dnf update
You will be prompted for your user password (which is then cached for a short time). To get an interactive root shell, use sudo -i or su - (for su -, enter the root password).
Basic Navigation: Common shell commands include pwd (print current directory), ls (list files), cd (change directory), cp (copy), mv (move/rename), rm (remove files), mkdir (create directory), and so on. Use --help after a command or consult manual pages via man <command> to learn more about each.
Text Editors: If you need to edit configuration files, AlmaLinux includes vi/vim by default. You may install a simpler editor like nano (sudo dnf install -y nano). Usage: nano /etc/example.conf or vi /etc/example.conf. Learning at least basic vi commands is helpful for editing in rescue situations where only vi is available.
Shell History & Autocomplete: The Bash shell keeps a history of commands (use Up/Down arrows to navigate). Pressing <kbd>Tab</kbd> autocompletes file names or command names (or lists options if there are multiple matches), which can save time.
Checking OS Version: To confirm you are running AlmaLinux and see the version, use:
bash
Copy
Edit
cat /etc/os-release
This will show the NAME (AlmaLinux) and VERSION (e.g., 9.2 “Turquoise Kodkod”). You can also use hostnamectl which reports the OS and kernel version.
Shutdown and Reboot: From the CLI, you can reboot with sudo reboot or shut down with sudo poweroff. These are preferred over pressing the power button, especially on servers, to ensure services stop gracefully.
Overall, AlmaLinux’s CLI behaves like RHEL/CentOS. If you are new to Linux command line, numerous tutorials are available; but the key for an admin is to know the package manager (dnf), service manager (systemctl), and basic navigation and editing. The following sections cover these critical skills in depth.
Package Management with DNF (YUM)
AlmaLinux 9 uses DNF as its package management tool (DNF is the next-generation YUM). In fact, the yum command on AlmaLinux 9 is an alias to DNF for compatibility​
DOCS.REDHAT.COM
, so you can use dnf and yum interchangeably. All software installation, updates, and removal are handled via RPM packages and repositories using dnf. Here are common package management tasks:
Updating the System: After installation, first update your system to the latest packages and security fixes:
bash
Copy
Edit
sudo dnf update
This will refresh repository metadata and upgrade all packages to the latest available versions. It’s wise to run this regularly. You can also check for only security updates (without installing all updates) with:
bash
Copy
Edit
sudo dnf --security update
This lists and applies just security-related fixes.
Installing Packages: To install a new software package from the repositories, use:
bash
Copy
Edit
sudo dnf install <package-name>
For example, sudo dnf install httpd installs the Apache HTTP Server. You can specify multiple packages in one command, or use wildcards. DNF will resolve dependencies automatically and prompt for confirmation (use -y to auto-confirm).
Removing Packages: To remove (uninstall) a package:
bash
Copy
Edit
sudo dnf remove <package-name>
This will uninstall the package and any dependencies that were explicitly installed with it and are no longer needed. (DNF will not remove dependencies that are used by other packages.)
Searching for Packages: If you're not sure of the exact name of a package, use:
bash
Copy
Edit
dnf search <keyword>
This searches package names and descriptions for the keyword. You can also use dnf list <pattern> to list packages matching a name pattern (useful with wildcards, e.g. dnf list "*apache*").
Listing Installed Packages: Use dnf list --installed to list all packages installed on the system. You can also use dnf info <package> to get details of a package (installed version, repository, summary).
Package Groups and Environments: AlmaLinux groups some packages into logical collections. For example, the installer’s Software Selection corresponds to DNF environment groups. You can use dnf groupinstall "<Environment name>" to install a group of packages (for example, "Server with GUI" or "Development Tools"). Similarly, dnf group list will show available package groups/environments. This is advanced usage; for most needs, installing individual packages suffices.
Modular AppStreams: AlmaLinux 9 (like RHEL 9) uses Application Streams (AppStream) for certain software that has multiple versions. For example, databases or language runtimes might be provided as modules with different streams (versions). Use dnf module list to see available module streams. You can install a specific stream by enabling the module or using dnf module install. For instance, to install a specific version of Node.js, you might run:
bash
Copy
Edit
sudo dnf module install nodejs:16
This enables the Node.js 16 stream and installs the default profile of packages for that module. If you need a different stream (say Node.js 18), you would switch (module reset and install the other). The module system allows parallel availability of multiple versions, but you can have only one stream of a module installed at a time. Most regular packages are non-modular and come from BaseOS or AppStream directly.
Cleaning Package Cache: DNF caches repository metadata and packages in /var/cache/dnf/. If you face issues like corrupt metadata or want to free space, use:
bash
Copy
Edit
sudo dnf clean all
This will clear out cached data, forcing DNF to re-fetch fresh metadata on the next operation.
Using YUM: As noted, yum is linked to dnf on AlmaLinux 9 for compatibility​
DOCS.REDHAT.COM
. Longtime CentOS/RHEL users can still type yum install ... and it will work the same. However, when writing scripts or documentation, prefer dnf for RHEL8/9 systems. For more complex package management tasks (like downgrading packages, holding a package at a certain version, or using rpm directly), refer to the RHEL/AlmaLinux documentation. Generally, DNF is powerful and covers most needs. Always ensure your system has the latest updates applied to get security fixes and improvements.
Software Repositories and EPEL
AlmaLinux 9 uses the same repository structure as RHEL 9. By default, two core repositories are enabled:
BaseOS – The base operating system content (core packages, minimal environment). This repo is enabled by default.
AppStream – Additional user-space applications, databases, runtime languages, etc., delivered as modules or packages. Enabled by default.
Additional repositories that AlmaLinux provides or is compatible with:
Extras – Contains extra packages not in RHEL, usually minor utilities or packages that enable other repos (like epel-release). This is typically enabled by default on AlmaLinux.
AlmaLinux Plus – Contains packages that override or add to BaseOS/AppStream with alternative versions or patches (not present in RHEL). This is disabled by default (only use if you need a package from it, as these can diverge from upstream).
High Availability (HA) – Contains cluster and high-availability related packages (corosync, pacemaker, etc.). Disabled by default; enable if you need HA clustering.
CRB (CodeReady Builder) – Called PowerTools in EL8, this repo contains development libraries, headers, and tools often needed to build software (e.g., -devel packages, etc.). In AlmaLinux 9, this is named "CRB" and is disabled by default, but required for EPEL and other build dependencies.
Resilient Storage, RT (Real Time), etc. – Other specialized repos (real-time kernel, etc.), usually disabled by default unless you enable those add-ons.
Enabling/Disabling Repositories: To enable a repository, use DNF’s config-manager (provided by dnf-plugins-core, which is usually installed by default; if not, install that first). For example:
Enable CodeReady Builder (CRB):
bash
Copy
Edit
sudo dnf config-manager --set-enabled crb
This command will enable the CRB repository (PowerTools equivalent), which is commonly needed along with EPEL.
Enable High Availability:
bash
Copy
Edit
sudo dnf config-manager --set-enabled highavailability
(Repo ID for High Availability in AlmaLinux 9 is highavailability.)
To verify which repos are enabled, run:
bash
Copy
Edit
dnf repolist
and
bash
Copy
Edit
dnf repolist enabled
to see all available vs enabled repos. Extra Packages for Enterprise Linux (EPEL): EPEL is a popular repository providing add-on packages for Enterprise Linux systems (RHEL, CentOS, AlmaLinux, etc.) that are not included in the base OS. Many users will want EPEL for additional tools. AlmaLinux fully supports EPEL.
To enable EPEL on AlmaLinux 9, install the epel-release package, which contains the repo definitions and GPG key:
bash
Copy
Edit
sudo dnf install epel-release
This will add the EPEL repository configuration to your system. After this, run dnf update to refresh metadata. EPEL packages require packages from CRB (CodeReady Builder), so ensure CRB is enabled as noted above. During EPEL installation, you may be prompted to import the EPEL GPG key – compare the key fingerprint with the official one (the prompt will show it) and confirm with "y" if it matches.
Once EPEL is enabled, you get access to a large collection of additional software. Use dnf --enablerepo=epel install <pkg> if you want to install a package exclusively from EPEL (though normally, after enabling, DNF will include EPEL in searches). Other Third-Party Repositories:
ELRepo – Provides hardware-related packages like alternative kernel builds (mainline kernels), extra driver modules (e.g., newer GPU drivers or filesystem drivers) for EL9. Enable by installing its release package:
bash
Copy
Edit
sudo dnf install elrepo-release
(This installs repo definitions for ELRepo).
RPM Fusion – Provides multimedia codecs, GPU drivers, and other software not in RHEL due to licensing. RPM Fusion has Free and Non-Free repos. To enable on AlmaLinux 9, first enable EPEL, then install the RPM Fusion release RPMs:
bash
Copy
Edit
sudo dnf install \
  https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm
(This command was provided in AlmaLinux docs for driver setup.) After that, you can install packages like codecs or proprietary driver wrappers from RPM Fusion.
CentOS SIG repositories – Special Interest Groups from CentOS community provide packages for certain niches (e.g., Hyperscale, NFV, Storage, etc.). These can usually be used on AlmaLinux as well (since binary compatible). AlmaLinux wiki provides instructions for enabling CentOS SIG repos if needed.
AlmaLinux Synergy – A repository by AlmaLinux community for packages not yet in RHEL/EPEL, acting as a staging area. It can be enabled by installing almalinux-release-synergy:
bash
Copy
Edit
sudo dnf install -y almalinux-release-synergy
This will also auto-enable EPEL and CRB if not already enabled. Synergy packages are temporary - once a package appears in RHEL or EPEL, it’s removed from Synergy.
Repository Priorities and Caution: AlmaLinux doesn’t enforce repository priority by default. If you enable many third-party repos (EPEL, RPMFusion, ELRepo, etc.), be mindful that package name overlaps could occur. Usually, it’s fine, but for critical systems limit the enabled repos to only those you need. You can disable a repo by editing the repo file in /etc/yum.repos.d/ (set enabled=0) or using dnf config-manager --set-disabled <reponame>. Also consider using dnf upgrade --refresh occasionally to ensure metadata is up to date.
Managing System Services (systemd)
AlmaLinux 9 uses systemd as the init system to manage services (daemons), replace old SysV init scripts, and handle system startup. Systemd introduces the systemctl command as the primary way to manage services and other units. Service Units: Each service has a unit file (in /usr/lib/systemd/system/ or /etc/systemd/system/) that defines how it starts, stops, and any dependencies. You usually refer to services by their name (e.g., sshd, httpd). Here are common systemctl operations:
Start a service (immediately):
bash
Copy
Edit
sudo systemctl start <service>.service
e.g., sudo systemctl start firewalld.service. (The “.service” suffix is optional with systemctl, you can just do systemctl start firewalld.)
Stop a service:
bash
Copy
Edit
sudo systemctl stop <service>.service
This will attempt to gracefully stop the service.
Restart a service:
bash
Copy
Edit
sudo systemctl restart <service>
This stops and then starts the service. There’s also systemctl reload <service> for services that can reload their config without full restart (e.g., systemctl reload httpd to reload Apache HTTPD).
Enable a service at boot:
bash
Copy
Edit
sudo systemctl enable <service>
Enabling configures the service to start automatically on boot. This typically creates a symlink for the service in the default runlevel target. For example, enabling sshd ensures SSH starts on boot​
REINTECH.IO
. To both start now and enable at boot in one step, use --now: sudo systemctl enable --now <service>.
Disable a service:
bash
Copy
Edit
sudo systemctl disable <service>
This prevents it from auto-starting on boot (it does not stop a running service immediately, it just affects future boots). Combine with --now to also stop it immediately.
Check status of a service:
bash
Copy
Edit
systemctl status <service>
This shows whether the service is active (running) or not, the recent log entries for the service, and the PID if running​
REINTECH.IO
. For example, systemctl status NetworkManager might show that it's active and running since boot.
List services:
bash
Copy
Edit
systemctl list-units --type=service --all
This lists all services and their state (running/stopped). Without --all, it lists only active units by default.
You can use systemctl | less to page through a lot of output or systemctl list-unit-files to list installed unit files and whether they’re enabled.
System State: Systemd uses targets (similar to runlevels). Common targets are graphical.target (multi-user + GUI) and multi-user.target (multi-user text mode). To see the current default target: systemctl get-default. To change the default (for example, if you installed GUI but want to boot to command line by default):
bash
Copy
Edit
sudo systemctl set-default multi-user.target
You can switch the current session to a different target with systemctl isolate <target> (be cautious: isolate will stop services not needed by the target, so isolating to multi-user will likely stop your GUI and related services until you reboot or isolate back).
Daemon Reload: If you manually modify a unit file or add a new one, run:
bash
Copy
Edit
sudo systemctl daemon-reload
to have systemd re-read the unit definitions​
REINTECH.IO
​
REINTECH.IO
.
Systemd Journal (Logs): Systemd includes a logging component, journald, which captures logs from services, the kernel, and other sources. Use the journalctl command to view logs. For example:
View all logs (paginated): sudo journalctl -e (shows the end of the log).
Follow live log output: sudo journalctl -f (like tail -f for the journal).
View logs for one boot: sudo journalctl -b (add -1 for previous boot, etc.).
Logs for a specific service:
bash
Copy
Edit
sudo journalctl -u <service>.service
This filters the journal to entries from that unit. For example, journalctl -u firewalld will show firewall service messages, and -u sshd shows SSH logs.
Time filtering: You can filter by time, e.g., journalctl --since "2025-04-01 14:00" to show logs since a date/time. Or --since "2 hours ago".
Limit output: -n 50 to show last 50 lines. Combine with -f to follow from those lines onward.
If your system uses traditional logging (rsyslog), you might also have logs in /var/log/ (e.g., /var/log/messages). By default on EL9, rsyslog might not be installed and the journal is kept in memory (volatile). If you want persistent journal logs across reboots, create /var/log/journal/ directory and restart systemd-journald service; it will then store logs under that directory. Analyzing Boot and Services: If a service fails to start, systemctl status will show "failed" and last logs. Use journalctl -xe for a detailed log of the failure context (the -x provides explanatory messages, -e jumps to end). For troubleshooting boot issues, systemctl --failed lists failed units (if any), and dmesg shows kernel messages (hardware issues, driver errors, etc., especially if something isn't working).
SELinux and Security Policies
SELinux (Security-Enhanced Linux) is enabled by default on AlmaLinux 9 and runs in enforcing mode (enforcing the targeted policy). SELinux provides Mandatory Access Control (MAC) to restrict processes and users to least privilege. Understanding SELinux basics is important for system security and troubleshooting.
SELinux Modes: Three modes are possible: enforcing, permissive, and disabled. Enforcing means SELinux policy rules are in effect and violations are blocked. Permissive means SELinux is running, but only logs violations (does not block). Disabled fully turns off SELinux. You can check the current mode with:
bash
Copy
Edit
getenforce
This will output “Enforcing”, “Permissive”, or “Disabled”. Alternatively, sestatus gives a detailed status, including policy name (typically targeted policy).
Temporarily Switch Mode: To switch SELinux to permissive mode until next reboot (useful for troubleshooting), run:
bash
Copy
Edit
sudo setenforce 0
(setenforce 0 sets permissive, setenforce 1 sets enforcing). This does not persist across reboots. After using permissive mode to test or troubleshoot, you should switch back to enforcing (setenforce 1) to maintain security, or make permanent changes if needed (see below).
Permanently Change Mode: Edit the config file /etc/selinux/config as root. The line SELINUX=enforcing can be changed to permissive or disabled. For example:
bash
Copy
Edit
SELINUX=permissive
SELINUXTYPE=targeted
Changing this requires a reboot to take effect. Note: Setting SELINUX=disabled will effectively disable the policy load. In RHEL9, SELINUX=disabled means no policy is loaded, but the kernel SELinux subsystem is still present. If you truly need to completely disable SELinux (rarely needed), a safer way is to set SELINUX=permissive (no blocks, but you get logs). Fully disabling via kernel boot parameter selinux=0 is possible (e.g., via grubby --update-kernel ALL --args selinux=0), but not recommended for production as it removes a layer of security.
Viewing and Managing Contexts: Every file, process, and port has an SELinux security context label. Usually you don’t need to adjust these unless a service is misconfigured. For example, if a web server needs to serve content from a non-standard directory, that directory’s files must have the proper SELinux type (e.g., httpd_sys_content_t). The ls -Z command shows context labels on files. The ps -Z shows contexts of processes.
SELinux Booleans: SELinux policy has boolean toggles that allow certain behaviors. For example, httpd_can_network_connect if set to on allows Apache to make outbound network connections (off by default). You can list booleans with semanage boolean -l or getsebool -a. Change a boolean (temporarily) with setsebool boolean_name on/off, add -P to make it persistent across reboots. E.g., sudo setsebool -P httpd_can_network_connect on.
Troubleshooting SELinux Denials: When SELinux blocks something, it logs an AVC (Access Vector Cache) denial to /var/log/audit/audit.log (if auditd is running) or the journal. A quick way to find recent SELinux issues is:
bash
Copy
Edit
sudo journalctl -t setroubleshoot
or use the sealert tool (from setroubleshoot-server package) which can analyze and give suggestions. If a service isn’t working, run it in permissive mode to see if SELinux was the issue (because in permissive, the action will succeed and an AVC will be logged). Then you know SELinux blocked it, and you can either adjust context/booleans or create a custom policy module. The ausearch -m avc -ts recent and audit2why/audit2allow tools can help generate custom allow rules if absolutely necessary.
Security Profiles (SCAP): During installation, AlmaLinux offered Security Policy selection (SCAP profiles). By default none is selected. If you need to comply with standards (like PCI-DSS, HIPAA, DISA STIG), you can apply one of these profiles which will configure the system to meet those guidelines (may disable certain services, enforce password policies, etc.). You can also apply them post-install using the scap-security-guide and openscap tools. This is advanced usage – only apply a security profile if you know the implications, as it can be very restrictive. The AlmaLinux wiki references OpenSCAP guides for more info. In summary, keep SELinux enabled (Enforcing) for best security, and only loosen it if absolutely required (and then only to Permissive while fixing issues). Many common services have SELinux policies already that just work with standard configurations. If something isn’t working (e.g., a web app can’t write to a directory), suspect SELinux and check audit logs – there is likely a secure way to configure SELinux to allow it (via context or boolean) rather than disabling SELinux entirely.
Firewall Configuration (firewalld)
AlmaLinux 9 comes with firewalld as the default firewall management service, which is a dynamic firewall daemon fronting iptables/nftables. Firewalld is typically enabled and active by default on AlmaLinux, running as a background service (firewalld.service). It manages firewall rules in terms of zones and services/ports. Key concepts and tasks for firewalld:
Zones: Firewalld organizes rules into zones (e.g., public, home, internal, dmz, work, trusted, etc.). Each network interface is assigned to a zone (by default, interfaces go into the public zone if not specified). Zones have varying default trust levels. The public zone is a generally untrusted zone (suitable for public networks) and is the default active zone. You can check the default zone:
bash
Copy
Edit
firewall-cmd --get-default-zone
(By default it should output "public".) To list all zones and their interfaces/services: firewall-cmd --list-all-zones. To see the active zone(s) configuration, use:
bash
Copy
Edit
firewall-cmd --list-all
This shows the active zone name, interfaces bound to it, and allowed services/ports. You can specify a zone with --zone=<zone> --list-all to inspect non-default ones.
Services and Ports: Firewalld has a concept of predefined services (each service corresponds to one or more ports/protocols). For example, "ssh" service = port 22/tcp, "http" = 80/tcp, "https" = 443/tcp, "cockpit" = 9090/tcp, etc. These definitions are in /etc/firewalld/services/*.xml. Rather than opening ports by number, you can allow a service by name which opens the appropriate port(s).
Allow a Service/Port: Use firewall-cmd to modify rules. There are two contexts for changes: runtime (current session) and permanent (persisted in config). By default, commands affect runtime only unless --permanent is specified. Common examples:
Open (allow) a service in the default zone (runtime):
bash
Copy
Edit
sudo firewall-cmd --add-service=<service-name>
e.g., sudo firewall-cmd --add-service=http to allow web traffic on port 80 (temporarily).
To make it permanent (so it stays open after reboot/firewall reload): add --permanent:
bash
Copy
Edit
sudo firewall-cmd --permanent --add-service=http
(Permanent changes don't take effect immediately until you reload the firewall, so it's often easiest to do the command twice: once without --permanent, once with, or just do permanent and then firewall-cmd --reload to apply.)
Similarly, to remove a service: firewall-cmd --remove-service=<name> (and with --permanent to remove from config).
If you want to allow a specific port that's not defined as a service, use --add-port=<port>/<tcp|udp>. For example: firewall-cmd --permanent --add-port=8080/tcp. You should also specify --zone if you want to target a zone other than the default (e.g., --zone=public --add-port=8080/tcp). Most often, you’ll work with the default public zone.
Reloading and Persistence: If you make permanent changes, you need to reload to apply them to runtime:
bash
Copy
Edit
sudo firewall-cmd --reload
This applies all pending permanent changes to the running firewall. Note that a reload does not break established connections in firewalld (it’s dynamic).
Viewing Allowed Services/Ports: Use:
bash
Copy
Edit
firewall-cmd --zone=public --list-services
to see what services are allowed in the public zone currently. You can also list open ports with --list-ports. For example, by default AlmaLinux might have services like ssh and cockpit allowed in public zone (if cockpit was installed).
Changing Zone of an Interface: By default, all interfaces go to public zone. If this is a trusted network (e.g., internal LAN), you might assign it to the home or internal zone which could have more open services. To change:
bash
Copy
Edit
sudo firewall-cmd --permanent --zone=home --change-interface=eth0
(Replace eth0 with your interface name as shown by nmcli or ip addr). Then --reload. Alternatively, you can set the zone in NetworkManager connection settings so it persists (nmcli connection modify ...).
Caution: If working on a remote SSH session, be careful not to lock yourself out. For example, if you were to run firewall-cmd --permanent --remove-service=ssh --zone=public and then reload, you'd close port 22 and drop your connection. Firewalld by default allows SSH in public zone on initial server install (or at least during installation it adds it if you opted to enable network). Just be mindful of changes. A common safe practice: add rules first (e.g., allow new port), test connectivity, then remove old rules if needed.
Additional Tools: Firewalld also has a GUI (firewall-config) and a TUI (nmtui can set zone for connections). But on a server, CLI is usually sufficient.
Check firewall status: systemctl status firewalld. If you prefer a static firewall and want to disable firewalld, you can install iptables-services and use classic iptables, but generally firewalld is recommended for its dynamic flexibility.
Example: Allowing Cockpit web interface:
bash
Copy
Edit
sudo firewall-cmd --permanent --add-service=cockpit
sudo firewall-cmd --reload
This opens port 9090/tcp (the cockpit service port) in the default zone. If you were running a web server on port 80/443, you’d ensure http and https services are added. Many AlmaLinux server installs have firewalld enabled but minimal services allowed (often just SSH). So any additional server software (web server, FTP, etc.) will require opening ports. Masquerading and Port Forwarding: Firewalld can also do NAT (masquerading) and forward ports, useful if your AlmaLinux box is a router. You can enable masquerading in a zone (--add-masquerade) and even add port forward rules (--add-forward-port). For detailed firewall scenarios, refer to the firewalld documentation. In summary, firewalld is powerful but user-friendly. Use firewall-cmd to open/close ports as needed. Keep the firewall on for security, only allowing what you require. For quick checks during troubleshooting, you might temporarily stop firewalld (systemctl stop firewalld) to see if a firewall is blocking an issue, but always re-enable it and properly configure rules instead of leaving it off.
User and Group Management
Multi-user capabilities are a hallmark of Linux. On AlmaLinux, you can manage user accounts and groups with standard tools (useradd, passwd, etc.) or through GUI system settings if you have one. Here’s how to handle common tasks via the command line:
Add a New User: Use the useradd command:
bash
Copy
Edit
sudo useradd <username>
This creates a user account with the specified name, and a corresponding primary group of the same name (AlmaLinux uses User Private Groups by default, meaning a group is created for each user). By default, on AlmaLinux the new user’s home directory (e.g., /home/username) is created and some default config files are copied from /etc/skel. You usually should set a password next.
Set/Change Password:
bash
Copy
Edit
sudo passwd <username>
You will be prompted to enter a new password for that user (twice). Normal users can run passwd to change their own password (without sudo).
Add User to a Group: The primary group of a user is typically their own (same name). If you want to give additional group memberships (e.g., add a user to the wheel group for admin/sudo rights, or to a project group), use:
bash
Copy
Edit
sudo usermod -aG <groupname> <username>
The -aG option appends the user to that supplementary group. For example: sudo usermod -aG wheel alice will add alice to the wheel group (which on AlmaLinux allows sudo privileges by default).
Create a New Group:
bash
Copy
Edit
sudo groupadd <groupname>
Then you can assign users to it via usermod as above. This is not needed when creating a user if you just want the default group, but useful for creating shared groups (e.g., a “developers” group).
Delete a User:
bash
Copy
Edit
sudo userdel <username>
Add -r to also remove their home directory and mail spool (userdel -r username). Be cautious with this irreversible action.
List Users and Groups: View /etc/passwd to see all user accounts (one per line). System accounts (with UIDs <1000) are for services. Normal user accounts typically start from UID 1000 upward. Similarly, /etc/group lists groups. You can also use the id command to see a user’s UID, GID, and groups: id username. The groups command shows group membership of a user (or yourself if no username given).
Sudo Access: By default, AlmaLinux allows members of the wheel group to use sudo (check /etc/sudoers file, you should see a line %wheel ALL=(ALL) ALL). So the typical approach to give a user admin rights is: add them to wheel group (usermod -aG wheel username). If you prefer to enable sudo per user without group, you could edit sudoers (via visudo) and add a line like username ALL=(ALL) ALL, but using the wheel group is simpler and the recommended method.
Lock or Disable Accounts: usermod --lock <username> (or passwd -l <username>) will lock the user’s password, preventing login (the account still exists). You might do this for an old account instead of deleting it. Unlock with usermod --unlock.
User Private Groups: As mentioned, when you create a user, AlmaLinux by default creates a group with the same name. This is the user’s primary group, and usually the user is the only member. This setup (UPG) makes collaborative file sharing easier in some cases and is standard on RHEL/CentOS/Alma.
Example: Create a user and give sudo rights:
bash
Copy
Edit
sudo useradd bob  
sudo passwd bob                # set bob's password  
sudo usermod -aG wheel bob     # add bob to sudoers (wheel group)
Now bob can use sudo to run admin commands. Encourage new users to create strong passwords. Also note password policies (like minimum length, complexity, expiry) can be configured via /etc/login.defs and PAM settings if needed.
Network Configuration
Networking on AlmaLinux 9 is managed by NetworkManager by default. On a server, you may not have a GUI network tool, but you can use nmcli (command-line interface) or nmtui (text user interface) to configure network connections. Traditional ifcfg files in /etc/sysconfig/network-scripts/ can still be used, but NetworkManager will handle them. Viewing Network Status:
Use ip addr to show network interfaces and IP addresses. Look for interfaces like eth0, ens33, eno1, etc., and their assigned IPs (if state UP). ip route shows the routing table (default gateway, etc.).
Alternatively, nmcli device status shows devices and their state, and nmcli connection show lists the configured network connections (which map to profiles, often one per interface).
Using nmtui: This is a user-friendly text UI. Simply run:
bash
Copy
Edit
sudo nmtui
You'll get a curses-based menu to Edit a connection, Activate a connection, or Set system hostname. You can edit existing connection profiles (like change from DHCP to static IP, set DNS servers, etc.) or create new ones. Navigate with arrow keys and Enter. This is very useful if you’re not comfortable with nmcli syntax. Using nmcli: The nmcli command has a rich syntax. A few useful nmcli examples:
Show all connection profiles: nmcli con show.
Show runtime device info: nmcli dev status and nmcli dev show <device>.
Bring a connection (interface) up or down:
bash
Copy
Edit
nmcli con up <connection-name>
nmcli con down <connection-name>
For example, if nmcli con show lists a connection "System eth0", you can do nmcli con up "System eth0". This is equivalent to ifup/ifdown in classic network scripts.
Modify a connection: e.g., nmcli con modify "System eth0" ipv4.method manual ipv4.addresses "192.168.1.50/24" ipv4.gateway "192.168.1.1" ipv4.dns "192.168.1.1" to set a static IP. Then bring it up.
Add a new connection: (rarely needed manually if using existing ifcfg or DHCP) can be done with nmcli con add commands.
Hostname Configuration: To view or set the hostname, use the hostnamectl command.
View current hostname: hostnamectl (also shows OS info).
Set a new hostname:
bash
Copy
Edit
sudo hostnamectl set-hostname new-hostname
Replace "new-hostname" with the desired static hostname (no spaces, usually). This takes effect immediately and persists (writes to /etc/hostname).
Alternatively, nmtui has a convenient option "Set system hostname" in its menu for this purpose. DNS Configuration: Typically, if using DHCP, DNS servers are received from DHCP. For static configs, you either configure DNS in nmcli/nmtui for that connection or edit /etc/resolv.conf (though note: if NetworkManager is controlling DNS, it might overwrite resolv.conf based on settings). Ensure resolv.conf contains the correct nameserver entries. To test DNS resolution, use:
bash
Copy
Edit
dig example.com
or host example.com or simply ping -c4 google.com to see if it resolves. If DNS fails, check that you have proper nameservers listed in resolv.conf or in your network config. Network Troubleshooting: If you can't reach the network:
Ensure the interface is up: (ip addr should show it UP with an IP). If not, bring up the connection (nmcli con up or ensure the ifcfg file has ONBOOT=yes and restart network).
Check connectivity: try ping -c 4 8.8.8.8. If that works (ICMP replies), but ping -c4 google.com fails, it's a DNS problem. If ping to IP fails, likely network or gateway issue.
Check your default route: ip route. You should have a "default via x.x.x.x dev <interface>" entry. If not, add a default gateway in your config or via nmcli.
Check firewall: Firewalld could block certain traffic (but typically not outbound ping). To rule out firewall on the system, temporarily stop firewalld (sudo systemctl stop firewalld) and test connectivity again.
If on a VM, ensure the VM’s virtual network is connected (bridged/NAT) and any host firewall isn't interfering.
Wi-Fi: If AlmaLinux is used on a desktop/laptop with Wi-Fi, NetworkManager will manage wireless as well. On server minimal install, you may need to use nmcli device wifi list to scan and then nmcli device wifi connect "<SSID>" password "<pass>" to connect, or use nmtui which provides a simple way to connect to a Wi-Fi network by selecting the SSID and entering the passphrase. Network Services: Ensure needed services (like sshd for SSH, NetworkManager itself, firewalld, etc.) are enabled. For SSH, AlmaLinux usually enables sshd by default on servers, but if not, use sudo systemctl enable --now sshd.
Cockpit Web Console
AlmaLinux 9 includes the Cockpit web console – a web-based interface for managing and monitoring your system. Cockpit allows you to manage system settings, view logs, administer user accounts, configure networking, manage virtual machines, and more, all through a web browser. It is especially useful for headless servers to get a graphical overview and perform admin tasks without SSH. Installation: In many AlmaLinux 9 installation variants, Cockpit is installed by default (for server installs). If you chose a minimal install or it’s not present, you can install it manually:
bash
Copy
Edit
sudo dnf install -y cockpit
This will install the main Cockpit package and related dependencies. Enabling: Cockpit runs as a socket-activated service. Enable and start the cockpit.socket to allow web access:
bash
Copy
Edit
sudo systemctl enable --now cockpit.socket
This opens the socket on port 9090 and spawns the cockpit service on demand. Cockpit will now be listening. Firewall: If you have firewalld running with a restrictive policy (which is default), you need to allow Cockpit service through the firewall (on the server side):
bash
Copy
Edit
sudo firewall-cmd --add-service=cockpit --permanent
sudo firewall-cmd --reload
This opens port 9090/tcp in the firewall. (If the system was installed with Cockpit by default, the installer might have already opened the port, but it’s good to verify.) Accessing Cockpit: Once running, open a web browser on a machine that can reach the AlmaLinux server and go to:
cpp
Copy
Edit
https://<server-ip>:9090/
For example, https://192.168.1.100:9090/. Cockpit uses HTTPS. The first time, because it uses a self-signed certificate out of the box, your browser will likely warn about an insecure certificate. You can safely ignore this for local usage (accept the exception), or you can install a valid SSL certificate for Cockpit (by placing cert/key in /etc/cockpit/ws-certs.d/). Logging In: You’ll see a login screen titled "Login to AlmaLinux" (or similar). Use any local system account credentials. You can log in as root (if it’s permitted, it is by default) or as a regular user. Regular users will only have their limited permissions unless they elevate. There’s a checkbox or prompt for Reuse my password for privileged tasks or an option to switch to administrative access after logging in​
DOCS.REDHAT.COM
. Essentially, Cockpit allows you to act as a normal user or as an admin. If you log in as a normal user, you can view your own stuff, but to perform system changes you’ll need to enter credentials for an admin account or elevate (it will prompt you). Features: Once inside, you’ll see an overview dashboard with system information (CPU/Memory usage, disk usage, etc.). Some key things you can do in Cockpit:
System Overview: Shows hardware info, OS version, uptime, performance graphs.
Logs: View system logs (journal) in a nice interface with filtering.
Terminal: There is a built-in web-based terminal you can launch, giving you a root shell in the browser (if you have appropriate rights).
Services: Manage systemd services – start/stop/enable/disable services from a list.
Networking: View and modify network settings, IP addresses, bonding, bridges, etc.
Accounts: Manage user accounts (add/remove users, change passwords).
Software Updates: Cockpit can show available updates and apply them.
Storage: Shows disks, partitions, LVM volume groups, mount points, and allows managing them. You can create and format disks, and even manage RAID or iSCSI.
Firewall: If firewalld is active, there might be a section to manage firewall rules in a simpler form.
SELinux: Newer versions of Cockpit have an SELinux troubleshooting section that surfaces recent denials and suggestions.
Applications: Cockpit is modular – additional pages appear if certain packages are installed:
For example, if you install cockpit-machines, you get a Virtual Machines section to manage KVM VMs through libvirt.
If you install cockpit-podman (for managing containers) or cockpit-docker, you get a Containers section.
If cockpit-networkmanager etc., some networking plugins.
On an AlmaLinux that’s a container host, you might integrate Kubernetes/Openshift plugins (beyond scope here).
Using Cockpit: It’s fairly intuitive – click around to explore. Many operations (like adding a user or starting a service) are just buttons and forms. It’s a friendly way to administer the server without remembering all commands, and useful as a learning tool (since doing an action in Cockpit often shows what command or effect it had). Security: Cockpit is only accessible to those who can reach port 9090. Ensure your firewall or security group (cloud env) only allows trusted sources. It uses system login authentication (PAM). You can optionally enable TLS client certificate auth or other advanced auth, but by default it’s user/password. If you are not using Cockpit, you can disable it: systemctl disable --now cockpit.socket (and close the firewall port). Cockpit is quite lightweight (only active when in use), so leaving it enabled on a server is usually fine. It’s an official RHEL component, so it’s well-supported and secure when properly used.
Virtualization (KVM) on AlmaLinux
AlmaLinux 9, like RHEL9, includes KVM/QEMU for virtualization, managed by the libvirt toolkit. This allows you to run virtual machines (VMs) on your AlmaLinux host without needing a separate hypervisor. The virtualization stack comprises KVM (kernel module for virtualization), QEMU (emulator/VM manager), and libvirtd (daemon that provides an API to manage VMs, networks, storage). Installing KVM/Libvirt: To set up a host for virtualization, install the necessary packages. For a minimal headless environment:
bash
Copy
Edit
sudo dnf install -y qemu-kvm libvirt virt-install virt-viewer
This installs the KVM hypervisor, the libvirtd service, and tools like virt-install (for creating VMs via CLI) and virt-viewer (for graphical console access). If you prefer a GUI, you can also install virt-manager (a graphical VM manager that can run on a desktop and connect to the server). Additional useful tools: virt-top (like top for VMs), libguestfs-tools (for examining VM disk images). These can be installed via group as well (there’s a "@Virtualization" group). Enabling and Starting Services: After installation, start the libvirtd service to manage virtualization:
bash
Copy
Edit
sudo systemctl enable --now libvirtd
This starts the libvirt daemon and ensures it auto-starts on boot​
LINUXTECHI.COM
. Libvirtd will in turn start other related services or socket activate them as needed (e.g., virtualization network service). On AlmaLinux, libvirt usually creates a default virtual network (NAT network 192.168.122.0/24 for VMs to get internet through the host) unless disabled. You can verify that KVM is ready by running:
bash
Copy
Edit
sudo virt-host-validate
This checks for VT-x/AMD-V support, proper kernel modules, etc. It should output all PASS if everything is good (or WARN for things that are optional). If you get a FAIL about virtualization not supported, your CPU or BIOS might not have virtualization extensions enabled. Ensure in BIOS/UEFI that VT-x/AMD-V is enabled (for Intel, grep -E 'vmx' /proc/cpuinfo should show flags if available; for AMD, grep -E 'svm' /proc/cpuinfo). If those flags are missing, you can only do software emulation (very slow). Creating a VM (virt-install): You can create virtual machines via command line or using Cockpit’s Virtual Machines page (if you added cockpit-machines). On command line, the virt-install tool is very handy. Example:
bash
Copy
Edit
sudo virt-install \
  --name testvm \
  --ram 2048 --vcpus 2 \
  --disk size=20 \
  --os-variant alma9.0 \
  --cdrom /var/lib/libvirt/boot/AlmaLinux-9-latest-x86_64-dvd.iso \
  --network default
This would create a VM named "testvm" with 2GB RAM, 2 vCPUs, a 20GB disk image, using an AlmaLinux 9 ISO as installation media, and connecting its network interface to the libvirt "default" network (NATed through host). The --os-variant helps optimize defaults for that OS (get list with osinfo-query os). If running that command from an environment with a graphical display (or X forwarding), virt-install can attach to the graphical console. If not, you might include --graphics none --console pty,target_type=serial to do a text install via serial console. Alternatively, use virt-manager GUI on a desktop to connect to the server’s libvirt (or run virt-manager on the server if it has GUI). Virt-manager provides a friendly interface to create and manage VMs. Managing VMs: Once you have VMs:
Use virsh list --all to list VMs (virsh is the CLI for libvirt).
Start/stop VMs with virsh start VMNAME, virsh shutdown VMNAME (or destroy for immediate power-off).
autostart a VM on boot: virsh autostart VMNAME.
Console access: virsh console VMNAME (for text console if one is configured, e.g., after installing).
Networking: by default, VMs on the default network will have internet access via NAT, and host can reach them by IP 192.168.122.x. If you need bridged networking (VM visible on LAN), you’d create a bridge on the host and attach VMs to it.
Virtualization Host Considerations: Ensure you have enough RAM for your VMs and host. KVM can overcommit memory somewhat, but it’s best not to assign more RAM to running VMs than physically available or you’ll hit swap. CPU overcommit is usually fine as long as workload is reasonable. Storage-wise, if using image files, they reside by default in /var/lib/libvirt/images/. Monitor disk space if you create many large VMs. Use Cases: KVM on AlmaLinux can run any OS that QEMU supports – other Linux distros, Windows, etc. For Windows VMs, install the virtio drivers for better disk/net performance (these drivers are available in the Fedora virtio-win package or ISO). For Linux, if using virtio devices (default), most modern kernels have support built-in. Containers (Podman): In addition to full VMs, AlmaLinux 9 supports containers. Podman is the default tool for running containers (as a replacement for Docker, which is not included by default). Podman is daemonless and can run rootless (as a regular user) or as root. Installing Podman: Podman is typically available in BaseOS or AppStream. Install with:
bash
Copy
Edit
sudo dnf install -y podman
This will bring in Podman and its dependencies (also Buildah for building images, and skopeo for image management, as part of the container-tools module). Verify installation with podman --version. Running a Container: The syntax is very similar to Docker. For example, to run an Alpine Linux container:
bash
Copy
Edit
podman run -dt --name myalpine alpine
This pulls the Alpine image (if not already present) and runs a container in detached mode (-d) with a pseudo-TTY (-t). You can then do podman exec -it myalpine /bin/sh to get a shell inside it, or podman logs myalpine to see its output. Podman uses the same container image format as Docker, so you can pull images from Docker Hub or Quay or others (podman defaults to registry.access.redhat.com, but Docker Hub can be used by specifying docker.io/library/imagename). Common Podman commands:
List running containers: podman ps (add -a to list all, including stopped).
Stop a container: podman stop <name>.
Start a stopped container: podman start <name>.
Remove a container: podman rm <name> (remove must be stopped first).
List images: podman images.
Remove an image: podman rmi <image-id>.
Rootless vs Rootful: Podman can run as a regular user without root privileges. In rootless mode, containers run in user namespace and have limited privileges – you won't need sudo for podman in that case. This is more secure for trying things. However, not all scenarios work rootless (for example, binding to low-numbered ports <1024, or using certain network modes). Rootless podman stores container data in user’s home directory (under ~/.local/share/containers/). Rootful (using sudo podman or root account) behaves like Docker, with system-wide containers stored in /var/lib/containers/. For most development purposes, rootless is fine and safer. If you encounter permission issues with rootless Podman, ensure your user is in the subuid/subgid files with a range allocated (should be automatically configured on install, e.g., /etc/subuid has username:100000:65536). Networking in Podman: By default, rootless containers use slirp4netns (user-mode networking) which allows outbound connectivity but not inbound (you can’t directly expose ports to host). Podman can map ports to the host, though for rootless it uses higher-level ports. For rootful containers, Podman can use CNI networking similarly to Docker’s bridge network (you can -p 8080:80 to map container port 80 to host 8080, etc.). Example:
bash
Copy
Edit
podman run -d -p 8080:80 nginx
This runs an Nginx web server container accessible on host port 8080. Podman Compose: Podman can run Docker Compose files via a tool called podman-compose or by aliasing Docker to Podman, etc. There’s also podman play kube to run Kubernetes YAML. If you need to run multi-container apps, either use podman-compose (a Python tool) or transition to Kubernetes or OpenShift for complex setups. For simple Docker Compose files, often just running multiple podman run with appropriate network settings suffices. Build Images: Use podman build just like docker build, or use Buildah for script-based builds. For a Dockerfile in the current directory:
bash
Copy
Edit
podman build -t myimage:1.0 .
This will produce an image you can see in podman images. Registry login: Podman can login to registries with podman login docker.io if pulling from a private repo requires auth. Podman and systemd: You can generate a systemd unit for a container (podman generate systemd --name mycontainer) and enable it to auto-start containers on boot. Cockpit integration: If you prefer a UI, installing Cockpit and the cockpit-podman package allows container management through the Cockpit web interface. In summary, for virtualization choose KVM/VMs when you need full OS isolation or to run different OSes; choose Podman containers for lightweight deployment of applications in isolation, typically using Linux container images. AlmaLinux provides enterprise-quality support for both.
Troubleshooting Common Issues
Even with a stable system like AlmaLinux, you may encounter issues. Here are some common problem areas and how to address them:
Package Installation or Update Issues
DNF fails or locks up: If a dnf command is stuck, you might have a rogue dnf process or a Yum lock. Kill any dnf processes and remove the lock file /var/run/dnf.pid or reboot to clear it. Running sudo dnf clean all and then sudo dnf update can refresh metadata if you get errors about repositories.
Missing Packages: If dnf can’t find a package, ensure the proper repo is enabled (check dnf repolist). For example, packages in EPEL won’t show up until EPEL is enabled. Dev libraries might require CRB enabled.
GPG key errors: If a repository’s GPG key isn’t imported, you’ll get an error when installing. Usually installing the *-release RPM (like epel-release) handles this. You can manually import keys (they are often in /etc/pki/rpm-gpg/ or downloadable from repo site) using rpm --import.
Transaction failures: Sometimes an update might fail due to conflicts. This can happen if you have third-party repos with overlapping packages. Review the error message – often it names the conflicting package. You might choose to remove an outdated package or exclude it. Using dnf distro-sync can help align versions to AlmaLinux’s repositories if things got out of sync.
Network Connectivity Problems
Cannot reach outside network: First, check physical link (cable plugged in, etc). Use ip addr to ensure you have an IP. If using DHCP, try sudo dhclient <interface> to force getting an IP. If static, double-check your config for typos. Confirm you have a default gateway (ip route). Try pinging your gateway and a public IP like 8.8.8.8. If ping by IP works but not by name, it’s DNS.
DNS not resolving: Check /etc/resolv.conf for valid nameserver entries. If empty/wrong, and you’re using NetworkManager, update the connection’s DNS settings (or add a public DNS like 8.8.8.8 temporarily). Use dig or nslookup to test DNS queries.
Firewall blocking: If you can ping out but not connect on a specific port (say you run a web server and can’t reach it), ensure firewalld is not blocking it. List rules with firewall-cmd --list-all. If needed, open the port or temporarily disable firewalld to test connectivity.
SSH issues: If SSH isn’t working: is sshd running? (systemctl status sshd). Is the port 22 open in firewall? Is the server’s IP correct and reachable? Check /etc/ssh/sshd_config for any unusual settings (like it might be set to a non-standard port or PermitRootLogin might be off, etc.). Also ensure the user is allowed (not in /etc/nologin).
NetworkManager: Sometimes NetworkManager can conflict with manual configs. If you prefer old network service, you could disable NetworkManager and enable network-scripts (network-scripts are deprecated though). Generally, stick to one system. Use nmcli or nmtui to make changes instead of editing ifcfg files by hand to avoid confusion.
Service and Daemon Issues
Service not starting: Run systemctl status <service> to see exit code and maybe error logs. Then check journalctl -u <service> for detailed logs. Common issues:
Misconfiguration: e.g., Apache httpd won’t start if the config has a syntax error or if a configured port is already in use. The logs will indicate the line of config or error.
Missing directories or permissions: e.g., a service trying to write to a path that doesn’t exist. Create the path or fix permissions.
SELinux denials: If a service refuses to start or its functionality is blocked, check sudo ausearch -m avc -ts recent or use journalctl -xe. You might see SELinux prevented something. In permissive mode the service would start. So test by setenforce 0 (temporarily) – if it works then, you know SELinux was an issue and you can adjust context or policy properly.
System won’t boot properly: If the system is stuck during boot or drops to emergency mode:
Use GRUB to edit the kernel command line: remove rhgb quiet to see detailed messages, or add systemd.unit=rescue.target to boot into rescue mode. If you get into emergency mode, usually it prints an error (like couldn’t mount a filesystem). Follow the hints (maybe a filesystem in fstab is missing; remove or fix that entry).
If you forgot the root password or are locked out, boot with rd.break (into initramfs emergency shell) to reset the root password.
Dracut issues: Sometimes after kernel updates, an initramfs might be missing modules (rare). Boot an older kernel from GRUB if possible and then rebuild initramfs (dracut -f).
Performance issues: If the system is slow or hanging:
Check top or htop to see CPU or memory hogs.
Check dmesg for hardware errors (disks throwing errors could slow system if retried).
Ensure swap is present if memory is low (see swapon -s).
If using tuned (RHEL tuning profiles) ensure it’s on an appropriate profile (e.g., virtual-guest if VM).
Storage and Filesystem
Disk full: Run df -h to check usage. If a partition (like / or /var) is 100% full, things will misbehave. Identify large files with du -hax / --max-depth=2 | sort -h | tail -20. Common culprits: log files in /var/log (check journalctl --disk-usage for journal size; you can vacuum it with journalctl --vacuum-size=1G to limit journal size), large cache in /var/cache (e.g., dnf cache if not cleaned), or something writing to a home directory or /tmp endlessly.
Mount issues: If an NFS mount or external drive isn’t mounting, check mount -a and /etc/fstab entries. Dmesg or journal might show errors for failed mounts. Comment out problematic fstab lines if they prevent boot (use nofail option for non-critical mounts so they don’t block boot).
LVM issues: If using LVM, vgs, lvs can show if volumes are full. You can extend an LV if you have free VG space using lvextend and then resize filesystem (xfs_growfs or resize2fs depending on FS).
Other Common Tips
Time and Sync: Ensure your system time is correct. AlmaLinux uses chronyd by default for NTP. If time is off, services (especially certificate validation) can fail. Use chronyc sources to check NTP servers and chronyc tracking for status. Sync time with chronyc makestep.
Kernel crashes (panics): If you experience kernel panics, make sure kdump is enabled to capture them. Check for hardware issues (bad RAM via memtest, etc.). You might try booting an alternate kernel (AlmaLinux plus or mainline from ELRepo) if you suspect a kernel bug. Also update to latest kernel as soon as possible – many panics are resolved in updates.
Hardware drivers: RHEL/AlmaLinux generally include a wide range of drivers. If a device (e.g., a RAID card or GPU) isn’t working, check lspci -k to see if a driver is associated. For GPUs (NVIDIA/AMD), install the proprietary drivers if needed (NVIDIA drivers via RPM Fusion or vendor, AMD normally works with open driver but for pro GPU use cases consider AMDGPU Pro stack). The AlmaLinux wiki provides guides for installing NVIDIA drivers.
Updates and Reboot: Unlike some bleeding-edge distros, on enterprise Linux it's safe and recommended to apply updates regularly. Kernel updates require a reboot to take effect (the old kernel stays running until reboot). Aim to reboot into a new kernel occasionally to keep within support. Use needs-restarting -r (part of dnf-utils) to check if a reboot is suggested after updates.
Troubleshooting Network Example
To illustrate a troubleshooting flow, consider you have no internet on a newly installed AlmaLinux server:
Connectivity Check: Ping an external IP:
bash
Copy
Edit
ping -c 4 1.1.1.1
If it fails, ping your default gateway (e.g., 192.168.1.1). If that fails, likely network is down. If gateway ping works but external doesn’t, likely a gateway or ISP issue.
Configuration: nmcli connection show – is the correct interface active? If not, bring it up (nmcli con up). If using static IP, was it set correctly? Check ip addr details.
DNS: Try ping -c4 google.com. If IP ping works but name fails, open /etc/resolv.conf and see if nameservers are present. If not, add one or fix DHCP server. Test DNS with dig google.com.
Firewall: If pings work but say HTTP fails, check firewall-cmd --list-all to see if maybe an overly strict zone is set. Or if this server is supposed to be reached from outside, ensure ports are open.
Logs: Use journalctl -u NetworkManager or dmesg to see if any network device errors (like perhaps the driver is flapping or cable disconnects).
Following a systematic approach as above (connectivity -> config -> DNS -> firewall -> logs) can resolve most network issues. The same structured approach (check service status -> config files -> logs -> environment (SELinux/firewall) -> external factors) can be applied to other subsystems.
Getting Help
If you encounter an issue not easily solved, consider:
Reading AlmaLinux Wiki or RHEL documentation for that topic.
Searching forums or knowledge base articles; often others have had similar issues.
Using diagnostic tools: sosreport can collect system info for support (especially if working with AlmaLinux or other support).
The AlmaLinux community (via Chat, forums, Stack Exchange) can be helpful.
Remember that AlmaLinux being RHEL-compatible means solutions for RHEL 9 often apply. When troubleshooting, treat it like RHEL – e.g., a solution for CentOS 9 Stream or Rocky Linux 9 should also work for AlmaLinux 9. In summary, keeping your system updated, monitoring logs, and understanding core admin tools will go a long way. This document provides an offline reference, but the man pages (man command) and built-in help --help are also invaluable resources on the system itself. With these guidelines, you should be equipped to install, configure, and maintain an AlmaLinux 9 system and tackle common issues that arise. Enjoy your stable and free Enterprise Linux experience!

