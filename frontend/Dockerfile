FROM node:18-alpine as build
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
# RUN npm install --production --silent && mv node_modules ../

COPY ["./src", "./src"]
COPY ./public ./public
RUN npm ci
RUN npm run build

FROM nginx:1.23.4-alpine
RUN apk add --no-cache gettext
COPY --from=build /usr/src/app/build /usr/share/nginx/html
COPY nginx/nginx.conf.template /etc/nginx/nginx.template
EXPOSE 80

# Must be set in docker-compose.yml or elsewhere in environment
ARG BACKEND_SERVER
# RUN envsubst '${BACKEND_SERVER}' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf
RUN sed "s|__BACKEND_SERVER__|${BACKEND_SERVER}|" /etc/nginx/nginx.template > /etc/nginx/nginx.conf
# CMD ["nginx", "-g", "daemon off;"]
CMD /bin/sh -c "cat /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"
# CMD /bin/sh -c "envsubst '$BACKEND_SERVER' < /etc/nginx/nginx.template > /etc/nginx/nginx.conf && cat /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"
