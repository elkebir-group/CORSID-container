FROM node:14.14.0

# VOLUME [ "/test" ]
RUN wget https://github.com/elkebir-group/CORSID-viz/archive/refs/tags/v0.1.0-singleton.tar.gz && \
    tar xzf v0.1.0-singleton.tar.gz

# RUN mv ./CORSID-viz-0.1.0-test/ ./corsid-viz
WORKDIR /CORSID-viz-0.1.0-singleton
# COPY package*.json ./
RUN npm install
# RUN npm install -g http-server 
RUN npm install -g @vue/cli
RUN npm install -g serve
# RUN npx vue-cli-service build --mode singleton
# CMD ["npm", "run", "serve"]
# CMD ["serve", "-s", "dist"]

# RUN npm install -g @vue/cli
# RUN npm run build
# npx vue-cli-service build --mode singleton
# EXPOSE 8080
# RUN npm install -g http-server
# CMD ["http-server", "dist"]
# RUN serve -s dist

# Copy test.corsid.json into assets/result.json
# npx vue-cli-service build --mode singleton
# Run `serve -s dist`