OPEN WEBUI 👋

OPEN WEBUI IS AN EXTENSIBLE, FEATURE-RICH, AND USER-FRIENDLY
SELF-HOSTED AI PLATFORM DESIGNED TO OPERATE ENTIRELY OFFLINE. It
supports various LLM runners like OLLAMA and OPENAI-COMPATIBLE APIS,
with BUILT-IN INFERENCE ENGINE for RAG, making it a POWERFUL AI
DEPLOYMENT SOLUTION.

Tip

LOOKING FOR AN ENTERPRISE PLAN? – SPEAK WITH OUR SALES TEAM TODAY!

Get ENHANCED CAPABILITIES, including CUSTOM THEMING AND BRANDING,
SERVICE LEVEL AGREEMENT (SLA) SUPPORT, LONG-TERM SUPPORT (LTS)
VERSIONS, and MORE!

For more information, be sure to check out our Open WebUI
Documentation.

KEY FEATURES OF OPEN WEBUI ⭐

 	*
🚀 EFFORTLESS SETUP: Install seamlessly using Docker or Kubernetes
(kubectl, kustomize or helm) for a hassle-free experience with support
for both :ollama and :cuda tagged images.

 	*
🤝 OLLAMA/OPENAI API INTEGRATION: Effortlessly integrate
OpenAI-compatible APIs for versatile conversations alongside Ollama
models. Customize the OpenAI API URL to link with LMSTUDIO, GROQCLOUD,
MISTRAL, OPENROUTER, AND MORE.

 	*
🛡️ GRANULAR PERMISSIONS AND USER GROUPS: By allowing
administrators to create detailed user roles and permissions, we
ensure a secure user environment. This granularity not only enhances
security but also allows for customized user experiences, fostering a
sense of ownership and responsibility amongst users.

 	*
📱 RESPONSIVE DESIGN: Enjoy a seamless experience across Desktop PC,
Laptop, and Mobile devices.

 	*
📱 PROGRESSIVE WEB APP (PWA) FOR MOBILE: Enjoy a native app-like
experience on your mobile device with our PWA, providing offline
access on localhost and a seamless user interface.

 	*
✒️🔢 FULL MARKDOWN AND LATEX SUPPORT: Elevate your LLM
experience with comprehensive Markdown and LaTeX capabilities for
enriched interaction.

 	*
🎤📹 HANDS-FREE VOICE/VIDEO CALL: Experience seamless
communication with integrated hands-free voice and video call
features, allowing for a more dynamic and interactive chat
environment.

 	*
🛠️ MODEL BUILDER: Easily create Ollama models via the Web UI.
Create and add custom characters/agents, customize chat elements, and
import models effortlessly through Open WebUI Community integration.

 	*
🐍 NATIVE PYTHON FUNCTION CALLING TOOL: Enhance your LLMs with
built-in code editor support in the tools workspace. Bring Your Own
Function (BYOF) by simply adding your pure Python functions, enabling
seamless integration with LLMs.

 	*
📚 LOCAL RAG INTEGRATION: Dive into the future of chat interactions
with groundbreaking Retrieval Augmented Generation (RAG) support. This
feature seamlessly integrates document interactions into your chat
experience. You can load documents directly into the chat or add files
to your document library, effortlessly accessing them using the #
command before a query.

 	*
🔍 WEB SEARCH FOR RAG: Perform web searches using providers like
SearXNG, Google PSE, Brave Search, serpstack, serper, Serply,
DuckDuckGo, TavilySearch, SearchApi and Bing and inject the results
directly into your chat experience.

 	*
🌐 WEB BROWSING CAPABILITY: Seamlessly integrate websites into your
chat experience using the # command followed by a URL. This feature
allows you to incorporate web content directly into your
conversations, enhancing the richness and depth of your interactions.

 	*
🎨 IMAGE GENERATION INTEGRATION: Seamlessly incorporate image
generation capabilities using options such as AUTOMATIC1111 API or
ComfyUI (local), and OpenAI's DALL-E (external), enriching your chat
experience with dynamic visual content.

 	*
⚙️ MANY MODELS CONVERSATIONS: Effortlessly engage with various
models simultaneously, harnessing their unique strengths for optimal
responses. Enhance your experience by leveraging a diverse set of
models in parallel.

 	*
🔐 ROLE-BASED ACCESS CONTROL (RBAC): Ensure secure access with
restricted permissions; only authorized individuals can access your
Ollama, and exclusive model creation/pulling rights are reserved for
administrators.

 	*
🌐🌍 MULTILINGUAL SUPPORT: Experience Open WebUI in your preferred
language with our internationalization (i18n) support. Join us in
expanding our supported languages! We're actively seeking
contributors!

 	*
🧩 PIPELINES, OPEN WEBUI PLUGIN SUPPORT: Seamlessly integrate custom
logic and Python libraries into Open WebUI using Pipelines Plugin
Framework. Launch your Pipelines instance, set the OpenAI URL to the
Pipelines URL, and explore endless possibilities. Examples include
FUNCTION CALLING, User RATE LIMITING to control access, USAGE
MONITORING with tools like Langfuse, LIVE TRANSLATION WITH
LIBRETRANSLATE for multilingual support, TOXIC MESSAGE FILTERING and
much more.

 	*
🌟 CONTINUOUS UPDATES: We are committed to improving Open WebUI with
regular updates, fixes, and new features.

Want to learn more about Open WebUI's features? Check out our Open
WebUI documentation for a comprehensive overview!

🔗 ALSO CHECK OUT OPEN WEBUI COMMUNITY!

Don't forget to explore our sibling project, Open WebUI Community,
where you can discover, download, and explore customized Modelfiles.
Open WebUI Community offers a wide range of exciting possibilities for
enhancing your chat interactions with Open WebUI! 🚀

HOW TO INSTALL 🚀

INSTALLATION VIA PYTHON PIP 🐍

Open WebUI can be installed using pip, the Python package installer.
Before proceeding, ensure you're using PYTHON 3.11 to avoid
compatibility issues.

 	*
INSTALL OPEN WEBUI: Open your terminal and run the following command
to install Open WebUI:

pip install open-webui

 	*
RUNNING OPEN WEBUI: After installation, you can start Open WebUI by
executing:

open-webui serve

This will start the Open WebUI server, which you can access at
http://localhost:8080

QUICK START WITH DOCKER 🐳

Note

Please note that for certain Docker environments, additional
configurations might be needed. If you encounter any connection
issues, our detailed guide on Open WebUI Documentation is ready to
assist you.

Warning

When using Docker to install Open WebUI, make sure to include the -v
open-webui:/app/backend/data in your Docker command. This step is
crucial as it ensures your database is properly mounted and prevents
any loss of data.

Tip

If you wish to utilize Open WebUI with Ollama included or CUDA
acceleration, we recommend utilizing our official images tagged with
either :cuda or :ollama. To enable CUDA, you must install the Nvidia
CUDA container toolkit on your Linux/WSL system.

INSTALLATION WITH DEFAULT CONFIGURATION

 	*
IF OLLAMA IS ON YOUR COMPUTER, use this command:

docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

 	*
IF OLLAMA IS ON A DIFFERENT SERVER, use this command:

To connect to Ollama on another server, change the OLLAMA_BASE_URL to
the server's URL:

docker run -d -p 3000:8080 -e OLLAMA_BASE_URL=https://example.com -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

 	*
TO RUN OPEN WEBUI WITH NVIDIA GPU SUPPORT, use this command:

docker run -d -p 3000:8080 --gpus all --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda

INSTALLATION FOR OPENAI API USAGE ONLY

 	*
IF YOU'RE ONLY USING OPENAI API, use this command:

docker run -d -p 3000:8080 -e OPENAI_API_KEY=your_secret_key -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

INSTALLING OPEN WEBUI WITH BUNDLED OLLAMA SUPPORT

This installation method uses a single container image that bundles
Open WebUI with Ollama, allowing for a streamlined setup via a single
command. Choose the appropriate command based on your hardware setup:

 	*
WITH GPU SUPPORT: Utilize GPU resources by running the following
command:

docker run -d -p 3000:8080 --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama

 	*
FOR CPU ONLY: If you're not using a GPU, use this command instead:

docker run -d -p 3000:8080 -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama

Both commands facilitate a built-in, hassle-free installation of both
Open WebUI and Ollama, ensuring that you can get everything up and
running swiftly.

After installation, you can access Open WebUI at
http://localhost:3000. Enjoy! 😄

OTHER INSTALLATION METHODS

We offer various installation alternatives, including non-Docker
native installation methods, Docker Compose, Kustomize, and Helm.
Visit our Open WebUI Documentation or join our Discord community for
comprehensive guidance.

TROUBLESHOOTING

Encountering connection issues? Our Open WebUI Documentation has got
you covered. For further assistance and to join our vibrant community,
visit the Open WebUI Discord.

OPEN WEBUI: SERVER CONNECTION ERROR

If you're experiencing connection issues, it’s often due to the
WebUI docker container not being able to reach the Ollama server at
127.0.0.1:11434 (host.docker.internal:11434) inside the container .
Use the --network=host flag in your docker command to resolve this.
Note that the port changes from 3000 to 8080, resulting in the link:
http://localhost:8080.

EXAMPLE DOCKER COMMAND:

docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main

KEEPING YOUR DOCKER INSTALLATION UP-TO-DATE

In case you want to update your local Docker installation to the
latest version, you can do it with Watchtower:

docker run --rm --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once open-webui

In the last part of the command, replace open-webui with your
container name if it is different.

Check our Updating Guide available in our Open WebUI Documentation.

USING THE DEV BRANCH 🌙

Warning

The :dev branch contains the latest unstable features and changes. Use
it at your own risk as it may have bugs or incomplete features.

If you want to try out the latest bleeding-edge features and are okay
with occasional instability, you can use the :dev tag like this:

docker run -d -p 3000:8080 -v open-webui:/app/backend/data --name open-webui --add-host=host.docker.internal:host-gateway --restart always ghcr.io/open-webui/open-webui:dev

OFFLINE MODE

If you are running Open WebUI in an offline environment, you can set
the HF_HUB_OFFLINE environment variable to 1 to prevent attempts to
download models from the internet.

export HF_HUB_OFFLINE=1

WHAT'S NEXT? 🌟

Discover upcoming features on our roadmap in the Open WebUI
Documentation.

LICENSE 📜

This project is licensed under the BSD-3-Clause License - see the
LICENSE file for details. 📄

SUPPORT 💬

If you have any questions, suggestions, or need assistance, please
open an issue or join our Open WebUI Discord community to connect with
us! 🤝

STAR HISTORY

-------------------------

Created by Timothy Jaeryang Baek - Let's make Open WebUI even more
amazing together! 💪