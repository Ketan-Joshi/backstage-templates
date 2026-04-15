FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE ${{ values.containerPort }}
CMD ["node", "index.js"]
