FROM node:10.16.3-alpine as build
ENV NODE_PATH=/app/node_modules
ENV PATH=$PATH:/app/node_modules/.bin
WORKDIR /app
COPY package* /app/
RUN npm install

COPY . /app/
RUN npm rebuild node-sass
RUN npm run build

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /var/www/site
WORKDIR /var/www/site
