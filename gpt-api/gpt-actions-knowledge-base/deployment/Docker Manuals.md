Docker Manuals
This section contains user guides on how to install, set up, configure, and use Docker products. It includes open source components like Docker Engine and Docker Compose, Docker’s desktop and cloud services, as well as account and administration information.
Open Source Projects
Docker Build
Docker Build is one of Docker Engine’s most used features. Whenever you create a Docker image, you are using Docker Build. Build is a key part of your software development life cycle, allowing you to package and bundle your code and ship it anywhere. Docker Build is more than a command for building images; it’s a whole ecosystem of tools and features supporting common workflow tasks as well as advanced scenarios.
Docker Build Overview
Docker Build implements a client-server architecture, where:
Client: Buildx is the client and the user interface for running and managing builds.
Server: BuildKit is the server (builder) that handles build execution.
When you invoke a build, the Buildx client sends a build request to the BuildKit backend. BuildKit resolves the build instructions and executes the build steps. The build output is either sent back to the client or uploaded to a registry (such as Docker Hub). Buildx and BuildKit are both installed with Docker Desktop and Docker Engine out-of-the-box. When you invoke the docker build command, you’re using Buildx to run a build using the default BuildKit bundled with Docker.
Buildx
Buildx is the CLI tool that you use to run builds. The docker build command is a wrapper around Buildx. When you invoke docker build, Buildx interprets the build options and sends a build request to the BuildKit backend. The Buildx client can do more than just run builds. You can also use Buildx to create and manage BuildKit backends (referred to as builders). It supports managing images in registries and running multiple builds concurrently. Docker Buildx is installed by default with Docker Desktop. You can also build the CLI plugin from source, or grab a binary from the GitHub repository and install it manually (see the Buildx README on GitHub for more information).
Note: While docker build invokes Buildx under the hood, there are subtle differences between this command and the canonical docker buildx build. For details, see documentation on the difference between docker build and docker buildx build.
BuildKit
BuildKit is the daemon process that executes the build workloads. A build execution starts with invoking a docker build command. Buildx interprets your build command and sends a build request to the BuildKit backend. The build request includes:
The Dockerfile
Build arguments
Export options
Caching options
BuildKit resolves the build instructions and executes the build steps. While BuildKit is executing the build, Buildx monitors the build status and prints progress to the terminal. If the build requires resources from the client (such as local files or build secrets), BuildKit requests those resources from Buildx. Compared to Docker’s legacy builder, BuildKit is more efficient: it only requests the resources that the build needs when they’re needed (the legacy builder always took a copy of the local filesystem). Examples of resources that BuildKit can request from Buildx include local filesystem build contexts, build secrets, SSH sockets, and registry authentication tokens.
Multi-stage builds
Multi-stage builds help you optimize Dockerfiles while keeping them easy to read and maintain. With multi-stage builds, you use multiple FROM statements in your Dockerfile. Each FROM instruction can use a different base image and begins a new stage of the build. You can selectively copy artifacts from one stage to another, leaving behind everything you don’t want in the final image. For example, consider a Dockerfile that has two stages: one for building a binary and another for copying that binary into a minimal base image:
dockerfile
Copy
# syntax=docker/dockerfile:1
FROM golang:1.23
WORKDIR /src
COPY <<EOF ./main.go
package main

import "fmt"

func main() {
  fmt.Println("hello, world")
}
EOF
RUN go build -o /bin/hello ./main.go

FROM scratch
COPY --from=0 /bin/hello /bin/hello
CMD ["/bin/hello"]
You only need this single Dockerfile (no separate build script). Just run docker build:
bash
Copy
$ docker build -t hello .
The end result is a tiny production image with nothing but the compiled binary inside. None of the build tools required to build the application are included in the resulting image. How does it work? The second FROM instruction starts a new build stage with the scratch image as its base. The COPY --from=0 line copies just the built artifact from the previous stage into this new stage. The Go SDK and any intermediate artifacts are left behind and not saved in the final image.
Name your build stages
By default, stages aren’t explicitly named and you refer to them by an integer (starting with 0 for the first FROM). You can name your stages by adding an AS <NAME> to the FROM instruction. For example, improving the previous Dockerfile:
dockerfile
Copy
# syntax=docker/dockerfile:1
FROM golang:1.23 AS build
WORKDIR /src
COPY <<EOF /src/main.go
package main

import "fmt"

func main() {
  fmt.Println("hello, world")
}
EOF
RUN go build -o /bin/hello ./main.go

FROM scratch
COPY --from=build /bin/hello /bin/hello
CMD ["/bin/hello"]
By naming the first stage “build” and using --from=build in the COPY, the build will not break if instructions are re-ordered, since the name is used instead of an index.
Stop at a specific build stage
When building an image, you might not need to build all stages. You can specify a target stage using --target. For example, using the above multi-stage Dockerfile, you could stop at the stage named build:
bash
Copy
$ docker build --target build -t hello .
This is useful for scenarios like:
Debugging a specific build stage
Using a debug stage with all debugging symbols or tools enabled, and a lean production stage
Using a testing stage populated with test data, but building for production using a different stage that uses real data
Use an external image as a stage
With multi-stage builds, you can also copy from an external image using COPY --from. You can specify another image (by name, tag, or ID). Docker will pull the image if needed and copy artifacts from it. For example:
dockerfile
Copy
COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf
Use a previous stage as a new stage
You can use a previous stage as a new base for another stage by referring to it in a FROM:
dockerfile
Copy
# syntax=docker/dockerfile:1

FROM alpine:latest AS builder
RUN apk --no-cache add build-base

FROM builder AS build1
COPY source1.cpp source.cpp
RUN g++ -o /binary source.cpp

FROM builder AS build2
COPY source2.cpp source.cpp
RUN g++ -o /binary source.cpp 
Differences between legacy builder and BuildKit
The legacy Docker builder processes all stages leading up to the selected --target and will build a stage even if the final target doesn’t depend on it. BuildKit only builds the stages that the target stage depends on. For example:
dockerfile
Copy
# syntax=docker/dockerfile:1
FROM ubuntu AS base
RUN echo "base"

FROM base AS stage1
RUN echo "stage1"

FROM base AS stage2
RUN echo "stage2"
With BuildKit enabled, building the stage2 target processes only base and stage2, skipping stage1 (since stage2 doesn’t depend on stage1). Without BuildKit (legacy builder), building stage2 would still process all stages (base, stage1, and stage2).
Multi-platform builds
A multi-platform build refers to a single build invocation that targets multiple different OS/architecture combinations. This allows you to create one image that can run on multiple platforms, such as linux/amd64, linux/arm64, and windows/amd64. Why multi-platform builds? Containerizing apps solves the “it works on my machine” problem by packaging apps and dependencies into containers. However, containers share the host kernel, meaning code inside the container must be compatible with the host’s architecture. For example, you can’t run a linux/amd64 container on an ARM64 host (without emulation), or a Windows container on a Linux host. Multi-platform builds solve this by packaging multiple architecture variants of the same app into a single image. Docker can then select the appropriate variant for the host automatically. Difference between single-platform and multi-platform images: A single-platform image has a single manifest pointing to one configuration and set of layers. A multi-platform image contains a manifest list pointing to multiple manifests, each for a different platform (with its own configuration and layers). When you push a multi-platform image to a registry, the manifest list and all manifests are stored. When you pull the image, the registry returns the manifest list, and Docker automatically pulls the variant matching the host’s architecture.
Prerequisites for multi-platform builds
To build multi-platform images, ensure your Docker environment supports it. Two ways:
Switch to the containerd image store (the “classic” Docker Engine image store doesn’t support multi-platform).
Use a custom builder with a driver that supports multi-platform (like the docker-container driver).
Switching to containerd ensures Engine can push, pull, and build multi-platform images. Using a custom builder (with docker-container driver) allows multi-platform builds without switching image stores (though you still can’t load multi-platform images into the legacy store directly; you would push them to a registry or use other outputs). If you use Docker Engine standalone and need multi-platform builds with emulation, install QEMU.
Build multi-platform images
Use the --platform flag with docker buildx build to define target platforms for the build output:
bash
Copy
$ docker buildx build --platform linux/amd64,linux/arm64 .
Strategies for multi-platform builds
There are three strategies for multi-platform builds:
Emulation (QEMU): Easiest to start if builder supports it. No Dockerfile changes needed; BuildKit auto-detects available emulators. Note: QEMU can be much slower for CPU-heavy tasks. Use native or cross-compilation if possible. Docker Desktop has QEMU built-in. For Docker Engine on Linux or remote builders, you need to install QEMU manually (for example, by running a tonistiigi/binfmt container to register QEMU for all architectures).
Multiple native nodes: Use multiple machines (or contexts) each on different architectures as part of one builder. For example, add an ARM node and an AMD64 node to a docker buildx builder, then build for both architectures with --platform .... This avoids emulation and is better for complex cases, but requires managing a builder cluster or using Docker Build Cloud (which provides managed multi-node builders on Docker’s infrastructure).
Cross-compilation: If your language supports cross-compiling, use multi-stage builds with BUILDPLATFORM and TARGETPLATFORM build args. In your Dockerfile, you can compile for target platforms using these variables, so your build container produces output for a different architecture. For example, in a Go build, use FROM --platform=$BUILDPLATFORM golang:... and set GOOS=$TARGETOS and GOARCH=$TARGETARCH before go build.
Examples of multi-platform builds
Simple multi-platform build (emulation): Create a Dockerfile that prints the architecture. Build it for linux/amd64 and linux/arm64, then run the image to see x86_64 or aarch64 output depending on host.
Multi-platform Neovim build (Docker Build Cloud): Use Docker Build Cloud to compile Neovim for linux/amd64 and linux/arm64 and export the binaries. Requires signing up for Build Cloud and using a cloud builder (docker buildx build --builder <cloud-builder> --platform linux/amd64,linux/arm64 --output ./bin .). After build, check the bin directory for platform-specific binaries.
Cross-compiling a Go application: Build a simple HTTP server for multiple platforms using cross-compilation. Use BUILDPLATFORM/TARGETPLATFORM build args in the Dockerfile and set GOOS/GOARCH accordingly. Then run docker build --platform ... for the target platforms. Verify that the output binaries support both architectures.
BuildKit (Detailed)
See also the separate “BuildKit” section of the documentation for more advanced details. BuildKit is an improved backend for building images, which became the default builder as of Docker Engine 23.0. It provides new functionality and improves build performance, with features like skipping unused build stages, parallelizing independent stages, incremental context transfer, avoiding side effects, advanced Dockerfile frontend features, and better cache management. BuildKit’s core is the LLB (Low-Level Build) format, an intermediate representation of the build, allowing complex build definitions and portable caching. BuildKit supports frontends – components that translate human-readable build definitions (like Dockerfiles) into LLB. For example, building a Dockerfile with BuildKit uses an external Dockerfile frontend. Enabling BuildKit: Docker Desktop and Engine 23.0+ have BuildKit enabled by default. For older Engine versions, set environment variable DOCKER_BUILDKIT=1 or enable it in the daemon config ("features": {"buildkit": true} in /etc/docker/daemon.json). Note: Buildx always uses BuildKit. BuildKit on Windows (experimental): BuildKit fully supports only Linux container builds currently. Experimental Windows container support is available (as of BuildKit v0.13). To try it, you need Windows Server 2019/2022 or Windows 11, and Docker Desktop 4.29+ with containerd 1.7.7+. Steps include enabling Hyper-V/Containers features, switching Docker Desktop to Windows containers, installing containerd, and running the BuildKit binaries (buildkitd.exe). Then create a remote builder pointing to the local BuildKit (docker buildx create --driver=remote npipe:////./pipe/buildkitd). After setting up, you can use docker buildx to perform Windows container builds through BuildKit.
Build drivers
Build drivers define how and where the BuildKit backend runs. Buildx supports these drivers:
docker: Uses the BuildKit library bundled in the Docker daemon (default).
docker-container: Launches a dedicated BuildKit container via Docker.
kubernetes: Creates BuildKit pods in a Kubernetes cluster.
remote: Connects to a manually managed remote BuildKit daemon.
Each driver suits different use cases. The default docker driver prioritizes simplicity (no extra setup) but has limited advanced features and no custom configuration. Other drivers are more flexible and better for advanced scenarios (e.g., cache exports, custom outputs, etc.). One key difference is image loading: The docker driver automatically loads built images into the local Docker Engine’s image store. Other drivers (container, kubernetes, remote) do not automatically load the image. If you run a build with those and don’t specify an output, the result stays in the build cache only. To load an image into the local engine when using a non-default driver, use --load:
bash
Copy
$ docker buildx build --load -t myimage --builder=container .
After using --load, the image will appear in docker image ls locally once the build finishes.
Tip: Starting with Docker Buildx 0.14.0, you can configure a custom builder to load images by default, similar to the docker driver’s behavior. To do so, create the builder with --driver-opt default-load=true. (Note: if you specify a custom output via --output, it won’t load to the image store unless you also use type=docker or --load.)
Exporters
Exporters save your build results to a specified output format. You choose an exporter with the --output (-o) option of docker buildx build. Buildx supports these exporter types:
image: Exports the result as a Docker image (to local image store by default).
registry: Exports as an image and pushes to a registry.
local: Exports the build filesystem into a local directory.
tar: Packs the build filesystem into a tar archive file.
oci: Exports the result in OCI image layout format to the local filesystem.
docker: Exports the result in the Docker Image Specification v1.2 format to the filesystem.
cacheonly: Does not export a build output; it just runs the build and creates/updates the build cache.
Most common cases don’t require explicitly setting an exporter. The --load and --push flags act as shorthand: for example, --push uses the image exporter with push=true, effectively pushing the result to a registry. If you want more control (like saving to disk), you can specify --output type=... with additional options. Use cases:
Load to image store: Use the docker exporter to load the image into the Docker Engine’s image store. (--output type=docker,name=myrepo/myimage:tag .) Note that using -t <name> --load automatically does this with the image exporter under the hood.
Push to registry: Use --push or --output type=image,name=myrepo/myimage:tag,push=true to push the image to a registry. Similarly, --output type=registry,name=myrepo/myimage:tag pushes to a registry.
Export image layout to a file: Use oci or docker exporter with dest=path/to/output.tar to save an image layout tarball. For example: --output type=oci,dest=./image.tar.
Export filesystem (no image): Use local to extract the filesystem to a directory (--output type=local,dest=./outdir) or tar to create a tarball of it.
Cache-only run: Use --output type=cacheonly if you want to run the build to populate cache but not produce an image. (By default, Buildx uses cacheonly if no outputs are specified and not using the docker driver; it will warn that no output is specified.)
You can also use multiple exporters in one build (Buildx 0.13.0+ and BuildKit 0.13.0+). Just specify --output multiple times. For example, you might want to push to a registry and save the output filesystem locally and load it into the local engine:
bash
Copy
$ docker buildx build \
    --output type=registry,tag=myrepo/myimage:tag \
    --output type=local,dest=./output-dir \
    --load .
In this single build, the image is pushed to the registry, the filesystem is saved in output-dir, and --load ensures the image is also loaded in the local Docker image store. Configuration options: Many exporters have common optional parameters:
Compression: For exported images (e.g., with image or registry exporters), you can specify the compression algorithm and level. For instance, compression=zstd,compression-level=15 will use Zstandard at level 15. (gzip/estargz support levels 0-9, zstd 0-22; higher = smaller but slower). force-compression=true can force re-compression of layers if the existing cache layers use a different algorithm.
OCI media types: By default, images use Docker media types. You can opt for OCI media types by oci-mediatypes=true in the exporter options (supported by image, registry, oci, docker exporters).
Build cache
When you build the same Docker image multiple times, understanding the Docker build cache can help optimize build speed. Docker’s build cache allows skipping steps if nothing relevant has changed. Docker builds each image layer based on the instructions in the Dockerfile. Each instruction results in a layer in the final image (as a stacked, layered filesystem). If nothing changed in an instruction (and all previous layers up to that point are the same), Docker can reuse the cached layer instead of re-executing that step. For example, suppose you have a simple Dockerfile:
dockerfile
Copy
# syntax=docker/dockerfile:1
FROM ubuntu:latest

RUN apt-get update && apt-get install -y build-essentials
COPY main.c Makefile /src/
WORKDIR /src/
RUN make build
If you build this image and then later change main.c, the COPY instruction’s cache will be invalidated (since the contents changed), and thus the subsequent RUN make build will also re-run. However, the RUN apt-get install layer may still be cached if the base image and that command didn’t change. Key points:
If a layer changes (cache miss), all layers after it must be rebuilt.
The build cache helps avoid re-running instructions when not necessary, significantly speeding up repeated builds.
For more tips on optimizing the build cache and avoiding invalidation, see topics like cache invalidation and best practices (e.g., order your Dockerfile from least to most frequently changing instructions, use .dockerignore to exclude unnecessary files, etc.).
Bake (Build Orchestration)
Bake is a feature of Docker Buildx that lets you define your build configuration in a declarative file (HCL, JSON, or YAML), rather than a long CLI command or complex scripts. It also enables running multiple builds concurrently with one command. A Bake file (often named docker-bake.hcl or similar) can define targets (each a build configuration) and groups (collections of targets to build together). For example, a HCL Bake file:
hcl
Copy
group "default" {
  targets = ["frontend", "backend"]
}

target "frontend" {
  context    = "./frontend"
  dockerfile = "frontend.Dockerfile"
  args = {
    NODE_VERSION = "22"
  }
  tags = ["myapp/frontend:latest"]
}

target "backend" {
  context    = "./backend"
  dockerfile = "backend.Dockerfile"
  args = {
    GO_VERSION = "1.23"
  }
  tags = ["myapp/backend:latest"]
}
Here, the default group includes two targets: “frontend” and “backend”. Each target specifies its build context, Dockerfile, build arguments, and output tag. The docker-bake.hcl provides a single source of truth for these builds. To invoke a build using this Bake file, run:
bash
Copy
$ docker buildx bake
By default, bake will execute the default group (building both frontend and backend concurrently). You can also specify a particular target or group with flags. Why use Bake? It streamlines complex builds, ensures consistency across builds, and simplifies CI configurations (instead of writing multiple docker build commands or scripts, you define everything in a Bake file and just call docker buildx bake). Bake is especially useful for monorepos or projects with multiple images. To get started with Bake, see the Bake introduction in Docker’s documentation, which covers creating a Bake file and more examples.
Docker Engine
Docker Engine is an open source containerization technology for building and containerizing your applications. Docker Engine acts as a client-server application with:
A server: the Docker daemon (dockerd), which is a long-running process.
APIs: interfaces that programs (and the CLI) use to communicate with the daemon.
A command-line interface (CLI) client: docker command, which uses the Docker APIs to control or interact with the daemon through commands or scripts.
Many Docker tools and services use these APIs and CLI under the hood. The Docker daemon is responsible for creating and managing Docker objects such as images, containers, networks, and volumes. For details on Docker’s architecture, refer to the Docker architecture documentation. Key features of Docker Engine include the ability to run containers (using container images), manage resources, and integrate with various storage and network drivers to support container isolation and persistence. Licensing: Docker Engine’s open source code is licensed under the Apache License, Version 2.0. However, note that for commercial use of Docker Engine as provided through Docker Desktop in larger enterprises (exceeding 250 employees OR $10 million USD in annual revenue), a paid Docker subscription is required.
Install Docker Engine (on Linux)
This section describes how to install Docker Engine on Linux (Docker CE). Docker Engine is also available for Windows and macOS via Docker Desktop (for those, see Docker Desktop installation).
Supported platforms
Docker Engine can be installed on 64-bit (x86_64/amd64) and Arm (armhf/arm64) Linux distributions. Official installation packages are provided for:
Ubuntu (LTS releases and latest interim releases on x86_64, armhf, arm64, s390x, ppc64le)
Debian (x86_64, armhf, arm64, ppc64le)
CentOS (and CentOS derivatives like Rocky/Alma; x86_64, arm64, arm)
Fedora (x86_64, arm64, arm)
RHEL (Red Hat Enterprise Linux; x86_64, arm64, arm)
SUSE Linux Enterprise (SLES) on IBM Z (s390x) and possibly x86_64
Raspberry Pi OS (32-bit) on arm
You can also install Docker Engine on other distributions via static binaries or convenience scripts, but those are not officially tested. Some distro maintainers provide their own Docker packages (which might have differences). Docker also provides static binaries for manual installation on any Linux distribution.
Release channels
Docker Engine has two update channels:
Stable – latest stable releases for general availability.
Test (Edge) – pre-release versions (beta or release candidates) for testing before general release.
It’s recommended to use stable for production. Use test channel with caution for early access to new features; expect breaking changes.
Support
Docker Engine (Community Edition) is an open source project supported by the community (the Moby project maintainers). Docker Inc. does not provide official support for Docker Engine Community beyond the open source community channels. (Commercial support is available for Docker Engine Enterprise or as part of Docker’s products like Docker Desktop, as per subscriptions.)
Reporting security issues
If you discover a security vulnerability in Docker Engine, do not file a public issue. Instead, email details privately to security@docker.com. Docker appreciates security reports and will credit reporters.
Installation steps overview
After meeting prerequisites, installing Docker Engine on Linux typically involves:
Uninstalling any old/conflicting Docker packages (like distro-provided packages named docker.io, docker-doc, podman-docker, etc.).
Setting up Docker’s official package repository (for APT on Debian/Ubuntu or Yum/DNF on CentOS/RHEL/Fedora).
Installing Docker Engine, CLI, containerd, and associated plugins from the repository.
Adjusting any post-installation steps (like managing the Docker daemon as a non-root user, configuring the daemon, etc.).
Note: Docker Desktop provides an alternative (bundled) installation on Windows, Mac, and some Linux distributions, which includes Docker Engine. Below are platform-specific instructions for popular distributions:
Ubuntu
Prerequisites: Use a 64-bit Ubuntu (recent LTS or interim release). Older versions of Docker might need removal (docker.io, etc. as mentioned). Also ensure your system uses iptables (nftables are not supported by Docker’s networking; if your system uses iptables-nft, it should still work as long as you add rules to the DOCKER-USER chain if customizing firewall). Uninstall old versions: Remove any packages named docker.io, docker-compose, podman-docker, etc. Also remove old containerd or runc packages if installed to avoid conflicts (the Docker Engine installation will provide its own containerd.io package). For example:
bash
Copy
sudo apt-get remove docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
(This command might report nothing to remove if none were installed.) Install using APT repository:
Set up the repository:
Update package index and install prerequisites:
bash
Copy
sudo apt-get update
sudo apt-get install ca-certificates curl
Add Docker’s official GPG key and set up a stable repository:
bash
Copy
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
Install Docker Engine packages: To install the latest version:
bash
Copy
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
To install a specific version, list available versions with apt-cache madison docker-ce, then install a chosen version by specifying the version string for both docker-ce and docker-ce-cli:
bash
Copy
VERSION_STRING=<VERSION_FROM_LIST>
sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin
Verify installation: Run the hello-world image to ensure Docker Engine is installed and running:
bash
Copy
sudo docker run hello-world
This should download the test image and print a confirmation message. If you get a permission error running without sudo, it indicates your user isn’t in the docker group yet.
Tip: By default, the docker group is created but no users are in it. See the “post-installation steps” to manage Docker as a non-root user.
Upgrades: To upgrade Docker Engine, simply repeat step 2 with the newer version (Docker APT repository will have updated packages).
Alternative install methods on Ubuntu:
Install from a package: If you can’t use the repository, you can download .deb packages for Docker components from download.docker.com and install them with dpkg -i. (You’d need the docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, and docker-compose-plugin packages for your arch and distro version.) This method requires manually updating by downloading new packages for each release.
Install using convenience script: Docker provides a script at https://get.docker.com to install Docker automatically. This script isn’t recommended for production (it runs as root and doesn’t allow customization), but it’s quick for development/test setups. Use it with caution and ideally review it before running. Example usage:
bash
Copy
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
This will install the latest stable Docker on your system. (There’s also https://test.docker.com for pre-release versions.) After using the script on an RPM-based distro (like CentOS/Fedora), you may need to start the Docker service manually (sudo systemctl start docker). The script handles adding user to docker group if you run it as a user with sudo privileges.
Install pre-releases using script: Use the test.docker.com script similarly to get beta/RC versions from the test channel.
Post-installation (optional): For Ubuntu (and Linux in general):
To allow running docker commands as a non-root user, add your user to the docker group: sudo usermod -aG docker $USER, then log out and back in.
Consider configuring Docker to start on boot (the packages usually enable the service by default).
Check documentation for additional configuration (like using an alternative cgroup driver, etc., if needed).
Uninstall Docker Engine (Ubuntu): To uninstall Docker and associated packages:
bash
Copy
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
This removes the packages. It does not automatically remove images, containers, volumes, or custom config files. To delete all images/containers/volumes, you can remove /var/lib/docker/ and /var/lib/containerd/ (be careful – this deletes all your Docker data). Also remove the Docker apt list file and GPG key if desired:
bash
Copy
sudo rm /etc/apt/sources.list.d/docker.list
sudo rm /etc/apt/keyrings/docker.asc
Debian
(Installation on Debian is similar to Ubuntu: set up Docker’s apt repository for Debian, then apt-get install docker-ce docker-ce-cli containerd.io etc. Use the appropriate codename in the repository URL and ensure any old docker.io packages are removed.)
CentOS / RHEL
For CentOS/RHEL and Fedora (YUM/DNF-based):
Remove old docker packages (yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine).
Set up the repo by installing yum-utils and running yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo (or corresponding repo for RHEL).
Install packages: sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin.
Start Docker: sudo systemctl start docker (and optionally enable it to start on boot).
Post-install: add user to docker group if needed (sudo usermod -aG docker $USER).
Uninstall: sudo yum remove docker-ce docker-ce-cli containerd.io and manually remove /var/lib/docker.
Fedora
(Fedora uses the same repository as CentOS/RHEL but make sure to use the correct repository URL for Fedora. Install with dnf similarly.)
Other distros
For other Linux distributions (Arch, etc.), Docker might be available via their native package manager or via static binaries.
Post-installation steps for Linux
After installing Docker Engine on Linux, there are some recommended optional steps:
Manage Docker as a non-root user: By default, docker commands require root (or sudo). To avoid prefixing with sudo, create a UNIX group called docker and add users. On many distros, this group is created automatically. Use sudo usermod -aG docker <username> to add your user. Re-login for it to take effect. Security warning: Only add trusted users to the docker group, as it effectively grants root-level access (Docker can manipulate the host).
Configure Docker to start on boot: (Usually enabled by default via systemd, but you can check sudo systemctl enable docker).
Configure cgroups or other settings if needed: For example, if using cgroup v2 on some distros, ensure Docker’s configuration is set appropriately.
Rootless mode: You can run the Docker daemon in rootless mode (so that Docker daemon itself does not require root). This is an advanced setup and requires following the rootless mode documentation (installing dockerd-rootless-setuptool.sh etc.). Rootless mode has some limitations but improves security by not running the daemon as root.
Storage (Managing Data in Containers)
By default, all files created inside a container are stored on a writable container layer (the container’s copy-on-write layer atop the image’s read-only layers). When the container is deleted, that data goes away with it. Also, writing to the container’s layer is generally slower and increases the container’s size. To persist data or share data between containers and the host, Docker provides storage mounts:
Volumes – Docker-managed directories on the host, completely independent of the host’s OS filesystem structure. Volumes are stored in Docker’s storage area (e.g., /var/lib/docker/volumes/...). They are the preferred mechanism for persistent data in Docker.
Bind mounts – A file or directory on the host is mounted into a container at a specified path. Bind mounts allow sharing existing host directories with a container.
tmpfs mounts – A temporary filesystem (stored in the host’s RAM) that a container can use. Data in a tmpfs mount does not persist and is not written to disk.
Named pipes (Windows) – On Windows, you can mount a named pipe from host to container (useful for Docker Engine’s named pipe, for example).
From inside a container, data mounted via any of these mechanisms just appears as part of the container’s filesystem (as a directory or file). The container generally doesn’t know whether it’s a volume, bind mount, etc., it just sees a filesystem. Volume mounts: Volumes are persisted on the host and are managed by Docker. They offer the best performance for reading/writing data because they bypass the storage driver’s union filesystem. Volumes can be created with docker volume create and used by multiple containers. They survive container deletion (you have to remove the volume explicitly). Bind mounts: Bind mounts map a specific host path into a container. They are convenient for sharing host files (like source code) with a container. However, they are not isolated: any process on the host can modify the files, and changes propagate into the container (and vice versa). Use bind mounts when you need to share data between host and container directly. tmpfs mounts: Use these when you need fast, ephemeral storage (like caches or sensitive info that shouldn’t be stored on disk). A tmpfs mount’s content is lost on container stop or host reboot. Storage driver and container layer: The container’s own layer uses a storage driver (like overlay2, btrfs, etc.) to implement copy-on-write. This is separate from volumes/bind mounts which bypass the storage driver for that portion of the filesystem. If you write a lot of data in a container’s layer, it can slow things down and inflate the image size when committing changes. Next steps: The Docker documentation provides dedicated sections on each storage type:
Volumes: how to create, use, and manage volumes (including examples with docker run -v or --mount and using volumes in Compose).
Bind mounts: how to use host directories in containers, considerations on paths and permissions.
tmpfs: usage of --tmpfs flag for in-memory filesystems.
Storage drivers: details on how Docker’s image and container layer storage works under the hood (drivers like overlay2, etc.) and how to choose or configure them.
containerd image store: information about using containerd’s store (for multi-platform etc.).
Using Volumes
Volumes are the preferred mechanism for persistent data generated by and used by Docker containers. Unlike bind mounts, volumes are managed by Docker and not tied to the host OS’s directory structure. When to use volumes:
You want data to persist even after the container is removed.
You need to share data between multiple containers.
You want better performance (volumes are stored in a way that bypasses the union file system, making them faster and more efficient).
You want portability and ease of backup/restore (volume data can be backed up from the Docker host easily, and Docker provides CLI commands to manage volumes).
You do not need to directly access the data from the host (if you do, a bind mount might be more straightforward).
Volumes are a better choice than writing data into the container’s layer because writing into a container’s layer goes through the storage driver and increases the container size. Volumes also don’t change when you update a container’s image; they remain independent. Volume lifecycle: A volume’s content exists outside any single container’s lifecycle. If a container is deleted, the volume still exists (unless you remove it). If you mount a volume into a new container, it has the data from previous use. Named volumes can be explicitly created and removed. Anonymous volumes (created by Docker when you use -v /path without a name) are given a unique name by Docker. Mounting a volume over existing data: If you mount a volume at a path where the container image already has files, those files are not visible while the volume is mounted (the volume content hides them). If the volume is empty on first mount, Docker will copy the existing files from the image into the volume (this is a convenient way to populate volumes with default data). Named vs Anonymous volumes: Named volumes have a specific name you assign; you can easily reference them later. Anonymous volumes are created by Docker when you don’t specify a name; these can pile up if not managed (Docker may remove them when containers go away, except when you use --volumes-from or explicitly keep them). Using volumes in CLI: You can use volumes by:
--mount flag (newer, more verbose but clearer syntax)
-v or --volume flag (older syntax)
Example --mount:
bash
Copy
docker run --mount type=volume,src=mydata,dst=/app/data nginx
Example -v:
bash
Copy
docker run -v mydata:/app/data nginx
Both create/use a volume named “mydata” and mount it at /app/data in the container. Managing volumes: Outside of containers, Docker CLI allows:
docker volume create [NAME]
docker volume ls
docker volume inspect [NAME]
docker volume rm [NAME]
These commands let you create volumes ahead of time, list all volumes, see details (like mountpoint on host, usage, etc.), and remove volumes (you can only remove a volume not used by any containers, unless you use -f to force remove). Using volumes with Compose: In a Docker Compose YAML, volumes can be declared and then used by services. Compose can create volumes automatically. For example:
yaml
Copy
services:
  db:
    image: mysql
    volumes:
      - db-data:/var/lib/mysql

volumes:
  db-data:
Each service container gets its own volume instance for named volumes in a Compose file. Advanced volume usage:
Read-only volumes: You can mount a volume read-only by adding :ro (in -v syntax) or readonly=true in --mount.
Volume drivers: By default, volumes are local. Docker can use volume driver plugins (e.g., for NFS, SSHFS, cloud storage). If using such drivers, you specify -v name:/path -o opt1=val1 ... --driver drivername or similar through docker volume create --driver.
Sharing volumes between machines: Typically, to share data between Docker hosts, you’d use a network file system or a volume driver that supports shared storage (or manually sync data).
Backup/Restore: You can run containers to back up volume data (e.g., using tar) or restore by running a container that has access to the volume and the backup file.
Using Bind Mounts
Bind mounts allow access to files or directories on the host filesystem from within a container. They are appropriate when you want a container to read or write specific data on the host or when you want to persist data in a more visible way on the host. To use a bind mount, you specify a host path and a target path in the container. For example:
bash
Copy
docker run -v /path/on/host:/path/in/container:rw myimage
Here, /path/on/host is a directory or file on the host, and it is mounted at /path/in/container inside the container. Considerations:
The host file or directory must exist prior to running the container (Docker will not create host directories automatically for bind mounts).
Permissions: The container’s view of file ownership and permissions is the same as on the host. You might need to adjust permissions on the host to allow the container’s process (which might run as a certain UID) to access the files.
Bind mounts can be dangerous if misused (a container with root privileges could modify sensitive host files if mounted).
On Docker Desktop (Mac/Windows), bind mounts are implemented via the virtualization layer (since the containers run in a VM). Not all host paths are accessible by default (e.g., on Mac/Win you configure which host directories are shared with Docker).
Bind mounts are commonly used for development (e.g., mounting source code into a container for live reload) or for cases where container output must be immediately accessible on the host.
Using tmpfs mounts
A tmpfs mount is a temporary file store in the host’s memory. It’s like mounting a RAM disk into the container. To use it, on Linux:
bash
Copy
docker run --tmpfs /path/in/container:size=1g myimage
This creates a tmpfs at /path/in/container (you can optionally specify a size, etc.). Any data written there by the container is stored in RAM and disappears when the container stops. Use cases for tmpfs:
Sensitive information that you don’t want written to disk.
Caching data for performance during the container’s life (like large computations, sorting, etc., where writing to disk would slow down).
Ensuring no trace of certain data remains after container is removed.
Note: tmpfs mounts only work on Linux containers (Docker Desktop on Mac/Windows will simulate them in the VM).
Storage Drivers (Docker’s image layer storage)
(This is more of a reference topic in Docker manuals rather than user guide; it may be summarized here.) Docker Engine uses storage drivers to manage image layers and container writable layers. Examples of storage drivers:
overlay2 (default on modern Linux)
aufs (older default on some distros, now deprecated)
devicemapper (direct-lvm mode recommended for production if used, now deprecated in favor of overlay)
btrfs
zfs
windowsfilter (on Windows)
Each driver has its specifics. For most users, the default (overlay2 on Linux) works best. The manuals contain guidance on how to choose a driver if needed, how to configure certain drivers (like device mapper or btrfs), and troubleshooting. For example:
Select a storage driver: (Documentation helps decide which driver to use based on OS kernel support and use case).
BTRFS/Device Mapper/OverlayFS/VFS/ZFS drivers: Each has its own page describing configuration and caveats.
Managing the image store (containerd): Newer Docker versions use containerd under the hood; the containerd image store can be used for advanced scenarios or with Buildx (like for multi-platform builds).
Networking
Networking overview: Docker networking allows containers to communicate with each other and with the outside world. By default, Docker provides some pre-defined networks and drivers:
bridge – default network driver for containers on a single host. Docker automatically attaches new containers to the default bridge network (unless otherwise specified). Containers on the same custom bridge network can communicate via IP and container name. Bridge networks provide isolation – containers on different bridges cannot talk to each other without extra configuration.
host – for containers to share the host’s network stack directly (no isolation between container and host network).
none – for containers with no networking (no interfaces aside from a loopback).
overlay – for multi-host networking (used when you use Docker Swarm or Docker Build Cloud, connecting containers across multiple daemons).
macvlan/ipvlan – for more advanced networking where containers appear as physical devices on the network (each container gets its own IP on the local LAN, etc.).
From a container’s perspective, by default, a container can make outgoing connections to any network (e.g., to the internet or to other reachable containers). Containers don’t inherently know if their peers are Docker containers or not; they just see network interfaces and addresses. User-defined networks: You can create your own networks (docker network create ...) – typically you’d create a bridge network for an application and attach multiple containers to it (for example, a web container and a database container on the same user-defined network can communicate by name). User-defined networks also enable DNS resolution between containers (containers can resolve each other’s names). Example:
bash
Copy
docker network create -d bridge my-net
docker run -d --network=my-net --name=db mysql
docker run -d --network=my-net --name=web my-web-app-image
Now web can reach db by using the hostname db. On user-defined networks, Docker doesn’t publish any ports by default, so containers are isolated from the host network except where you explicitly expose ports. Published ports: To allow incoming connections from the host to a container, you publish ports. For example, docker run -p 8080:80 nginx maps port 8080 on the host to port 80 in the container. This is achieved via NAT (iptables rules on Linux) or the networking stack on other OS. Docker’s default bridge network supports these published ports to allow external access. Container IPs and hostnames: By default, containers get an IP address on their attached network(s). On a bridge network, Docker uses an internal IP range (usually 172.x.0.0/16). The container’s hostname defaults to its container ID (or name), but on user networks, Docker provides built-in DNS so that container names can be used to communicate. You can also specify custom hostnames or additional entries in a container’s /etc/hosts via options. DNS services: Docker’s networks include an embedded DNS server that containers use by default (it resolves container names within the same network). If a container tries to resolve a name not known internally, it queries external DNS (as configured on the host or by Docker’s --dns option). You can configure custom DNS servers for containers or custom static entries. Multiple networks: A container can be on multiple networks (e.g., you could connect a container to a frontend network and a backend network). If so, the container will have multiple IP addresses (one per network). Docker selects one of the networks as the default route (you can influence it with --network-alias or priorities as needed). This allows scenarios like a service that connects to an overlay network for inter-service traffic and also to a bridge network for exposing to a local gateway. Networking in Docker Compose: Compose simplifies networking by creating a default network for all services in a compose file (so they can all talk to each other by service name). You can also define multiple networks in compose if needed. Proxy and internet access: If your containers need internet access and you are behind a proxy, Docker has ways to configure global proxy settings so that containers use the proxy (through environment variables or Docker daemon settings). Additionally, Docker Desktop provides a VPN-friendly mode and other networking features for host integration.
Containers (runtime topics)
Docker’s manuals include guides for various container runtime scenarios:
Start containers automatically: Docker can be set to start containers on daemon startup (using restart policies like --restart unless-stopped or always). This section explains how to use restart policies to make containers resilient to Docker daemon restarts or host reboots.
Run multiple processes in a container: Generally, one container runs one main process. If you need multiple processes, this guide suggests approaches like using a process manager (e.g., supervisord) or techniques to handle multiple services in one container (though it’s usually recommended to split into multiple containers).
Resource constraints: Docker allows limiting CPU, memory, and other resources per container. For example --memory 512m to limit memory, --cpus 1.5 to limit CPU usage, and other options for I/O, PIDs, etc. The manual covers how to apply these constraints and what they mean.
Runtime metrics: Docker can provide metrics about container resource usage (CPU, memory, block I/O, etc.), accessible via docker stats or programmatically. There are also ways to integrate with monitoring systems.
Container logs: Docker captures stdout/stderr of containers and retains logs (by default, using the json-file driver). You can view logs with docker logs. There’s a guide on how to read and manage container logs, and how to configure different logging drivers (e.g., syslog, fluentd, etc.) for containers, log rotation, etc.
Detach vs foreground: Understanding how to run containers in the background (-d) vs attached, and how to reattach or view logs.
Legacy container links (deprecated): An older way to allow containers to discover each other and communicate. Modern practice uses networks instead. (The manual likely warns against using the old --link feature, but documents it for completeness.)
Docker Command-Line (CLI) Tips
Manuals also provide guidance on effectively using the docker CLI:
Completion: Docker provides shell completion scripts for Bash, Zsh, etc., to auto-complete commands and options. This can be installed via package or manually.
Proxy configuration for CLI: How to configure the Docker CLI to use a proxy when communicating with a remote daemon.
Filtering (docker ps, docker images filters): The CLI supports filtering output. For example, docker ps --filter status=exited or docker images --filter "dangling=true". This section teaches how to use these filters.
Formatting output: You can format the output of commands like docker ps or docker inspect with --format and Go-style templates. For instance, docker images --format "{{.Repository}}: {{.Size}}". The manual provides template fields for different commands.
Using docker context: (This might be in Manage Resources category) – contexts allow switching between multiple Docker environments (like local, remote, cloud).
Using docker scan / Docker Scout CLI: Possibly under security.
OpenTelemetry for Docker CLI: A newer addition (the manual entry suggests there’s info on integrating Docker CLI with OpenTelemetry for tracing command actions, likely for enterprise logging).
Docker Daemon and Configuration
Docker Engine manuals cover how to configure and troubleshoot the daemon (dockerd):
Start the daemon: This covers various ways Docker can be started (as a service on systemd, using service scripts, etc.), and some common options (like --debug).
IPv6 networking: How to enable and configure IPv6 for Docker containers (by editing daemon.json to set ipv6: true and a fixed subnet, etc.).
Daemon proxy configuration: If Docker Engine needs to pull images through a proxy or if containers need a proxy, how to configure environment variables or daemon settings accordingly.
Live restore: Docker has a “live restore” feature to keep containers running across a Docker daemon restart (so that stopping the daemon doesn’t stop containers). The manual explains how to enable this and its limitations.
Alternative container runtimes: Docker by default uses runc as the low-level container runtime. This section might explain how to configure Docker to use alternatives (like Kata Containers for sandboxing, or other OCI-compatible runtimes).
Metrics (Prometheus): Docker can expose daemon and container metrics in Prometheus format. There’s likely instructions to enable metrics (--metrics-addr) so Prometheus can scrape Docker.
Remote access to daemon: How to configure the daemon to listen on a TCP socket or socket file for remote API access, including setting up TLS for security. (By default Docker listens on a UNIX socket accessible by root or docker group.)
Daemon logs: Where to find and how to read Docker daemon logs (e.g., via journalctl -u docker.service on systemd systems, or checking /var/log/ depending on OS).
Troubleshooting the daemon: Common issues and steps (like checking storage driver status, ensuring your user is in the right group, verifying that the daemon process is running, etc.)
Manage resources (contexts, etc.)
Docker contexts: Contexts allow you to switch CLI targets between different Docker endpoints (e.g., local, remote SSH, cloud). docker context ls shows contexts, docker context use <name> switches. The manual explains how to create a context (e.g., docker context create ... for an SSH host) and use it. This is helpful for managing multiple Docker environments.
Object labels: Docker objects (images, containers, volumes, networks) can have user-defined labels (key-value metadata). The manual might give best practices for labeling and how to use labels in filters or for organization.
Prune unused objects: Over time, Docker can accumulate unused images, stopped containers, volumes, networks. Docker provides docker system prune (or specific prune commands like docker image prune) to clean up. The manual cautions what will be removed and how to use these prunes safely.
Docker Products
Docker Desktop
Docker Desktop is a one-click install application for Mac, Windows, and Linux that lets you build, share, and run containerized applications and microservices on your local machine using a convenient GUI and integration with your OS. It includes everything you need to get started with Docker on those platforms: the Docker Engine (daemon), Docker CLI, Docker Compose, Kubernetes (optional), and more, all packaged together. Docker Desktop simplifies setting up your development environment, handling things like virtualization (on Windows and Mac), port mapping, file sharing between host and containers, and keeps itself updated. Key features of Docker Desktop:
GUI Dashboard: Docker Desktop provides a graphical interface to view containers, images, volumes, and networks, and to perform common actions (start/stop, config changes, etc.) easily.
Included components: Docker Engine, Docker CLI, Docker Compose, Docker Build (BuildKit), Docker Scout (for image analysis; depending on subscription), Docker Extensions (to extend Desktop’s functionality), Docker Content Trust tools, Kubernetes (a single-node K8s cluster for testing), and credential helpers for secure login storage.
Easy setup: Docker Desktop manages the complex environment setup for you. On Windows, it can switch between Linux and Windows container mode; on Windows it uses Hyper-V or WSL2 for Linux containers; on Mac it uses a lightweight VM (HyperKit or Virtualization.framework).
Volume mounts and networking: It provides seamless volume mounting (with file change notifications) and makes containers accessible via localhost on the host machine. It automatically deals with host networking differences.
Auto-updates: It regularly gets updates with new Docker versions, bug fixes, and security patches, which can be installed directly.
Docker Desktop allows you to work with your choice of development tools (IDEs, etc.) and leverages Docker Hub for images and templates. It’s great for quickly building and testing containerized applications locally. Installing Docker Desktop: Available for Mac, Windows, and Linux – each with specific steps (generally downloading the installer and running it). After installation, you can use the Docker Dashboard or the CLI docker commands.
Docker Build Cloud
Docker Build Cloud is a service that lets you build container images faster by running builds on Docker-managed cloud infrastructure. It integrates with Docker Buildx to execute builds remotely with no configuration needed for the user. How it works: Instead of building on your local machine, Docker Build Cloud routes your docker buildx build commands to a remote BuildKit builder in the cloud. All build data is encrypted in transit. The remote builder executes the Dockerfile steps and returns the result (or pushes it to a registry as specified). It also leverages a remote cache that is shared, so builds can be faster for all team members once something is built once. Benefits:
Improved speed: Cloud builders might be more powerful and can do multi-platform builds in parallel, speeding up build times especially for large projects or multiple architectures.
Shared cache: Team members or CI pipelines using Build Cloud can share a cache, so if one person builds an image, another person’s similar build can reuse layers from cache.
No infrastructure to manage: Docker handles provisioning builders on AWS EC2 instances for you. You don’t need to maintain a build server; just opt-in to using Build Cloud.
To use Docker Build Cloud, you need a Docker account with a Pro, Team, or Business subscription (it’s a paid feature). Once enabled, you simply create a Buildx builder that uses the cloud driver and then build as usual. For example:
bash
Copy
docker buildx create --driver cloud <your-org>/<builder-name> --use
docker buildx build --platform linux/amd64,linux/arm64 -t myimage:buildcloud --push .
This sends the build to the cloud. No changes to your Dockerfile or build commands aside from specifying the cloud builder. Currently, Docker Build Cloud is hosted in a single region (US East), so users far from that region might see slightly higher latency, but multi-region support is planned.
Docker Hub
Docker Hub is a cloud-based repository service for sharing container images. It’s like GitHub for Docker images. Key points:
It hosts public images (like the official images for popular software – e.g., nginx, mysql, etc.) and private images for subscribers or organizations.
You can push your images to Docker Hub (docker push username/repo:tag) and pull them from anywhere (docker pull username/repo:tag).
Docker Hub provides image discovery (search), user profiles, organization accounts, and automated build pipelines (you can connect a Git repo to Docker Hub to automatically build an image when code is updated).
Docker Hub also handles image distribution – when you docker pull, it will fetch the layers from Hub’s CDN. It supports multi-platform manifests so the appropriate image for your architecture is pulled.
Additional features include Docker Hub’s Webhooks (trigger actions after pushes), the Docker Official Images program (curated images maintained by Docker), and content trust (if you enable Docker Content Trust, you can sign images and Docker Hub can verify signatures).
Basic Docker Hub usage: You need to create a Docker Hub account (free tier allows a limited number of private repos and unlimited public repos). Then:
docker login to authenticate CLI with Hub.
docker pull library/redis:latest to get a public image (the library/ prefix is implied for official images).
docker tag myimage:latest myusername/myrepo:v1
docker push myusername/myrepo:v1 to upload an image to your repository.
Docker Hub is the default registry used by Docker Engine (unless you configure a different registry).
Docker Scout
Docker Scout is a service and set of tools for container image analysis and policy evaluation. It helps you scan images for known vulnerabilities (CVEs), surface insights about base image recommendations, and evaluate whether images comply with best practices or organizational policies. Features:
Image vulnerability scanning: It scans the packages and layers in your images and reports known security issues. (This was formerly part of Docker Security Scanning, now rebranded as Scout.)
Insights and recommendations: Scout can suggest upgrading base images to reduce vulnerabilities or using alternative images.
Policy evaluation: In a team setting, you can define policies (like “no critical vulnerabilities” or “only use approved base images”). Docker Scout can evaluate images against these policies.
Integration: Docker Scout can integrate into CI pipelines or Docker Hub (automated scans when you push an image).
There is a Docker Scout CLI (docker scout command) which you can use to analyze images locally or retrieve information from the Docker Scout backend. Using Docker Scout typically requires a Docker account. Some scanning features might be available free for public images, while advanced features require a subscription.
Docker for GitHub Copilot
Docker for GitHub Copilot is an integration that helps developers using GitHub Copilot (an AI pair programming tool) to leverage Docker. It likely refers to how Copilot can suggest Dockerfile or Compose file snippets effectively, and Docker providing certain extensions or documentation to improve these suggestions. There might be a special set of capabilities or guidelines for using Docker in combination with Copilot, but in terms of documentation, it probably outlines how to install or enable any Docker/Copilot extension and describes example scenarios (like writing Dockerfiles with AI assistance). (This section of manuals likely introduces the integration and how to set it up if needed, possibly by installing a VS Code extension or enabling access in Copilot Labs.)
Docker Extensions
Docker Extensions allow you to extend Docker Desktop’s functionality with additional tools, UI panels, or integrations. Docker Desktop provides a framework where extensions (created by Docker or third parties) can plug into the Desktop GUI. Examples of Docker Extensions:
Build and deploy tools (for instance, an extension might integrate with GUIs for managing Kubernetes, or monitoring tools).
Utilities to clean up images/containers, visualize container metrics, etc., within Docker Desktop.
The Docker Extensions documentation explains how to discover and install extensions from the Docker Desktop UI (there’s an “Extensions Marketplace”). You can also develop your own extensions. To use, you typically need Docker Desktop 4.x or later, and then in the Docker Desktop UI, go to the Extensions section and browse or install desired extensions. For developers: an extension is essentially a Docker container with some metadata that Docker Desktop can communicate with to render a UI or perform actions.
Testcontainers Cloud
Testcontainers Cloud is a cloud service related to the Testcontainers library (used for integration testing with containers). It allows running your Testcontainers-based tests in the cloud (so you don’t need Docker locally in CI, etc.). Testcontainers Cloud is listed under products, but it likely links to external docs (testcontainers.com). In short: Testcontainers Cloud provides a SaaS solution to execute Testcontainers (which usually spins up containers locally during tests) in an isolated cloud environment, which can speed up CI and support more parallel test runs with real containers. (Detailed usage would be covered on testcontainers.com site. Since it's external, the manuals page probably just provides a brief description and points to Testcontainers Cloud site.)
Docker Projects
Docker Projects is a newer feature providing a unified, project-based workflow to run containerized projects. It likely ties together Compose, Docker CLI, and possibly extensions to simplify running multi-container apps. It might allow you to define a “project” in Docker Desktop where you can manage the lifecycle of a multi-container application more easily, possibly with a graphical interface or improved compose integration. (This feature’s documentation would outline how to create a Project, how to start/stop the project, and how it differs from just running docker-compose. It might store some metadata about your project in Docker Desktop, enabling things like one-click run of your whole app stack, or sharing projects.) Since details are not fully included in our content, just note: Docker Projects helps group related containers, volumes, networks, etc., as one unit (a project) for easier management. It’s likely still evolving or in preview.
Docker Platform (Accounts & Administration)
These sections of the manuals are more about managing Docker accounts, subscriptions, and enterprise features:
Administration
“Administration” in Docker’s context refers to centralized observability and management for organizations. This could involve using Docker Hub’s org features, or the Docker Business features where an admin can see team activity, manage resources, etc. For example, Docker Business offers an Admin Dashboard where you can see usage of Docker Desktop in your organization, manage who has access, enforce certain security settings, and view analytics. It might also refer to using tools like Docker’s Audit logs, or integration with SSO (Single Sign-On) for user authentication in large organizations. Key topics likely include:
Viewing usage metrics (who in your org is using Docker, what versions, etc.).
Setting up centralized logging or monitoring of Docker use.
Enforcing organization policies (like disabling features via Desktop admin settings).
(This is a high-level section and may not have CLI commands, more of a conceptual guide with steps to use the Docker Hub or Docker Cloud UI for admins.)
Billing
The Billing manuals cover how to manage your Docker subscriptions and payments:
How to upgrade/downgrade plans (Personal/Pro/Team/Business).
How to add a payment method.
Viewing invoices.
Managing billing contacts.
Perhaps managing usage (like seat counts for Team/Business, which ties into billing).
FAQs about billing cycles, etc.
Basically, if you have a Docker Pro or Team or Business subscription, this doc tells you how to handle billing through Docker’s portals.
Accounts
Accounts documentation deals with your Docker ID and Hub account:
How to create an account.
Managing your profile (username, email).
Password resets.
Using access tokens (instead of password for CLI login – covered likely under “For developers -> Access tokens”).
Two-factor authentication (2FA) setup for security.
Account recovery (using recovery codes if 2FA is lost).
Disabling 2FA or other account security settings.
It also likely touches on organization accounts and teams:
Creating an organization.
Inviting users to your org.
Managing team membership and roles (admin, developer, etc.).
Removing users or transferring ownership.
Security (Accounts & Content)
Security in Docker’s platform context can include:
Securing your Docker Hub account (with 2FA, mentioned above).
Content trust (Docker Content Trust allows signing images; Docker Desktop includes “Docker Content Trust” tooling).
Scanning images for vulnerabilities (overlap with Docker Scout).
Security best practices for using Docker (maybe links to not exposing the daemon, using rootless mode, etc., but likely focused on Hub/Registry/Account security).
Possibly covers secrets management in Docker (though that might be more of a Swarm topic or Compose).
Since in Manuals, “Security” might refer to features on Docker Hub/Hub org (like controlling content, trusted publishers, or the scanning I mentioned). It might also have sections on Single Sign-On (SSO) for organizations (the menu snippet showed FAQs for SSO and domain enforcement, identity providers, etc.), which is relevant to Business subscribers linking Docker accounts with their corporate SSO. In summary, this section guides enterprise users on setting up SSO, domain verification, and addresses security announcements or processes.
Subscription
This covers Docker’s licensing and subscription management:
Docker Personal vs Pro vs Team vs Business – what features each has (Subscriptions and features).
How to set up your subscription (like converting an org to a Team subscription).
Scaling your subscription – e.g., adding more seats to a Team plan.
Managing seats – inviting/removing users in your Team/Business (since each user occupies a seat).
Changing your subscription – upgrading or downgrading plans.
Docker Desktop license agreement – information on the license that large companies need to be aware of (since usage in large enterprises requires a paid plan).
FAQs related to subscriptions, licensing, renewal, cancellation, etc.
This section ensures organizations comply with Docker’s licensing and know how to administer their subscriptions via the Docker Hub web portal.
Note: The above content has been compiled into a single comprehensive reference, preserving the logical flow, headings, and important details (including code examples) from the Docker Manuals documentation. Navigation elements, sidebars, and external links have been omitted for clarity. Each section is separated by headers for easy scanning.

Sources









Search

Deep research


ChatGPT can make mistakes. Check importan