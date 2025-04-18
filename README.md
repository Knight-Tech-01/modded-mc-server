# Modded Minecraft Server (NeoForge 1.21)

This repository contains the full setup for a **modded Minecraft server** using [NeoForge](https://neoforged.net/) (version `21.1.143`), ready to run inside a Docker container. It includes all necessary config files, mods, and a start script designed to simplify setup and deployment.

## Features

- Built with **Java 21** (required by Minecraft 1.21 and NeoForge)
- Uses **NeoForge installer** for mod support
- Includes all mod/config files
- Runs in a **Docker container** for easy deployment and portability
- Supports automatic restart, optional pre-install, and custom JVM args

---

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/) installed on your host system
- Optional: [Git](https://git-scm.com/) if you’re cloning this repo

---

### Build the Docker Image

Clone the repository (or copy files manually), then from the project directory:

```bash
docker build -t modded-mc-server .
