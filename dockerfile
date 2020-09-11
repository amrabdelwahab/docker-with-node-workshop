From node:14-alpine AS dev
WORKDIR /usr/src/app
RUN apk add postgresql-client

FROM dev AS production
COPY package*.json ./
RUN npm install
COPY . ./
CMD ["node", "app.js"]
