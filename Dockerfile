# ===== BUILD STAGE =====
FROM node:18-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# ===== RUN STAGE (NGINX) =====
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html

# arquivo para suportar SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
