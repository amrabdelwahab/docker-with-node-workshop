From node:14-alpine AS dev
WORKDIR /usr/src/app
RUN apk add postgresql-client

FROM dev AS production
COPY . ./
CMD ["node", "app.js"]
