# Use the official Nginx image as the base image
FROM nginx:stable-alpine
# copying the contents under dist/ to the directory /web/data/ in the container
COPY dist/ /web/data/
# Copy the custom Nginx configuration file to the appropriate location in the container
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 3000 to allow access to the application
EXPOSE 3000