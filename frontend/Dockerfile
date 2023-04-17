# 1. Use multi-stage build to reduce final image size
FROM node:18-alpine as build
ENV NODE_ENV=production
WORKDIR /usr/src/app

# 2. Copy only package.json and package-lock.json and install only prod dependencies;
#    re-run only when package.json or package-lock.json changes
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm ci --only=production

# 3. Copy all other source files and build
COPY ["./src", "./src"]
COPY ./public ./public
RUN npm run build

# 4. Use a smaller build image for the final image
FROM nginx:1.23.4-alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
COPY nginx/nginx.conf.template /etc/nginx/nginx.template

# 5. Replace __BACKEND_SERVER__ with the actual backend server in nginx.conf
#    (Must be set in docker-compose.yml or fly.toml as a build arg)
ARG BACKEND_SERVER
RUN sed "s|__BACKEND_SERVER__|${BACKEND_SERVER}|" /etc/nginx/nginx.template > /etc/nginx/conf.d/default.conf

# Alternative, more elegant way of doing the same (that didn't work):
# RUN apk add --no-cache gettext
# RUN envsubst '${BACKEND_SERVER}' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf

# 6. Expose port 80 and start nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
# CMD /bin/sh -c "cat /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"
