Complete Container Stack Documentation
Table of Contents
Docker Manuals
Introduction to Docker
Docker Architecture
Docker CLI and Container Management
Docker Compose and Multi-Container Applications
Docker Networking
Docker Security Best Practices
AlmaLinux 9 Technical Reference
Installation and Setup
System Administration Basics
Package Management with DNF
Service Management with systemd
SELinux Configuration
Firewall Management with firewalld
Networking Configuration
Containers and Development on AlmaLinux 9
Best Practices for AlmaLinux Servers
Traefik Comprehensive Guide
Overview of Traefik
Traefik Architecture and Key Concepts
Docker Provider Setup
Routing and Reverse Proxy Configuration
Middlewares
TLS and Let's Encrypt Configuration
Dashboard and Monitoring
Production Best Practices
Integration Examples
Portainer Technical Guide
Introduction to Portainer
Deploying Portainer (Single Environment)
Managing Multiple Environments (Portainer Agent)
Stack Deployments
Access Control and RBAC
Automation via API
[Single Sign-On (SSO) with Authentikgn-on-sso-with-authentik)
TLS Setup via Traefik
Backup and Recovery
Upgrades and Maintenance
Best Practices for Portainer
Docker Manuals
Introduction to Docker
Docker is a platform that enables developers and system administrators to build, ship, and run applications in containers. Containers are lightweight, portable units that bundle an application’s code with all its dependencies, ensuring consistency across environments. By containerizing application​
REINTECH.IO
elps eliminate the “it works on my machine” problem, making deployment to production or any other environment more reliable【1†L128-L137】【1†L139-L147】. Docker containers achieve isolation by leveraging operating system features (like namespaces and control groups in Linux) rather than full-blown virtual machines, which makes them much more resource-efficient compared to traditional VMs. Use Cases: Docker streamlines the development lifecycle and supports modern DevOps practices. Developers can use containers for development, testing, and continuous integration/continuous deployment (CI/CD) workflows. For example, a team can containerize a web application and its database, run tests in an isolated container network, and then deploy the same containers to production ensuring that the environment remains consistent【1†L133-L142】【1†L144-L152】. Docker’s portability means containers can run on a developer’s laptop, on on-premises servers, or in cloud environments with minimal changes. This makes scaling applications and migrating them between environments very straightforward. Containers vs Virtual Machines: Containers share the host system’s kernel and do not require a full guest OS for each instance, in contrast to virtual machines. This means you can run many more containerized workloads on the same hardware compared to VMs, achieving better resource utilization【1†L154-L160】. Containers start up faster and use less memory, which is ideal for microservices architectures and environments where quick scaling is necessary. Latest Stable Version: The core Docker platform consists of the Docker Engine (the container runtime) and associated tools. As of early 2025, the latest Docker Engine is version 28.x, reflecting continuous improvements in performance and security【35†L762-L770】. Docker also now ships Docker Compose as a plugin (docker compose command) for defining multi-container applications. It’s recommended to keep Docker Engine updated to the latest stable release for the newest features and security patches. Always refer to the official release notes for information on changes when upgrading Docker Engine or Docker Desktop【35†L774-L781】.
Docker Architecture
Docker uses a client-server architecture composed of three main components: the Docker client, the Docker daemon, and the Docker registry【1†L162-L170】. The Docker client is the command-line tool (docker) that users interact with. When you run a command like docker run, the client communicates with the Docker daemon (dockerd) which performs the heavy lifting of building, running, and managing containers on the host【1†L180-L187】. The client and daemon usually communicate via a REST API over a UNIX socket or network interface. 【3†embed_image】 Docker architecture diagram: the Docker client sends commands (e.g., docker run, docker build, docker pull) to the Docker daemon. The daemon manages container images and running containers on the Docker Host. Docker registries (like Docker Hub) store images that can be pulled to the host or pushed from it【1†L164-L172】【1†L174-L182】.
Docker Daemon (dockerd): This is the background service running on the host machine. It listens for Docker API requests from clients and manages Docker objects such as images, containers, networks, and volumes【1†L174-L182】. The daemon handles container lifecycle operations (start, stop, scheduling), image builds, and network management. It can also communicate with other daemons (for example, in a swarm or cluster scenario) to coordinate multi-node container deployments【1†L174-L178】.
Docker Client (docker CLI): The command-line interface is how users interact with Docker. When you issue commands like docker run, docker build, or docker pull, the CLI translates these into API calls that the Docker daemon executes【1†L180-L187】. The Docker CLI can be used to manage local containers as well as remote daemons (by setting the DOCKER_HOST environment variable or using context/CLI flags to point to a remote server).
Docker Registries: A Docker registry is a repository for storing and distributing container images. The default public registry is Docker Hub, but there are others like Quay, Google Container Registry, and you can run your own private registry. When you use docker pull ubuntu:latest, the client contacts a registry (by default Docker Hub) to fetch the image layers. Likewise, docker push uploads an image to a registry. Docker images are identified by name:tag (e.g., nginx:alpine) and content-addressable digest (sha256). By using registries, Docker enables easy sharing and versioning of application images. (Note: Docker Content Trust can be enabled to verify image signatures, ensuring image integrity and publisher authenticity【4†L25-L33】.)
Images vs Containers: An image is a read-only template with instructions for creating a Docker container. It is built up from a series of layers (each layer usually corresponds to an instruction in a Dockerfile). A container is a runtime instance of an image — it includes the image plus a writable layer on top. You can have multiple containers running from the same image, each with its own state. Best practice is to keep images small and focused, and containers ephemeral (containers should be stateless and disposable, with state stored in volumes or databases when needed).
Docker CLI and Container Management
Docker provides a rich CLI to manage images and containers. Below are some of the most common commands and functionality:
Images Management: You can build images using a Dockerfile with docker build -t <name:tag> . (the -t flag tags the image with a name). To list images on your system use docker images. Pull images from a registry with docker pull, and remove unused images with docker rmi. It’s advisable to periodically clean up unused images (docker image prune) to save disk space.
Running Containers: Launch containers from images with docker run. For example, docker run -d -p 80:80 nginx:latest will run an Nginx web server container in detached mode (-d), mapping port 80 of the host to port 80 of the container. The first time you run an image that isn’t present locally, Docker will pull it from the registry. Each container can be given a --name for easier reference (otherwise Docker assigns a random name).
Container Lifecycle: Once running, containers can be managed with commands like docker stop <name> (gracefully stop), docker kill <name> (force stop), and docker start <name> (restart a stopped container). Use docker ps to list running containers (add -a to list all, including stopped ones). You can attach to a running container’s console with docker attach or start an interactive session inside a container with docker exec -it <name> /bin/bash (which is useful for debugging).
Logs and Monitoring: Docker logs can be viewed using docker logs <name> (with -f to follow live logs). Container resource usage (CPU, memory, network, I/O) can be monitored via docker stats. Inspect container details with docker inspect, which shows low-level configuration and state (including network settings, volume mounts, environment variables, etc.).
Volumes and Data Management: Persistent data in Docker is managed through volumes or bind mounts. Volumes are managed by Docker (created with docker volume create or on the fly with docker run -v volumeName:/path/in/container). Bind mounts map a host directory or file into a container (-v /host/path:/container/path). Use volumes for database storage or any data that should outlive a single container instance. To avoid leftover volumes consuming space, list them with docker volume ls and remove unused ones with docker volume rm or docker volume prune.
Resource Limits: Docker allows constraining resources per container for better multi-tenancy. For example, use --memory="512m" to limit memory, --cpus="1.0" to limit CPU, or --restart=always to have containers automatically restart on failures or daemon restarts. Setting appropriate limits ensures one container doesn’t exhaust the host resources at the expense of others.
Container Management Best Practices: Keep containers as ephemeral as possible – treat them as replaceable. If you need to update an application, build a new image and redeploy containers rather than patching a running container. Use descriptive names and labels for containers to help identify them. Leverage Docker object labels (key-value metadata on images/containers) to tag versions, roles, or environment info, which is helpful in orchestrated environments or for automation scripts.
Docker Compose and Multi-Container Applications
While the docker run command is great for single containers, real-world applications often consist of multiple interconnected services (for example, a web server, a database, and a background worker). Docker Compose is a tool and YAML file format for defining and running multi-container Docker applications. Instead of running a series of docker commands, you describe your application’s services, networks, and volumes in a docker-compose.yml (or compose.yaml) file and then start everything with a single command. Compose File Basics: In a compose file, you typically define multiple services, each corresponding to a container (often based on an image). You can specify for each service the image to use (or build instructions), port mappings, environment variables, volumes, and dependency relationships. For example, a simple Compose file might define a web service running an image of your web app and a db service running a MySQL image, and set that the web depends on db starting first.
Example excerpt of a Compose service definition with labels for Traefik integration (explained in a later section):
yaml
Copy
Edit
services:
  web:
    image: mywebsite:latest
    ports:
      - "80:80"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.web.rule=Host(`example.com`)"
      - "traefik.http.routers.web.entrypoints=web"
In this example, web service’s container will be accessible on host port 80, and we’ve added labels to integrate with Traefik (so Traefik will create a route for example.com). Compose automatically creates a network for these services, enabling the web service to reach db by its service name.
Managing Multi-Container Apps: Once your compose file is ready, running docker compose up -d (in the directory of the compose file) will create and start all the defined services. The -d flag runs them in background (detached). Docker Compose will create a default network (usually named after your project) so that services can communicate by name (e.g., your web app could reach the database at hostname db if that’s the service name). You can scale services (run multiple container instances) with docker compose up --scale web=3 for example, if your application is stateless and can benefit from load balancing. To stop and remove all containers in the application, use docker compose down (adding -v will also remove named volumes defined in the file).
Compose for Development: Compose is very useful in development environments as well. You can define volumes to mount source code into containers for live reloading, or use Compose profiles to enable/disable certain services. Compose files can be checked into version control to share consistent development setups across teams. They also serve as documentation of how the whole stack is wired together.
Docker Compose v2: Note that modern Docker setups include Compose as an integrated CLI plugin (you use docker compose ... instead of the old separate docker-compose binary). The Compose YAML specification is now part of the Open Container Initiative (OCI) and is evolving with version 3.x being common. Always refer to the official Docker documentation for the latest Compose file keys and options【40†L5-L13】. Compose v2 supports features like running compose files in Docker Swarm mode or Kubernetes (with Docker stacks or Kompose), but in this guide we focus on the local Docker Engine usage.
Docker Networking
Docker’s networking allows containers to communicate with each other and with the outside world. By default, Docker creates a bridge network called bridge (or docker0 on Linux) for containers. When you run a container without specifying a network, it connects to this default bridge, which enables basic outbound connectivity (containers can reach the internet through NAT) and allows containers to talk to each other by IP address on the same host. Network Drivers: Docker supports multiple network drivers【6†L55-L63】, each suited for different scenarios:
Bridge Network (default): Containers on the same user-defined bridge network can communicate by container name (Docker adds entries to each container’s /etc/hosts or managesNS). The default bridge network requires linking or explicit connection by IP unless you create a user-defined bridge (with docker network create) which provides automatic service name resolution. Use bridge networks for standalone deployments on a single host.
Host Network: The host driver disables network isolation. A container using the host network shares the host’s network stack (meaning it can directly bind ports on the host). This can be useful for certain high-performance networking need​
MARIUSHOSTING.COM
e container provides a service (like monitoring) that needs direct host network access. However, it sacrifices isolation.
None Network: Essentially no networking. The container has no external network interfaces. Useful for specialized cases or security where isolation is paramount.
Overlay Network: Used in Docker Swarm or multi-host scenarios, an overlay network allows containers on different hosts (joined in a swarm or using Docker Enterprise) to communicate securely as if on the same network. This is critical for distributed applications. (In a single-host non-swarm setup, overlay is not used; one would typically just use bridge networks.)
Macvlan Network: This driver gives containers their own MAC address and treats them like physical devices on the network. The container can appear as a separate host on the physical network. This can be useful for legacy applications expecting each service to have a unique MAC or when you need to be part of the same Layer 2 network as the host’s network. It requires more configuration and is advanced usage.
IPvlan, Network Plugins: Docker also supports IPvlan and third-party network plugins (like CNI plugins for integration with Kubernetes, or other software-defined networking solutions). These are less common for everypear in orchestrated or cloud setups.
Exposing Ports: To allow access from outside the host to a container’s service, Docker uses port mapping. For example, docker run -p 8080:80 nginx maps host port 8080 to container port 80. Multiple containers can use the same container port (e.g., many containers running a web server on port 80 internally) as long as they are mapped to different host ports. In Compose files, the ports section does the same mapping. Be mindful of security – exposing ports meanes are reachable from the host’s network (which could be the internet if no firewall rules are blocking it). Container-to-Container Communication: On the same host, containers on the same user-defined network can talk to each other using their service names or container names (as DNS hostnames). If you have multiple networks, a container can be attached to more than one (allowing it to bridge between networks). Docker’s built-r will resolve container names to their private IP addresses on the network. Networking and DNS in Compose: Docker Compose simplifies networking by automatically creating a network for the compose project and attacces to it (unless specified otherwise). This means you can simply use the service name to connect (for example, a WordPress container could reach its MySQL database by connecting to host db if the database service is named `pose file). Firewall Considerations: If the Docker host is running a firewall (like ufw or firewalld on Linux), you need to ensure that the mapped ports are allowed through the firewall. For instance, if a container’s web service is mapped to host port 8080, open that port in the host’s firewall (e.g., using firewall-cmd --add-port=8080/tcp --permanent followed by a reload for firewalld【20†L103-L112】). Docker manipulates iptables/nftables rules automatically to handle NAT for container traffic, but host-based firewalls might still block incoming connections if not configured. On systems like AlmaLinux 9 with firewalld, docker will often integrate with the firewall zone named docker or adjust rules — however, it's good practice to explicitly allow needed service ports.
Docker Security Best Practices
Running containers securely is crucial. While containers provide some isolation, they share the host kernel, so following security best practices is important:
Least Privilege: Run containers with the least privileges required. Avoid running processes inside containers as root user if possible. Many official images provide a way to run as a non-root user. If you build your own Dockerfile, consider using USER to switch to a non-root user after installing software.
Image Provenance and Updates: Use official and trusted images as base images. Keep images updated to include the latest security patches【4†L5-L13】. Regularly pull newer versions and rebuild your custom images. Remove unused images to avoid running outdated software. Enable Docker Content Trust (DCT) if appropriate, which requires images to be signed and verified on pull【4†L25-L33】.
Minimize Image Size: Smaller images not only have a smaller attack surface but also fewer components that could have vulnerabilities. Prefer minimal base images (Alpine, Distroless, etc.) when feasible, and only include what’s necessary for your application to run【4†L33-L37】.
Sensitive Data Management: Do not bake secrets (passwords, API keys) into images. Instead, supply them at runtime via environment variables or Docker secrets (if using Swarm or a secrets management system). Use Docker Volumes or secret management tools for confidential data. If using environment variables for secrets, be aware of docker inspect and logs which might reveal them; consider using Docker secrets or mounting secrets from the host.
Network Security: By default, containers on the same bridge network can talk to each other freely. Use user-defined networks to have more control. For multi-tenant scenarios, use the --icc=false Docker daemon option to disable inter-container communication on the default bridge. Use firewall rules or Docker’s embedded network policies (in swarm mode, you can use network segmentation).
Resource Limits and Quotas: Applying CPU and memory limits to containers not only helps with stability but also can mitigate certain denial-of-service risks (one compromised container can’t easily starve the whole host if limits are in place). Also consider using read-only filesystems (--read-only flag) for containers that don’t need to write to disk, and multi-stage builds to avoid shipping build tools in the final image.
Isolate with user namespaces: Docker can map container user IDs to different host user IDs (user namespace remapping). This can prevent a root user in a container from being root on the host. It adds an extra layer of security in case of a breakout. This feature needs to be enabled in the daemon (/etc/docker/daemon.json with "userns-remap" settings).
Rootless Docker: Newer Docker versions support running the Docker daemon in rootless mode (no root privileges on host). This mode uses user namespaces and other kernel features so that the Docker daemon and containers run without root. Rootless mode can run many (though not all) container workloads and is a good option to reduce risk on development machines or CI runners.
SELinux / AppArmor: On Linux, Docker integrates with security modules. For example, on an SELinux-enabled host (like AlmaLinux), Docker automatically applies an SELinux context type to containers (svirt_lxc_net_t or similar). If mounting host directories, append the :z or :Z suffix to the volume to allow Docker to relabel files for SELinux【39†L190-L198】【39†L200-L208】. The :z option is for shared content (multiple containers can access) and :Z for exclusive. This ensures the container can read/write the host files without violating SELinux policy. Similarly, Docker applies a default AppArmor profile on many systems to restrict system calls. It’s generally good to leave these in place (or customize as needed) rather than disabling security profiles.
Do Not Expose Docker Socket Unprotected: The Docker UNIX socket (/var/run/docker.sock) is effectively root access to the host. Do not expose it to containers unless absolutely necessary, and never expose it via a mapped TCP port without proper protection. If you run management UIs like Portainer (discussed later), ensure they are secured since they use the socket to control Docker.
Monitoring and Patching: Use tools to scan your images for vulnerabilities (Docker Hub offers scanning, and​
MARIUSHOSTING.COM
ools like Trivy or Clair). Monitor container behavior at runtime – e.g., unexpected network connections or process activity – to detect breaches. Always promptly apply updates to Docker itself; Docker releases include important security fixes and it's recommended to run a supported version of Docker Engine.
By following these practices, you significantly harden your container environment. Docker has made it easier to deploy software, but it doesn’t eliminate the need for vigilance on security. In production, also consider additional layers such as running containers in VMs or using Kubernetes with network policies for defense-in-depth if appropriate for your use-case.
AlmaLinux 9 Technical Reference
Installation and Setup
About AlmaLinux 9: AlmaLinux 9 is an enterprise-grade Linux distribution that is binary-compatible with Red 
GITHUB.COM
se Linux 9. It is community-driven and designed as a drop-in replacement for CentOS. AlmaLinux 9.x will receive full support until at least 2027 and security updates through 2032【36†L1-L8】. This makes it a stable base for servers, containers, and development environments. Obtaining AlmaLinux 9: You can download ISO images from the official AlmaLinux website or mirrors. AlmaLinux provides minimal ISOs (for a lightweight server install), DVD ISOs (with more packages, including GUI options), and boot/netinstall ISOs (for network installation). Choose the minimal or server install for container hosts to avoid unnecessary packages. AlmaLinux supports x86_64, ARM64 (AArch64), and other architectures similarly to RHEL. Installation Process: Installing AlmaLinux 9 is similar to RHEL 9 or CentOS Stream 9:
Boot Installer: Write the ISO to a USB or mount it for a VM, then boot. Select installation destination and software selection. For a server or container host, a minimal install or AlmaLinux Server (with or without GUI) is common.
Partitioning: The installer (Anaconda) guides through disk partitioning. You can use automatic partitioning or custom. Ensure adequate space for /var if you plan to store container images (since Docker/Podman images go under /var/lib/... by default).
User Creation: Set a strong root password and create an initial non-root user. You can allow that user to have administrator privileges (sudo).
Network: Configure the network (you might want to enable the network interface during install if using netinstall or for immediate SSH access).
Finalize: Complete the installation and reboot. Post-install, you have a basic AlmaLinux system.
After the first boot, it’s recommended to update the system to the latest packages:
bash
Copy
Edit
sudo dnf update -y
This will apply any patches (including security fixes) that have been released since the ISO image. Reboot if the kernel or critical libraries were updated. Setting Hostname and Timezone: Use the hostnamectl set-hostname <your-hostname> command to set a permanent hostname. Ensure your timezone is correct with timedatectl set-timezone <Region/City>. These steps help ensure logs and scheduling (cron jobs, etc.) match your locale, and a proper hostname is important in networked environments.
System Administration Basics
User and Group Management: AlmaLinux uses the standard Linux user management commands. Create additional users with useradd and set passwords with passwd. Typically, for server administration, you’ll add your user to the wheel group, which by default grants sudo privileges (check /etc/sudoers where %wheel ALL=(ALL) NOPASSWD: ALL or similar might be set, or you may need to uncomment a line to enable wheel group sudo). For example:
bash
Copy
Edit
sudo usermod -aG wheel <username>
This adds a user to the wheel group. Using sudo is preferred over direct root login for auditing and safety. Filesystem and Directories: AlmaLinux 9 uses the XFS filesystem by default for RHEL-based installs (unless changed). This is robust for server workloads. The directory structure follows the Linux Filesystem Hierarchy Standard. Key directories:
/etc for configuration,
/var for variable data (logs in /var/log, web content in /var/www, Docker/Podman storage in /var/lib/containers or /var/lib/docker),
/home for user directories,
/opt for optional software installations, etc.
Essential Commands: As a RHEL-type system, AlmaLinux uses GNU core utilities and typical commands. Some useful ones:
dnf (package manager, see next section),
systemctl (service management, detailed later),
firewall-cmd (firewalld management),
nmcli (network management CLI if using NetworkManager),
semanage and sestatus (for SELinux management, if needed),
journalctl (for viewing logs from systemd’s journald).
File Editing: Editors like vim or nano may not be installed by default on a minimal install. nano is simple for beginners, vim for advanced usage. Install with dnf install nano or dnf install vim as needed. Always be careful editing critical config files and consider making backups (or use version control for /etc in critical systems). Service Accounts: AlmaLinux and RHEL often create system users for services (with UIDs < 1000 by convention). For example, the web server (httpd) runs as apache user, Docker uses root and sometimes a dockerd user depending on setup, etc. When configuring services or file permissions, be mindful of which user a service runs as.
Package Management with DNF
AlmaLinux 9 uses DNF (Dandified YUM) as its package management tool, which is the next-generation version of YUM. It manages RPM packages, resolves dependencies, and can perform installations, updates, and removals of software.
Basic Commands:
dnf install <package> – Install a package (plus dependencies).
dnf remove <package> – Remove a package.
dnf update – Update all packages to the latest available versions. (You can use dnf upgrade interchangeably; both do the same in AlmaLinux).
dnf search <keyword> – Search for packages by keyword.
dnf info <package> – Get information about a package (version, summary, repo source).
dnf list --installed – List all installed packages.
dnf clean all – Clear the package cache (useful if you need to refresh metadata).
Repositories: By default, AlmaLinux is configured with official repositories akin to RHEL’s (BaseOS, AppStream, etc.). Additional repositories can be added by placing .repo files in /etc/yum.repos.d/. For example, EPEL (Extra Packages for Enterprise Linux) is a popular repository providing additional software not in the base distro. You can enable it by installing the epel-release package: sudo dnf install epel-release (if available for Alma 9). AlmaLinux also supports other third-party repos like REMI (for newer PHP versions), PowerTools (CRB - CodeReady Builder), and others, depending on needs. Always ensure third-party repos are trustworthy and necessary.
Module Streams: RHEL 8/9 introduced module streams for certain packages (like multiple versions of PostgreSQL, NodeJS, etc.). With DNF, you can list modules via dnf module list. For example, dnf module install nodejs:16 would enable Node.js v16 stream. Modules allow parallel availability of different versions but note you can only enable one stream of a module at a time per system.
Package Groups: You can install groups of packages using dnf groupinstall "<Group Name>". For instance, dnf groupinstall "Development Tools" will install a suite of compilers and libraries for building software (useful in a dev environment). There are groups for environments like "Server with GUI", "Headless Management", etc., which you might choose during installation or post-install.
Transactions and History: DNF keeps a history of transactions. You can view dnf history to see past installs/removals. You can even rollback certain transactions with dnf history undo <transaction_id> if needed (though rollbacks can sometimes fail if dependencies changed).
Keeping AlmaLinux Updated: Regularly update your system to get security patches (you may also enable automatic updates using tools like dnf-automatic). AlmaLinux will release minor version updates (9.1, 9.2, etc.) which you obtain just by updating packages – no need for a special upgrade tool. Each minor version is supported until the next one is out (AlmaLinux 9.5 is out as of late 2024【37†L157-L165】, for example, containing cumulative updates over 9.0). Always review change logs for kernel or critical library updates if you’re runningService Management with systemd Alsystem and service manager. Systemd brings a consistent way to manage servicetasks, and centralize logging (via journaldrvices:** Use the systemctl command. For exastart nginx – starts the nginx service immediately. :contentReference[oaicite:4]{index=4}inx – stops it.
`sudo systemctl resta​
MARIUSHOSTING.COM
restarts (stop then start).
sudo systemctl reload nginx – reloads configuration without full restart (if the service supports it, e.g., reload Nginx or Apache config).
Enable/Disable at Boot:
sudo systemctl enable nginx – configures nginx to start on boot (it creates a symlink in systemd configuration to ensure the service starts in the desired runlevel/target).
sudo systemctl disable nginx – prevents it from starting at boot.
Services that are enabled will auto-start during system boot. You can check enabled services with systemctl list-unit-files --state=enabled.
Status and Logs:
systemctl status nginx – shows whether the service is active, last few log lines, and if it’s running (active) or stopped (inactive) or failed.
journalctl -u nginx -f – shows logs from the nginx service unit, with -f to follow. Remove -f to see the full log. Journalctl is powerful: you can filter by time (--since "2 hours ago"), by boot (-b for current boot logs), etc.
Service Unit Files: Systemd unit files for services are typically in /usr/lib/systemd/system/ (for packages) or /etc/systemd/system/ (for custom/overrides). They have a [Service] section that defines how to start the process. It’s often useful to know these if you need to add dependencies or environment variables. However, directly editing the vendor-provided unit file isn’t recommended – instead use systemctl edit nginx which creates an override drop-in file in /etc/systemd/system/nginx.service.d/ for local changes.
Targets (Runlevels): Systemd has “targets” which are similar to runlevels. For example, graphical.target vs multi-user.target (non-graphical, multi-user is the typical server runlevel). You can change the default target (for example, if you installed a GUI and want to boot to it, systemctl set-default graphical.target). systemctl isolate <target> can switch to another target on the fly.
Common Services on AlmaLinux: Many common services you might use: sshd (OpenSSH server) is enabled by default on servers (allowing SSH login), firewalld (the firewall daemon, covered next) is usually running by default【12†L336-L344】【12†L375-L384】, network (managed by NetworkManager, which is the default network service on AlmaLinux 9 unless you switch to network-scripts). If you install Docker, it typically introduces a service docker.service you manage similarly; same for Podman’s socket or other container services. Enabling/Disabling Services in AlmaLinux: After installing new software (say Docker), you often need to enable and start it:
bash
Copy
Edit
sudo systemctl enable --now docker
The --now flag starts it immediately as well as enabling for boot. This is a convenient way to do both steps at once. You might want to verify status with systemctl status docker afterward to ensure it's running without errors【8†L69-L77】【8†L81-L89】. Handling Services on Boot: If you find a service not starting on boot, check systemctl status and journalctl for errors. Sometimes SELinux can prevent a service from starting if not configured (for example, a web server trying to bind to a non-standard port might be blocked by SELinux policy, requiring a context change; see SELinux section below).
SELinux Configuration
Security-Enhanced Linux (SELinux) is a mandatory access control (MAC) system that is enabled by default on AlmaLinux 9 (enforcing mode). SELinux adds an additional layer of security by enforcing policies that confine processes to least privilege. By default, AlmaLinux ships with targeted policies that confine key services (web server, database, etc.) while leaving others unconfined.
Checking Status: Use sestatus or getenforce to check SELinux status. On a fresh AlmaLinux 9, it should show as “Enforcing”【12†L377-L384】, meaning policies are actively being applied. If it’s “Permissive,” SELinux is on but not enforcing (just logging violations), and “Disabled” means it’s completely off.
Changing Modes Temporarily: You can switch between Enforcing and Permissive without a reboot using sudo setenforce 0 (go to permissive) or sudo setenforce 1 (back to enforcing). getenforce will then reflect the new state【18†L1-L9】【18†L13-L21】. Note that going from disabled to enabled requires a reboot (and proper configuration).
Changing Modes Permanently: The persistent mode is set in the file /etc/selinux/config. You’d edit that (as root) to set SELINUX=enforcing or permissive or disabled, then reboot to apply. Alternatively on AlmaLinux/RHEL 9, using the grubby command is recommended to alter kernel boot parameters. For example, to disable SELinux permanently you could use:
grubby --update-kernel ALL --args selinux=0
which adds a kernel boot argument to disable SELinux【12†L393-L402】. However, disabling SELinux is not recommended in production – the better approach if encountering issues is to put it in permissive mode while troubleshooting and adjusting policy, then return to enforcing.
Working with SELinux Contexts: Each file, process, and port has an SELinux context (user:role:type:level). For most use cases, you might encounter SELinux when something doesn’t work due to a denial (like a web server unable to read files or bind to a port). You can check logs for SELinux denials with journalctl -t setroubleshoot or grep AVC /var/log/audit/audit.log. The sealert tool (part of setroubleshoot) can analyze denials and suggest solutions.
Common Tasks:
Allowing a web server to use a non-standard port: use semanage port -a -t http_port_t -p tcp 8080 (for example) to label port 8080 as a HTTP service port (if you want to run a web server on 8080).
Adjusting file contexts: if you have web content in a non-standard directory, label it with chcon -R -t httpd_sys_content_t /my/content or better, add a rule with semanage fcontext so that it persists context assignments (then restorecon to apply).
For Docker/Podman, ensure the container_selinux package is installed (it should be as a dependency). This provides the policies that allow containers to operate. If you mount host volumes into containers, use the :z or :Z flags as mentioned in the Docker section to auto-handle labeling【39†L198-L205】【39†L206-L214】.
Disabling SELinux (not recommended): In some development cases or constrained environments, you might decide to set SELinux to permissive. To do this persistently, edit /etc/selinux/config and change SELINUX=enforcing to SELINUX=permissive, then reboot. Or use setenforce 0 for a one-time switch (which will reset on reboot). Fully disabling (SELINUX=disabled) requires a reboot and results in no SELinux policy being loaded at all. This should be avoided unless absolutely necessary, as it removes a layer of protection.
Best Practices: Keep SELinux in enforcing mode on servers whenever possible for maximum security. If something isn’t working, instead of turning it off, investigate the SELinux denial and see if there’s a proper policy or boolean to adjust. RHEL-based systems provide numerous SELinux booleans (tunable settings) you can view with getsebool -a. For example, allowing Apache to connect out to the network (httpd_can_network_connect) or allowing NFS home directories, etc. You can set these with setsebool -P boolean_name on/off. AlmaLinux, being RHEL-compatible, has the same SELinux capabilities and booleans.
Firewall Management with firewalld
AlmaLinux 9 comes with firewalld as the default firewall management service. firewalld provides a dynamic way to manage iptables/nftables rules through zones and services, and it’s easier to use than manually writing iptables rules for most users. By default, firewalld is enabled and starts on boot on AlmaLinux【12†L336-L344】【12†L348-L357】.
Basic Concepts:
Zones: Predefined trust levels (public, private, internal, dmz, work, home, etc.). Each network interface can be assigned to a zone. By default, interfaces not bound to a zone go to the public zone (which is a fairly restrictive zone intended for untrusted networks). The public zone, by default, allows very few services (typically only DHCPv6 and maybe SSH). Other zones like “home” or “internal” are more open (intended for trusted LANs).
Services and Ports: firewalld has a concept of services (which are basically named sets of ports and protocols). For example, the “http” service is port 80/tcp, “https” is 443/tcp, “ssh” is 22/tcp, etc. Opening a service in a zone will allow those ports. You can also directly open specific ports.
Permanent vs Runtime: firewalld distinguishes between runtime changes (effective immediately but lost on next reload/restart) and permanent (persisted in config). By default, the --add-port or --add-service apply to runtime unless --permanent is specified. Typically, one adds rules with --permanent and then reloads the firewall.
Using firewall-cmd:
Check the status and default zone: firewall-cmd --state (should return running if active), firewall-cmd --get-active-zones (to see which zone an interface is in).
List allowed services/ports in a zone: firewall-cmd --list-all --zone=public.
Allow a service (runtime): sudo firewall-cmd --add-service=http --zone=public. This opens port 80 in the public zone until next reboot or firewalld reload.
Make it permanent: add --permanent and then run firewall-cmd --reload to apply the permanent rules to the running firewall【20†L103-L112】【20†L112-L120】. For example:
bash
Copy
Edit
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
This would permanently allow HTTPS (443/tcp) on the public zone.
Open a specific port: sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp (replace zone and port/protocol as needed)【20†L103-L111】. Then reload.
Remove a rule: e.g., sudo firewall-cmd --permanent --remove-service=http --zone=public, then reload.
Change default zone: sudo firewall-cmd --set-default-zone=home (for instance) if this server is in a trusted network and you want a less strict default policy – but be cautious with that. Alternatively, assign a specific interface to a zone: sudo firewall-cmd --permanent --zone=public --change-interface=eth0.
Rich Rules: firewalld also supports rich rules for more complex scenarios (like allow from a specific IP to a port, or logging). Example of a rich rule to allow only a certain IP:
bash
Copy
Edit
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="203.0.113.4" port port=22 protocol=tcp accept'
This would allow SSH (22/tcp) only from 203.0.113.4 in the public zone.
firewalld GUI/Console: On systems with a GUI, you can use the firewall-config tool for a graphical interface. On server installs without GUI, sticking to firewall-cmd is fine, or using textual UIs like nmtui for NetworkManager can also set zones of interfaces indirectly.
Integration with Docker: There is an interplay between Docker and firewalld. Docker manipulates iptables directly to create NAT and allow container -> host connections. With firewalld, you’ll see a docker zone in iptables -L output when Docker is running. Typically, Docker ensures that ports you publish (via -p) are accessible. If you find that firewalld is blocking published ports, you might need to add the port to the zone for the docker0 interface or configure firewalld to trust Docker’s rules. In practice, if you open needed service ports as described above, that should suffice.
Best Practices: Keep your firewall enabled even on development machines unless it truly interferes with something. Only open the ports/services that are necessary. AlmaLinux’s firewalld starts with a secure baseline (especially on the public zone). Regularly review firewall-cmd --list-all for each active zone to verify it hasn’t got more open than expected. And remember to consider IPv6 as well (firewalld handles both by default if you have IPv6 connectivity).
Networking Configuration
Networking on AlmaLinux 9 can be managed via NetworkManager (the default) or classic network scripts (deprecated). By default, AlmaLinux uses NetworkManager with configuration files in /etc/NetworkManager/system-connections/ or using keyfiles. However, it’s often convenient to use the command-line tool nmcli or the text UI nmtui for managing network settings.
Viewing Network Status: nmcli device status will show interfaces and their state (connected/disconnected) and type (ethernet, wifi, etc.). nmcli connection show shows configured connections (which can represent static configs or DHCP configs for interfaces).
Setting a Static IP (with nmcli): Suppose your interface is enp1s0 (the naming is usually predictable but use ip addr to identify interfaces):
Define the IP address and subnet:
sudo nmcli connection modify enp1s0 ipv4.addresses 10.0.0.30/24
Set the gateway:
sudo nmcli connection modify enp1s0 ipv4.gateway 10.0.0.1
Set DNS server(s):
sudo nmcli connection modify enp1s0 ipv4.dns "10.0.0.10 8.8.8.8" (for multiple DNS, space-separated)【22†L13-L21】【22†L17-L25】.
Ensure the method is manual (static) and not auto (DHCP):
sudo nmcli connection modify enp1s0 ipv4.method manual【22†L27-L35】.
(If IPv6 is in use, similarly configure ipv6.addresses, ipv6.gateway, and set ipv6.method to manual or ignore depending on needs.)
Bring the connection down and up to apply changes:
sudo nmcli connection down enp1s0 && sudo nmcli connection up enp1s0【22†L33-L41】.
Alternatively, a system reboot or systemctl restart NetworkManager would also apply, but toggling the interface is less disruptive. After this, ip addr show enp1s0 should reflect the new static IP and nmcli connection show enp1s0 should list the details.
Using ifcfg Files: AlmaLinux still supports old-style network scripts with ifcfg files in /etc/sysconfig/network-scripts/. If NetworkManager is running, it will actually use those if present (unless told otherwise). A typical ifcfg for a static IP might look like:
ini
Copy
Edit
DEVICE=enp1s0
BOOTPROTO=none
ONBOOT=yes
IPADDR=10.0.0.30
PREFIX=24
GATEWAY=10.0.0.1
DNS1=10.0.0.10
DNS2=8.8.8.8
This method is fine too, and NetworkManager can read these if you have nm-controlled=no or similar. However, nmcli is the modern recommended approach.
Hostname & DNS: The system’s hostname can be set with hostnamectl as mentioned. DNS client settings, if not using NetworkManager’s DNS entries, are in /etc/resolv.conf. On a server, that is usually managed by NetworkManager or systemd-resolved. If you find DNS not resolving, ensure /etc/resolv.conf has correct nameserver entries. If using DHCP, the DHCP server often provides these.
Multiple NICs and Bonding/Bridging: For advanced setups, AlmaLinux (via NetworkManager or directly via nmcli/ifcfg) can configure bonded interfaces (for link aggregation), VLAN tagging on interfaces, or even bridges (for KVM virtualization or containers that need to be on the same L2 network). For example, to create a bridge br0 and have an interface join it, you could use nmcli or ifcfg files. This is beyond the scope of this doc to detail fully, but NetworkManager does support nmcli connection add type bridge ... and nmcli connection add type bridge-slave ... for adding member interfaces.
Testing Connectivity: Use ping to test basic network connectivity. For DNS resolution test, dig or host commands (from bind-utils package) are useful. If something like internet access is not working, check default route (ip route to see if a default via gateway is present) and check that no firewalld or SELinux is blocking (though typically those don’t block outbound).
Networking and Containers on AlmaLinux: If this AlmaLinux 9 system will host containers (Docker or Podman), ensure that any static IP configuration doesn’t conflict with Docker’s default network (172.17.0.0/16) or Podman’s (usually 10.88.0.0/16). If your host network uses those ranges, you may want to adjust Docker’s default bridge network settings (in daemon.json) or Podman’s CNI config to avoid overlap.
Containers and Development on AlmaLinux 9
AlmaLinux 9 is a great host for container runtimes and also as a development environment, given its stability. Here’s how to optimize AlmaLinux for these purposes:
Installing Docker on AlmaLinux 9: AlmaLinux does not ship Docker Engine by default (instead, Red Hat promotes Podman). However, you can install Docker CE on AlmaLinux by using the CentOS/RHEL repository from Docker. The steps are:
Add Docker CE Repo: Docker’s repo for CentOS/RHEL can be added, since AlmaLinux 9 is compatible. For example:
bash
Copy
Edit
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
(This repo covers RHEL-compatible distributions.)【8†L52-L60】
Install Packages:
bash
Copy
Edit
sudo dnf install -y docker-ce docker-ce-cli containerd.io
This will install the Docker engine, CLI, and containerd (Docker’s underlying runtime)【8†L62-L70】. If you encounter dependency issues, ensure the repo is correct and AlmaLinux extras are enabled (for container-selinux package). Sometimes using --nobest can help if the very latest version isn’t available.
Start and Enable Docker:
bash
Copy
Edit
sudo systemctl enable --now docker
This starts the Docker daemon and sets it to run on boot【8†L67-L75】.
Post-install: Verify with docker run hello-world【8†L75-L83】. Also, to run docker commands as your regular user, add yourself to the “docker” group: sudo usermod -aG docker <username>【8†L87-L93】, then log out and back in for it to take effect. (Be aware that giving a user access to the docker group is effectively giving root-level control, so only do this for trusted users or in dev environments.)
Note: Instead of Docker, AlmaLinux offers Podman as a rootless container engine (dnf install podman). Podman can run many Docker container images without needing a daemon and can run as non-root by default, making it safer for multi-user systems. Podman also has podman compose (or using podman with compose YAML via podman play kube or similar). If you prefer the Docker workflow but rootless, Podman is an alternative. You can even alias docker=podman for many commands. That said, Docker is still widely used, and on AlmaLinux it works fine if installed as above.
Development Tools: On AlmaLinux, if you’re setting up a development environment, you likely need compilers, libraries, etc. The group "Development Tools" can be installed as mentioned (which includes GCC, make, etc.). For development in certain languages, you might need to enable module streams (for example, dnf module enable nodejs:18 for Node.js 18, then dnf install nodejs). AlmaLinux’s AppStream repository contains multiple versions of languages like Python, Ruby, Node, etc., via modules.
SELinux Considerations for Containers: As discussed, when using Docker on AlmaLinux with SELinux enabled, ensure the containerd.io and container-selinux packages are present (they should be installed as dependencies). Use :z on volume mounts so SELinux allows container access. If writing custom SELinux policies for containers (rare, but for very locked-down scenarios), you might explore the udica tool which helps generate SELinux policies for containers【17†L141-L149】【17†L143-L147】.
Using AlmaLinux as a Container Base: You can also use AlmaLinux inside containers. There are official AlmaLinux container images (like almalinux:9 on Docker Hub) which provide a minimal AlmaLinux userland. This is useful for containerizing applications that require a RHEL-like environment. Package management inside such a container uses dnf as normal. AlmaLinux container images are typically slim, containing just the basics to function (no kernel, since containers use the host kernel).
Container Orchestration: If your use-case grows, AlmaLinux 9 can be a node in a Kubernetes cluster (via something like RKE, k3s, or even OpenShift Origin). Ensure cgroups v2 is properly configured (RHEL9 uses cgroup v2 by default which modern Kubernetes supports). You might need to set systemd.unified_cgroup_hierarchy=1 in older releases if it wasn’t already. But AlmaLinux 9 likely has cgroup v2 as default, which Docker supports as of Docker 20.x+.
Performance Tuning: For heavy container usage, consider tuning the storage driver for Docker if needed (modern Docker on RHEL uses overlay2 which is good). Ensure adequate disk space for /var/lib/docker. If running databases in containers, you may want to locate the volume on fast storage (like NVMe SSDs) and perhaps use direct-lvm for stable performance (with Docker’s devicemapper, though devicemapper is deprecated in favor of overlay on xfs). For networking performance, if using high packet rates, using macvlan or host networking can reduce overhead.
Best Practices for AlmaLinux Servers
Whether you use AlmaLinux 9 as a host for containers, as a development VM, or as a general server, some best practices to keep in mind:
Regular Updates: Keep the system updated. Enable automatic updates for critical security patches if possible (the dnf-automatic package can apply updates on a schedule). This ensures kernel and library vulnerabilities are patched. AlmaLinux will occasionally release point upgrades (like 9.3, 9.4); these are achieved by standard package updates.
Enable EPEL if needed: The Extra Packages for Enterprise Linux repository provides many developer tools and newer versions of software that are not in base AlmaLinux. If you need packages like htop, stress, or certain newer language versions, EPEL is a safe and curated source. Install with dnf install epel-release and then dnf update.
Security Hardening: Beyond SELinux and firewalld, consider:
SSH Hardening: Use key-based authentication, disable root login over SSH (edit /etc/ssh/sshd_config to PermitRootLogin no), and perhaps change the default port or use firewall to limit access. You can also use tools like Fail2Ban to block brute force attempts.
User Management: Remove or lock any unnecessary system accounts. Use groups to manage permissions cleanly. Ensure strong, unique passwords if password auth is enabled.
Monitoring: Set up monitoring for your AlmaLinux server – whether it’s node_exporter for Prometheus, or a cloud monitoring agent, ensure you get alerted on high resource usage, low disk space, etc. AlmaLinux being stable means if something is wrong, it’s likely your application load or an attack, so monitoring helps catch that.
Time Sync: Use chronyd (which should be installed by default) or ntpd to keep system time in sync. Chrony is the default in RHEL9 and is usually active by default, syncing with CentOS/Alma pool NTP servers. Check with chronyc sources.
Backups: Regularly backup important data from your AlmaLinux server. If it’s a VM, take snapshots or use backup tools. If it’s a physical host, ensure config files (like those in /etc, or data in /var) are backed up to remote storage.
Using AlmaLinux for Development: If you use AlmaLinux as a development environment (say via a VM or WSL2 or similar), you can install development tools, editors, and container tools as needed. Leverage Podman if you want rootless containers to avoid needing sudo for docker. Use toolbox (a Fedora/RedHat tool) or similar if you want a disposable dev environment container that’s integrated.
Kernel and Performance Tuning: AlmaLinux 9 comes with a modern kernel (5.14 for AlmaLinux 9.0, with minor version updates incorporating later kernels as per RHEL’s roadmap). For special workloads, consider tuning sysctl parameters. For instance, if running a lot of network throughput, you might adjust net.core.* and net.ipv4.ip_local_port_range, etc. If running containers, Docker might set some of these for you, but not all. Use sysctl -a to view current kernel parameters and consider tuning file descriptor limits, process limits, etc., if your application demands it.
Container-Specific: When AlmaLinux is used as a container host, ensure Docker’s or Podman’s storage doesn’t fill the root filesystem. Monitor /var/lib/docker size. Use log rotation for container logs (Docker by default keeps growing the log; you can set a log driver or max-size). Also consider the impact of SELinux on containers as covered; don’t disable SELinux – set it up correctly.
AlmaLinux 9 being a clone of RHEL 9 means you get a predictable, stable platform with a decade of updates. That stability is excellent for both hosting and developing containerized applications. By following the above best practices, you’ll maintain a secure and efficient AlmaLinux environment.
Traefik Comprehensive Guide
Overview of Traefik
Traefik is a modern, cloud-native reverse proxy and load balancer that is designed to dynamically manage routing of HTTP(S) traffic to microservices and containers. Often dubbed a “cloud-native edge router,” Traefik integrates with various container orchestrators and platforms (Docker, Kubernetes, Swarm, etc.) to automatically discover services and route requests to them without manual configuration of static routes. Key features of Traefik include:
Automatic discovery of services (using providers like Docker, Kubernetes, file-based config).
Dynamic configuration via providers and a powerful routing rule system (e.g., route by domain, path, headers).
Integrated Let's Encrypt support for automatic certificate provisioning and renewal (great for quickly securing endpoints with HTTPS).
Middleware system to modify requests/responses on the fly (for tasks like authentication, rate limiting, compression, etc.).
Support for multiple protocols (HTTP, HTTPS, TCP, UDP) and WebSocket, HTTP/2, gRPC, etc.
Observability with built-in metrics (for Prometheus, Datadog, etc.), access logs, and tracing support (Zipkin, Jaeger, etc.).
A web dashboard to visualize configured routers, services, and middlewares.
Traefik’s current major version is 2.x (with minor releases 2.9, 2.10, etc., and even a preview of 3.x in development). The config syntax changed significantly from Traefik 1.x, so guides will usually specify version. This guide covers Traefik 2.x, which uses the concept of routers, services, and middlewares for configuration.
Traefik Architecture and Key Concepts
Traefik’s architecture can be understood in terms of entry points, routers, middlewares, services, and providers:
EntryPoints: These are the network entry points into Traefik. For example, you can define an entrypoint for HTTP on port 80, another for HTTPS on port 443, maybe another for a TCP service on port 3306, etc. EntryPoints are defined in the static configuration (because they define where Traefik listens).
Providers: Providers are sources of configuration. Traefik supports Docker, Kubernetes, file (YAML/TOML), Consul, etc. A provider supplies Traefik with information about routes and services. The configuration from providers is dynamic (Traefik listens for changes, like new containers starting, or changes in a config file).
Routers: A router matches incoming requests on an entrypoint to a service (and can apply middlewares). A router has a rule (e.g., “Host(myapp.example.com) && PathPrefix(/api)”) to decide if it should handle a request【24†L121-L129】. If the request matches, the router will forward the request to its associated service. A router can also specify other properties like which entrypoint(s) it listens on and what priority it has (if multiple routers could match, priority decides).
Services: In Traefik terms, a service is the destination for the traffic that a router forwards. This could be one or multiple endpoints (containers, pods, URLs). For example, a service might be defined to point to a Docker container’s port, or a set of pods in Kubernetes, etc. Traefik will load-balance requests among all endpoints of a service if there are multiple. Services can also be used to do things like pass through to a weighted set of upstreams (for A/B testing, etc.).
Middlewares: Middlewares are filters that can modify requests or responses or take actions before the request reaches the service. Traefik provides many middlewares: for authentication (like BasicAuth, ForwardAuth), rate limiting, IP whitelisting, redirects, adding headers, rewriting paths, etc.【28†L69-L77】【28†L79-L87】. You attach middlewares to routers (i.e., a router can reference a list of middlewares to apply).
The Traefik Dashboard/API: Traefik itself exposes an internal API and a web UI (dashboard) which can show you all the routers, services, etc. This is very useful for debugging and oversight. Access to the dashboard should be secured (it can be done by either not exposing it or by putting authentication on it via middleware).
Static vs Dynamic Configuration: Traefik has two types of config:
Static config – defined when Traefik starts (via a config file or command-line flags or env vars). This includes things like entrypoints, the definition of providers (e.g., “enable Docker provider”), and global settings (like log level). Static config cannot be changed without restarting Traefik.
Dynamic config – obtained from providers (could be from a file provider which is watched, or from Docker labels on containers, etc.). This includes routers, services, middlewares definitions. Dynamic config can change at runtime as Traefik monitors the providers.
In a Docker context, much of Traefik’s configuration will be provided dynamically through Docker labels on containers.
Docker Provider Setup
When running Traefik with Docker, Traefik can automatically discover containers and route to them based on labels. To enable this, you configure Traefik’s static configuration to use the Docker provider. Traefik Deployment (Docker Compose example): You might deploy Traefik itself as a Docker container. Here’s a conceptual example of a Traefik service in a compose file:
yaml
Copy
Edit
services:
  traefik:
    image: traefik:latest
    command:
      - "--entryPoints.web.address=:80"
      - "--entryPoints.websecure.address=:443"
      - "--providers.docker=true"
      - "--providers.docker.exposedByDefault=false"
      - "--providers.docker.network=traefiknet"
      - "--api.insecure=true"        # (enable dashboard without auth; use only in dev!)
      - "--api.dashboard=true"
      - "--certificatesResolvers.myresolver.acme.httpChallenge.entryPoint=web"
      - "--certificatesResolvers.myresolver.acme.email=you@example.com"
      - "--certificatesResolvers.myresolver.acme.storage=/letsencrypt/acme.json"
      - "--certificatesResolvers.myresolver.acme.httpChallenge=true"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./letsencrypt:/letsencrypt"
    networks:
      - traefiknet
Explanation:
We define entrypoint web on port 80 and websecure on 443.
We enable the Docker provider. Setting exposedByDefault=false means Traefik will not route every container automatically unless explicitly labeled (good security practice).
We specify a Docker network (traefiknet) that Traefik will use to find containers – Traefik can only see containers on the networks it’s connected to, so we attach Traefik and other services to a common network.
We enabled the API/dashboard on port 8080 (insecure means no auth; in production, you’d use a secure method, or not expose it at all).
We configured Let’s Encrypt (certificatesResolver) named "myresolver" with an HTTP challenge, storing cert info in an acme.json file (mounted at /letsencrypt inside the container).
We map ports 80, 443 on host to Traefik’s entrypoints; and 8080 for the dashboard.
We mount the Docker socket read-only, which is required for Traefik to monitor Docker events and discover containers (Traefik needs access to Docker daemon to see container IPs, labels, etc.).
We created a Docker network traefiknet for Traefik and services (defined elsewhere in compose).
Once Traefik is up with such config, it will listen on 80/443 and be ready to route, but no routes exist yet (since exposedByDefault=false). Now, when you launch containers that you want to expose via Traefik, you add labels to define routers and services. Docker Labels for Traefik: Suppose we have a simple service container (like an instance of the whoami test image). In its docker-compose service definition, we’d add:
yaml
Copy
Edit
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.whoami.rule=Host(`whoami.example.com`)"
  - "traefik.http.routers.whoami.entrypoints=web"
  - "traefik.http.services.whoami.loadbalancer.server.port=80"
This tells Traefik: enable this container for routing, define an HTTP router named "whoami" that matches requests with Host header whoami.example.com on the web entrypoint (port 80), and define a service (implicitly named "whoami" as well) that points to this container’s port 80. When this container starts, Traefik sees these labels and dynamically creates a router and service to route traffic. If you navigate to http://whoami.example.com (assuming DNS points to the Traefik host), Traefik will forward the request to the whoami container. 【44†L313-L317】shows an example of labels for a whoami container in a compose file, where Traefik is enabled and a router rule by Host is set, along with entrypoint【44†L313-L320】. Traefik’s Docker provider automatically uses the container’s IP on the specified network and the server.port to know how to reach the container. If you don’t specify loadbalancer.server.port, Traefik will try to auto-detect the port (it picks the container’s first exposed port), but it’s good practice to be explicit. Remember: If you use a custom Docker network as in the example, ensure all your services that Traefik should route to are on that network (and Traefik itself too). Otherwise, Traefik won’t see them or be able to connect.
Routing and Reverse Proxy Configuration
Traefik routers use rules to decide how to route traffic. Some common rule types:
Host-based routing: e.g., Host(app.example.com). This matches the request’s Host header (domain name). You can match multiple hosts with OR, like Host(app.example.com) || Host(api.example.com).
Path-based routing: e.g., PathPrefix(/api) to match any path that starts with /api. Or Path(/login) to match an exact path.
Headers: e.g., Headers(X-Use-Backend, blue) could be used to route traffic with a specific header (less common in simple setups).
Methods: you can route based on HTTP method, like Methods(POST).
Combined Rules: You can combine conditions with && for AND, || for OR. For example: Host(example.com) && Path(/admin) could route admin path to a specific service.
Routers also have a priority (if not set, Traefik auto-assigns based on length of rule; more specific rules get higher priority usually). If two routers could match the same request, the one with higher priority wins. Example: You might have one service serve the main site and another serve the API, but both on the same domain:
yaml
Copy
Edit
labels:
  - "traefik.http.routers.frontend.rule=Host(`example.com`) && PathPrefix(`/`)"
  - "traefik.http.routers.frontend.entrypoints=websecure"
  - "traefik.http.routers.frontend.tls.certresolver=myresolver"
  ...
  - "traefik.http.routers.api.rule=Host(`example.com`) && PathPrefix(`/api`)"
  - "traefik.http.routers.api.entrypoints=websecure"
  - "traefik.http.routers.api.tls.certresolver=myresolver"
  ...
Here we’ve also introduced tls.certresolver which attaches Let’s Encrypt to those routers (so Traefik will serve them on HTTPS with a cert obtained via the resolver). Both routers use the same domain, but the /api prefix one should likely get a higher priority (Traefik by default might consider longer path more specific and give it a higher priority, but it can be explicitly set via traefik.http.routers.api.priority=10 for example). Wildcards and Catch-All: Traefik supports wildcard domains in Host rules (Host(*.example.com)) and a special rule HostRegexp for advanced patterns. Also, a router with no rule (or a rule like PathPrefix(/)) on entrypoint 80 could catch all traffic (like a default backend), if no other router matches. Just be careful as it might also catch traffic for other domains if no Host rule is specified. HTTP to HTTPS Redirect: A common need is to redirect all HTTP to HTTPS. Traefik can do this with a middleware (RedirectScheme). For instance, you can create a middleware with traefik.http.middlewares.redirect-to-https.redirectScheme.scheme=https and then apply it to a router on the http entrypoint that matches all. Alternatively, Traefik offers a simpler mechanism by allowing a router on :80 to have a middleware to redirect. Many tutorials set up a single router listening on web (80) with rule Host(domain) that just redirects. But an easier is using the global redirect option in Traefik's entrypoint or middleware. Load Balancing: If a Traefik service (destination) has multiple endpoints (e.g., if you scaled a container to 3 instances and each has labels for the same router rule), Traefik automatically load-balances between them (round-robin by default). You can adjust load balancing strategy and weights if needed in config (usually more in Kubernetes CRD or file provider scenarios; Docker labels can do some but limited). For most cases, just scaling containers gives you load balancing.
Middlewares
Middlewares in Traefik perform a variety of functions on requests. They are very powerful for implementing cross-cutting concerns like authentication and traffic management. Some widely used middlewares:
RedirectScheme: Redirects HTTP to HTTPS (or vice versa). Typically used to force HTTPS. Example (Docker labels):
traefik.http.middlewares.redirect-to-https.redirectScheme.scheme=https and optionally permanent=true. Then attach that middleware to routers on entrypoint web (80).
RedirectRegex: Redirect based on regex matching of the URL. Useful if you want to redirect old URLs to new ones. For example, redirecting example.com/old to example.com/new.
Headers: Adds or modifies HTTP headers. This is often used to add security headers (Content-Security-Policy, HSTS, etc.) or to set HSTS to enforce TLS. Can also be used to remove certain headers.
BasicAuth: Simple HTTP Basic Auth. You can provide user/password (hashed) combinations. Good for quickly protecting a route (like the Traefik dashboard or a dev service) with a username/password prompt.
DigestAuth / ForwardAuth: DigestAuth is like Basic but more secure (less common). ForwardAuth is extremely useful: it delegates authentication to an external service. For example, you can integrate Traefik with an OAuth2 or SSO provider (like Authelia or Authentik) using ForwardAuth – the middleware will call an external URL to check auth【23†L13-L21】.
RateLimit: Limit the number of requests over time (to mitigate abuse or simple DoS).
IPWhiteList (IPAllowList): Only allow requests from certain IPs/CIDR ranges. Useful for limiting an internal service to an intranet, etc.
Compress: Enables gzip compression on responses.
Retry: Automatically retry failed requests to the backend (with a certain count).
CircuitBreaker: Temporarily stop sending requests to a service that’s failing often, to allow it to recover (open circuit).
Buffering: Buffers requests/responses (control upload/download rate, max body size, etc.).
CORS (Headers can handle this): If you need Cross-Origin Resource Sharing headers set for APIs, use the Headers middleware to add Access-Control-Allow-Origin etc., or a dedicated plugin.
Middleware Configuration: In Docker labels, you can define a middleware either directly on the same container that has the router or define it on a separate "middleware container" (Traefik allows defining middleware in a static file too). Often for simplicity, one might define middleware along with a given service’s labels. For example:
yaml
Copy
Edit
labels:
  - "traefik.http.middlewares.my-auth.basicauth.users=admin:$$apr1$$o8...$$N7NHYHbP... (hashed password)"
  - "traefik.http.routers.secure-app.middlewares=my-auth"
This protects the router secure-app with basic auth using the credentials provided. Note: in compose, $ needs to be escaped as $$ in labels. Authentik ForwardAuth Example: Since the use case mentions Authentik, an example of how to configure forward auth to Authentik via Docker labels:
You’d have Authentik running somewhere with an outpost or endpoint for forward auth (Authentik’s docs provide a URL like http://authentik-outpost:9000/outpost.goauthentik.io/auth/traefik).
In Traefik labels:
yaml
Copy
Edit
- "traefik.http.middlewares.authentik.forwardauth.address=http://authentik-outpost:9000/outpost.goauthentik.io/auth/traefik"
- "traefik.http.middlewares.authentik.forwardauth.trustForwardHeader=true"
- "traefik.http.middlewares.authentik.forwardauth.authResponseHeaders=X-authentik-username,X-authentik-email"
- "traefik.http.routers.approuter.middlewares=authentik"
This tells Traefik to use the Authentik outpost as an authentication gateway. When a request comes in, Traefik will call that Authentik URL. If Authentik says it’s not authenticated, it will handle redirecting the user to login, etc. Authentik’s docs give a full template as seen in their example【24†L103-L112】【24†L113-L120】. Once set, any request to approuter will require the user to be authenticated by Authentik. The forwarded headers (like X-authentik-username) can be passed to the backend if needed (perhaps the app uses them for knowing the user identity).
Chaining Middlewares: Traefik allows multiple middlewares on a router (the labels use a comma-separated list or multiple - "traefik.http.routers.name.middlewares=mid1,mid2"). The order matters as they execute in sequence. For example, you might have middlewares=authentik,ratelimit. Typically you’d do auth first then rate limit or vice versa depending on desired effect. Traefik’s flexibility with middlewares means you can achieve complex behaviors without touching the backend services. It centralizes concerns like authentication and routing at the proxy level.
TLS and Let's Encrypt Configuration
Traefik excels at managing TLS certificates, especially via Let’s Encrypt, removing a lot of manual work from the user. TLS Basics in Traefik: Traefik can terminate TLS (HTTPS) connections at the proxy. You can configure routers to be TLS routers by either specifying a certificate or using Traefik’s ACME (Automated Certificate Management Environment) integration for Let’s Encrypt.
EntryPoints for TLS: Typically, you’ll have an entrypoint for HTTPS (e.g., websecure on port 443). In static config, you can mark an entrypoint as HTTPS by providing a certificate or enabling a default cert. However, Traefik will automatically handle TLS on an entrypoint if a router on that entrypoint is configured with TLS.
Using Let’s Encrypt (ACME): Traefik can act as an ACME client. You define certResolvers in static config. For example, a certResolver named "myresolver" can be configured to use the HTTP-01 challenge or DNS-01 challenge:
HTTP-01 Challenge: Requires that Traefik listen on port 80 for the domain and serve a special token when Let’s Encrypt validation server asks for it. In Traefik config, you’d specify:
yaml
Copy
Edit
--certificatesResolvers.myresolver.acme.httpChallenge.entryPoint=web
--certificatesResolvers.myresolver.acme.email=you@example.com
--certificatesResolvers.myresolver.acme.storage=/letsencrypt/acme.json
This stores certs in acme.json (a file Traefik uses to keep certs and account info)【44†L387-L394】【44†L395-L403】. The email is used for LE account registration.
DNS-01 Challenge: Used for wildcard certs or when you can’t expose port 80 to the internet. Requires API access to your DNS provider to create a verification TXT record. Traefik supports many DNS providers. You’d configure:
yaml
Copy
Edit
--certificatesResolvers.myresolver.acme.dnsChallenge.provider=cloudflare
--certificatesResolvers.myresolver.acme.email=you@example.com
--certificatesResolvers.myresolver.acme.storage=/letsencrypt/acme.json
--certificatesResolvers.myresolver.acme.dnsChallenge.resolvers=1.1.1.1:53
And set environment variables or a file with your DNS API credentials (like Cloudflare API token, etc.). Each provider has its specific env names (e.g., CF_DNS_API_TOKEN).
TLS-ALPN Challenge: Another method (for when port 80 might be blocked but 443 is open). Less commonly used but Traefik supports it.
Once a certResolver is defined, you simply add to your router label traefik.http.routers.routername.tls.certresolver=myresolver. When a request for a new domain comes in, Traefik will automatically request a cert from Let’s Encrypt using the specified challenge. The first time, it might serve a default certificate until the real one is obtained, then subsequent requests get the real cert. Traefik will also renew certificates automatically before expiration. Default Certificate: If Traefik is terminating TLS for requests that don’t match any router (or before a proper cert is acquired), it will use either a built-in default (self-signed-ish) or you can specify a default certificate in static config for better user experience. This is optional. TLS Options: Traefik allows configuration of TLS options (like minimum TLS version, cipher suites) via tls.options. For example, you could set tls.options.default.minVersion=VersionTLS12 to disallow TLS1.0/1.1. You can also enable mutual TLS (client certificate validation) by specifying tls.options.myOption.clientAuth.caFiles etc., and then attaching that option to routers. DNS-01 for Wildcards: If you want a wildcard certificate for *.example.com, you must use DNS-01. Traefik with a DNS-01 resolver can request a wildcard by having a router rule for, say, Host(example.com) + adding a TLS certresolver with domains[0].main=example.com and domains[0].sans=*.example.com in config. However, an easier approach: Traefik will automatically request a cert for all domain names it encounters in router rules. For wildcard, it might not automatically request it unless specified. But one can define a dummy router that triggers it. In the context of the user use-case: They likely have multiple services with subdomains and want Traefik to manage certificates for all, possibly using DNS-01 if they don’t want to expose port 80 or for wildcard convenience. For example, using Cloudflare’s API to get a wildcard for *.example.com. Setting that up in Traefik static config with a cloudflare token (via environment) and the dnsChallenge is the way. Certificate Storage and Backup: The acme.json file is important – it’s where Traefik stores certificates and private keys (encrypted). Back it up if you wouldn’t want to hit Let’s Encrypt rate limits by re-creating frequently. If you run multiple Traefik instances (for HA) and want them to share certificates, you need to share this acme storage (e.g., put it on a network file system or use Traefik Enterprise which can share storage or an approach with Consul KV).
Dashboard and Monitoring
Traefik’s dashboard is a web UI that visualizes the dynamic configuration – routers, services, middlewares, their statuses, and some stats.
Enabling the Dashboard: As shown earlier, you enable the API/Dashboard in static config with something like --api.dashboard=true. If you set --api.insecure=true, the dashboard is accessible without authentication on Traefik’s API port (default 8080). In production, you should not use insecure mode on a public network. Instead, either don't expose 8080 at all (maybe only allow it from localhost or an admin VPN), or front it with Traefik itself on a secure route with auth. A neat trick: you can run the dashboard on a domain through Traefik by defining a router for it. For example, labels on Traefik’s own container:
yaml
Copy
Edit
- "traefik.http.routers.traefik.rule=Host(`traefik.example.com`)"
- "traefik.http.routers.traefik.service=api@internal"
- "traefik.http.routers.traefik.entrypoints=websecure"
- "traefik.http.routers.traefik.tls.certresolver=myresolver"
- "traefik.http.routers.traefik.middlewares=my-auth"  # protect with auth
Here, api@internal is a special internal service that serves the dashboard and API. This way, you can access the dashboard via https://traefik.example.com, with proper TLS and maybe basic auth.
What the Dashboard Shows: You’ll see a list of routers (with their rules, entrypoints, attached middlewares, service status), list of middlewares (and their types/config), list of services (with the endpoint IPs, load balancer status, etc.). It also shows if any router had errors (like if a service is unreachable, the router might show a warning). This is extremely helpful for debugging why a route isn’t working as expected.
Traefik Logs: Besides the visual dashboard, Traefik logs to stdout by default. You can set log level (info, debug) in static config. In debug mode, it will log every configuration change event and a lot of detail, which can be helpful. Traefik also can emit access logs (disabled by default). To enable access logs: --accesslog=true and optionally a format or file path. Access logs will record each request going through Traefik (with status code, response time, etc.).
Metrics: Traefik can expose metrics to monitoring systems:
Prometheus: The most common, enable via --metrics.prometheus=true and optionally --metrics.prometheus.addEntryPointsLabels=true --metrics.prometheus.addServicesLabels=true (to get finer-grained labels). Once enabled, Traefik will have a metrics endpoint (usually at /metrics on the Traefik API). You can point Prometheus to scrape Traefik. There are pre-built Grafana dashboards for Traefik metrics that show things like request rate per service, latency, etc.
InfluxDB, Datadog, StatsD: Traefik supports these as well if that’s your stack.
Tracing: Traefik supports distributed tracing integration. If you enable tracing (e.g., Jaeger or Zipkin), Traefik will generate trace spans for requests passing through it, which can be combined with traces from your services. For example, for Zipkin:
yaml
Copy
Edit
--tracing.zipkin.httpEndpoint=http://zipkin:9411/api/v2/spans
--tracing.zipkin.samplerate=0.2
--tracing.zipkin.id128Bit=true
--tracing.serviceName=traefik
This would send traces to a Zipkin server at that address with a sample rate of 20%【29†L7-L15】【29†L19-L28】. Ensure the Zipkin endpoint and network connectivity exist. With tracing enabled, each request through Traefik appears in Zipkin (or Jaeger) which is invaluable for debugging latency issues and seeing the flow of requests in microservice architectures.
Health Checks: Traefik by itself doesn’t actively health-check HTTP services unless configured (there is a passive health check in that if endpoints stop responding, Traefik will temporarily stop using them). In Kubernetes, it hooks into readiness probes. In Docker, you might rely on container restarts. But Traefik’s http.services.<service>.healthCheck (in file provider) can be configured to hit a URL on a schedule to determine if an instance is healthy. This is more advanced usage typically not done via labels (requires file provider or Traefik Enterprise).
Monitoring Traefik is important just like any critical infrastructure component. At the very least, enable access logs and some form of metrics. In a production environment, you might run multiple Traefik instances for high availability (maybe behind keepalived or using an external LB to distribute traffic to them, since Traefik by itself is not a clustering solution unless using Enterprise).
Production Best Practices
Running Traefik in production involves considering availability, security, and maintainability:
High Availability (HA): Traefik OSS doesn’t natively cluster (each instance is independent). For HA, run at least two instances of Traefik. You can use a virtual IP (keepalived) or DNS round-robin or a cloud load balancer in front to distribute incoming traffic to both. If using Let’s Encrypt, ensure both instances have access to the same certificate store (e.g., use a shared mounted volume or switch to a DNS-01 challenge with a shared DNS state, or have each get certs with orchestrator-specific logic). Alternatively, configure one Traefik as primary for ACME and use the others in passthrough or with the same certs synced.
Secure the Dashboard/API: As stressed, don’t leave --api.insecure=true in production on a public network. Always secure it with at least basic auth or IP restriction, or disable it entirely. Only admin operators should see the dashboard.
Minimize Permissions: If running Traefik as a container, it generally does not need to run as root inside the container. By default the official Traefik image runs as root because it needs to bind low ports and access the docker socket. You can use Docker capabilities (e.g., CAP_NET_BINDService to allow binding <1024 ports) and run Traefik as a non-root user. Or put Traefik behind a host port forward so it binds to high port. At least ensure the docker socket mount is read-only and that Traefik’s container is not privileged.
Use docker provider safely: The Docker provider by default would expose any container with a port, unless exposedByDefault=false is set (which we did). Always use that and explicitly label what should be exposed. This prevents an accidentally launched container from being automatically internet-accessible.
ACME Rate Limits: Let’s Encrypt has rate limits. In development or initial setup, you might hit them by requesting too many certs. Use the staging LE environment (set caServer to the Let’s Encrypt staging URL) while testing, to avoid blocking yourself. Once things work, switch to production CA. Also, consider using the DNS-01 wildcard to get one cert for all subdomains if you expect to add many services dynamically (so new subdomains don’t each cause a new cert issuance).
Traefik Updates: Keep Traefik updated to latest stable version. Traefik releases often include fixes and new features. Upgrading is usually as simple as replacing the Docker image and restarting the container (Traefik will reload config on startup). The configuration is usually backward-compatible in minor releases, but check the release notes for breaking changes if jumping versions.
Logging Levels: In production, run Traefik at info or even error log level to avoid verbosity (unless troubleshooting). Debug logging can be very noisy and slightly impact performance.
Timeouts: Traefik has default timeouts for connecting to backends, etc. Ensure they align with your needs. For example, if you have some endpoints that do long polling or streams, you might increase timeouts. You can configure respondingTimeouts and forwardingTimeouts in Traefik if needed.
Hardening: If you need Traefik to pass external security audits, consider things like disabling TLS1.0/1.1 as mentioned, and using strong cipher suites. Also ensure no sensitive info is leaked in responses (Traefik by default adds a Server header like “Traefik” – which is not harmful, but some prefer to hide version info).
Monitoring & Alerting: Treat Traefik like any critical server: monitor its memory/CPU (should be low overhead, but if you route thousands of req/s, it uses resources), monitor the certificate expiration (Traefik will renew automatically around 30 days before expiry, but you could still have an external check that your domains have valid certs, just in case). Monitor for HTTP 500s or other errors in the access logs that might indicate misconfigurations or backend issues.
By following these practices, Traefik can be a very robust component in production, handling thousands of routes and certificates effortlessly (Traefik is used in many large-scale systems and is known for its performance and dynamic config).
Integration Examples
Traefik’s flexibility allows it to be the central hub routing to various applications and working with other components. Here are some integration examples relevant to the user’s context and beyond:
Single Sign-On with Authentik (ForwardAuth): As earlier described, Traefik can integrate with SSO solutions like Authentik. For instance, you might protect internal services (say Portainer or Grafana) by not exposing them directly, but instead requiring Authentik authentication. You’d deploy an Authentik outpost (which handles the authentication flow) and configure Traefik ForwardAuth middleware on those routes【24†L101-L109】【24†L113-L120】. When a user tries to access, e.g., portainer.example.com, Traefik’s forward auth will redirect them to Authentik login if they aren’t already authenticated. This provides a seamless SSO across your self-hosted services. Authentik specifically has documentation and templates for Traefik as shown, making this straightforward. The benefit is you centralize auth and can have MFA, password policies, etc., via Authentik.
Traefik with Portainer: Portainer (discussed next section) can itself sit behind Traefik. You might run Portainer at portainer.example.com. Instead of using Portainer’s own SSL, you simply let Traefik handle it and run Portainer in HTTP mode. For example, launching the Portainer container with labels:
yaml
Copy
Edit
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.portainer.rule=Host(`portainer.example.com`)"
  - "traefik.http.routers.portainer.entrypoints=websecure"
  - "traefik.http.routers.portainer.tls.certresolver=myresolver"
  - "traefik.http.services.portainer.loadbalancer.server.port=9000"
This assumes Portainer’s UI is on port 9000 internally (for Portainer 2.x, if you want to use its own TLS, it’s 9443, but we don’t need that as Traefik terminates TLS). Now Portainer gets the benefits of Traefik (like SSO via Authentik from previous point, or you could add BasicAuth middleware if you needed an extra layer).
WordPress with OpenLiteSpeed: Suppose you run a WordPress site with OpenLiteSpeed (a web server). You can have Traefik route HTTP and HTTPS requests for your domain to the OpenLiteSpeed container. Additionally, you might use middlewares for things like redirecting www -> non-www or enabling HSTS. Traefik’s job would be to handle the TLS and then just pass through to OpenLiteSpeed on whatever port it listens (like 8088 for OLS’s HTTP). This decouples TLS config from the WordPress container.
Hosting an API and Web UI (OpenWebUI/ChatGPT): If you have an application like OpenWebUI for ChatGPT (maybe it provides a web interface to a language model), you likely want it accessible at some path or subdomain. Traefik can route chat.domain.com to that container. If the app has a WebSocket or SSE for live updates, Traefik supports WebSockets natively (just ensure you don’t have any middleware that might strip Sec-WebSocket-* headers or such). In Traefik’s configuration, a WebSocket is just an upgraded HTTP connection, which Traefik proxies correctly as long as the router rule matches.
Microservices with Prometheus and Grafana: Traefik can serve as a reverse proxy for monitoring tools too. For example, you might have Prometheus on prometheus.example.com and Grafana on grafana.example.com. Both can be routed by Traefik. Grafana might have its own auth, but you could add another layer (like SSO or basicauth) via Traefik if desired for extra protection. Traefik could also add HTTPS to Prometheus which might otherwise serve on HTTP. Additionally, Traefik itself can feed metrics into Prometheus. So in an architecture, you might have:
Traefik -> routes to everything (including Grafana/Prom)
Prometheus scrapes Traefik metrics (Traefik acting as a target).
Grafana visualizes data including from Prometheus (and could show Traefik metrics dashboards).
Distributed Tracing with Zipkin/Jaeger: If you run a distributed system and use Zipkin or Jaeger for tracing, integrating Traefik is beneficial. Traefik as the entry point can create a root span for each inbound request, then your services (if instrumented) continue the trace. For instance, in Docker labels (or static config) you set up Zipkin as in the earlier example【29†L19-L27】. Now assume Zipkin’s UI is at zipkin.example.com – Traefik can also route to that. One thing: if Traefik is performing TLS termination and your services are also doing traces, ensure it passes the tracing headers like uber-trace-id or X-B3-TraceId etc., which it does by default when tracing is enabled. This allows correlation of front-end (Traefik) and backend spans.
Connecting Multiple Networks: Sometimes you have services not containerized (or on different docker networks). Traefik can have multiple entrypoints and multiple network interfaces. You could use Traefik to route between networks as well. For example, Traefik could listen on an internal entrypoint and forward to internal services. Or use TCP mode to forward database connections (Traefik can do TCP routing if you need, say, a TLS pass-through or SNI based routing for non-HTTP protocols).
These examples show that Traefik can unify access to a heterogeneous set of tools: Portainer (for container management), Authentik (for auth), WordPress (for content), custom apps, and monitoring tools. Each service doesn’t need to worry about TLS or exposing itself – Traefik takes care of that, making your architecture cleaner and more secure.
Portainer Technical Guide
Introduction to Portainer
Portainer is a lightweight, web-based container management UI that allows you to easily manage Docker environments (and also supports Kubernetes, Nomad, etc., though originally known for Docker). It provides a graphical interface for common tasks: deploying containers or stacks, managing images, networks, volumes, and viewing logs and stats. It’s often used to simplify container operations especially when you don’t want to manage everything via CLI, or to delegate some management to less experienced users safely. Key Portainer features:
Container Management: Start, stop, remove containers; edit or duplicate their settings; see resource usage and console output.
Images: Pull images from
Introduction to Portainer (continued)
Portainer’s feature set includes:
Container Management: Start, stop, restart, and remove containers via an easy UI. You can inspect environment variables, bound volumes, and other settings of each container. Portainer also allows opening a console into a running container from the browser.
Image Management: Pull images from registries (Docker Hub or custom registries), tag, push, or remove images. You can browse through images you have and see their sizes and layers.
Network and Volume Management: Create and manage Docker networks (bridge, overlay if using Swarm, etc.) and volumes. You can see which containers are attached to networks and which volumes are in use.
Container Creation and Stacks: Deploy new containers with a form-based wizard (set image, commands, ports, etc.) or use Stacks to deploy multi-container applications via docker-compose (Stacks allow you to paste a docker-compose.yml or upload one, and Portainer will create the services).
Multi-Environment Support: Portainer can manage multiple Docker environments from one interface. These environments can be local Docker, remote Docker hosts, Docker Swarm clusters, or Kubernetes clusters. It connects to remote environments via the Portainer Agent or via direct API (for local).
User Management and Roles: In Portainer, you can create users (and teams) and assign roles to control access. For example, you can limit certain users to specific stacks or endpoints (environments). This is part of RBAC (Role-Based Access Control).
Extensions: Portainer has a concept of extensions (some are commercial features). But core (Portainer CE) includes a lot of functionality out of the box for free.
Portainer is typically run as a container itself (for Docker environment management). It has a minimal footprint (just a few tens of MB of RAM when idle). The web UI runs on a specified port (9000 for HTTP by default, or 9443 for HTTPS). It also has an API which the web UI calls, and which you can use for automation. Portainer’s latest version as of 2025 is in the 2.x series for the Community Edition (CE). The example use-case indicates interest in things like SSO with Authentik and TLS via Traefik, which are possible with Portainer CE 2.6+ (OAuth support was added around Portainer 2.6 for CE【31†L58-L62】).
Deploying Portainer (Single Environment)
Running Portainer on Docker: The simplest way to get Portainer running managing a single Docker host is:
bash
Copy
Edit
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data --name portainer portainer/portainer-ce:latest
This command does the following:
Pulls the Portainer Community Edition image.
Runs it detached, mapping host port 9000 to container 9000 (Portainer UI will be at http://your-host:9000).
Mounts the Docker socket into the container, allowing Portainer to control the local Docker daemon【8†L89-L93】.
Mounts a volume portainer_data at /data in the container – Portainer uses /data to store its database (which has all configurations, users, resource control info, etc.). It’s important to persist this.
Names the container "portainer" for easier reference.
After running that, you would navigate to http://<server>:9000 and you’ll be prompted to create an admin user (the first-time setup). You’ll set a username and password for the Portainer admin. Once inside, by default, Portainer will have added the local Docker environment (since you mounted the socket). You’ll see it under “Endpoints” as the local environment. From there, you can click it and start managing containers/images on that host via the UI. Note on Docker Socket Security: The above method gives Portainer full control of Docker (which is needed for it to manage things). Ensure the Portainer container is from a trusted source (official image) and always keep it updated because it has high privileges via the socket. Using Portainer with Docker Compose: If you prefer docker-compose:
yaml
Copy
Edit
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:
This does the same as the docker run above, but in a compose file. Web Interface Basics: After setup, the UI is fairly intuitive:
The home shows the environment (endpoint) list.
Click into an endpoint to manage it. You’ll see sections for Containers, Images, Networks, Volumes, etc.
To deploy a container, go to Containers > Add Container. Fill in image name, commands, network, storage, etc., or use the "App Templates" (Portainer includes some one-click app templates).
To deploy a stack (multiple containers), go to Stacks > Add Stack. You can paste a docker-compose YAML or upload a file. Portainer will parse it and create the corresponding containers/networks.
Persistent Data and Backups: Portainer’s own data (users, saved stack definitions, etc.) reside in the /data volume. Make sure to back this up (discussed below) or at least keep the volume persistent (like named volume or bind mount to a host path that’s backed up). If you lose /data, you’d lose Portainer’s saved info (though your Docker containers would still exist on the host, Portainer just wouldn’t know about them until re-added).
Managing Multiple Environments (Portainer Agent)
Portainer can manage not just the Docker host it’s running on, but also remote Docker hosts or even clusters. There are two main ways to add a remote environment:
Using the Portainer Agent: This is a small container that runs on the remote host and exposes an API for Portainer to connect to.
Direct via TCP: Exposing the Docker API of the remote host over TCP (not recommended unless secured by TLS, and even then, the agent is often easier).
Portainer Agent Setup: On each remote Docker host you want to manage, run:
bash
Copy
Edit
docker run -d -p 9001:9001 -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/volumes:/var/lib/docker/volumes \
    --name portainer_agent portainer/agent:latest
The agent listens on port 9001 by default (this is an internal port for agent communication).
Mounting the docker socket and volumes is needed for the agent to query containers and volume info.
Ensure port 9001 is reachable by the Portainer server (if Portainer is on a different host, you may need to open firewall for 9001 on the agents, restricted to the Portainer server’s IP).
The agent encrypts communication with a shared key (Portainer generates it). Make sure you use the same version of agent as Portainer expects.
Once the agent is running on a host, go to Portainer UI > Endpoints > Add Endpoint. Choose “Agent” as the environment type. Provide:
A name (e.g., “Prod Server 1”).
The agent’s address (IP or hostname of the remote host and port 9001).
(If applicable, ticks for TLS if you configured the agent with TLS, which by default it’s not needed on trusted networks since it uses a built-in tunnel with the server.)
After adding, Portainer will connect to the agent and the new environment will appear in the list. You can then manage that host’s containers just like the local one. You can add multiple endpoints and even group them. Managing Swarm or Kubernetes: If the remote host is a Docker Swarm manager, Portainer can detect the Swarm and show services/stacks accordingly. Similarly for Kubernetes (if you deploy Portainer on K8s or add a K8s cluster, Portainer UI switches to show K8s constructs). But focusing on Docker: The agent works for standalone and Swarm mode. Edge Agent: Portainer also has an Edge mode for agents to connect out to a central Portainer (useful behind NAT). This is more advanced scenario where the agent connects to Portainer’s beacon and you manage edge devices. RBAC with Multiple Endpoints: You can control which users can access which environment. For example, you can add a user and only give them access to “Dev environment” but not “Prod environment” by assigning them to a team and the endpoint access accordingly. (In Portainer CE, RBAC is somewhat basic but works for separating environments and stacks.)
Stack Deployments
Portainer’s Stacks feature is a convenient way to deploy and manage multi-container applications from compose files, without needing to manually run docker-compose CLI on the server.
Add a Stack: In the UI, go to “Stacks” and click “Add stack”. You have the option to:
Web editor: Paste or type your docker-compose YAML right into a text box.
Upload file: Upload a docker-compose.yml from your computer.
Git repository (Git sync): If you have your compose file in a git repo, you can provide the repo URL (and credentials if private, or specify branch/compose file path). Portainer can pull and deploy, and optionally auto-pull updates.
Give the stack a name. If using the web editor or file upload, Portainer will immediately deploy it when you click “Deploy the stack”.
Once deployed, Portainer will create all the resources (networks, volumes, containers) as defined. It will then show the stack in the list. Clicking the stack name shows the list of containers it includes, and their statuses.
Managing Stacks: Portainer tracks stacks it deployed. You can stop/start all containers in a stack with one action. You can also update a stack: e.g., click the stack, then “Editor” to modify the compose YAML (say, change an image tag or environment variable), then redeploy. Portainer will apply changes (creating new containers, removing, or updating as needed).
Stack vs Container: If you deployed via Stacks, you should manage those containers via the stack interface (the containers will be labeled as part of a Portainer stack). If you remove containers outside of Portainer that belong to a stack, Portainer might consider the stack in error state. It’s best to use one method consistently.
Compose version support: Portainer supports compose versions 2 and 3 (which cover most use cases). Some very new features of Compose might not be supported if they rely on latest Docker API features not yet in Portainer’s parsing logic. But common things (networks, depends_on, deploy configs for swarm, etc.) are supported.
Swarm Stacks: If you connect Portainer to a Docker Swarm cluster, Portainer can also deploy “Swarm stacks” (which use docker stack deploy under the hood). The UI will detect if the endpoint is Swarm mode and adjust accordingly. For single Docker hosts, stacks are deployed like docker-compose (not swarm mode).
Templates: Portainer has an “App Templates” section which is a curated list of common stacks (like WordPress+MySQL, etc.). These are basically pre-defined stacks you can deploy with one click, and then perhaps adjust environment variables. You can also create custom templates (by providing a JSON template file or via the Portainer config).
Using stacks is beneficial for complex apps, because you have the whole configuration in one place and can spin everything up or tear it down easily. It’s also easier to source-control your docker-compose.yml and then copy-paste when needed.
Access Control and RBAC
Portainer allows you to create multiple user accounts and control what they can do or see. This is useful if you have a team and you want to give limited access to some users (for example, a developer can deploy stacks on the dev environment but not touch prod). In Portainer CE (Community Edition):
Users and Teams: You can create users and group them into teams. For instance, a “Developers” team and an “Ops” team.
Endpoints (Environments) access: You can assign which teams/users have access to which endpoint (Docker host or cluster). By default, an endpoint can be set as public (any authenticated user can access) or restricted (only specifically authorized teams/users). When restricted, you explicitly map team “Developers” can access endpoint “Dev Docker host”, but not Prod, etc.
Resource Ownership: Portainer has the concept of resource ownership. A container/stack/image can be “owned” by a user, a team, or marked as public (accessible by anyone). For example, if a user in team A deploys a stack, they could mark it owned by team A, so that team B cannot accidentally modify it.
Roles: In CE, roles are simplified: essentially Non-admin users can either have no access, read-only, or full control on a given endpoint they’re granted. Admin users (the default admin account, or any user marked as admin) have full control on all endpoints and Portainer settings. The finer RBAC (like where you could say user X can only restart containers but not create new ones) is more a Portainer Business Edition feature. However, CE does allow a “read-only” flag on endpoints for non-admins.
For example, you might create a user “viewer” and set them to read-only on an environment. When they log in, they can see containers, logs, etc., but cannot start/stop or deploy anything. Setting up Users/Teams:
After login as admin, go to Settings -> Users to add new users. Assign initial passwords.
Create teams and add users to teams.
Go to Endpoints, edit an endpoint access control: set it to Restricted. Then you can check which teams have “full access” or “read-only” access.
When deploying a container or stack as an admin, you can set the ownership (you might assign it to a team so that team’s users can manage their own resources).
Practical example: Suppose you have a Portainer managing two endpoints: Dev and Prod. You have two teams of developers where Dev1 team should only access Dev endpoint, and Dev2 team also only Dev, and perhaps Ops team can access both Dev and Prod. You could:
Mark both endpoints as Restricted.
Give Dev1 and Dev2 teams access (full control) to Dev endpoint; do not give them Prod.
Give Ops team full control to both Dev and Prod.
Now, Dev users when logging in will only see the Dev environment listed. They can deploy stuff there. They won’t even see Prod in the UI.
For further safety, you could give Dev teams “standard user” status (non-admin) so they can’t change Portainer settings or add endpoints themselves.
If you wanted one team to not modify other team’s containers on the same environment, use resource ownership: team A’s containers are only editable by team A or admins.
Note: The admin user can always see and do everything. For audit purposes, you might want each person to have their own login rather than everyone using “admin”. Portainer’s RBAC in CE is suitable for small setups. For larger enterprise needs (like very granular control, or integration with LDAP/AD for user management), the Business Edition is available. But many self-hosters find CE sufficient.
Automation via API
Portainer itself exposes a HTTP API that covers almost all actions you can do in the UI. In fact, the UI is built on top of this API. The API can be used to automate tasks or integrate Portainer with other systems. Using the API:
The base URL is whatever your Portainer’s address is, e.g., http://portainer.example.com/api/.
You will need to authenticate. Portainer’s API supports basic auth (with the admin or user credentials) or you can POST to /api/auth with JSON {"Username": "admin", "Password": "****"} and it will return a JWT token. You then include that token in headers for subsequent requests (Authorization: Bearer <token>).
API endpoints allow creating containers, stacks, users, updating configurations, etc. For example, GET /api/endpoints lists endpoints, POST /api/stacks can create a new stack (you’d provide the endpoint ID and stack definition).
The Portainer documentation (or browsing the UI in dev tools) is the best way to find exact endpoints. They also provide an OpenAPI/Swagger spec on the Portainer site【33†L130-L134】.
Use cases for automation:
CI/CD Integration: Perhaps you want your CI system to deploy a new version of a stack via Portainer API after building an image. The CI could call the Portainer API to update the stack (essentially sending a new compose file or updating image tags).
Bulk management: Create many users or set up endpoints via script instead of clicking.
Backup via API: While Portainer has UI for backup (Settings -> Backup, which allows downloading a backup of Portainer data【49†L42-L46】), one could also trigger an export via API or simply schedule copying the /data volume.
Monitoring integration: While Portainer isn't typically queried for monitoring data (since one would directly monitor Docker or use Prometheus for container metrics), you could query Portainer’s API to get a list of containers and their status, if you needed to integrate that into some custom dashboard.
Portainer’s API is quite powerful, essentially anything you can do by clicking can be done via a REST call. Make sure to protect the API endpoints (if your Portainer is behind Traefik and Authentik SSO, that helps). Additionally, you might consider creating an API Key or using a less privileged user for specific automation tasks (Portainer 2.9+ introduced API keys for users to avoid sending actual passwords).
Single Sign-On (SSO) with Authentik
Portainer CE 2.6 and above supports OAuth2/OpenID Connect as an authentication method, which means you can integrate SSO solutions like Authentik. This allows users to log into Portainer using an external identity provider (and even enforce MFA through that provider) instead of local Portainer accounts. Setup Outline:
In Authentik (or your OIDC provider), create an OAuth2 application for Portainer. Authentik’s docs provide steps【31†L79-L87】【31†L90-L98】:
Application name (Portainer).
Choose OAuth2/OpenID provider, set redirect URI to your Portainer URL (e.g., https://portainer.example.com/ as Strict redirect).
Authentik will give you a Client ID and Client Secret (and a discovery URL or endpoints).
In Portainer, go to Settings -> Authentication. Change method to “OAuth” (or “OAuth2” in UI).
It will ask for Client ID, Client Secret, Authorization URL, Access Token URL, Resource (UserInfo) URL, Redirect URL, Logout URL, and Scopes【33†L108-L117】.
These values come from Authentik’s application you set up:
Authorization URL: e.g., https://authentik.example.com/application/o/authorize/
Access Token URL: https://authentik.example.com/application/o/token/
Resource/UserInfo URL: https://authentik.example.com/application/o/userinfo/
Redirect URL: https://portainer.example.com/ (this must match exactly what is set in Authentik as redirect)【33†L111-L118】.
Logout URL: https://authentik.example.com/application/o/<slug>/end-session/ (Authentik provides an end-session URL).
Scopes: typically openid email profile (Authentik suggests email openid profile)【33†L117-L124】.
User Identifier: This is which field from the OIDC token to use as Portainer username. Authentik by default might use preferred_username or email. So set accordingly (the Authentik guide uses preferred_username)【33†L115-L123】.
Save settings.
After configuring, Portainer will logout and you’ll need to login via the new SSO. On hitting Portainer’s URL, it should redirect you to Authentik’s login page. After authenticating, Authentik redirects you back to Portainer, and Portainer creates a session for the SSO user.
Important details:
The first time a new SSO user logs in, Portainer will create a user entry for them (with no password, marked as external auth). By default, that user will not be an admin. You might need to log in as the local admin (when SSO is enabled, you still can log in with a local admin by an alternate path – Portainer usually provides a way, like an “Internal” login option if admin account exists). Then you can elevate the SSO user to administrator if needed or put them in teams.
You cannot use OAuth and local auth simultaneously for normal users. It’s one method at a time (except admin as noted).
Authentik specifics: ensure the Portainer application in Authentik is set to use Authorization Code flow (likely default) and not require PKCE (Portainer might not support PKCE as of writing). The Authentik docs snippet we have confirms it's standard OAuth code flow.
If Portainer is behind Traefik, you likely have Traefik already doing some auth. In such a case, you might skip Portainer’s own SSO and just use Traefik forwardAuth. But using Portainer’s built-in OAuth means the Portainer UI itself knows the user identity and audit logs can show the username, etc.
Once SSO is working, users will enjoy one-click login if they already have an Authentik session (SSO). This streamlines access. It’s especially useful if you integrate with something like LDAP via Authentik, so that corporate credentials work on Portainer.
TLS Setup via Traefik
Portainer’s web UI can be served via HTTPS. There are a few ways to achieve TLS:
Using Portainer’s built-in HTTPS (you supply a cert to Portainer).
Using an external reverse proxy like Traefik or Nginx to offload TLS.
Given the user’s stack includes Traefik, the common approach is: Offload TLS to Traefik – This means running Portainer in HTTP mode (port 9000) internally, and not enabling its HTTPS, then Traefik listens on 443 and forwards to Portainer. Benefits of this approach:
Traefik already has Let’s Encrypt automation, so Portainer gets HTTPS with minimal effort.
You can also apply the Authentik SSO at Traefik level if you hadn’t done Portainer’s internal SSO (but doing both is fine too).
Centralized TLS management.
We saw earlier how to label Portainer’s container for Traefik:
yaml
Copy
Edit
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.portainer.rule=Host(`portainer.example.com`)"
  - "traefik.http.routers.portainer.entrypoints=websecure"
  - "traefik.http.routers.portainer.tls.certresolver=myresolver"
  - "traefik.http.services.portainer.loadbalancer.server.port=9000"
With that, Traefik will get a cert for portainer.example.com via myresolver and terminate TLS. It will forward the requests to Portainer’s service on port 9000. Portainer sees it as normal HTTP requests (though it can detect the X-Forwarded-Proto header if needed, but typically not needed). Direct TLS (Portainer’s own): For completeness, if one didn’t use Traefik, Portainer can serve HTTPS by providing it a certificate. In the docker run you’d map -p 9443:9443 and provide --ssl options with the certificate and key file. This is documented on Portainer’s site. But then you’d have to handle certificate issuance/renewal (e.g., using Let’s Encrypt separately). So using Traefik is easier. If using Authentik SSO with Traefik forwardAuth and not Portainer’s OAuth, one must ensure Traefik allows the OAuth redirect process to reach Portainer. However, since in that scenario Portainer would just see an authenticated header from Traefik and treat it as an already-authenticated session (but Portainer doesn’t inherently support that without its own OAuth). So realistically, using Portainer’s built-in SSO (as above) and Traefik just passing through TLS is the straightforward solution. Websocket considerations: Portainer’s UI might use websockets for realtime updates (like tailing logs). Traefik will handle that fine as long as no special config is needed (it will automatically forward Upgrade headers). In summary, with Traefik in place, simply configure Traefik to route the Portainer domain and you get TLS. No extra steps inside Portainer needed, other than maybe telling Portainer it’s behind a proxy if you want to adjust session settings (Portainer has an option “Public HTTP address” in settings to set the external URL, which might be used for OAuth redirects or notifications).
Backup and Recovery
Backing up Portainer primarily means backing up the data volume (/data). This volume contains:
The Portainer database (portainer.db), which includes users, teams, endpoint definitions, stack definitions, resource control settings.
Any files stored via Portainer (like if you uploaded an SSL cert for some reason or stack file, etc.).
(It does not store container images or such – those remain in Docker).
Backup via UI: Portainer offers a one-click backup. Under Settings -> Backup Portainer, there is a “Download backup” button【49†L42-L46】. Clicking it makes the browser download a tar archive of the Portainer data (basically a dump of the /data volume). You should do this as an admin. You can restore by uploading that file in a new Portainer instance (on first setup or via the UI restore function). Automated Backup: Relying on manual download isn’t ideal for regular backups. Alternatives:
If /data is a named volume, you could use Docker commands to export it: e.g., docker run --rm -v portainer_data:/data -v $(pwd):/backup alpine tar czf /backup/portainer_backup.tar.gz /data. This creates a backup tar.gz in your current dir.
Or use a tool like docker cp on a stopped Portainer container to copy out /data (though better to stop Portainer to have DB in consistent state).
Use a volume backup container or script (the community has some, e.g., portainer-backup scripts【46†L23-L26】).
If /data is bind-mounted to the host (e.g., /opt/portainer-data), you can use traditional host backup (like rsync it to somewhere safe).
What to backup: At minimum, backup portainer’s /data. If you want a more complete disaster recovery backup, also backup any compose files (though those are in portainer’s DB if you deployed as stacks), and you might also backup your container data volumes (like if you have a MySQL container with a volume, that data is separate from Portainer). Restoring Portainer: If your Portainer instance was lost (say the server died):
Re-deploy a new Portainer (same version ideally).
Before accessing UI, replace its /data with the backup data (if you have the tar, extract it into the volume).
Start Portainer and it should have all previous info. If endpoints were remote, you may need to re-establish trust (Portainer might have stored an endpoint ID that agents expect – usually it picks up fine if agent is still running with same secret).
Alternatively, if you have the backup file, you can deploy Portainer fresh, create an admin (maybe same credentials as before), then in Settings -> Restore, upload the file.
If you are using OAuth authentication, note that those users exist via the SSO, but Portainer's record of them (like team membership) is in the DB backup. Stack Configs in Backup: Portainer’s backup includes the stack definitions (the compose file content you deployed). That means on restore it knows how to redeploy them. However, Portainer doesn’t automatically redeploy stacks on a new environment unless you instruct it. If you lost both Portainer and the Docker host, you’d need to recreate the environment and redeploy stacks. So for completeness in a multi-host scenario: backup Portainer data, and have backups of your actual container data (which Portainer doesn’t handle).
Upgrades and Maintenance
Keeping Portainer up-to-date:
Upgrading Portainer: Since Portainer is a container, upgrading is done by deploying a new container version. If using Docker, you’d pull the new image and recreate the container with the same /data volume. For example: docker pull portainer/portainer-ce:latest, then docker stop portainer && docker rm portainer, then re-run the docker run ... with the new image (or if using compose, change image tag and docker compose up -d). The data migration, if any, is usually handled automatically by Portainer on startup. Portainer releases often maintain backward compatibility in the database, but always check release notes.
Zero-Downtime: In a single instance, you’ll have a brief downtime during container restart. In multi-node Portainer (one Portainer server managing many agents), usually you only run one Portainer (for CE, as it doesn’t cluster), so just plan a short maintenance window to restart it.
Compatibility: Ensure the Portainer Agent versions match the server if upgrading. Typically, upgrading Portainer server first, then updating agents (though older agents usually still work with newer server for a while).
Migrating Portainer: If moving Portainer to a new host or into a cluster, just bring along the /data volume. You can also migrate from Portainer CE to BE by deploying BE and pointing it to the CE data (though BE might require license etc).
Routine maintenance tasks:
Cleaning up Portainer DB: Normally not needed, but if you removed stacks/endpoints/users often, the DB should shrink automatically (it’s SQLite). Keep an eye if portainer.db grows abnormally (maybe lots of stack versions saved).
Portainer Logs: Portainer logs to stdout (so docker logs portainer shows it). Typically minimal logs unless errors. But if many users, it logs each login, etc. Use --restart=always (as in the compose) so it auto-starts on host reboot.
Endpoint Health: In Endpoints view, Portainer shows if an endpoint is down (like agent unreachable). If an agent goes offline, you might need to check that host or re-register it if something changed (like agent lost config).
Updating Stacks: When you update a stack (e.g., new image tag), Portainer does not automatically do image pulls unless told. Ensure your compose has pull_image: always if you want that behavior, or manually pull images via UI before redeploy.
Best Practices for Portainer
To wrap up, consider these best practices when using Portainer:
Secure Admin Access: Protect Portainer behind authentication (either its own or SSO). Never expose it to the internet without strong access control. If possible, limit access by IP or use an extra layer (like an Authentik forwardAuth in Traefik, or VPN).
Use Least Privilege for Users: Only give users access to the environments and actions they need. Use teams to separate concerns (devs vs ops, etc.). This will prevent accidents (like a dev accidentally deleting a prod container).
Keep Portainer Updated: New releases often bring security fixes (for instance, older Portainer had an API token vulnerability that was fixed, etc.). Since it’s easy to update (just container replacement), plan to update at least every few months after testing.
Regular Backups: Automate backup of the Portainer /data. Also document the procedure to restore, so if your Portainer server dies, you can recover quickly. If using an external DB (Portainer BE can use external SQL, CE always uses internal), back that up too.
Don’t Rely on Portainer as Sole Ops Channel: While Portainer is great, ensure you or someone on the team still knows how to use Docker CLI for emergencies. If Portainer ever has an issue, you should be able to manage containers via CLI until it’s resolved.
Volume Management via Portainer: One limitation: Portainer might not fully handle some advanced volume plugins or complex bind mount scenarios (especially on remote endpoints). You might occasionally need to do such things via CLI.
API Keys: Use API keys for automation instead of embedding user passwords. In Portainer 2.11+, you can create API keys under your user profile for scripting. This way, if the key is compromised, it can be revoked without changing your main password.
Resource Limits for Users: You can’t directly limit what containers a user deploys (like preventing them from using too much CPU) via Portainer. Rely on Docker’s own controls (like cgroup limits in the compose). Portainer will allow any container creation that the Docker API allows for that user’s access.
Monitor Portainer: At least watch the container’s memory/CPU. It’s lightweight, but if you have hundreds of stacks it might use more memory. Also monitor the Docker socket usage (heavy use of Portainer by many users could in theory overwhelm the Docker daemon with requests, though that’s rare).
Logging and Auditing: Portainer logs some events (like user logins). For a more detailed audit, consider using the Docker daemon’s audit logs or integrating Portainer with external logging if needed. Portainer BE has more audit, but CE is limited.
Portainer and Swarm/K8s: If you expand to orchestrators, be aware of differences. In Swarm, Portainer can deploy stacks as Swarm services. In Kubernetes, Portainer’s UI shifts to K8s objects (it can even manage Helm charts). The learning curve is slightly different, but it’s an option if you transition from Docker to K8s.
Portainer greatly simplifies container management for both small home server setups and certain production scenarios. By following security best practices and utilizing its features (like teams, stacks, SSO), you can safely delegate container operations and maintain oversight of your container infrastructure through a user-friendly interface.
Sources:
Docker Documentation – Overview and Architecture【1†L162-L170】【1†L174-L182】
Docker Security Best Practices【39†L190-L198】【39†L200-L209】【4†L33-L37】
AlmaLinux Wiki and Server World – AlmaLinux 9 Setup (SELinux, firewalld)【12†L377-L385】【20†L103-L112】
Authentik and Traefik Integration Docs【24†L101-L109】【24†L113-L120】
Authentik and Portainer OAuth Integration【33†L108-L117】【33†L115-L123】
Traefik Documentation – Docker Provider and Tracing【44†L313-L320】【29†L19-L27】
Marius Hosting – Portainer Backup Guide【49†L42-L46】
Complete Container Stack Documentation
Table of Contents
Docker Manuals
Introduction to Docker
Docker Architecture
Docker CLI and Container Management
Docker Compose and Multi-Container Applications
Docker Networking
Docker Security Best Practices
AlmaLinux 9 Technical Reference
Installation and Setup
System Administration Basics
Package Management with DNF
Service Management with systemd
SELinux Configuration
Firewall Management with firewalld
Networking Configuration
Containers and Development on AlmaLinux 9
Best Practices for AlmaLinux Servers
Traefik Comprehensive Guide
Overview of Traefik
Traefik Architecture and Key Concepts
Docker Provider Setup
Routing and Reverse Proxy Configuration
Middlewares
TLS and Let's Encrypt Configuration
Dashboard and Monitoring
Production Best Practices
Integration Examples
Portainer Technical Guide
Introduction to Portainer
Deploying Portainer (Single Environment)
Managing Multiple Environments (Portainer Agent)
Stack Deployments
Access Control and RBAC
Automation via API
[Single Sign-On (SSO) with Authentikgn-on-sso-with-authentik)
TLS Setup via Traefik
Backup and Recovery
Upgrades and Maintenance
Best Practices for Portainer
Docker Manuals
Introduction to Docker
Docker is a platform that enables developers and system administrators to build, ship, and run applications in containers. Containers are lightweight, portable units that bundle an application’s code with all its dependencies, ensuring consistency across environments. By containerizing application​
REINTECH.IO
elps eliminate the “it works on my machine” problem, making deployment to production or any other environment more reliable【1†L128-L137】【1†L139-L147】. Docker containers achieve isolation by leveraging operating system features (like namespaces and control groups in Linux) rather than full-blown virtual machines, which makes them much more resource-efficient compared to traditional VMs. Use Cases: Docker streamlines the development lifecycle and supports modern DevOps practices. Developers can use containers for development, testing, and continuous integration/continuous deployment (CI/CD) workflows. For example, a team can containerize a web application and its database, run tests in an isolated container network, and then deploy the same containers to production ensuring that the environment remains consistent【1†L133-L142】【1†L144-L152】. Docker’s portability means containers can run on a developer’s laptop, on on-premises servers, or in cloud environments with minimal changes. This makes scaling applications and migrating them between environments very straightforward. Containers vs Virtual Machines: Containers share the host system’s kernel and do not require a full guest OS for each instance, in contrast to virtual machines. This means you can run many more containerized workloads on the same hardware compared to VMs, achieving better resource utilization【1†L154-L160】. Containers start up faster and use less memory, which is ideal for microservices architectures and environments where quick scaling is necessary. Latest Stable Version: The core Docker platform consists of the Docker Engine (the container runtime) and associated tools. As of early 2025, the latest Docker Engine is version 28.x, reflecting continuous improvements in performance and security【35†L762-L770】. Docker also now ships Docker Compose as a plugin (docker compose command) for defining multi-container applications. It’s recommended to keep Docker Engine updated to the latest stable release for the newest features and security patches. Always refer to the official release notes for information on changes when upgrading Docker Engine or Docker Desktop【35†L774-L781】.
Docker Architecture
Docker uses a client-server architecture composed of three main components: the Docker client, the Docker daemon, and the Docker registry【1†L162-L170】. The Docker client is the command-line tool (docker) that users interact with. When you run a command like docker run, the client communicates with the Docker daemon (dockerd) which performs the heavy lifting of building, running, and managing containers on the host【1†L180-L187】. The client and daemon usually communicate via a REST API over a UNIX socket or network interface. 【3†embed_image】 Docker architecture diagram: the Docker client sends commands (e.g., docker run, docker build, docker pull) to the Docker daemon. The daemon manages container images and running containers on the Docker Host. Docker registries (like Docker Hub) store images that can be pulled to the host or pushed from it【1†L164-L172】【1†L174-L182】.
Docker Daemon (dockerd): This is the background service running on the host machine. It listens for Docker API requests from clients and manages Docker objects such as images, containers, networks, and volumes【1†L174-L182】. The daemon handles container lifecycle operations (start, stop, scheduling), image builds, and network management. It can also communicate with other daemons (for example, in a swarm or cluster scenario) to coordinate multi-node container deployments【1†L174-L178】.
Docker Client (docker CLI): The command-line interface is how users interact with Docker. When you issue commands like docker run, docker build, or docker pull, the CLI translates these into API calls that the Docker daemon executes【1†L180-L187】. The Docker CLI can be used to manage local containers as well as remote daemons (by setting the DOCKER_HOST environment variable or using context/CLI flags to point to a remote server).
Docker Registries: A Docker registry is a repository for storing and distributing container images. The default public registry is Docker Hub, but there are others like Quay, Google Container Registry, and you can run your own private registry. When you use docker pull ubuntu:latest, the client contacts a registry (by default Docker Hub) to fetch the image layers. Likewise, docker push uploads an image to a registry. Docker images are identified by name:tag (e.g., nginx:alpine) and content-addressable digest (sha256). By using registries, Docker enables easy sharing and versioning of application images. (Note: Docker Content Trust can be enabled to verify image signatures, ensuring image integrity and publisher authenticity【4†L25-L33】.)
Images vs Containers: An image is a read-only template with instructions for creating a Docker container. It is built up from a series of layers (each layer usually corresponds to an instruction in a Dockerfile). A container is a runtime instance of an image — it includes the image plus a writable layer on top. You can have multiple containers running from the same image, each with its own state. Best practice is to keep images small and focused, and containers ephemeral (containers should be stateless and disposable, with state stored in volumes or databases when needed).
Docker CLI and Container Management
Docker provides a rich CLI to manage images and containers. Below are some of the most common commands and functionality:
Images Management: You can build images using a Dockerfile with docker build -t <name:tag> . (the -t flag tags the image with a name). To list images on your system use docker images. Pull images from a registry with docker pull, and remove unused images with docker rmi. It’s advisable to periodically clean up unused images (docker image prune) to save disk space.
Running Containers: Launch containers from images with docker run. For example, docker run -d -p 80:80 nginx:latest will run an Nginx web server container in detached mode (-d), mapping port 80 of the host to port 80 of the container. The first time you run an image that isn’t present locally, Docker will pull it from the registry. Each container can be given a --name for easier reference (otherwise Docker assigns a random name).
Container Lifecycle: Once running, containers can be managed with commands like docker stop <name> (gracefully stop), docker kill <name> (force stop), and docker start <name> (restart a stopped container). Use docker ps to list running containers (add -a to list all, including stopped ones). You can attach to a running container’s console with docker attach or start an interactive session inside a container with docker exec -it <name> /bin/bash (which is useful for debugging).
Logs and Monitoring: Docker logs can be viewed using docker logs <name> (with -f to follow live logs). Container resource usage (CPU, memory, network, I/O) can be monitored via docker stats. Inspect container details with docker inspect, which shows low-level configuration and state (including network settings, volume mounts, environment variables, etc.).
Volumes and Data Management: Persistent data in Docker is managed through volumes or bind mounts. Volumes are managed by Docker (created with docker volume create or on the fly with docker run -v volumeName:/path/in/container). Bind mounts map a host directory or file into a container (-v /host/path:/container/path). Use volumes for database storage or any data that should outlive a single container instance. To avoid leftover volumes consuming space, list them with docker volume ls and remove unused ones with docker volume rm or docker volume prune.
Resource Limits: Docker allows constraining resources per container for better multi-tenancy. For example, use --memory="512m" to limit memory, --cpus="1.0" to limit CPU, or --restart=always to have containers automatically restart on failures or daemon restarts. Setting appropriate limits ensures one container doesn’t exhaust the host resources at the expense of others.
Container Management Best Practices: Keep containers as ephemeral as possible – treat them as replaceable. If you need to update an application, build a new image and redeploy containers rather than patching a running container. Use descriptive names and labels for containers to help identify them. Leverage Docker object labels (key-value metadata on images/containers) to tag versions, roles, or environment info, which is helpful in orchestrated environments or for automation scripts.
Docker Compose and Multi-Container Applications
While the docker run command is great for single containers, real-world applications often consist of multiple interconnected services (for example, a web server, a database, and a background worker). Docker Compose is a tool and YAML file format for defining and running multi-container Docker applications. Instead of running a series of docker commands, you describe your application’s services, networks, and volumes in a docker-compose.yml (or compose.yaml) file and then start everything with a single command. Compose File Basics: In a compose file, you typically define multiple services, each corresponding to a container (often based on an image). You can specify for each service the image to use (or build instructions), port mappings, environment variables, volumes, and dependency relationships. For example, a simple Compose file might define a web service running an image of your web app and a db service running a MySQL image, and set that the web depends on db starting first.
Example excerpt of a Compose service definition with labels for Traefik integration (explained in a later section):
yaml
Copy
Edit
services:
  web:
    image: mywebsite:latest
    ports:
      - "80:80"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.web.rule=Host(`example.com`)"
      - "traefik.http.routers.web.entrypoints=web"
In this example, web service’s container will be accessible on host port 80, and we’ve added labels to integrate with Traefik (so Traefik will create a route for example.com). Compose automatically creates a network for these services, enabling the web service to reach db by its service name.
Managing Multi-Container Apps: Once your compose file is ready, running docker compose up -d (in the directory of the compose file) will create and start all the defined services. The -d flag runs them in background (detached). Docker Compose will create a default network (usually named after your project) so that services can communicate by name (e.g., your web app could reach the database at hostname db if that’s the service name). You can scale services (run multiple container instances) with docker compose up --scale web=3 for example, if your application is stateless and can benefit from load balancing. To stop and remove all containers in the application, use docker compose down (adding -v will also remove named volumes defined in the file).
Compose for Development: Compose is very useful in development environments as well. You can define volumes to mount source code into containers for live reloading, or use Compose profiles to enable/disable certain services. Compose files can be checked into version control to share consistent development setups across teams. They also serve as documentation of how the whole stack is wired together.
Docker Compose v2: Note that modern Docker setups include Compose as an integrated CLI plugin (you use docker compose ... instead of the old separate docker-compose binary). The Compose YAML specification is now part of the Open Container Initiative (OCI) and is evolving with version 3.x being common. Always refer to the official Docker documentation for the latest Compose file keys and options【40†L5-L13】. Compose v2 supports features like running compose files in Docker Swarm mode or Kubernetes (with Docker stacks or Kompose), but in this guide we focus on the local Docker Engine usage.
Docker Networking
Docker’s networking allows containers to communicate with each other and with the outside world. By default, Docker creates a bridge network called bridge (or docker0 on Linux) for containers. When you run a container without specifying a network, it connects to this default bridge, which enables basic outbound connectivity (containers can reach the internet through NAT) and allows containers to talk to each other by IP address on the same host. Network Drivers: Docker supports multiple network drivers【6†L55-L63】, each suited for different scenarios:
Bridge Network (default): Containers on the same user-defined bridge network can communicate by container name (Docker adds entries to each container’s /etc/hosts or managesNS). The default bridge network requires linking or explicit connection by IP unless you create a user-defined bridge (with docker network create) which provides automatic service name resolution. Use bridge networks for standalone deployments on a single host.
Host Network: The host driver disables network isolation. A container using the host network shares the host’s network stack (meaning it can directly bind ports on the host). This can be useful for certain high-performance networking need​
MARIUSHOSTING.COM
e container provides a service (like monitoring) that needs direct host network access. However, it sacrifices isolation.
None Network: Essentially no networking. The container has no external network interfaces. Useful for specialized cases or security where isolation is paramount.
Overlay Network: Used in Docker Swarm or multi-host scenarios, an overlay network allows containers on different hosts (joined in a swarm or using Docker Enterprise) to communicate securely as if on the same network. This is critical for distributed applications. (In a single-host non-swarm setup, overlay is not used; one would typically just use bridge networks.)
Macvlan Network: This driver gives containers their own MAC address and treats them like physical devices on the network. The container can appear as a separate host on the physical network. This can be useful for legacy applications expecting each service to have a unique MAC or when you need to be part of the same Layer 2 network as the host’s network. It requires more configuration and is advanced usage.
IPvlan, Network Plugins: Docker also supports IPvlan and third-party network plugins (like CNI plugins for integration with Kubernetes, or other software-defined networking solutions). These are less common for everypear in orchestrated or cloud setups.
Exposing Ports: To allow access from outside the host to a container’s service, Docker uses port mapping. For example, docker run -p 8080:80 nginx maps host port 8080 to container port 80. Multiple containers can use the same container port (e.g., many containers running a web server on port 80 internally) as long as they are mapped to different host ports. In Compose files, the ports section does the same mapping. Be mindful of security – exposing ports meanes are reachable from the host’s network (which could be the internet if no firewall rules are blocking it). Container-to-Container Communication: On the same host, containers on the same user-defined network can talk to each other using their service names or container names (as DNS hostnames). If you have multiple networks, a container can be attached to more than one (allowing it to bridge between networks). Docker’s built-r will resolve container names to their private IP addresses on the network. Networking and DNS in Compose: Docker Compose simplifies networking by automatically creating a network for the compose project and attacces to it (unless specified otherwise). This means you can simply use the service name to connect (for example, a WordPress container could reach its MySQL database by connecting to host db if the database service is named `pose file). Firewall Considerations: If the Docker host is running a firewall (like ufw or firewalld on Linux), you need to ensure that the mapped ports are allowed through the firewall. For instance, if a container’s web service is mapped to host port 8080, open that port in the host’s firewall (e.g., using firewall-cmd --add-port=8080/tcp --permanent followed by a reload for firewalld【20†L103-L112】). Docker manipulates iptables/nftables rules automatically to handle NAT for container traffic, but host-based firewalls might still block incoming connections if not configured. On systems like AlmaLinux 9 with firewalld, docker will often integrate with the firewall zone named docker or adjust rules — however, it's good practice to explicitly allow needed service ports.
Docker Security Best Practices
Running containers securely is crucial. While containers provide some isolation, they share the host kernel, so following security best practices is important:
Least Privilege: Run containers with the least privileges required. Avoid running processes inside containers as root user if possible. Many official images provide a way to run as a non-root user. If you build your own Dockerfile, consider using USER to switch to a non-root user after installing software.
Image Provenance and Updates: Use official and trusted images as base images. Keep images updated to include the latest security patches【4†L5-L13】. Regularly pull newer versions and rebuild your custom images. Remove unused images to avoid running outdated software. Enable Docker Content Trust (DCT) if appropriate, which requires images to be signed and verified on pull【4†L25-L33】.
Minimize Image Size: Smaller images not only have a smaller attack surface but also fewer components that could have vulnerabilities. Prefer minimal base images (Alpine, Distroless, etc.) when feasible, and only include what’s necessary for your application to run【4†L33-L37】.
Sensitive Data Management: Do not bake secrets (passwords, API keys) into images. Instead, supply them at runtime via environment variables or Docker secrets (if using Swarm or a secrets management system). Use Docker Volumes or secret management tools for confidential data. If using environment variables for secrets, be aware of docker inspect and logs which might reveal them; consider using Docker secrets or mounting secrets from the host.
Network Security: By default, containers on the same bridge network can talk to each other freely. Use user-defined networks to have more control. For multi-tenant scenarios, use the --icc=false Docker daemon option to disable inter-container communication on the default bridge. Use firewall rules or Docker’s embedded network policies (in swarm mode, you can use network segmentation).
Resource Limits and Quotas: Applying CPU and memory limits to containers not only helps with stability but also can mitigate certain denial-of-service risks (one compromised container can’t easily starve the whole host if limits are in place). Also consider using read-only filesystems (--read-only flag) for containers that don’t need to write to disk, and multi-stage builds to avoid shipping build tools in the final image.
Isolate with user namespaces: Docker can map container user IDs to different host user IDs (user namespace remapping). This can prevent a root user in a container from being root on the host. It adds an extra layer of security in case of a breakout. This feature needs to be enabled in the daemon (/etc/docker/daemon.json with "userns-remap" settings).
Rootless Docker: Newer Docker versions support running the Docker daemon in rootless mode (no root privileges on host). This mode uses user namespaces and other kernel features so that the Docker daemon and containers run without root. Rootless mode can run many (though not all) container workloads and is a good option to reduce risk on development machines or CI runners.
SELinux / AppArmor: On Linux, Docker integrates with security modules. For example, on an SELinux-enabled host (like AlmaLinux), Docker automatically applies an SELinux context type to containers (svirt_lxc_net_t or similar). If mounting host directories, append the :z or :Z suffix to the volume to allow Docker to relabel files for SELinux【39†L190-L198】【39†L200-L208】. The :z option is for shared content (multiple containers can access) and :Z for exclusive. This ensures the container can read/write the host files without violating SELinux policy. Similarly, Docker applies a default AppArmor profile on many systems to restrict system calls. It’s generally good to leave these in place (or customize as needed) rather than disabling security profiles.
Do Not Expose Docker Socket Unprotected: The Docker UNIX socket (/var/run/docker.sock) is effectively root access to the host. Do not expose it to containers unless absolutely necessary, and never expose it via a mapped TCP port without proper protection. If you run management UIs like Portainer (discussed later), ensure they are secured since they use the socket to control Docker.
Monitoring and Patching: Use tools to scan your images for vulnerabilities (Docker Hub offers scanning, and​
MARIUSHOSTING.COM
ools like Trivy or Clair). Monitor container behavior at runtime – e.g., unexpected network connections or process activity – to detect breaches. Always promptly apply updates to Docker itself; Docker releases include important security fixes and it's recommended to run a supported version of Docker Engine.
By following these practices, you significantly harden your container environment. Docker has made it easier to deploy software, but it doesn’t eliminate the need for vigilance on security. In production, also consider additional layers such as running containers in VMs or using Kubernetes with network policies for defense-in-depth if appropriate for your use-case.
AlmaLinux 9 Technical Reference
Installation and Setup
About AlmaLinux 9: AlmaLinux 9 is an enterprise-grade Linux distribution that is binary-compatible with Red 
GITHUB.COM
se Linux 9. It is community-driven and designed as a drop-in replacement for CentOS. AlmaLinux 9.x will receive full support until at least 2027 and security updates through 2032【36†L1-L8】. This makes it a stable base for servers, containers, and development environments. Obtaining AlmaLinux 9: You can download ISO images from the official AlmaLinux website or mirrors. AlmaLinux provides minimal ISOs (for a lightweight server install), DVD ISOs (with more packages, including GUI options), and boot/netinstall ISOs (for network installation). Choose the minimal or server install for container hosts to avoid unnecessary packages. AlmaLinux supports x86_64, ARM64 (AArch64), and other architectures similarly to RHEL. Installation Process: Installing AlmaLinux 9 is similar to RHEL 9 or CentOS Stream 9:
Boot Installer: Write the ISO to a USB or mount it for a VM, then boot. Select installation destination and software selection. For a server or container host, a minimal install or AlmaLinux Server (with or without GUI) is common.
Partitioning: The installer (Anaconda) guides through disk partitioning. You can use automatic partitioning or custom. Ensure adequate space for /var if you plan to store container images (since Docker/Podman images go under /var/lib/... by default).
User Creation: Set a strong root password and create an initial non-root user. You can allow that user to have administrator privileges (sudo).
Network: Configure the network (you might want to enable the network interface during install if using netinstall or for immediate SSH access).
Finalize: Complete the installation and reboot. Post-install, you have a basic AlmaLinux system.
After the first boot, it’s recommended to update the system to the latest packages:
bash
Copy
Edit
sudo dnf update -y
This will apply any patches (including security fixes) that have been released since the ISO image. Reboot if the kernel or critical libraries were updated. Setting Hostname and Timezone: Use the hostnamectl set-hostname <your-hostname> command to set a permanent hostname. Ensure your timezone is correct with timedatectl set-timezone <Region/City>. These steps help ensure logs and scheduling (cron jobs, etc.) match your locale, and a proper hostname is important in networked environments.
System Administration Basics
User and Group Management: AlmaLinux uses the standard Linux user management commands. Create additional users with useradd and set passwords with passwd. Typically, for server administration, you’ll add your user to the wheel group, which by default grants sudo privileges (check /etc/sudoers where %wheel ALL=(ALL) NOPASSWD: ALL or similar might be set, or you may need to uncomment a line to enable wheel group sudo). For example:
bash
Copy
Edit
sudo usermod -aG wheel <username>
This adds a user to the wheel group. Using sudo is preferred over direct root login for auditing and safety. Filesystem and Directories: AlmaLinux 9 uses the XFS filesystem by default for RHEL-based installs (unless changed). This is robust for server workloads. The directory structure follows the Linux Filesystem Hierarchy Standard. Key directories:
/etc for configuration,
/var for variable data (logs in /var/log, web content in /var/www, Docker/Podman storage in /var/lib/containers or /var/lib/docker),
/home for user directories,
/opt for optional software installations, etc.
Essential Commands: As a RHEL-type system, AlmaLinux uses GNU core utilities and typical commands. Some useful ones:
dnf (package manager, see next section),
systemctl (service management, detailed later),
firewall-cmd (firewalld management),
nmcli (network management CLI if using NetworkManager),
semanage and sestatus (for SELinux management, if needed),
journalctl (for viewing logs from systemd’s journald).
File Editing: Editors like vim or nano may not be installed by default on a minimal install. nano is simple for beginners, vim for advanced usage. Install with dnf install nano or dnf install vim as needed. Always be careful editing critical config files and consider making backups (or use version control for /etc in critical systems). Service Accounts: AlmaLinux and RHEL often create system users for services (with UIDs < 1000 by convention). For example, the web server (httpd) runs as apache user, Docker uses root and sometimes a dockerd user depending on setup, etc. When configuring services or file permissions, be mindful of which user a service runs as.
Package Management with DNF
AlmaLinux 9 uses DNF (Dandified YUM) as its package management tool, which is the next-generation version of YUM. It manages RPM packages, resolves dependencies, and can perform installations, updates, and removals of software.
Basic Commands:
dnf install <package> – Install a package (plus dependencies).
dnf remove <package> – Remove a package.
dnf update – Update all packages to the latest available versions. (You can use dnf upgrade interchangeably; both do the same in AlmaLinux).
dnf search <keyword> – Search for packages by keyword.
dnf info <package> – Get information about a package (version, summary, repo source).
dnf list --installed – List all installed packages.
dnf clean all – Clear the package cache (useful if you need to refresh metadata).
Repositories: By default, AlmaLinux is configured with official repositories akin to RHEL’s (BaseOS, AppStream, etc.). Additional repositories can be added by placing .repo files in /etc/yum.repos.d/. For example, EPEL (Extra Packages for Enterprise Linux) is a popular repository providing additional software not in the base distro. You can enable it by installing the epel-release package: sudo dnf install epel-release (if available for Alma 9). AlmaLinux also supports other third-party repos like REMI (for newer PHP versions), PowerTools (CRB - CodeReady Builder), and others, depending on needs. Always ensure third-party repos are trustworthy and necessary.
Module Streams: RHEL 8/9 introduced module streams for certain packages (like multiple versions of PostgreSQL, NodeJS, etc.). With DNF, you can list modules via dnf module list. For example, dnf module install nodejs:16 would enable Node.js v16 stream. Modules allow parallel availability of different versions but note you can only enable one stream of a module at a time per system.
Package Groups: You can install groups of packages using dnf groupinstall "<Group Name>". For instance, dnf groupinstall "Development Tools" will install a suite of compilers and libraries for building software (useful in a dev environment). There are groups for environments like "Server with GUI", "Headless Management", etc., which you might choose during installation or post-install.
Transactions and History: DNF keeps a history of transactions. You can view dnf history to see past installs/removals. You can even rollback certain transactions with dnf history undo <transaction_id> if needed (though rollbacks can sometimes fail if dependencies changed).
Keeping AlmaLinux Updated: Regularly update your system to get security patches (you may also enable automatic updates using tools like dnf-automatic). AlmaLinux will release minor version updates (9.1, 9.2, etc.) which you obtain just by updating packages – no need for a special upgrade tool. Each minor version is supported until the next one is out (AlmaLinux 9.5 is out as of late 2024【37†L157-L165】, for example, containing cumulative updates over 9.0). Always review change logs for kernel or critical library updates if you’re runningService Management with systemd Alsystem and service manager. Systemd brings a consistent way to manage servicetasks, and centralize logging (via journaldrvices:** Use the systemctl command. For exastart nginx – starts the nginx service immediately. :contentReference[oaicite:4]{index=4}inx – stops it.
`sudo systemctl resta​
MARIUSHOSTING.COM
restarts (stop then start).
sudo systemctl reload nginx – reloads configuration without full restart (if the service supports it, e.g., reload Nginx or Apache config).
Enable/Disable at Boot:
sudo systemctl enable nginx – configures nginx to start on boot (it creates a symlink in systemd configuration to ensure the service starts in the desired runlevel/target).
sudo systemctl disable nginx – prevents it from starting at boot.
Services that are enabled will auto-start during system boot. You can check enabled services with systemctl list-unit-files --state=enabled.
Status and Logs:
systemctl status nginx – shows whether the service is active, last few log lines, and if it’s running (active) or stopped (inactive) or failed.
journalctl -u nginx -f – shows logs from the nginx service unit, with -f to follow. Remove -f to see the full log. Journalctl is powerful: you can filter by time (--since "2 hours ago"), by boot (-b for current boot logs), etc.
Service Unit Files: Systemd unit files for services are typically in /usr/lib/systemd/system/ (for packages) or /etc/systemd/system/ (for custom/overrides). They have a [Service] section that defines how to start the process. It’s often useful to know these if you need to add dependencies or environment variables. However, directly editing the vendor-provided unit file isn’t recommended – instead use systemctl edit nginx which creates an override drop-in file in /etc/systemd/system/nginx.service.d/ for local changes.
Targets (Runlevels): Systemd has “targets” which are similar to runlevels. For example, graphical.target vs multi-user.target (non-graphical, multi-user is the typical server runlevel). You can change the default target (for example, if you installed a GUI and want to boot to it, systemctl set-default graphical.target). systemctl isolate <target> can switch to another target on the fly.
Common Services on AlmaLinux: Many common services you might use: sshd (OpenSSH server) is enabled by default on servers (allowing SSH login), firewalld (the firewall daemon, covered next) is usually running by default【12†L336-L344】【12†L375-L384】, network (managed by NetworkManager, which is the default network service on AlmaLinux 9 unless you switch to network-scripts). If you install Docker, it typically introduces a service docker.service you manage similarly; same for Podman’s socket or other container services. Enabling/Disabling Services in AlmaLinux: After installing new software (say Docker), you often need to enable and start it:
bash
Copy
Edit
sudo systemctl enable --now docker
The --now flag starts it immediately as well as enabling for boot. This is a convenient way to do both steps at once. You might want to verify status with systemctl status docker afterward to ensure it's running without errors【8†L69-L77】【8†L81-L89】. Handling Services on Boot: If you find a service not starting on boot, check systemctl status and journalctl for errors. Sometimes SELinux can prevent a service from starting if not configured (for example, a web server trying to bind to a non-standard port might be blocked by SELinux policy, requiring a context change; see SELinux section below).
SELinux Configuration
Security-Enhanced Linux (SELinux) is a mandatory access control (MAC) system that is enabled by default on AlmaLinux 9 (enforcing mode). SELinux adds an additional layer of security by enforcing policies that confine processes to least privilege. By default, AlmaLinux ships with targeted policies that confine key services (web server, database, etc.) while leaving others unconfined.
Checking Status: Use sestatus or getenforce to check SELinux status. On a fresh AlmaLinux 9, it should show as “Enforcing”【12†L377-L384】, meaning policies are actively being applied. If it’s “Permissive,” SELinux is on but not enforcing (just logging violations), and “Disabled” means it’s completely off.
Changing Modes Temporarily: You can switch between Enforcing and Permissive without a reboot using sudo setenforce 0 (go to permissive) or sudo setenforce 1 (back to enforcing). getenforce will then reflect the new state【18†L1-L9】【18†L13-L21】. Note that going from disabled to enabled requires a reboot (and proper configuration).
Changing Modes Permanently: The persistent mode is set in the file /etc/selinux/config. You’d edit that (as root) to set SELINUX=enforcing or permissive or disabled, then reboot to apply. Alternatively on AlmaLinux/RHEL 9, using the grubby command is recommended to alter kernel boot parameters. For example, to disable SELinux permanently you could use:
grubby --update-kernel ALL --args selinux=0
which adds a kernel boot argument to disable SELinux【12†L393-L402】. However, disabling SELinux is not recommended in production – the better approach if encountering issues is to put it in permissive mode while troubleshooting and adjusting policy, then return to enforcing.
Working with SELinux Contexts: Each file, process, and port has an SELinux context (user:role:type:level). For most use cases, you might encounter SELinux when something doesn’t work due to a denial (like a web server unable to read files or bind to a port). You can check logs for SELinux denials with journalctl -t setroubleshoot or grep AVC /var/log/audit/audit.log. The sealert tool (part of setroubleshoot) can analyze denials and suggest solutions.
Common Tasks:
Allowing a web server to use a non-standard port: use semanage port -a -t http_port_t -p tcp 8080 (for example) to label port 8080 as a HTTP service port (if you want to run a web server on 8080).
Adjusting file contexts: if you have web content in a non-standard directory, label it with chcon -R -t httpd_sys_content_t /my/content or better, add a rule with semanage fcontext so that it persists context assignments (then restorecon to apply).
For Docker/Podman, ensure the container_selinux package is installed (it should be as a dependency). This provides the policies that allow containers to operate. If you mount host volumes into containers, use the :z or :Z flags as mentioned in the Docker section to auto-handle labeling【39†L198-L205】【39†L206-L214】.
Disabling SELinux (not recommended): In some development cases or constrained environments, you might decide to set SELinux to permissive. To do this persistently, edit /etc/selinux/config and change SELINUX=enforcing to SELINUX=permissive, then reboot. Or use setenforce 0 for a one-time switch (which will reset on reboot). Fully disabling (SELINUX=disabled) requires a reboot and results in no SELinux policy being loaded at all. This should be avoided unless absolutely necessary, as it removes a layer of protection.
Best Practices: Keep SELinux in enforcing mode on servers whenever possible for maximum security. If something isn’t working, instead of turning it off, investigate the SELinux denial and see if there’s a proper policy or boolean to adjust. RHEL-based systems provide numerous SELinux booleans (tunable settings) you can view with getsebool -a. For example, allowing Apache to connect out to the network (httpd_can_network_connect) or allowing NFS home directories, etc. You can set these with setsebool -P boolean_name on/off. AlmaLinux, being RHEL-compatible, has the same SELinux capabilities and booleans.
Firewall Management with firewalld
AlmaLinux 9 comes with firewalld as the default firewall management service. firewalld provides a dynamic way to manage iptables/nftables rules through zones and services, and it’s easier to use than manually writing iptables rules for most users. By default, firewalld is enabled and starts on boot on AlmaLinux【12†L336-L344】【12†L348-L357】.
Basic Concepts:
Zones: Predefined trust levels (public, private, internal, dmz, work, home, etc.). Each network interface can be assigned to a zone. By default, interfaces not bound to a zone go to the public zone (which is a fairly restrictive zone intended for untrusted networks). The public zone, by default, allows very few services (typically only DHCPv6 and maybe SSH). Other zones like “home” or “internal” are more open (intended for trusted LANs).
Services and Ports: firewalld has a concept of services (which are basically named sets of ports and protocols). For example, the “http” service is port 80/tcp, “https” is 443/tcp, “ssh” is 22/tcp, etc. Opening a service in a zone will allow those ports. You can also directly open specific ports.
Permanent vs Runtime: firewalld distinguishes between runtime changes (effective immediately but lost on next reload/restart) and permanent (persisted in config). By default, the --add-port or --add-service apply to runtime unless --permanent is specified. Typically, one adds rules with --permanent and then reloads the firewall.
Using firewall-cmd:
Check the status and default zone: firewall-cmd --state (should return running if active), firewall-cmd --get-active-zones (to see which zone an interface is in).
List allowed services/ports in a zone: firewall-cmd --list-all --zone=public.
Allow a service (runtime): sudo firewall-cmd --add-service=http --zone=public. This opens port 80 in the public zone until next reboot or firewalld reload.
Make it permanent: add --permanent and then run firewall-cmd --reload to apply the permanent rules to the running firewall【20†L103-L112】【20†L112-L120】. For example:
bash
Copy
Edit
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
This would permanently allow HTTPS (443/tcp) on the public zone.
Open a specific port: sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp (replace zone and port/protocol as needed)【20†L103-L111】. Then reload.
Remove a rule: e.g., sudo firewall-cmd --permanent --remove-service=http --zone=public, then reload.
Change default zone: sudo firewall-cmd --set-default-zone=home (for instance) if this server is in a trusted network and you want a less strict default policy – but be cautious with that. Alternatively, assign a specific interface to a zone: sudo firewall-cmd --permanent --zone=public --change-interface=eth0.
Rich Rules: firewalld also supports rich rules for more complex scenarios (like allow from a specific IP to a port, or logging). Example of a rich rule to allow only a certain IP:
bash
Copy
Edit
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="203.0.113.4" port port=22 protocol=tcp accept'
This would allow SSH (22/tcp) only from 203.0.113.4 in the public zone.
firewalld GUI/Console: On systems with a GUI, you can use the firewall-config tool for a graphical interface. On server installs without GUI, sticking to firewall-cmd is fine, or using textual UIs like nmtui for NetworkManager can also set zones of interfaces indirectly.
Integration with Docker: There is an interplay between Docker and firewalld. Docker manipulates iptables directly to create NAT and allow container -> host connections. With firewalld, you’ll see a docker zone in iptables -L output when Docker is running. Typically, Docker ensures that ports you publish (via -p) are accessible. If you find that firewalld is blocking published ports, you might need to add the port to the zone for the docker0 interface or configure firewalld to trust Docker’s rules. In practice, if you open needed service ports as described above, that should suffice.
Best Practices: Keep your firewall enabled even on development machines unless it truly interferes with something. Only open the ports/services that are necessary. AlmaLinux’s firewalld starts with a secure baseline (especially on the public zone). Regularly review firewall-cmd --list-all for each active zone to verify it hasn’t got more open than expected. And remember to consider IPv6 as well (firewalld handles both by default if you have IPv6 connectivity).
Networking Configuration
Networking on AlmaLinux 9 can be managed via NetworkManager (the default) or classic network scripts (deprecated). By default, AlmaLinux uses NetworkManager with configuration files in /etc/NetworkManager/system-connections/ or using keyfiles. However, it’s often convenient to use the command-line tool nmcli or the text UI nmtui for managing network settings.
Viewing Network Status: nmcli device status will show interfaces and their state (connected/disconnected) and type (ethernet, wifi, etc.). nmcli connection show shows configured connections (which can represent static configs or DHCP configs for interfaces).
Setting a Static IP (with nmcli): Suppose your interface is enp1s0 (the naming is usually predictable but use ip addr to identify interfaces):
Define the IP address and subnet:
sudo nmcli connection modify enp1s0 ipv4.addresses 10.0.0.30/24
Set the gateway:
sudo nmcli connection modify enp1s0 ipv4.gateway 10.0.0.1
Set DNS server(s):
sudo nmcli connection modify enp1s0 ipv4.dns "10.0.0.10 8.8.8.8" (for multiple DNS, space-separated)【22†L13-L21】【22†L17-L25】.
Ensure the method is manual (static) and not auto (DHCP):
sudo nmcli connection modify enp1s0 ipv4.method manual【22†L27-L35】.
(If IPv6 is in use, similarly configure ipv6.addresses, ipv6.gateway, and set ipv6.method to manual or ignore depending on needs.)
Bring the connection down and up to apply changes:
sudo nmcli connection down enp1s0 && sudo nmcli connection up enp1s0【22†L33-L41】.
Alternatively, a system reboot or systemctl restart NetworkManager would also apply, but toggling the interface is less disruptive. After this, ip addr show enp1s0 should reflect the new static IP and nmcli connection show enp1s0 should list the details.
Using ifcfg Files: AlmaLinux still supports old-style network scripts with ifcfg files in /etc/sysconfig/network-scripts/. If NetworkManager is running, it will actually use those if present (unless told otherwise). A typical ifcfg for a static IP might look like:
ini
Copy
Edit
DEVICE=enp1s0
BOOTPROTO=none
ONBOOT=yes
IPADDR=10.0.0.30
PREFIX=24
GATEWAY=10.0.0.1
DNS1=10.0.0.10
DNS2=8.8.8.8
This method is fine too, and NetworkManager can read these if you have nm-controlled=no or similar. However, nmcli is the modern recommended approach.
Hostname & DNS: The system’s hostname can be set with hostnamectl as mentioned. DNS client settings, if not using NetworkManager’s DNS entries, are in /etc/resolv.conf. On a server, that is usually managed by NetworkManager or systemd-resolved. If you find DNS not resolving, ensure /etc/resolv.conf has correct nameserver entries. If using DHCP, the DHCP server often provides these.
Multiple NICs and Bonding/Bridging: For advanced setups, AlmaLinux (via NetworkManager or directly via nmcli/ifcfg) can configure bonded interfaces (for link aggregation), VLAN tagging on interfaces, or even bridges (for KVM virtualization or containers that need to be on the same L2 network). For example, to create a bridge br0 and have an interface join it, you could use nmcli or ifcfg files. This is beyond the scope of this doc to detail fully, but NetworkManager does support nmcli connection add type bridge ... and nmcli connection add type bridge-slave ... for adding member interfaces.
Testing Connectivity: Use ping to test basic network connectivity. For DNS resolution test, dig or host commands (from bind-utils package) are useful. If something like internet access is not working, check default route (ip route to see if a default via gateway is present) and check that no firewalld or SELinux is blocking (though typically those don’t block outbound).
Networking and Containers on AlmaLinux: If this AlmaLinux 9 system will host containers (Docker or Podman), ensure that any static IP configuration doesn’t conflict with Docker’s default network (172.17.0.0/16) or Podman’s (usually 10.88.0.0/16). If your host network uses those ranges, you may want to adjust Docker’s default bridge network settings (in daemon.json) or Podman’s CNI config to avoid overlap.
Containers and Development on AlmaLinux 9
AlmaLinux 9 is a great host for container runtimes and also as a development environment, given its stability. Here’s how to optimize AlmaLinux for these purposes:
Installing Docker on AlmaLinux 9: AlmaLinux does not ship Docker Engine by default (instead, Red Hat promotes Podman). However, you can install Docker CE on AlmaLinux by using the CentOS/RHEL repository from Docker. The steps are:
Add Docker CE Repo: Docker’s repo for CentOS/RHEL can be added, since AlmaLinux 9 is compatible. For example:
bash
Copy
Edit
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
(This repo covers RHEL-compatible distributions.)【8†L52-L60】
Install Packages:
bash
Copy
Edit
sudo dnf install -y docker-ce docker-ce-cli containerd.io
This will install the Docker engine, CLI, and containerd (Docker’s underlying runtime)【8†L62-L70】. If you encounter dependency issues, ensure the repo is correct and AlmaLinux extras are enabled (for container-selinux package). Sometimes using --nobest can help if the very latest version isn’t available.
Start and Enable Docker:
bash
Copy
Edit
sudo systemctl enable --now docker
This starts the Docker daemon and sets it to run on boot【8†L67-L75】.
Post-install: Verify with docker run hello-world【8†L75-L83】. Also, to run docker commands as your regular user, add yourself to the “docker” group: sudo usermod -aG docker <username>【8†L87-L93】, then log out and back in for it to take effect. (Be aware that giving a user access to the docker group is effectively giving root-level control, so only do this for trusted users or in dev environments.)
Note: Instead of Docker, AlmaLinux offers Podman as a rootless container engine (dnf install podman). Podman can run many Docker container images without needing a daemon and can run as non-root by default, making it safer for multi-user systems. Podman also has podman compose (or using podman with compose YAML via podman play kube or similar). If you prefer the Docker workflow but rootless, Podman is an alternative. You can even alias docker=podman for many commands. That said, Docker is still widely used, and on AlmaLinux it works fine if installed as above.
Development Tools: On AlmaLinux, if you’re setting up a development environment, you likely need compilers, libraries, etc. The group "Development Tools" can be installed as mentioned (which includes GCC, make, etc.). For development in certain languages, you might need to enable module streams (for example, dnf module enable nodejs:18 for Node.js 18, then dnf install nodejs). AlmaLinux’s AppStream repository contains multiple versions of languages like Python, Ruby, Node, etc., via modules.
SELinux Considerations for Containers: As discussed, when using Docker on AlmaLinux with SELinux enabled, ensure the containerd.io and container-selinux packages are present (they should be installed as dependencies). Use :z on volume mounts so SELinux allows container access. If writing custom SELinux policies for containers (rare, but for very locked-down scenarios), you might explore the udica tool which helps generate SELinux policies for containers【17†L141-L149】【17†L143-L147】.
Using AlmaLinux as a Container Base: You can also use AlmaLinux inside containers. There are official AlmaLinux container images (like almalinux:9 on Docker Hub) which provide a minimal AlmaLinux userland. This is useful for containerizing applications that require a RHEL-like environment. Package management inside such a container uses dnf as normal. AlmaLinux container images are typically slim, containing just the basics to function (no kernel, since containers use the host kernel).
Container Orchestration: If your use-case grows, AlmaLinux 9 can be a node in a Kubernetes cluster (via something like RKE, k3s, or even OpenShift Origin). Ensure cgroups v2 is properly configured (RHEL9 uses cgroup v2 by default which modern Kubernetes supports). You might need to set systemd.unified_cgroup_hierarchy=1 in older releases if it wasn’t already. But AlmaLinux 9 likely has cgroup v2 as default, which Docker supports as of Docker 20.x+.
Performance Tuning: For heavy container usage, consider tuning the storage driver for Docker if needed (modern Docker on RHEL uses overlay2 which is good). Ensure adequate disk space for /var/lib/docker. If running databases in containers, you may want to locate the volume on fast storage (like NVMe SSDs) and perhaps use direct-lvm for stable performance (with Docker’s devicemapper, though devicemapper is deprecated in favor of overlay on xfs). For networking performance, if using high packet rates, using macvlan or host networking can reduce overhead.
Best Practices for AlmaLinux Servers
Whether you use AlmaLinux 9 as a host for containers, as a development VM, or as a general server, some best practices to keep in mind:
Regular Updates: Keep the system updated. Enable automatic updates for critical security patches if possible (the dnf-automatic package can apply updates on a schedule). This ensures kernel and library vulnerabilities are patched. AlmaLinux will occasionally release point upgrades (like 9.3, 9.4); these are achieved by standard package updates.
Enable EPEL if needed: The Extra Packages for Enterprise Linux repository provides many developer tools and newer versions of software that are not in base AlmaLinux. If you need packages like htop, stress, or certain newer language versions, EPEL is a safe and curated source. Install with dnf install epel-release and then dnf update.
Security Hardening: Beyond SELinux and firewalld, consider:
SSH Hardening: Use key-based authentication, disable root login over SSH (edit /etc/ssh/sshd_config to PermitRootLogin no), and perhaps change the default port or use firewall to limit access. You can also use tools like Fail2Ban to block brute force attempts.
User Management: Remove or lock any unnecessary system accounts. Use groups to manage permissions cleanly. Ensure strong, unique passwords if password auth is enabled.
Monitoring: Set up monitoring for your AlmaLinux server – whether it’s node_exporter for Prometheus, or a cloud monitoring agent, ensure you get alerted on high resource usage, low disk space, etc. AlmaLinux being stable means if something is wrong, it’s likely your application load or an attack, so monitoring helps catch that.
Time Sync: Use chronyd (which should be installed by default) or ntpd to keep system time in sync. Chrony is the default in RHEL9 and is usually active by default, syncing with CentOS/Alma pool NTP servers. Check with chronyc sources.
Backups: Regularly backup important data from your AlmaLinux server. If it’s a VM, take snapshots or use backup tools. If it’s a physical host, ensure config files (like those in /etc, or data in /var) are backed up to remote storage.
Using AlmaLinux for Development: If you use AlmaLinux as a development environment (say via a VM or WSL2 or similar), you can install development tools, editors, and container tools as needed. Leverage Podman if you want rootless containers to avoid needing sudo for docker. Use toolbox (a Fedora/RedHat tool) or similar if you want a disposable dev environment container that’s integrated.
Kernel and Performance Tuning: AlmaLinux 9 comes with a modern kernel (5.14 for AlmaLinux 9.0, with minor version updates incorporating later kernels as per RHEL’s roadmap). For special workloads, consider tuning sysctl parameters. For instance, if running a lot of network throughput, you might adjust net.core.* and net.ipv4.ip_local_port_range, etc. If running containers, Docker might set some of these for you, but not all. Use sysctl -a to view current kernel parameters and consider tuning file descriptor limits, process limits, etc., if your application demands it.
Container-Specific: When AlmaLinux is used as a container host, ensure Docker’s or Podman’s storage doesn’t fill the root filesystem. Monitor /var/lib/docker size. Use log rotation for container logs (Docker by default keeps growing the log; you can set a log driver or max-size). Also consider the impact of SELinux on containers as covered; don’t disable SELinux – set it up correctly.
AlmaLinux 9 being a clone of RHEL 9 means you get a predictable, stable platform with a decade of updates. That stability is excellent for both hosting and developing containerized applications. By following the above best practices, you’ll maintain a secure and efficient AlmaLinux environment.
Traefik Comprehensive Guide
Overview of Traefik
Traefik is a modern, cloud-native reverse proxy and load balancer that is designed to dynamically manage routing of HTTP(S) traffic to microservices and containers. Often dubbed a “cloud-native edge router,” Traefik integrates with various container orchestrators and platforms (Docker, Kubernetes, Swarm, etc.) to automatically discover services and route requests to them without manual configuration of static routes. Key features of Traefik include:
Automatic discovery of services (using providers like Docker, Kubernetes, file-based config).
Dynamic configuration via providers and a powerful routing rule system (e.g., route by domain, path, headers).
Integrated Let's Encrypt support for automatic certificate provisioning and renewal (great for quickly securing endpoints with HTTPS).
Middleware system to modify requests/responses on the fly (for tasks like authentication, rate limiting, compression, etc.).
Support for multiple protocols (HTTP, HTTPS, TCP, UDP) and WebSocket, HTTP/2, gRPC, etc.
Observability with built-in metrics (for Prometheus, Datadog, etc.), access logs, and tracing support (Zipkin, Jaeger, etc.).
A web dashboard to visualize configured routers, services, and middlewares.
Traefik’s current major version is 2.x (with minor releases 2.9, 2.10, etc., and even a preview of 3.x in development). The config syntax changed significantly from Traefik 1.x, so guides will usually specify version. This guide covers Traefik 2.x, which uses the concept of routers, services, and middlewares for configuration.
Traefik Architecture and Key Concepts
Traefik’s architecture can be understood in terms of entry points, routers, middlewares, services, and providers:
EntryPoints: These are the network entry points into Traefik. For example, you can define an entrypoint for HTTP on port 80, another for HTTPS on port 443, maybe another for a TCP service on port 3306, etc. EntryPoints are defined in the static configuration (because they define where Traefik listens).
Providers: Providers are sources of configuration. Traefik supports Docker, Kubernetes, file (YAML/TOML), Consul, etc. A provider supplies Traefik with information about routes and services. The configuration from providers is dynamic (Traefik listens for changes, like new containers starting, or changes in a config file).
Routers: A router matches incoming requests on an entrypoint to a service (and can apply middlewares). A router has a rule (e.g., “Host(myapp.example.com) && PathPrefix(/api)”) to decide if it should handle a request【24†L121-L129】. If the request matches, the router will forward the request to its associated service. A router can also specify other properties like which entrypoint(s) it listens on and what priority it has (if multiple routers could match, priority decides).
Services: In Traefik terms, a service is the destination for the traffic that a router forwards. This could be one or multiple endpoints (containers, pods, URLs). For example, a service might be defined to point to a Docker container’s port, or a set of pods in Kubernetes, etc. Traefik will load-balance requests among all endpoints of a service if there are multiple. Services can also be used to do things like pass through to a weighted set of upstreams (for A/B testing, etc.).
Middlewares: Middlewares are filters that can modify requests or responses or take actions before the request reaches the service. Traefik provides many middlewares: for authentication (like BasicAuth, ForwardAuth), rate limiting, IP whitelisting, redirects, adding headers, rewriting paths, etc.【28†L69-L77】【28†L79-L87】. You attach middlewares to routers (i.e., a router can reference a list of middlewares to apply).
The Traefik Dashboard/API: Traefik itself exposes an internal API and a web UI (dashboard) which can show you all the routers, services, etc. This is very useful for debugging and oversight. Access to the dashboard should be secured (it can be done by either not exposing it or by putting authentication on it via middleware).
Static vs Dynamic Configuration: Traefik has two types of config:
Static config – defined when Traefik starts (via a config file or command-line flags or env vars). This includes things like entrypoints, the definition of providers (e.g., “enable Docker provider”), and global settings (like log level). Static config cannot be changed without restarting Traefik.
Dynamic config – obtained from providers (could be from a file provider which is watched, or from Docker labels on containers, etc.). This includes routers, services, middlewares definitions. Dynamic config can change at runtime as Traefik monitors the providers.
In a Docker context, much of Traefik’s configuration will be provided dynamically through Docker labels on containers.
Docker Provider Setup
When running Traefik with Docker, Traefik can automatically discover containers and route to them based on labels. To enable this, you configure Traefik’s static configuration to use the Docker provider. Traefik Deployment (Docker Compose example): You might deploy Traefik itself as a Docker container. Here’s a conceptual example of a Traefik service in a compose file:
yaml
Copy
Edit
services:
  traefik:
    image: traefik:latest
    command:
      - "--entryPoints.web.address=:80"
      - "--entryPoints.websecure.address=:443"
      - "--providers.docker=true"
      - "--providers.docker.exposedByDefault=false"
      - "--providers.docker.network=traefiknet"
      - "--api.insecure=true"        # (enable dashboard without auth; use only in dev!)
      - "--api.dashboard=true"
      - "--certificatesResolvers.myresolver.acme.httpChallenge.entryPoint=web"
      - "--certificatesResolvers.myresolver.acme.email=you@example.com"
      - "--certificatesResolvers.myresolver.acme.storage=/letsencrypt/acme.json"
      - "--certificatesResolvers.myresolver.acme.httpChallenge=true"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./letsencrypt:/letsencrypt"
    networks:
      - traefiknet
Explanation:
We define entrypoint web on port 80 and websecure on 443.
We enable the Docker provider. Setting exposedByDefault=false means Traefik will not route every container automatically unless explicitly labeled (good security practice).
We specify a Docker network (traefiknet) that Traefik will use to find containers – Traefik can only see containers on the networks it’s connected to, so we attach Traefik and other services to a common network.
We enabled the API/dashboard on port 8080 (insecure means no auth; in production, you’d use a secure method, or not expose it at all).
We configured Let’s Encrypt (certificatesResolver) named "myresolver" with an HTTP challenge, storing cert info in an acme.json file (mounted at /letsencrypt inside the container).
We map ports 80, 443 on host to Traefik’s entrypoints; and 8080 for the dashboard.
We mount the Docker socket read-only, which is required for Traefik to monitor Docker events and discover containers (Traefik needs access to Docker daemon to see container IPs, labels, etc.).
We created a Docker network traefiknet for Traefik and services (defined elsewhere in compose).
Once Traefik is up with such config, it will listen on 80/443 and be ready to route, but no routes exist yet (since exposedByDefault=false). Now, when you launch containers that you want to expose via Traefik, you add labels to define routers and services. Docker Labels for Traefik: Suppose we have a simple service container (like an instance of the whoami test image). In its docker-compose service definition, we’d add:
yaml
Copy
Edit
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.whoami.rule=Host(`whoami.example.com`)"
  - "traefik.http.routers.whoami.entrypoints=web"
  - "traefik.http.services.whoami.loadbalancer.server.port=80"
This tells Traefik: enable this container for routing, define an HTTP router named "whoami" that matches requests with Host header whoami.example.com on the web entrypoint (port 80), and define a service (implicitly named "whoami" as well) that points to this container’s port 80. When this container starts, Traefik sees these labels and dynamically creates a router and service to route traffic. If you navigate to http://whoami.example.com (assuming DNS points to the Traefik host), Traefik will forward the request to the whoami container. 【44†L313-L317】shows an example of labels for a whoami container in a compose file, where Traefik is enabled and a router rule by Host is set, along with entrypoint【44†L313-L320】. Traefik’s Docker provider automatically uses the container’s IP on the specified network and the server.port to know how to reach the container. If you don’t specify loadbalancer.server.port, Traefik will try to auto-detect the port (it picks the container’s first exposed port), but it’s good practice to be explicit. Remember: If you use a custom Docker network as in the example, ensure all your services that Traefik should route to are on that network (and Traefik itself too). Otherwise, Traefik won’t see them or be able to connect.
Routing and Reverse Proxy Configuration
Traefik routers use rules to decide how to route traffic. Some common rule types:
Host-based routing: e.g., Host(app.example.com). This matches the request’s Host header (domain name). You can match multiple hosts with OR, like Host(app.example.com) || Host(api.example.com).
Path-based routing: e.g., PathPrefix(/api) to match any path that starts with /api. Or Path(/login) to match an exact path.
Headers: e.g., Headers(X-Use-Backend, blue) could be used to route traffic with a specific header (less common in simple setups).
Methods: you can route based on HTTP method, like Methods(POST).
Combined Rules: You can combine conditions with && for AND, || for OR. For example: Host(example.com) && Path(/admin) could route admin path to a specific service.
Routers also have a priority (if not set, Traefik auto-assigns based on length of rule; more specific rules get higher priority usually). If two routers could match the same request, the one with higher priority wins. Example: You might have one service serve the main site and another serve the API, but both on the same domain:
yaml
Copy
Edit
labels:
  - "traefik.http.routers.frontend.rule=Host(`example.com`) && PathPrefix(`/`)"
  - "traefik.http.routers.frontend.entrypoints=websecure"
  - "traefik.http.routers.frontend.tls.certresolver=myresolver"
  ...
  - "traefik.http.routers.api.rule=Host(`example.com`) && PathPrefix(`/api`)"
  - "traefik.http.routers.api.entrypoints=websecure"
  - "traefik.http.routers.api.tls.certresolver=myresolver"
  ...
Here we’ve also introduced tls.certresolver which attaches Let’s Encrypt to those routers (so Traefik will serve them on HTTPS with a cert obtained via the resolver). Both routers use the same domain, but the /api prefix one should likely get a higher priority (Traefik by default might consider longer path more specific and give it a higher priority, but it can be explicitly set via traefik.http.routers.api.priority=10 for example). Wildcards and Catch-All: Traefik supports wildcard domains in Host rules (Host(*.example.com)) and a special rule HostRegexp for advanced patterns. Also, a router with no rule (or a rule like PathPrefix(/)) on entrypoint 80 could catch all traffic (like a default backend), if no other router matches. Just be careful as it might also catch traffic for other domains if no Host rule is specified. HTTP to HTTPS Redirect: A common need is to redirect all HTTP to HTTPS. Traefik can do this with a middleware (RedirectScheme). For instance, you can create a middleware with traefik.http.middlewares.redirect-to-https.redirectScheme.scheme=https and then apply it to a router on the http entrypoint that matches all. Alternatively, Traefik offers a simpler mechanism by allowing a router on :80 to have a middleware to redirect. Many tutorials set up a single router listening on web (80) with rule Host(domain) that just redirects. But an easier is using the global redirect option in Traefik's entrypoint or middleware. Load Balancing: If a Traefik service (destination) has multiple endpoints (e.g., if you scaled a container to 3 instances and each has labels for the same router rule), Traefik automatically load-balances between them (round-robin by default). You can adjust load balancing strategy and weights if needed in config (usually more in Kubernetes CRD or file provider scenarios; Docker labels can do some but limited). For most cases, just scaling containers gives you load balancing.
Middlewares
Middlewares in Traefik perform a variety of functions on requests. They are very powerful for implementing cross-cutting concerns like authentication and traffic management. Some widely used middlewares:
RedirectScheme: Redirects HTTP to HTTPS (or vice versa). Typically used to force HTTPS. Example (Docker labels):
traefik.http.middlewares.redirect-to-https.redirectScheme.scheme=https and optionally permanent=true. Then attach that middleware to routers on entrypoint web (80).
RedirectRegex: Redirect based on regex matching of the URL. Useful if you want to redirect old URLs to new ones. For example, redirecting example.com/old to example.com/new.
Headers: Adds or modifies HTTP headers. This is often used to add security headers (Content-Security-Policy, HSTS, etc.) or to set HSTS to enforce TLS. Can also be used to remove certain headers.
BasicAuth: Simple HTTP Basic Auth. You can provide user/password (hashed) combinations. Good for quickly protecting a route (like the Traefik dashboard or a dev service) with a username/password prompt.
DigestAuth / ForwardAuth: DigestAuth is like Basic but more secure (less common). ForwardAuth is extremely useful: it delegates authentication to an external service. For example, you can integrate Traefik with an OAuth2 or SSO provider (like Authelia or Authentik) using ForwardAuth – the middleware will call an external URL to check auth【23†L13-L21】.
RateLimit: Limit the number of requests over time (to mitigate abuse or simple DoS).
IPWhiteList (IPAllowList): Only allow requests from certain IPs/CIDR ranges. Useful for limiting an internal service to an intranet, etc.
Compress: Enables gzip compression on responses.
Retry: Automatically retry failed requests to the backend (with a certain count).
CircuitBreaker: Temporarily stop sending requests to a service that’s failing often, to allow it to recover (open circuit).
Buffering: Buffers requests/responses (control upload/download rate, max body size, etc.).
CORS (Headers can handle this): If you need Cross-Origin Resource Sharing headers set for APIs, use the Headers middleware to add Access-Control-Allow-Origin etc., or a dedicated plugin.
Middleware Configuration: In Docker labels, you can define a middleware either directly on the same container that has the router or define it on a separate "middleware container" (Traefik allows defining middleware in a static file too). Often for simplicity, one might define middleware along with a given service’s labels. For example:
yaml
Copy
Edit
labels:
  - "traefik.http.middlewares.my-auth.basicauth.users=admin:$$apr1$$o8...$$N7NHYHbP... (hashed password)"
  - "traefik.http.routers.secure-app.middlewares=my-auth"
This protects the router secure-app with basic auth using the credentials provided. Note: in compose, $ needs to be escaped as $$ in labels. Authentik ForwardAuth Example: Since the use case mentions Authentik, an example of how to configure forward auth to Authentik via Docker labels:
You’d have Authentik running somewhere with an outpost or endpoint for forward auth (Authentik’s docs provide a URL like http://authentik-outpost:9000/outpost.goauthentik.io/auth/traefik).
In Traefik labels:
yaml
Copy
Edit
- "traefik.http.middlewares.authentik.forwardauth.address=http://authentik-outpost:9000/outpost.goauthentik.io/auth/traefik"
- "traefik.http.middlewares.authentik.forwardauth.trustForwardHeader=true"
- "traefik.http.middlewares.authentik.forwardauth.authResponseHeaders=X-authentik-username,X-authentik-email"
- "traefik.http.routers.approuter.middlewares=authentik"
This tells Traefik to use the Authentik outpost as an authentication gateway. When a request comes in, Traefik will call that Authentik URL. If Authentik says it’s not authenticated, it will handle redirecting the user to login, etc. Authentik’s docs give a full template as seen in their example【24†L103-L112】【24†L113-L120】. Once set, any request to approuter will require the user to be authenticated by Authentik. The forwarded headers (like X-authentik-username) can be passed to the backend if needed (perhaps the app uses them for knowing the user identity).
Chaining Middlewares: Traefik allows multiple middlewares on a router (the labels use a comma-separated list or multiple - "traefik.http.routers.name.middlewares=mid1,mid2"). The order matters as they execute in sequence. For example, you might have middlewares=authentik,ratelimit. Typically you’d do auth first then rate limit or vice versa depending on desired effect. Traefik’s flexibility with middlewares means you can achieve complex behaviors without touching the backend services. It centralizes concerns like authentication and routing at the proxy level.
TLS and Let's Encrypt Configuration
Traefik excels at managing TLS certificates, especially via Let’s Encrypt, removing a lot of manual work from the user. TLS Basics in Traefik: Traefik can terminate TLS (HTTPS) connections at the proxy. You can configure routers to be TLS routers by either specifying a certificate or using Traefik’s ACME (Automated Certificate Management Environment) integration for Let’s Encrypt.
EntryPoints for TLS: Typically, you’ll have an entrypoint for HTTPS (e.g., websecure on port 443). In static config, you can mark an entrypoint as HTTPS by providing a certificate or enabling a default cert. However, Traefik will automatically handle TLS on an entrypoint if a router on that entrypoint is configured with TLS.
Using Let’s Encrypt (ACME): Traefik can act as an ACME client. You define certResolvers in static config. For example, a certResolver named "myresolver" can be configured to use the HTTP-01 challenge or DNS-01 challenge:
HTTP-01 Challenge: Requires that Traefik listen on port 80 for the domain and serve a special token when Let’s Encrypt validation server asks for it. In Traefik config, you’d specify:
yaml
Copy
Edit
--certificatesResolvers.myresolver.acme.httpChallenge.entryPoint=web
--certificatesResolvers.myresolver.acme.email=you@example.com
--certificatesResolvers.myresolver.acme.storage=/letsencrypt/acme.json
This stores certs in acme.json (a file Traefik uses to keep certs and account info)【44†L387-L394】【44†L395-L403】. The email is used for LE account registration.
DNS-01 Challenge: Used for wildcard certs or when you can’t expose port 80 to the internet. Requires API access to your DNS provider to create a verification TXT record. Traefik supports many DNS providers. You’d configure:
yaml
Copy
Edit
--certificatesResolvers.myresolver.acme.dnsChallenge.provider=cloudflare
--certificatesResolvers.myresolver.acme.email=you@example.com
--certificatesResolvers.myresolver.acme.storage=/letsencrypt/acme.json
--certificatesResolvers.myresolver.acme.dnsChallenge.resolvers=1.1.1.1:53
And set environment variables or a file with your DNS API credentials (like Cloudflare API token, etc.). Each provider has its specific env names (e.g., CF_DNS_API_TOKEN).
TLS-ALPN Challenge: Another method (for when port 80 might be blocked but 443 is open). Less commonly used but Traefik supports it.
Once a certResolver is defined, you simply add to your router label traefik.http.routers.routername.tls.certresolver=myresolver. When a request for a new domain comes in, Traefik will automatically request a cert from Let’s Encrypt using the specified challenge. The first time, it might serve a default certificate until the real one is obtained, then subsequent requests get the real cert. Traefik will also renew certificates automatically before expiration. Default Certificate: If Traefik is terminating TLS for requests that don’t match any router (or before a proper cert is acquired), it will use either a built-in default (self-signed-ish) or you can specify a default certificate in static config for better user experience. This is optional. TLS Options: Traefik allows configuration of TLS options (like minimum TLS version, cipher suites) via tls.options. For example, you could set tls.options.default.minVersion=VersionTLS12 to disallow TLS1.0/1.1. You can also enable mutual TLS (client certificate validation) by specifying tls.options.myOption.clientAuth.caFiles etc., and then attaching that option to routers. DNS-01 for Wildcards: If you want a wildcard certificate for *.example.com, you must use DNS-01. Traefik with a DNS-01 resolver can request a wildcard by having a router rule for, say, Host(example.com) + adding a TLS certresolver with domains[0].main=example.com and domains[0].sans=*.example.com in config. However, an easier approach: Traefik will automatically request a cert for all domain names it encounters in router rules. For wildcard, it might not automatically request it unless specified. But one can define a dummy router that triggers it. In the context of the user use-case: They likely have multiple services with subdomains and want Traefik to manage certificates for all, possibly using DNS-01 if they don’t want to expose port 80 or for wildcard convenience. For example, using Cloudflare’s API to get a wildcard for *.example.com. Setting that up in Traefik static config with a cloudflare token (via environment) and the dnsChallenge is the way. Certificate Storage and Backup: The acme.json file is important – it’s where Traefik stores certificates and private keys (encrypted). Back it up if you wouldn’t want to hit Let’s Encrypt rate limits by re-creating frequently. If you run multiple Traefik instances (for HA) and want them to share certificates, you need to share this acme storage (e.g., put it on a network file system or use Traefik Enterprise which can share storage or an approach with Consul KV).
Dashboard and Monitoring
Traefik’s dashboard is a web UI that visualizes the dynamic configuration – routers, services, middlewares, their statuses, and some stats.
Enabling the Dashboard: As shown earlier, you enable the API/Dashboard in static config with something like --api.dashboard=true. If you set --api.insecure=true, the dashboard is accessible without authentication on Traefik’s API port (default 8080). In production, you should not use insecure mode on a public network. Instead, either don't expose 8080 at all (maybe only allow it from localhost or an admin VPN), or front it with Traefik itself on a secure route with auth. A neat trick: you can run the dashboard on a domain through Traefik by defining a router for it. For example, labels on Traefik’s own container:
yaml
Copy
Edit
- "traefik.http.routers.traefik.rule=Host(`traefik.example.com`)"
- "traefik.http.routers.traefik.service=api@internal"
- "traefik.http.routers.traefik.entrypoints=websecure"
- "traefik.http.routers.traefik.tls.certresolver=myresolver"
- "traefik.http.routers.traefik.middlewares=my-auth"  # protect with auth
Here, api@internal is a special internal service that serves the dashboard and API. This way, you can access the dashboard via https://traefik.example.com, with proper TLS and maybe basic auth.
What the Dashboard Shows: You’ll see a list of routers (with their rules, entrypoints, attached middlewares, service status), list of middlewares (and their types/config), list of services (with the endpoint IPs, load balancer status, etc.). It also shows if any router had errors (like if a service is unreachable, the router might show a warning). This is extremely helpful for debugging why a route isn’t working as expected.
Traefik Logs: Besides the visual dashboard, Traefik logs to stdout by default. You can set log level (info, debug) in static config. In debug mode, it will log every configuration change event and a lot of detail, which can be helpful. Traefik also can emit access logs (disabled by default). To enable access logs: --accesslog=true and optionally a format or file path. Access logs will record each request going through Traefik (with status code, response time, etc.).
Metrics: Traefik can expose metrics to monitoring systems:
Prometheus: The most common, enable via --metrics.prometheus=true and optionally --metrics.prometheus.addEntryPointsLabels=true --metrics.prometheus.addServicesLabels=true (to get finer-grained labels). Once enabled, Traefik will have a metrics endpoint (usually at /metrics on the Traefik API). You can point Prometheus to scrape Traefik. There are pre-built Grafana dashboards for Traefik metrics that show things like request rate per service, latency, etc.
InfluxDB, Datadog, StatsD: Traefik supports these as well if that’s your stack.
Tracing: Traefik supports distributed tracing integration. If you enable tracing (e.g., Jaeger or Zipkin), Traefik will generate trace spans for requests passing through it, which can be combined with traces from your services. For example, for Zipkin:
yaml
Copy
Edit
--tracing.zipkin.httpEndpoint=http://zipkin:9411/api/v2/spans
--tracing.zipkin.samplerate=0.2
--tracing.zipkin.id128Bit=true
--tracing.serviceName=traefik
This would send traces to a Zipkin server at that address with a sample rate of 20%【29†L7-L15】【29†L19-L28】. Ensure the Zipkin endpoint and network connectivity exist. With tracing enabled, each request through Traefik appears in Zipkin (or Jaeger) which is invaluable for debugging latency issues and seeing the flow of requests in microservice architectures.
Health Checks: Traefik by itself doesn’t actively health-check HTTP services unless configured (there is a passive health check in that if endpoints stop responding, Traefik will temporarily stop using them). In Kubernetes, it hooks into readiness probes. In Docker, you might rely on container restarts. But Traefik’s http.services.<service>.healthCheck (in file provider) can be configured to hit a URL on a schedule to determine if an instance is healthy. This is more advanced usage typically not done via labels (requires file provider or Traefik Enterprise).
Monitoring Traefik is important just like any critical infrastructure component. At the very least, enable access logs and some form of metrics. In a production environment, you might run multiple Traefik instances for high availability (maybe behind keepalived or using an external LB to distribute traffic to them, since Traefik by itself is not a clustering solution unless using Enterprise).
Production Best Practices
Running Traefik in production involves considering availability, security, and maintainability:
High Availability (HA): Traefik OSS doesn’t natively cluster (each instance is independent). For HA, run at least two instances of Traefik. You can use a virtual IP (keepalived) or DNS round-robin or a cloud load balancer in front to distribute incoming traffic to both. If using Let’s Encrypt, ensure both instances have access to the same certificate store (e.g., use a shared mounted volume or switch to a DNS-01 challenge with a shared DNS state, or have each get certs with orchestrator-specific logic). Alternatively, configure one Traefik as primary for ACME and use the others in passthrough or with the same certs synced.
Secure the Dashboard/API: As stressed, don’t leave --api.insecure=true in production on a public network. Always secure it with at least basic auth or IP restriction, or disable it entirely. Only admin operators should see the dashboard.
Minimize Permissions: If running Traefik as a container, it generally does not need to run as root inside the container. By default the official Traefik image runs as root because it needs to bind low ports and access the docker socket. You can use Docker capabilities (e.g., CAP_NET_BINDService to allow binding <1024 ports) and run Traefik as a non-root user. Or put Traefik behind a host port forward so it binds to high port. At least ensure the docker socket mount is read-only and that Traefik’s container is not privileged.
Use docker provider safely: The Docker provider by default would expose any container with a port, unless exposedByDefault=false is set (which we did). Always use that and explicitly label what should be exposed. This prevents an accidentally launched container from being automatically internet-accessible.
ACME Rate Limits: Let’s Encrypt has rate limits. In development or initial setup, you might hit them by requesting too many certs. Use the staging LE environment (set caServer to the Let’s Encrypt staging URL) while testing, to avoid blocking yourself. Once things work, switch to production CA. Also, consider using the DNS-01 wildcard to get one cert for all subdomains if you expect to add many services dynamically (so new subdomains don’t each cause a new cert issuance).
Traefik Updates: Keep Traefik updated to latest stable version. Traefik releases often include fixes and new features. Upgrading is usually as simple as replacing the Docker image and restarting the container (Traefik will reload config on startup). The configuration is usually backward-compatible in minor releases, but check the release notes for breaking changes if jumping versions.
Logging Levels: In production, run Traefik at info or even error log level to avoid verbosity (unless troubleshooting). Debug logging can be very noisy and slightly impact performance.
Timeouts: Traefik has default timeouts for connecting to backends, etc. Ensure they align with your needs. For example, if you have some endpoints that do long polling or streams, you might increase timeouts. You can configure respondingTimeouts and forwardingTimeouts in Traefik if needed.
Hardening: If you need Traefik to pass external security audits, consider things like disabling TLS1.0/1.1 as mentioned, and using strong cipher suites. Also ensure no sensitive info is leaked in responses (Traefik by default adds a Server header like “Traefik” – which is not harmful, but some prefer to hide version info).
Monitoring & Alerting: Treat Traefik like any critical server: monitor its memory/CPU (should be low overhead, but if you route thousands of req/s, it uses resources), monitor the certificate expiration (Traefik will renew automatically around 30 days before expiry, but you could still have an external check that your domains have valid certs, just in case). Monitor for HTTP 500s or other errors in the access logs that might indicate misconfigurations or backend issues.
By following these practices, Traefik can be a very robust component in production, handling thousands of routes and certificates effortlessly (Traefik is used in many large-scale systems and is known for its performance and dynamic config).
Integration Examples
Traefik’s flexibility allows it to be the central hub routing to various applications and working with other components. Here are some integration examples relevant to the user’s context and beyond:
Single Sign-On with Authentik (ForwardAuth): As earlier described, Traefik can integrate with SSO solutions like Authentik. For instance, you might protect internal services (say Portainer or Grafana) by not exposing them directly, but instead requiring Authentik authentication. You’d deploy an Authentik outpost (which handles the authentication flow) and configure Traefik ForwardAuth middleware on those routes【24†L101-L109】【24†L113-L120】. When a user tries to access, e.g., portainer.example.com, Traefik’s forward auth will redirect them to Authentik login if they aren’t already authenticated. This provides a seamless SSO across your self-hosted services. Authentik specifically has documentation and templates for Traefik as shown, making this straightforward. The benefit is you centralize auth and can have MFA, password policies, etc., via Authentik.
Traefik with Portainer: Portainer (discussed next section) can itself sit behind Traefik. You might run Portainer at portainer.example.com. Instead of using Portainer’s own SSL, you simply let Traefik handle it and run Portainer in HTTP mode. For example, launching the Portainer container with labels:
yaml
Copy
Edit
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.portainer.rule=Host(`portainer.example.com`)"
  - "traefik.http.routers.portainer.entrypoints=websecure"
  - "traefik.http.routers.portainer.tls.certresolver=myresolver"
  - "traefik.http.services.portainer.loadbalancer.server.port=9000"
This assumes Portainer’s UI is on port 9000 internally (for Portainer 2.x, if you want to use its own TLS, it’s 9443, but we don’t need that as Traefik terminates TLS). Now Portainer gets the benefits of Traefik (like SSO via Authentik from previous point, or you could add BasicAuth middleware if you needed an extra layer).
WordPress with OpenLiteSpeed: Suppose you run a WordPress site with OpenLiteSpeed (a web server). You can have Traefik route HTTP and HTTPS requests for your domain to the OpenLiteSpeed container. Additionally, you might use middlewares for things like redirecting www -> non-www or enabling HSTS. Traefik’s job would be to handle the TLS and then just pass through to OpenLiteSpeed on whatever port it listens (like 8088 for OLS’s HTTP). This decouples TLS config from the WordPress container.
Hosting an API and Web UI (OpenWebUI/ChatGPT): If you have an application like OpenWebUI for ChatGPT (maybe it provides a web interface to a language model), you likely want it accessible at some path or subdomain. Traefik can route chat.domain.com to that container. If the app has a WebSocket or SSE for live updates, Traefik supports WebSockets natively (just ensure you don’t have any middleware that might strip Sec-WebSocket-* headers or such). In Traefik’s configuration, a WebSocket is just an upgraded HTTP connection, which Traefik proxies correctly as long as the router rule matches.
Microservices with Prometheus and Grafana: Traefik can serve as a reverse proxy for monitoring tools too. For example, you might have Prometheus on prometheus.example.com and Grafana on grafana.example.com. Both can be routed by Traefik. Grafana might have its own auth, but you could add another layer (like SSO or basicauth) via Traefik if desired for extra protection. Traefik could also add HTTPS to Prometheus which might otherwise serve on HTTP. Additionally, Traefik itself can feed metrics into Prometheus. So in an architecture, you might have:
Traefik -> routes to everything (including Grafana/Prom)
Prometheus scrapes Traefik metrics (Traefik acting as a target).
Grafana visualizes data including from Prometheus (and could show Traefik metrics dashboards).
Distributed Tracing with Zipkin/Jaeger: If you run a distributed system and use Zipkin or Jaeger for tracing, integrating Traefik is beneficial. Traefik as the entry point can create a root span for each inbound request, then your services (if instrumented) continue the trace. For instance, in Docker labels (or static config) you set up Zipkin as in the earlier example【29†L19-L27】. Now assume Zipkin’s UI is at zipkin.example.com – Traefik can also route to that. One thing: if Traefik is performing TLS termination and your services are also doing traces, ensure it passes the tracing headers like uber-trace-id or X-B3-TraceId etc., which it does by default when tracing is enabled. This allows correlation of front-end (Traefik) and backend spans.
Connecting Multiple Networks: Sometimes you have services not containerized (or on different docker networks). Traefik can have multiple entrypoints and multiple network interfaces. You could use Traefik to route between networks as well. For example, Traefik could listen on an internal entrypoint and forward to internal services. Or use TCP mode to forward database connections (Traefik can do TCP routing if you need, say, a TLS pass-through or SNI based routing for non-HTTP protocols).
These examples show that Traefik can unify access to a heterogeneous set of tools: Portainer (for container management), Authentik (for auth), WordPress (for content), custom apps, and monitoring tools. Each service doesn’t need to worry about TLS or exposing itself – Traefik takes care of that, making your architecture cleaner and more secure.
Portainer Technical Guide
Introduction to Portainer
Portainer is a lightweight, web-based container management UI that allows you to easily manage Docker environments (and also supports Kubernetes, Nomad, etc., though originally known for Docker). It provides a graphical interface for common tasks: deploying containers or stacks, managing images, networks, volumes, and viewing logs and stats. It’s often used to simplify container operations especially when you don’t want to manage everything via CLI, or to delegate some management to less experienced users safely. Key Portainer features:
Container Management: Start, stop, remove containers; edit or duplicate their settings; see resource usage and console output.
Images: Pull images from
Introduction to Portainer (continued)
Portainer’s feature set includes:
Container Management: Start, stop, restart, and remove containers via an easy UI. You can inspect environment variables, bound volumes, and other settings of each container. Portainer also allows opening a console into a running container from the browser.
Image Management: Pull images from registries (Docker Hub or custom registries), tag, push, or remove images. You can browse through images you have and see their sizes and layers.
Network and Volume Management: Create and manage Docker networks (bridge, overlay if using Swarm, etc.) and volumes. You can see which containers are attached to networks and which volumes are in use.
Container Creation and Stacks: Deploy new containers with a form-based wizard (set image, commands, ports, etc.) or use Stacks to deploy multi-container applications via docker-compose (Stacks allow you to paste a docker-compose.yml or upload one, and Portainer will create the services).
Multi-Environment Support: Portainer can manage multiple Docker environments from one interface. These environments can be local Docker, remote Docker hosts, Docker Swarm clusters, or Kubernetes clusters. It connects to remote environments via the Portainer Agent or via direct API (for local).
User Management and Roles: In Portainer, you can create users (and teams) and assign roles to control access. For example, you can limit certain users to specific stacks or endpoints (environments). This is part of RBAC (Role-Based Access Control).
Extensions: Portainer has a concept of extensions (some are commercial features). But core (Portainer CE) includes a lot of functionality out of the box for free.
Portainer is typically run as a container itself (for Docker environment management). It has a minimal footprint (just a few tens of MB of RAM when idle). The web UI runs on a specified port (9000 for HTTP by default, or 9443 for HTTPS). It also has an API which the web UI calls, and which you can use for automation. Portainer’s latest version as of 2025 is in the 2.x series for the Community Edition (CE). The example use-case indicates interest in things like SSO with Authentik and TLS via Traefik, which are possible with Portainer CE 2.6+ (OAuth support was added around Portainer 2.6 for CE【31†L58-L62】).
Deploying Portainer (Single Environment)
Running Portainer on Docker: The simplest way to get Portainer running managing a single Docker host is:
bash
Copy
Edit
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data --name portainer portainer/portainer-ce:latest
This command does the following:
Pulls the Portainer Community Edition image.
Runs it detached, mapping host port 9000 to container 9000 (Portainer UI will be at http://your-host:9000).
Mounts the Docker socket into the container, allowing Portainer to control the local Docker daemon【8†L89-L93】.
Mounts a volume portainer_data at /data in the container – Portainer uses /data to store its database (which has all configurations, users, resource control info, etc.). It’s important to persist this.
Names the container "portainer" for easier reference.
After running that, you would navigate to http://<server>:9000 and you’ll be prompted to create an admin user (the first-time setup). You’ll set a username and password for the Portainer admin. Once inside, by default, Portainer will have added the local Docker environment (since you mounted the socket). You’ll see it under “Endpoints” as the local environment. From there, you can click it and start managing containers/images on that host via the UI. Note on Docker Socket Security: The above method gives Portainer full control of Docker (which is needed for it to manage things). Ensure the Portainer container is from a trusted source (official image) and always keep it updated because it has high privileges via the socket. Using Portainer with Docker Compose: If you prefer docker-compose:
yaml
Copy
Edit
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:
This does the same as the docker run above, but in a compose file. Web Interface Basics: After setup, the UI is fairly intuitive:
The home shows the environment (endpoint) list.
Click into an endpoint to manage it. You’ll see sections for Containers, Images, Networks, Volumes, etc.
To deploy a container, go to Containers > Add Container. Fill in image name, commands, network, storage, etc., or use the "App Templates" (Portainer includes some one-click app templates).
To deploy a stack (multiple containers), go to Stacks > Add Stack. You can paste a docker-compose YAML or upload a file. Portainer will parse it and create the corresponding containers/networks.
Persistent Data and Backups: Portainer’s own data (users, saved stack definitions, etc.) reside in the /data volume. Make sure to back this up (discussed below) or at least keep the volume persistent (like named volume or bind mount to a host path that’s backed up). If you lose /data, you’d lose Portainer’s saved info (though your Docker containers would still exist on the host, Portainer just wouldn’t know about them until re-added).
Managing Multiple Environments (Portainer Agent)
Portainer can manage not just the Docker host it’s running on, but also remote Docker hosts or even clusters. There are two main ways to add a remote environment:
Using the Portainer Agent: This is a small container that runs on the remote host and exposes an API for Portainer to connect to.
Direct via TCP: Exposing the Docker API of the remote host over TCP (not recommended unless secured by TLS, and even then, the agent is often easier).
Portainer Agent Setup: On each remote Docker host you want to manage, run:
bash
Copy
Edit
docker run -d -p 9001:9001 -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/volumes:/var/lib/docker/volumes \
    --name portainer_agent portainer/agent:latest
The agent listens on port 9001 by default (this is an internal port for agent communication).
Mounting the docker socket and volumes is needed for the agent to query containers and volume info.
Ensure port 9001 is reachable by the Portainer server (if Portainer is on a different host, you may need to open firewall for 9001 on the agents, restricted to the Portainer server’s IP).
The agent encrypts communication with a shared key (Portainer generates it). Make sure you use the same version of agent as Portainer expects.
Once the agent is running on a host, go to Portainer UI > Endpoints > Add Endpoint. Choose “Agent” as the environment type. Provide:
A name (e.g., “Prod Server 1”).
The agent’s address (IP or hostname of the remote host and port 9001).
(If applicable, ticks for TLS if you configured the agent with TLS, which by default it’s not needed on trusted networks since it uses a built-in tunnel with the server.)
After adding, Portainer will connect to the agent and the new environment will appear in the list. You can then manage that host’s containers just like the local one. You can add multiple endpoints and even group them. Managing Swarm or Kubernetes: If the remote host is a Docker Swarm manager, Portainer can detect the Swarm and show services/stacks accordingly. Similarly for Kubernetes (if you deploy Portainer on K8s or add a K8s cluster, Portainer UI switches to show K8s constructs). But focusing on Docker: The agent works for standalone and Swarm mode. Edge Agent: Portainer also has an Edge mode for agents to connect out to a central Portainer (useful behind NAT). This is more advanced scenario where the agent connects to Portainer’s beacon and you manage edge devices. RBAC with Multiple Endpoints: You can control which users can access which environment. For example, you can add a user and only give them access to “Dev environment” but not “Prod environment” by assigning them to a team and the endpoint access accordingly. (In Portainer CE, RBAC is somewhat basic but works for separating environments and stacks.)
Stack Deployments
Portainer’s Stacks feature is a convenient way to deploy and manage multi-container applications from compose files, without needing to manually run docker-compose CLI on the server.
Add a Stack: In the UI, go to “Stacks” and click “Add stack”. You have the option to:
Web editor: Paste or type your docker-compose YAML right into a text box.
Upload file: Upload a docker-compose.yml from your computer.
Git repository (Git sync): If you have your compose file in a git repo, you can provide the repo URL (and credentials if private, or specify branch/compose file path). Portainer can pull and deploy, and optionally auto-pull updates.
Give the stack a name. If using the web editor or file upload, Portainer will immediately deploy it when you click “Deploy the stack”.
Once deployed, Portainer will create all the resources (networks, volumes, containers) as defined. It will then show the stack in the list. Clicking the stack name shows the list of containers it includes, and their statuses.
Managing Stacks: Portainer tracks stacks it deployed. You can stop/start all containers in a stack with one action. You can also update a stack: e.g., click the stack, then “Editor” to modify the compose YAML (say, change an image tag or environment variable), then redeploy. Portainer will apply changes (creating new containers, removing, or updating as needed).
Stack vs Container: If you deployed via Stacks, you should manage those containers via the stack interface (the containers will be labeled as part of a Portainer stack). If you remove containers outside of Portainer that belong to a stack, Portainer might consider the stack in error state. It’s best to use one method consistently.
Compose version support: Portainer supports compose versions 2 and 3 (which cover most use cases). Some very new features of Compose might not be supported if they rely on latest Docker API features not yet in Portainer’s parsing logic. But common things (networks, depends_on, deploy configs for swarm, etc.) are supported.
Swarm Stacks: If you connect Portainer to a Docker Swarm cluster, Portainer can also deploy “Swarm stacks” (which use docker stack deploy under the hood). The UI will detect if the endpoint is Swarm mode and adjust accordingly. For single Docker hosts, stacks are deployed like docker-compose (not swarm mode).
Templates: Portainer has an “App Templates” section which is a curated list of common stacks (like WordPress+MySQL, etc.). These are basically pre-defined stacks you can deploy with one click, and then perhaps adjust environment variables. You can also create custom templates (by providing a JSON template file or via the Portainer config).
Using stacks is beneficial for complex apps, because you have the whole configuration in one place and can spin everything up or tear it down easily. It’s also easier to source-control your docker-compose.yml and then copy-paste when needed.
Access Control and RBAC
Portainer allows you to create multiple user accounts and control what they can do or see. This is useful if you have a team and you want to give limited access to some users (for example, a developer can deploy stacks on the dev environment but not touch prod). In Portainer CE (Community Edition):
Users and Teams: You can create users and group them into teams. For instance, a “Developers” team and an “Ops” team.
Endpoints (Environments) access: You can assign which teams/users have access to which endpoint (Docker host or cluster). By default, an endpoint can be set as public (any authenticated user can access) or restricted (only specifically authorized teams/users). When restricted, you explicitly map team “Developers” can access endpoint “Dev Docker host”, but not Prod, etc.
Resource Ownership: Portainer has the concept of resource ownership. A container/stack/image can be “owned” by a user, a team, or marked as public (accessible by anyone). For example, if a user in team A deploys a stack, they could mark it owned by team A, so that team B cannot accidentally modify it.
Roles: In CE, roles are simplified: essentially Non-admin users can either have no access, read-only, or full control on a given endpoint they’re granted. Admin users (the default admin account, or any user marked as admin) have full control on all endpoints and Portainer settings. The finer RBAC (like where you could say user X can only restart containers but not create new ones) is more a Portainer Business Edition feature. However, CE does allow a “read-only” flag on endpoints for non-admins.
For example, you might create a user “viewer” and set them to read-only on an environment. When they log in, they can see containers, logs, etc., but cannot start/stop or deploy anything. Setting up Users/Teams:
After login as admin, go to Settings -> Users to add new users. Assign initial passwords.
Create teams and add users to teams.
Go to Endpoints, edit an endpoint access control: set it to Restricted. Then you can check which teams have “full access” or “read-only” access.
When deploying a container or stack as an admin, you can set the ownership (you might assign it to a team so that team’s users can manage their own resources).
Practical example: Suppose you have a Portainer managing two endpoints: Dev and Prod. You have two teams of developers where Dev1 team should only access Dev endpoint, and Dev2 team also only Dev, and perhaps Ops team can access both Dev and Prod. You could:
Mark both endpoints as Restricted.
Give Dev1 and Dev2 teams access (full control) to Dev endpoint; do not give them Prod.
Give Ops team full control to both Dev and Prod.
Now, Dev users when logging in will only see the Dev environment listed. They can deploy stuff there. They won’t even see Prod in the UI.
For further safety, you could give Dev teams “standard user” status (non-admin) so they can’t change Portainer settings or add endpoints themselves.
If you wanted one team to not modify other team’s containers on the same environment, use resource ownership: team A’s containers are only editable by team A or admins.
Note: The admin user can always see and do everything. For audit purposes, you might want each person to have their own login rather than everyone using “admin”. Portainer’s RBAC in CE is suitable for small setups. For larger enterprise needs (like very granular control, or integration with LDAP/AD for user management), the Business Edition is available. But many self-hosters find CE sufficient.
Automation via API
Portainer itself exposes a HTTP API that covers almost all actions you can do in the UI. In fact, the UI is built on top of this API. The API can be used to automate tasks or integrate Portainer with other systems. Using the API:
The base URL is whatever your Portainer’s address is, e.g., http://portainer.example.com/api/.
You will need to authenticate. Portainer’s API supports basic auth (with the admin or user credentials) or you can POST to /api/auth with JSON {"Username": "admin", "Password": "****"} and it will return a JWT token. You then include that token in headers for subsequent requests (Authorization: Bearer <token>).
API endpoints allow creating containers, stacks, users, updating configurations, etc. For example, GET /api/endpoints lists endpoints, POST /api/stacks can create a new stack (you’d provide the endpoint ID and stack definition).
The Portainer documentation (or browsing the UI in dev tools) is the best way to find exact endpoints. They also provide an OpenAPI/Swagger spec on the Portainer site【33†L130-L134】.
Use cases for automation:
CI/CD Integration: Perhaps you want your CI system to deploy a new version of a stack via Portainer API after building an image. The CI could call the Portainer API to update the stack (essentially sending a new compose file or updating image tags).
Bulk management: Create many users or set up endpoints via script instead of clicking.
Backup via API: While Portainer has UI for backup (Settings -> Backup, which allows downloading a backup of Portainer data【49†L42-L46】), one could also trigger an export via API or simply schedule copying the /data volume.
Monitoring integration: While Portainer isn't typically queried for monitoring data (since one would directly monitor Docker or use Prometheus for container metrics), you could query Portainer’s API to get a list of containers and their status, if you needed to integrate that into some custom dashboard.
Portainer’s API is quite powerful, essentially anything you can do by clicking can be done via a REST call. Make sure to protect the API endpoints (if your Portainer is behind Traefik and Authentik SSO, that helps). Additionally, you might consider creating an API Key or using a less privileged user for specific automation tasks (Portainer 2.9+ introduced API keys for users to avoid sending actual passwords).
Single Sign-On (SSO) with Authentik
Portainer CE 2.6 and above supports OAuth2/OpenID Connect as an authentication method, which means you can integrate SSO solutions like Authentik. This allows users to log into Portainer using an external identity provider (and even enforce MFA through that provider) instead of local Portainer accounts. Setup Outline:
In Authentik (or your OIDC provider), create an OAuth2 application for Portainer. Authentik’s docs provide steps【31†L79-L87】【31†L90-L98】:
Application name (Portainer).
Choose OAuth2/OpenID provider, set redirect URI to your Portainer URL (e.g., https://portainer.example.com/ as Strict redirect).
Authentik will give you a Client ID and Client Secret (and a discovery URL or endpoints).
In Portainer, go to Settings -> Authentication. Change method to “OAuth” (or “OAuth2” in UI).
It will ask for Client ID, Client Secret, Authorization URL, Access Token URL, Resource (UserInfo) URL, Redirect URL, Logout URL, and Scopes【33†L108-L117】.
These values come from Authentik’s application you set up:
Authorization URL: e.g., https://authentik.example.com/application/o/authorize/
Access Token URL: https://authentik.example.com/application/o/token/
Resource/UserInfo URL: https://authentik.example.com/application/o/userinfo/
Redirect URL: https://portainer.example.com/ (this must match exactly what is set in Authentik as redirect)【33†L111-L118】.
Logout URL: https://authentik.example.com/application/o/<slug>/end-session/ (Authentik provides an end-session URL).
Scopes: typically openid email profile (Authentik suggests email openid profile)【33†L117-L124】.
User Identifier: This is which field from the OIDC token to use as Portainer username. Authentik by default might use preferred_username or email. So set accordingly (the Authentik guide uses preferred_username)【33†L115-L123】.
Save settings.
After configuring, Portainer will logout and you’ll need to login via the new SSO. On hitting Portainer’s URL, it should redirect you to Authentik’s login page. After authenticating, Authentik redirects you back to Portainer, and Portainer creates a session for the SSO user.
Important details:
The first time a new SSO user logs in, Portainer will create a user entry for them (with no password, marked as external auth). By default, that user will not be an admin. You might need to log in as the local admin (when SSO is enabled, you still can log in with a local admin by an alternate path – Portainer usually provides a way, like an “Internal” login option if admin account exists). Then you can elevate the SSO user to administrator if needed or put them in teams.
You cannot use OAuth and local auth simultaneously for normal users. It’s one method at a time (except admin as noted).
Authentik specifics: ensure the Portainer application in Authentik is set to use Authorization Code flow (likely default) and not require PKCE (Portainer might not support PKCE as of writing). The Authentik docs snippet we have confirms it's standard OAuth code flow.
If Portainer is behind Traefik, you likely have Traefik already doing some auth. In such a case, you might skip Portainer’s own SSO and just use Traefik forwardAuth. But using Portainer’s built-in OAuth means the Portainer UI itself knows the user identity and audit logs can show the username, etc.
Once SSO is working, users will enjoy one-click login if they already have an Authentik session (SSO). This streamlines access. It’s especially useful if you integrate with something like LDAP via Authentik, so that corporate credentials work on Portainer.
TLS Setup via Traefik
Portainer’s web UI can be served via HTTPS. There are a few ways to achieve TLS:
Using Portainer’s built-in HTTPS (you supply a cert to Portainer).
Using an external reverse proxy like Traefik or Nginx to offload TLS.
Given the user’s stack includes Traefik, the common approach is: Offload TLS to Traefik – This means running Portainer in HTTP mode (port 9000) internally, and not enabling its HTTPS, then Traefik listens on 443 and forwards to Portainer. Benefits of this approach:
Traefik already has Let’s Encrypt automation, so Portainer gets HTTPS with minimal effort.
You can also apply the Authentik SSO at Traefik level if you hadn’t done Portainer’s internal SSO (but doing both is fine too).
Centralized TLS management.
We saw earlier how to label Portainer’s container for Traefik:
yaml
Copy
Edit
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.portainer.rule=Host(`portainer.example.com`)"
  - "traefik.http.routers.portainer.entrypoints=websecure"
  - "traefik.http.routers.portainer.tls.certresolver=myresolver"
  - "traefik.http.services.portainer.loadbalancer.server.port=9000"
With that, Traefik will get a cert for portainer.example.com via myresolver and terminate TLS. It will forward the requests to Portainer’s service on port 9000. Portainer sees it as normal HTTP requests (though it can detect the X-Forwarded-Proto header if needed, but typically not needed). Direct TLS (Portainer’s own): For completeness, if one didn’t use Traefik, Portainer can serve HTTPS by providing it a certificate. In the docker run you’d map -p 9443:9443 and provide --ssl options with the certificate and key file. This is documented on Portainer’s site. But then you’d have to handle certificate issuance/renewal (e.g., using Let’s Encrypt separately). So using Traefik is easier. If using Authentik SSO with Traefik forwardAuth and not Portainer’s OAuth, one must ensure Traefik allows the OAuth redirect process to reach Portainer. However, since in that scenario Portainer would just see an authenticated header from Traefik and treat it as an already-authenticated session (but Portainer doesn’t inherently support that without its own OAuth). So realistically, using Portainer’s built-in SSO (as above) and Traefik just passing through TLS is the straightforward solution. Websocket considerations: Portainer’s UI might use websockets for realtime updates (like tailing logs). Traefik will handle that fine as long as no special config is needed (it will automatically forward Upgrade headers). In summary, with Traefik in place, simply configure Traefik to route the Portainer domain and you get TLS. No extra steps inside Portainer needed, other than maybe telling Portainer it’s behind a proxy if you want to adjust session settings (Portainer has an option “Public HTTP address” in settings to set the external URL, which might be used for OAuth redirects or notifications).
Backup and Recovery
Backing up Portainer primarily means backing up the data volume (/data). This volume contains:
The Portainer database (portainer.db), which includes users, teams, endpoint definitions, stack definitions, resource control settings.
Any files stored via Portainer (like if you uploaded an SSL cert for some reason or stack file, etc.).
(It does not store container images or such – those remain in Docker).
Backup via UI: Portainer offers a one-click backup. Under Settings -> Backup Portainer, there is a “Download backup” button【49†L42-L46】. Clicking it makes the browser download a tar archive of the Portainer data (basically a dump of the /data volume). You should do this as an admin. You can restore by uploading that file in a new Portainer instance (on first setup or via the UI restore function). Automated Backup: Relying on manual download isn’t ideal for regular backups. Alternatives:
If /data is a named volume, you could use Docker commands to export it: e.g., docker run --rm -v portainer_data:/data -v $(pwd):/backup alpine tar czf /backup/portainer_backup.tar.gz /data. This creates a backup tar.gz in your current dir.
Or use a tool like docker cp on a stopped Portainer container to copy out /data (though better to stop Portainer to have DB in consistent state).
Use a volume backup container or script (the community has some, e.g., portainer-backup scripts【46†L23-L26】).
If /data is bind-mounted to the host (e.g., /opt/portainer-data), you can use traditional host backup (like rsync it to somewhere safe).
What to backup: At minimum, backup portainer’s /data. If you want a more complete disaster recovery backup, also backup any compose files (though those are in portainer’s DB if you deployed as stacks), and you might also backup your container data volumes (like if you have a MySQL container with a volume, that data is separate from Portainer). Restoring Portainer: If your Portainer instance was lost (say the server died):
Re-deploy a new Portainer (same version ideally).
Before accessing UI, replace its /data with the backup data (if you have the tar, extract it into the volume).
Start Portainer and it should have all previous info. If endpoints were remote, you may need to re-establish trust (Portainer might have stored an endpoint ID that agents expect – usually it picks up fine if agent is still running with same secret).
Alternatively, if you have the backup file, you can deploy Portainer fresh, create an admin (maybe same credentials as before), then in Settings -> Restore, upload the file.
If you are using OAuth authentication, note that those users exist via the SSO, but Portainer's record of them (like team membership) is in the DB backup. Stack Configs in Backup: Portainer’s backup includes the stack definitions (the compose file content you deployed). That means on restore it knows how to redeploy them. However, Portainer doesn’t automatically redeploy stacks on a new environment unless you instruct it. If you lost both Portainer and the Docker host, you’d need to recreate the environment and redeploy stacks. So for completeness in a multi-host scenario: backup Portainer data, and have backups of your actual container data (which Portainer doesn’t handle).
Upgrades and Maintenance
Keeping Portainer up-to-date:
Upgrading Portainer: Since Portainer is a container, upgrading is done by deploying a new container version. If using Docker, you’d pull the new image and recreate the container with the same /data volume. For example: docker pull portainer/portainer-ce:latest, then docker stop portainer && docker rm portainer, then re-run the docker run ... with the new image (or if using compose, change image tag and docker compose up -d). The data migration, if any, is usually handled automatically by Portainer on startup. Portainer releases often maintain backward compatibility in the database, but always check release notes.
Zero-Downtime: In a single instance, you’ll have a brief downtime during container restart. In multi-node Portainer (one Portainer server managing many agents), usually you only run one Portainer (for CE, as it doesn’t cluster), so just plan a short maintenance window to restart it.
Compatibility: Ensure the Portainer Agent versions match the server if upgrading. Typically, upgrading Portainer server first, then updating agents (though older agents usually still work with newer server for a while).
Migrating Portainer: If moving Portainer to a new host or into a cluster, just bring along the /data volume. You can also migrate from Portainer CE to BE by deploying BE and pointing it to the CE data (though BE might require license etc).
Routine maintenance tasks:
Cleaning up Portainer DB: Normally not needed, but if you removed stacks/endpoints/users often, the DB should shrink automatically (it’s SQLite). Keep an eye if portainer.db grows abnormally (maybe lots of stack versions saved).
Portainer Logs: Portainer logs to stdout (so docker logs portainer shows it). Typically minimal logs unless errors. But if many users, it logs each login, etc. Use --restart=always (as in the compose) so it auto-starts on host reboot.
Endpoint Health: In Endpoints view, Portainer shows if an endpoint is down (like agent unreachable). If an agent goes offline, you might need to check that host or re-register it if something changed (like agent lost config).
Updating Stacks: When you update a stack (e.g., new image tag), Portainer does not automatically do image pulls unless told. Ensure your compose has pull_image: always if you want that behavior, or manually pull images via UI before redeploy.
Best Practices for Portainer
To wrap up, consider these best practices when using Portainer:
Secure Admin Access: Protect Portainer behind authentication (either its own or SSO). Never expose it to the internet without strong access control. If possible, limit access by IP or use an extra layer (like an Authentik forwardAuth in Traefik, or VPN).
Use Least Privilege for Users: Only give users access to the environments and actions they need. Use teams to separate concerns (devs vs ops, etc.). This will prevent accidents (like a dev accidentally deleting a prod container).
Keep Portainer Updated: New releases often bring security fixes (for instance, older Portainer had an API token vulnerability that was fixed, etc.). Since it’s easy to update (just container replacement), plan to update at least every few months after testing.
Regular Backups: Automate backup of the Portainer /data. Also document the procedure to restore, so if your Portainer server dies, you can recover quickly. If using an external DB (Portainer BE can use external SQL, CE always uses internal), back that up too.
Don’t Rely on Portainer as Sole Ops Channel: While Portainer is great, ensure you or someone on the team still knows how to use Docker CLI for emergencies. If Portainer ever has an issue, you should be able to manage containers via CLI until it’s resolved.
Volume Management via Portainer: One limitation: Portainer might not fully handle some advanced volume plugins or complex bind mount scenarios (especially on remote endpoints). You might occasionally need to do such things via CLI.
API Keys: Use API keys for automation instead of embedding user passwords. In Portainer 2.11+, you can create API keys under your user profile for scripting. This way, if the key is compromised, it can be revoked without changing your main password.
Resource Limits for Users: You can’t directly limit what containers a user deploys (like preventing them from using too much CPU) via Portainer. Rely on Docker’s own controls (like cgroup limits in the compose). Portainer will allow any container creation that the Docker API allows for that user’s access.
Monitor Portainer: At least watch the container’s memory/CPU. It’s lightweight, but if you have hundreds of stacks it might use more memory. Also monitor the Docker socket usage (heavy use of Portainer by many users could in theory overwhelm the Docker daemon with requests, though that’s rare).
Logging and Auditing: Portainer logs some events (like user logins). For a more detailed audit, consider using the Docker daemon’s audit logs or integrating Portainer with external logging if needed. Portainer BE has more audit, but CE is limited.
Portainer and Swarm/K8s: If you expand to orchestrators, be aware of differences. In Swarm, Portainer can deploy stacks as Swarm services. In Kubernetes, Portainer’s UI shifts to K8s objects (it can even manage Helm charts). The learning curve is slightly different, but it’s an option if you transition from Docker to K8s.
Portainer greatly simplifies container management for both small home server setups and certain production scenarios. By following security best practices and utilizing its features (like teams, stacks, SSO), you can safely delegate container operations and maintain oversight of your container infrastructure through a user-friendly interface.
Sources:
Docker Documentation – Overview and Architecture【1†L162-L170】【1†L174-L182】
Docker Security Best Practices【39†L190-L198】【39†L200-L209】【4†L33-L37】
AlmaLinux Wiki and Server World – AlmaLinux 9 Setup (SELinux, firewalld)【12†L377-L385】【20†L103-L112】
Authentik and Traefik Integration Docs【24†L101-L109】【24†L113-L120】
Authentik and Portainer OAuth Integration【33†L108-L117】【33†L115-L123】
Traefik Documentation – Docker Provider and Tracing【44†L313-L320】【29†L19-L27】
Marius Hosting – Portainer Backup Guide【49†L42-L46】


OpenLiteSpeed on Docker vs Native Linux: Performance & Deployment Guide
Overview
OpenLiteSpeed (OLS) is a high-performance, lightweight web server. It can run directly on a Linux host or inside a Docker container. Containerizing OLS offers portability and isolation, while a native installation runs directly on the host OS. This guide examines the trade-offs in performance and deployment between running OpenLiteSpeed in Docker containers versus on a native Linux system, backed by current best practices and industry data.
Containerizing OpenLiteSpeed: Pros and Cons
Pros of Docker Containerization:
Portability & Consistency: Docker bundles OLS with its dependencies, making it easy to replicate the same environment anywhere. You can reproduce builds and deployments reliably since only the Docker engine is required on the host​
TORIZON.IO
. This simplifies moving your OLS setup to new servers or environments without re-installation.
Isolation of Dependencies: Containers encapsulate OLS and related services (PHP, databases, etc.) separately, preventing version conflicts. For example, updating one component in a container won’t break others on the host​
REDDIT.COM
. Each container has its own libraries and user space, which avoids the “it works on my machine” problem.
Ease of Updates & Rollbacks: Upgrading OLS is simplified – you can pull a new container image or rebuild it, and roll back easily if needed. This means you can run newer OLS or PHP versions even on an older host OS​
REDDIT.COM
. The container provides consistency, so software can be updated independently of the host.
Scalability & Orchestration: Containerized OLS can be deployed in clusters using Docker Compose, Kubernetes, etc., enabling easy horizontal scaling and management. Orchestrators can restart or duplicate containers to handle load. This is ideal for microservices or multi-instance deployments where OLS serves as part of a larger system​
REDDIT.COM
.
Security Sandbox: Docker adds a layer of security isolation. If the OLS web server (or a web app on it) is compromised, the damage is more contained than on a host system – the attacker would be trapped in the container namespace rather than owning the whole server​
REDDIT.COM
. Running OLS as a non-root user or in rootless containers further improves security. (Containers are not full security boundaries, but they do make compromising the entire host more difficult in many cases.)
Cons of Docker Containerization:
Added Complexity: Introducing Docker means an extra layer of infrastructure. You must manage Docker itself, container images, and networking. For a simple single-server setup, running OLS natively might be simpler – Docker’s benefits shine when you have many services or need consistency​
REDDIT.COM
​
REDDIT.COM
. If your current VM is stable and you’re not frequently re-deploying or modifying it, containerizing might not be worth the complexity overhead.
Data Management Overhead: By default, containers are ephemeral. You need to set up volumes for persistent storage (for site files, configs, SSL certs, logs, etc.), which is an extra step. If not planned, data could be lost when a container is removed. In contrast, a native install keeps data on the host filesystem by default. (Using volumes or bind mounts mitigates this by storing data on the host while still running OLS in Docker.)
Networking Differences: In Docker, OLS runs in an isolated network namespace. You must publish ports (e.g. map container port 80/443 to host) to serve traffic, and be aware of Docker’s virtual network. This NAT layer can slightly complicate network configuration and introduces a tiny bit of latency (discussed below)​
STACKOVERFLOW.COM
. On a native setup, OLS binds directly to host interfaces without this indirection.
Potential Performance Overhead: While container overhead is very low, it isn’t zero. There is a minor runtime cost for using Docker’s abstraction (especially I/O and network, as detailed in the next section). Absolute bare-metal performance is achieved only by native execution without any container​
CHANNELFUTURES.COM
. For extremely latency-sensitive scenarios, this slight overhead might matter (though for most web workloads it’s negligible).
Debugging & Monitoring Complexity: With OLS in a container, you might need container-specific steps to debug or monitor (e.g. docker exec to enter the container, or ensuring your monitoring agent has access to container metrics). Native installations integrate directly with host monitoring, logging, and management tools. This is surmountable (containers can expose metrics, logs, etc.), but it requires additional configuration.
Performance Considerations: Docker vs Native
Running OpenLiteSpeed in a Docker container yields performance that is nearly identical to running it natively on Linux, thanks to Docker’s lightweight nature. However, certain resources (CPU, memory, disk I/O, network) can behave slightly differently under containerization. Below is a breakdown of performance impacts and considerations, with technical explanations:
CPU Throughput: CPU performance inside Docker is virtually the same as on the host. Containers use the host kernel directly, so there’s no hypervisor to slow down CPU operations. Empirical studies show no significant CPU overhead for containers versus native execution (differences on the order of 0–4%, often 0%)​
STACKOVERFLOW.COM
. In other words, an OpenLiteSpeed process in Docker can handle essentially the same request load as one running directly on the host. Recent benchmarks confirm that “containers introduce no compute tax” – they ran within 0.1% of native speed in CPU-intensive tests​
BLOG.HATHORA.DEV
. This means you can expect OLS’s request processing, SSL handshakes, etc., to perform at native speeds.
Memory Usage: Memory footprint and throughput are also nearly identical between containerized and native runs. Docker doesn’t emulate memory – the OLS process uses normal host memory via the kernel, so memory access and usage incur no extra overhead​
STACKOVERFLOW.COM
. The main difference is the Docker engine itself consumes some RAM (tens of MB) and if you set memory limits, the container can be constrained. Without limits, OLS will use whatever memory it needs just like a normal process. (Be mindful that if you do enforce a memory limit and OLS or PHP exceed it, the kernel’s OOM killer will terminate processes in the container. Native OLS would similarly crash if the system ran out of memory, but with containers it’s easier to accidentally set an artificially low cap.) In summary, serving cached pages or holding objects in memory cache is just as efficient under Docker as on the host.
Disk I/O (File System Performance): Disk I/O in containers can be as fast as native, but it depends on storage configuration. Reading files from Docker’s layered filesystem has very little overhead – if a file isn’t modified in the container, it’s read from the image layer with negligible performance cost​
DOCS.DOCKER.COM
​
DOCS.DOCKER.COM
. However, writing to the container’s filesystem can trigger the copy-on-write mechanism. The first time a file from the read-only image layer is modified, Docker’s storage driver must copy that file into the container’s writeable layer (this is called a “copy_up” in OverlayFS). Copying the whole file (especially if large) before writing can noticeably impact write performance​
DOCS.DOCKER.COM
. For example, if OpenLiteSpeed writes to a log file or cache file that was part of the image, the first write incurs the cost of copying that file into the container layer. After the first write, subsequent writes are fast (they operate on the container’s copy of the file). In practice, OLS workloads (serving files, reading configs) are mostly read-heavy, so they see minimal difference. But for write-heavy workloads, Docker’s thin provisioning and COW layers add overhead. The good news is there’s a straightforward solution: use volumes for data. Docker volumes or bind mounts let OLS read/write directly on the host filesystem, bypassing the union filesystem. This yields the “best and most predictable performance” for write-intensive operations​
DOCS.DOCKER.COM
. In fact, industry tests noted that Docker volumes have noticeably better performance than using the AUFS overlay filesystem for data​
CLOUDNATIVENOW.COM
. Takeaway: OLS serving static files or cached content from a volume will perform like native. If it’s writing lots of data (logs, uploads), mapping those directories to host storage avoids any slowdown.
Network Latency & Throughput: Network performance is the one area where containerization introduces a small overhead, primarily due to NAT and virtual networking. By default, Docker containers use a bridged network interface and port mapping to connect to the host network. This extra hop through Docker’s virtual ethernet and NAT adds a bit of latency – on the order of microseconds per packet. An IBM research study showed that using Docker’s NAT (e.g. -p 80:80 port mapping) causes a minor hit in latency compared to native networking​
STACKOVERFLOW.COM
. One recent benchmark measured about ~5 microseconds added to 99th-percentile latency within a data center when using container networking​
BLOG.HATHORA.DEV
. Even under high packet rates, the overhead is small, though measurable​
CLOUDNATIVENOW.COM
. The impact on throughput is negligible for most web workloads; it might only become a concern in extreme scenarios (like hundreds of thousands of small requests per second, where those microseconds accumulate). Mitigations: If ultra-low latency or maximum packets per second are required, you can use host networking mode. Running a container with --network=host bypasses Docker’s networking stack and lets OLS use the host interface directly, yielding identical network performance to native​
STACKOVERFLOW.COM
. In summary, for typical usage the default bridged networking is fine (the overhead is so minimal that network variability or internet latency will dwarf it​
BLOG.HATHORA.DEV
). But Docker gives you the flexibility to remove even that overhead when necessary by switching to host network mode.
Bottom Line: With proper configuration, OpenLiteSpeed in Docker can match native performance in CPU, memory, and disk I/O, with network performance almost on par except for a tiny NAT overhead (which can be eliminated by configuration). Modern container overhead is low enough that in practice a well-tuned containerized OLS will feel just as fast as a native deployment​
STACKOVERFLOW.COM
.
Best Practices for Running OpenLiteSpeed in Docker
To ensure you get optimal performance and reliability when containerizing OpenLiteSpeed, follow these best practices for configuration:
Allocate Sufficient CPU & Memory: By default, a Docker container can use all host CPU cores – which is good for performance. If you need to limit CPU (e.g., in multi-tenant environments), use Docker’s --cpus or --cpuset options carefully. It’s recommended to allocate whole CPU cores to the container if you impose limits (for example, --cpus="2.0" for two cores) to minimize context-switch overhead​
BLOG.LITESPEEDTECH.COM
. Fractional CPU quotas can introduce extra scheduling latency, whereas whole cores ensure OLS runs without added interruptions. For memory, avoid setting an overly tight memory limit (-m flag) on the container unless necessary; let OLS and associated processes use what they need and rely on the host’s overall memory management. If you do set a limit, monitor usage to prevent invoking the OOM killer. Essentially, treat resource limits as you would in a VM or on bare metal – give OLS enough headroom to operate efficiently.
Use Volumes for Persistent Data: Mount Docker volumes or host directories for any data that should persist or needs high-performance I/O. This includes your website files, OpenLiteSpeed configuration (/usr/local/lsws conf), logs/, and any LiteSpeed Cache data. Storing these on a volume means reads/writes go straight to the host filesystem, avoiding copy-on-write overhead and yielding native-speed I/O​
DOCS.DOCKER.COM
. It also ensures that if the container is recreated or updated, you don’t lose important data. For example, you might use -v /host/path/html:/usr/local/lsws/Example/html for site documents and -v /host/path/logs:/usr/local/lsws/logs for logs. By separating persistent data, you not only improve performance but also get organized in distinguishing ephemeral container layers from long-term storage​
REDDIT.COM
. (As a bonus, this makes backups easier – you can snapshot or rsync the host volumes as needed.)
Leverage Host Networking for Low-Latency: If you require the absolute lowest network latency or are pushing very high request rates, consider running the container with host networking (docker run --network=host). This way, OpenLiteSpeed listens on the host’s network interfaces directly, eliminating Docker’s port mapping overhead​
STACKOVERFLOW.COM
. Host networking is useful when you want to maximize throughput or avoid any potential issues with Docker’s virtual NAT (for instance, in edge cases with very high connection churn or throughput). Keep in mind that with host networking, port conflicts can occur (since the container isn’t isolated on networking – ensure nothing else on the host uses ports 80/443). For most use cases, the default bridge network with -p 80:80 is sufficient, but host networking is a good tweak for performance enthusiasts or specialized scenarios.
Choose the Optimal Storage Driver: Use Docker’s recommended storage driver on your system for best results – typically Overlay2 on modern Linux kernels. The OverlayFS/overlay2 driver is fast and reliable, and it’s the default on most distributions. Avoid older drivers like AUFS or devicemapper in loopback mode, which have more overhead. Studies have shown volumes outperform AUFS significantly for file operations​
CLOUDNATIVENOW.COM
, and overlay2 generally surpasses or equals AUFS performance. Fortunately, Docker will usually pick overlay2 automatically; just verify by running docker info and checking the storage driver. Ensure your host filesystem is formatted with features that support the driver well (for overlay2, an ext4 or xfs filesystem with d_type enabled is recommended by Docker). In short, stick with the modern defaults unless you have a specific reason to change – they offer the best performance and stability for containerized OLS.
Keep Your Container Lean & Updated: Use the official OpenLiteSpeed Docker image (or a well-maintained minimal base) and avoid installing unnecessary packages into the container. A slimmer image means less attack surface and slightly less overhead (especially during container startup or image pull). When building custom images, follow Dockerfile best practices (minimize layers, clean up caches, etc.). Also, keep the OLS container updated – rebuild or pull new images to get the latest OpenLiteSpeed version and security patches. This ensures your performance is not only fast but also that you have the latest improvements (for example, newer OLS versions might have better HTTP/3 support or bug fixes). Regular updates in Docker are easier (just swap the image) compared to manual native upgrades, so take advantage of that for both performance and security benefits.
Comparing Containerized vs Native Deployments
In practical terms, running OpenLiteSpeed in Docker versus on a native Linux install will feel similar to end-users, but the workflow for deployment and management differs. Here’s a comparison of key aspects in real-world scenarios:
Deployment & Portability: A native installation typically involves installing OLS (and PHP, etc.) via a package or script on each server and configuring it. In contrast, with Docker you can ship the environment as a single image or compose file. This makes migrating or scaling out easier – e.g., if you switch hosting providers or add a new server, you can just deploy the same OLS container image and it will run identically​
REDDIT.COM
. Containers encapsulate the OS environment (libraries, configurations) needed for OLS, so differences in the host OS have minimal impact​
TORIZON.IO
. Native setups might require re-doing config and installation on each new host, whereas containerized setups are more plug-and-play.
Performance: As detailed earlier, there’s little difference in performance. In practice, a well-tuned containerized OLS can handle the same traffic as a native one. Benchmarks and user experiences indicate that most won’t notice any performance degradation when using Docker for OLS​
STACKOVERFLOW.COM
. Native might have a very slight edge in edge cases (no extra latency at all, whereas Docker adds microseconds)​
CHANNELFUTURES.COM
, but this is rarely a deciding factor. It’s safe to choose based on other factors (manageability, scaling) rather than raw speed, since Docker won’t meaningfully slow OLS down in typical scenarios.
System Integration: With a native install, OpenLiteSpeed is integrated into the host OS – e.g., it may run as a systemd service, store config under /etc/ or /usr/local/lsws, and log to /var/log/. This allows you to use host-based tools (journalctl, logrotate, fail2ban for logs, etc.) directly. In a container, OLS is isolated from the host’s init system and filesystem by default. You’ll likely run it in the foreground inside the container (Docker takes care of keeping it alive/restarting it). Logs and config are inside the container’s filesystem unless exported via volumes. This means you might need to adapt monitoring/backup procedures: for example, mount log volumes so that host-based log rotation or security monitoring can still function, or use Docker’s logging driver to forward logs to the host. It’s all achievable, but native setups might integrate a bit more naturally with existing server management routines.
Security & Isolation: In native mode, you rely on OS user permissions and optional security modules (SELinux/AppArmor) to isolate OLS and any web apps. In Docker mode, you gain an extra layer of isolation via namespaces and cgroups – which can limit what OLS can access on the host. If an attacker breaks into a native OLS process, they might pivot to the rest of the system more easily than from a constrained container (assuming the container is not running with excessive privileges)​
REDDIT.COM
. On the other hand, containers share the kernel, so kernel-level exploits could affect the host. Both approaches can be made secure, but their models differ: Docker encourages a “sealed” application container with only specific ports and volumes exposed, while a native setup might require hardening the OS around the OLS service. Some admins find comfort in the additional container sandbox, while others prefer the simplicity of one less layer.
Maintenance & Operations: Managing Dockerized OLS means dealing with Docker commands or a compose file to start/stop containers, whereas native OLS uses the system’s service management. Routine tasks like restarting the server or applying config changes are slightly different (e.g., docker restart my-ols vs systemctl restart lsws). Updates in Docker (as noted) involve image updates, which can be very fast (swap containers) but you need to maintain your Dockerfiles or watch for new image tags. Native updates use the package manager or source builds, which some admins find straightforward as well. Backup strategies also differ: with native, you back up certain directories; with Docker, you ensure volumes are backed up and maybe snapshot the image or Docker volumes. In summary, daily operation of containerized OLS is just a little different – neither inherently harder nor easier, but using Docker effectively has a learning curve. If you’re already comfortable with Docker, leveraging it for OLS will unify your deployment workflow with your other containerized services. If not, a native install might be more immediately transparent.
When to Use Docker vs When to Go Native
Both deployment methods have their ideal use cases. Below are scenarios to help decide which approach fits best: When Containerizing OLS is Ideal:
Multiple Environments or Moves: If you need to run OpenLiteSpeed across dev/staging/production or migrate between servers frequently, Docker offers consistency. You can “build once, run anywhere” – e.g., package your whole WordPress + OLS stack in a container and deploy it on any Linux host with Docker with minimal fuss​
REDDIT.COM
. This reduces the “works on one server but not another” issues.
Microservices or Complex Stacks: When OLS is part of a larger microservices architecture (perhaps as a reverse proxy, or serving alongside other containerized apps), running it in Docker keeps everything in the same management ecosystem. Orchestrators like Kubernetes handle containerized services uniformly, so including OLS allows you to manage it with the same tooling as other components (scaling, health checks, etc.).
Isolation of Apps or Tenants: If you host multiple websites or applications that require different configurations, containerizing each OLS instance can cleanly separate them. For example, one site can run in an OLS container with PHP7 and another with PHP8 without conflict. This is useful in multi-tenant scenarios – each customer’s stack in its own container – ensuring one doesn’t affect the others. (OLS also has built-in capabilities for isolation, but Docker goes further by isolating at the OS level.)
Easy Scaling & Recovery: In environments where you might need to rapidly scale out (like handling a traffic spike) or quickly recover from failures, Docker’s lightweight nature helps. Spinning up a new OLS container is fast (seconds) and can be automated. In contrast, setting up a new VM or native install might take longer. If an OLS container crashes, Docker can restart it automatically. For load-balanced web servers, you can clone containers to add capacity. This agility makes Docker appealing for cloud-native deployments.
Preference for Modern DevOps Practices: If your workflow already uses CI/CD pipelines, infrastructure as code, and container registries, it’s natural to include OLS in that. You can version your OLS configuration in a Dockerfile, test it in CI, and deploy via registry. This aligns with modern DevOps patterns for consistency and automation. Native installs can be automated too (with configuration management tools), but containers often require less per-host configuration once the image is prepared.
When a Native Installation is Better:
Simplicity of a Single Server: If you have a single-purpose server (e.g., one box running OLS for a few sites) and don’t plan to change or replicate the setup often, a native install might be simpler and perfectly sufficient​
REDDIT.COM
. You avoid introducing Docker and can manage OLS with familiar tools. Essentially, if Docker isn’t solving a clear problem for your use case, running without it avoids the additional moving parts.
Absolute Minimal Overhead: In extremely latency-sensitive scenarios (financial trading, high-frequency transactions, etc.), you might not even want the slight network indirection of Docker. Native OLS eliminates even the ~microsecond overhead of container networking​
CHANNELFUTURES.COM
. Similarly, if you’re constrained on resources (say a very small VPS or a device with minimal RAM), avoiding Docker’s background services could save a bit of memory. (Docker is lightweight, but on a 512MB RAM server, every MB matters – though note that OLS itself is quite lightweight too.)
Tight Host Integration: Sometimes OLS needs to integrate closely with host systems or hardware. For example, if you rely on the host’s firewall, advanced networking (custom iptables, SNAT/DNAT rules), or have to use kernel modules (like kernel TLS or specific drivers), running OLS natively might simplify access to those features. While you can use Docker with --privileged or extra configs to access host features, at that point you lose many benefits of isolation. Native deployment would be more straightforward in such cases.
Legacy or Traditional Workflows: In some organizations, the operational model is built around managing services on VMs/servers directly (with tools like Ansible, Puppet, etc.). If introducing Docker is not feasible due to team skillsets or compliance (some regulated environments prefer no container layer), sticking to a traditional install could be better. Also, if you’re using a hosting panel or environment that doesn’t support Docker well (like cPanel without CloudLinux, etc.), you might opt for native where all vendor support lies.
Debugging/Profiling Needs: When you need to troubleshoot performance issues or do low-level profiling (strace, perf, etc.), doing it on a native process is a bit more direct. With containers, you can still do these (by entering the container namespace), but it’s another step. If you value having the webserver as just another process on the host that you can attach debuggers to without any indirection, native fits that preference.
In summary, containerization is ideal when you value portability, isolation, and modern deployment practices – it shines in multi-server, multi-service, or frequently-changing environments. Native installation can be advantageous for simplicity and when you need to squeeze out every last drop of performance or integration with the host. Often, the decision comes down to the scale and nature of your deployment: a single Linux server running a stable site may do great with a native OpenLiteSpeed setup, whereas a cloud-native microservices platform or a host with many disparate applications would benefit from Dockerizing OpenLiteSpeed for better management. References: The recommendations above are based on up-to-date sources including performance benchmarks (showing Docker’s negligible overhead)​
STACKOVERFLOW.COM
​
BLOG.HATHORA.DEV
, Docker’s official documentation​
DOCS.DOCKER.COM
​
DOCS.DOCKER.COM
, and industry analyses of container vs native deployments​
STACKOVERFLOW.COM
​
CLOUDNATIVENOW.COM
. By following these guidelines, you can confidently deploy OpenLiteSpeed in the environment that best suits your needs, without sacrificing performance or reliability.
