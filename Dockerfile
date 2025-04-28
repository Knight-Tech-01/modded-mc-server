# Use Java 21 base image
FROM eclipse-temurin:21-jdk

# Install cron
RUN apt update && apt install -y cron

# Set working directory in container
WORKDIR /server

# Copy all local files into the image
COPY . .

# Make the backup and start script executable
RUN chmod +x ./startserver.sh
RUN chmod +x ./backup.sh

# Automatically accept the EULA during build
RUN echo "eula=true" > eula.txt

# Install NeoForge server
RUN java -jar neoforge-21.1.143-installer.jar -installServer

# Add cron job for backups every 6 hours
RUN echo "0 */6 * * * root /server/backup.sh >> /server/backup_log.txt 2>&1" > /etc/cron.d/mc-backup && chmod 0644 /etc/cron.d/mc-backup && crontab /etc/cron.d/mc-backup

# Expose Minecraft server port
EXPOSE 25565

# Set environment variables
ENV ATM10_JAVA=java \
    ATM10_RESTART=true \
    ATM10_INSTALL_ONLY=false

# Start the cron service and the server
CMD service cron start && ./startserver.sh
