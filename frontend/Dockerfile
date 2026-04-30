# FROM node:20-alpine AS base
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci

# FROM node:alpine
# WORKDIR /app
# COPY --from=base /app/node_modules ./node_modules
# COPY . .
# EXPOSE 3000
# CMD [ "npm", "start" ]


####################################################################################
# FROM node:20-alpine AS build
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci
# COPY . .
# ENV REACT_APP_BACKEND_URL=http://sms-backend-service.sms-app.svc.cluster.local:5000
# RUN npm run build

# # Production stage
# FROM nginx:alpine
# WORKDIR /usr/share/nginx/html
# RUN rm -rf ./*
# COPY --from=build /app/build ./
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

#############################################################

FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
# Bake a placeholder — replaced at runtime by docker-entrypoint.sh
ENV REACT_APP_BASE_URL=__REACT_APP_BASE_URL__
RUN npm run build
 
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/build ./
# COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
EXPOSE 80
CMD ["/docker-entrypoint.sh"]