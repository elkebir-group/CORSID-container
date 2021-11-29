FROM node:14.14.0

WORKDIR /corsid_viz

RUN npm install

COPY ./corsid-viz/ .

CMD ["npm", "run", "serve"]