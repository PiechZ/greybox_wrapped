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
COPY --from=build /usr/src/app/build /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# EXPOSE 3000
# RUN chown -R node /usr/src/app
# USER node
# CMD ["node", "src/index.js"]
# CMD [ "npx", "serve", "build" ]
