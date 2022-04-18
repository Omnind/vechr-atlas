FROM node:lts

WORKDIR /app

COPY ./entrypoint.sh /entrypoint/

RUN chmod +x /entrypoint/entrypoint.sh

ENTRYPOINT ["/entrypoint/entrypoint.sh"]

EXPOSE 8080

CMD [ "yarn", "serve" ]