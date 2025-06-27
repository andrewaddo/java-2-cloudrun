# Use an official JBoss/WildFly base image
FROM quay.io/wildfly/wildfly:latest

# Copy your application WAR file to the deployments directory
COPY helloworld.war /opt/jboss/wildfly/standalone/deployments/

# (Optional) Copy a custom standalone.xml for specific configurations
# COPY standalone.xml /opt/jboss/wildfly/standalone/configuration/

# Expose the default HTTP port
EXPOSE 8080

# Command to run the JBoss server
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]

