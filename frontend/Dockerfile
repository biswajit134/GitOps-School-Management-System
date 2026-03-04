FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci
RUN npm run test


FROM node:alpine
WORKDIR /app
COPY --from=base /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD [ "npm", "start" ]

# FROM node:20-alpine as build
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci
# COPY . .
# RUN npm run build

# # Production stage
# FROM nginx:alpine
# WORKDIR /usr/share/nginx/html
# RUN rm -rf ./*
# COPY --from=build /app/build ./
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

# # #