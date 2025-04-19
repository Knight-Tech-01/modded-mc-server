#!/bin/sh
set -eu

NEOFORGE_VERSION=21.1.143
INSTALLER="neoforge-$NEOFORGE_VERSION-installer.jar"
NEOFORGE_URL="https://maven.neoforged.net/releases/net/neoforged/neoforge/$NEOFORGE_VERSION/$INSTALLER"

pause() {
    printf "%s\n" "Press enter to continue..."
    read ans
}

# Check if Java is available
if ! command -v "${ATM10_JAVA:-java}" >/dev/null 2>&1; then
    echo "Minecraft 1.21 requires Java 21 - Java not found"
    pause
    exit 1
fi

cd "$(dirname "$0")"

# Check for proper NeoForge installation
if [ ! -f "libraries/net/neoforged/neoforge/$NEOFORGE_VERSION/unix_args.txt" ]; then
    echo "NeoForge not installed, installing now."

    if [ ! -f "$INSTALLER" ]; then
        echo "No NeoForge installer found, downloading now."
        if command -v wget >/dev/null 2>&1; then
            echo "DEBUG: (wget) Downloading $NEOFORGE_URL"
            wget -O "$INSTALLER" "$NEOFORGE_URL"
        elif command -v curl >/dev/null 2>&1; then
            echo "DEBUG: (curl) Downloading $NEOFORGE_URL"
            curl -o "$INSTALLER" -L "$NEOFORGE_URL"
        else
            echo "Neither wget nor curl found. Please install one and try again."
            pause
            exit 1
        fi
    fi

    echo "Running NeoForge installer."
    "${ATM10_JAVA:-java}" -jar "$INSTALLER" -installServer
fi

# Create default server.properties if it doesn't exist
if [ ! -e server.properties ]; then
    printf "allow-flight=true\nmotd=All the Mods 10\nmax-tick-time=180000" > server.properties
fi

# Exit early if ATM10_INSTALL_ONLY is true
if [ "${ATM10_INSTALL_ONLY:-false}" = "true" ]; then
    echo "INSTALL_ONLY: complete"
    exit 0
fi

# Ensure Java version is 21+
JAVA_VERSION=$("${ATM10_JAVA:-java}" -fullversion 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ ! "$JAVA_VERSION" -ge 21 ]; then
    echo "Minecraft 1.21 requires Java 21 - found Java $JAVA_VERSION"
    pause
    exit 1
fi

# Start server in loop unless ATM10_RESTART=false
while true
do
    "${ATM10_JAVA:-java}" @user_jvm_args.txt @libraries/net/neoforged/neoforge/$NEOFORGE_VERSION/unix_args.txt nogui

    if [ "${ATM10_RESTART:-true}" = "false" ]; then
        exit 0
    fi

    echo "Restarting automatically in 10 seconds (press Ctrl + C to cancel)"
    sleep 10
done
