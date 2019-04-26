FROM node

ADD app/ /home/node/app
EXPOSE 3000
WORKDIR /home/node/app
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org && \
    cnpm install
CMD ["cnpm","start"]