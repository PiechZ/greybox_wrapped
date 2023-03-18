FROM node:18-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
# RUN npm install --production --silent && mv node_modules ../

COPY . .
RUN npm ci
RUN npm run build
EXPOSE 3000
RUN chown -R node /usr/src/app
USER node
# CMD ["node", "src/index.js"]
CMD [ "npx", "serve", "build" ]