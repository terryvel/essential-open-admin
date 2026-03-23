FROM nginx:latest

# Install envsubst
RUN apt-get update && apt-get install -y gettext

# Enable and install SSH for Azure
# ssh root@127.0.0.1 -p 2222 -c aes256-cbc
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "$SSH_PASSWD" | chpasswd 

COPY sshd_config /etc/ssh/

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY essential_open_admin/nginx.conf /etc/nginx/conf.d/

# Copy static files
COPY public /usr/share/nginx/html

# Copy and setup entrypoint
COPY essential_open_admin/entrypoint.sh /docker-entrypoint.d/99-custom-entrypoint.sh
RUN chmod +x /docker-entrypoint.d/99-custom-entrypoint.sh

# Entrypoint is handled by the base image's entrypoint script which runs scripts in /docker-entrypoint.d/
# But to be explicit and ensure our logic runs, we can also use our own ENTRYPOINT if we wanted complete control.
# The nginx:alpine image executes /docker-entrypoint.sh which looks for scripts in /docker-entrypoint.d/
# converting our script to be one of those is the "correct" way for this image.
# However, modifying the index.html in place inside /usr/share/nginx/html is fine.

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

