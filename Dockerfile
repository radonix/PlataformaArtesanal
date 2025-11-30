# ==========================
# STAGE 1 — Build
# ==========================
FROM node:18-alpine AS builder
WORKDIR /app

# Copia arquivos de dependência
COPY package*.json ./

# Instala dependências com cache eficiente
RUN npm ci

# Copia todo o projeto
COPY . .

# Gera o build de produção
RUN npm run build

# ==========================
# STAGE 2 — NGINX Runtime
# ==========================
FROM nginx:stable-alpine AS runner
WORKDIR /usr/share/nginx/html

# Remove arquivos padrão do nginx
RUN rm -rf ./*

# Copia o build do frontend
COPY --from=builder /app/dist ./
# -> Se for CRA (Create React App), troque /app/dist por /app/build

# Copia configurações personalizadas do Nginx (opcional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
