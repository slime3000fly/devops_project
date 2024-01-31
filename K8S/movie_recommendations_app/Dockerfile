FROM node:14

WORKDIR /app

COPY package*.json ./
COPY . .

RUN npm config set registry https://registry.npmjs.org/
RUN echo "registry=https://registry.npmjs.org/" > .npmrc
RUN npm install

RUN npm run build

CMD ["npm", "start"]
