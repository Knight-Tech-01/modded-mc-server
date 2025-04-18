# Use Java 21 base image
FROM eclipse-temurin:21-jdk

# Set working directory in container
WORKDIR /server

# Copy all local files into the image
COPY . .

# Make your start script executable (important for Linux-based containers)
RUN chmod +x ./startserver.sh

# Optional: pre-install NeoForge during build
RUN ./startserver.sh ATM10_INSTALL_ONLY=true || true

# Expose default Minecraft server port
EXPOSE 25565

# Environment variables (optional)
ENV ATM10_JAVA=java \
    ATM10_RESTART=true \
    ATM10_INSTALL_ONLY=false

# Run the server
CMD ["./startserver.sh"]
