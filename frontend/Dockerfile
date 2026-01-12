FROM nginx:1.27

# Copy the built frontend files to the nginx html directory
COPY frontend/html /usr/share/nginx/html
# Copy the nginx configuration files
COPY frontend/conf.d/ /etc/nginx/conf.d/

EXPOSE 3000

# Start nginx
CMD ["nginx", "-g", "daemon off;"]