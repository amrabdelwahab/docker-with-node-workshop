From node:14-alpine AS dev
WORKDIR /usr/src/app

FROM dev AS production
COPY . ./
CMD ["node", "app.js"]
