FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ENV MONGO_URL=${{secrets.MONGO_URL}}
ENV PORT=5000
ENV SECRET_KEY=biswajit1234
EXPOSE 5000
CMD ["npm", "start"]