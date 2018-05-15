FROM node:6.11.3-alpine
RUN mkdir -p /hpme/web
COPY package.json /home/web/
COPY src /home/web/src/
WORKDIR "/home/web"
RUN npm install
RUN npm test
ENTRYPOINT npm run start