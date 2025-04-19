# Use Java 21 base image
FROM eclipse-temurin:21-jdk

# Set working directory in container
WORKDIR /server

# Copy all local files into the image
COPY . .

# Make the start script executable
RUN chmod +x ./startserver.sh

# Automatically accept the EULA during build
RUN echo "eula=true" > eula.txt

# Install NeoForge server
RUN java -jar neoforge-21.1.143-installer.jar -installServer

# Expose Minecraft server port
EXPOSE 25565

# Set environment variables
ENV ATM10_JAVA=java \
    ATM10_RESTART=true \
    ATM10_INSTALL_ONLY=false

# Start the server when the container runs
CMD ["./startserver.sh"]
