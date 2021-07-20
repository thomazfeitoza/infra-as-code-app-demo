FROM node:14-alpine
WORKDIR /opt/application
COPY package*.json ./
RUN npm install --production
COPY ./src .
ENTRYPOINT ["node", "app.js"]