FROM node:17.6.0-alpine

WORKDIR /app

RUN npm i -g @nestjs/cli

COPY ./entrypoint.sh /entrypoint/

RUN chmod +x /entrypoint/entrypoint.sh

ENTRYPOINT ["/entrypoint/entrypoint.sh"]

EXPOSE 3001

CMD [ "npm", "run", "start:dev" ]