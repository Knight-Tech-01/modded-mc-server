#!/bin/sh
set -eu
NEOFORGE_VERSION=21.1.143
# To use a specific Java runtime, set an environment variable named ATM10_JAVA to the full path of java.exe.
# To disable automatic restarts, set an environment variable named ATM10_RESTART to false.
# To install the pack without starting the server, set an environment variable named ATM10_INSTALL_ONLY to true.

INSTALLER="neoforge-$NEOFORGE_VERSION-installer.jar"
NEOFORGE_URL="https://maven.neoforged.net/releases/net/neoforged/neoforge/$NEOFORGE_VERSION/neoforge-$NEOFORGE_VERSION-installer.jar"

if ! command -v "${ATM10_JAVA:-java}" >/dev/null 2>&1; then
    echo "Minecraft 1.21 requires Java 21 - Java not found"
    exit 1
fi

cd "$(dirname "$0")"

# Ensure NeoForge is installed if necessary
if [ ! -d libraries ] || ! find libraries -name unix_args.txt | grep -q .; then
    echo "Neoforge not installed, installing now."
    if [ ! -f "$INSTALLER" ]; then
        echo "No Neoforge installer found, downloading now."
        if command -v wget >/dev/null 2>&1; then
            echo "DEBUG: (wget) Downloading $NEOFORGE_URL"
            wget -O "$INSTALLER" "$NEOFORGE_URL"
        else
            if command -v curl >/dev/null 2>&1; then
                echo "DEBUG: (curl) Downloading $NEOFORGE_URL"
                curl -o "$INSTALLER" -L "$NEOFORGE_URL"
            else
                echo "Neither wget or curl were found on your system. Please install one and try again"
                exit 1
            fi
        fi
    fi

    echo "Running Neoforge installer."
    "${ATM10_JAVA:-java}" -jar "$INSTALLER" -installServer
fi

# Ensure server.properties exists
if [ ! -e server.properties ]; then
    printf "allow-flight=true\nmotd=All the Mods 10\nmax-tick-time=180000" > server.properties
fi

# If installation-only mode is enabled, exit early
if [ "${ATM10_INSTALL_ONLY:-false}" = "true" ]; then
    echo "INSTALL_ONLY: complete"
    exit 0
fi

# Ensure correct Java version (Minecraft 1.21 requires Java 21)
JAVA_VERSION=$("${ATM10_JAVA:-java}" -fullversion 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ ! "$JAVA_VERSION" -ge 21 ]; then
    echo "Minecraft 1.21 requires Java 21 - found Java $JAVA_VERSION"
    exit 1
fi

# Main loop to start server
while true
do
    "${ATM10_JAVA:-java}" @user_jvm_args.txt @libraries/net/neoforged/neoforge/$NEOFORGE_VERSION/unix_args.txt nogui

    # Check if restart should be enabled or not
    if [ "${ATM10_RESTART:-true}" = "false" ]; then
        exit 0
    fi

    echo "Restarting automatically in 10 seconds (press Ctrl + C to cancel)"
    sleep 10
done
