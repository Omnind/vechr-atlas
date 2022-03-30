FROM node:lts

WORKDIR /app

RUN apt-get -qy update && apt-get -qy install openssl

RUN npm i -g @nestjs/cli

COPY ./entrypoint.sh /entrypoint/

RUN chmod +x /entrypoint/entrypoint.sh

ENTRYPOINT ["/entrypoint/entrypoint.sh"]

EXPOSE 3000

CMD [ "npm", "run", "start:dev" ]