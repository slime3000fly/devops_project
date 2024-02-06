# Use a base image with Node.js for building
FROM node:14 as build-stage

WORKDIR /app

COPY package*.json ./
COPY . .

RUN npm config set registry https://registry.npmjs.org/
RUN echo "registry=https://registry.npmjs.org/" > .npmrc
RUN npm install
RUN npm run build

# Create a new image with Nginx
FROM nginx

COPY --from=build-stage /app/build /usr/share/nginx/html
# Copy Nginx configuration for reverse proxy
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80