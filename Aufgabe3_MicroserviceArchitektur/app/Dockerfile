# Builds the same immutable web app as in Aufgaben 1/2 but via Dockerfile.
ARG APP_VERSION=v1
FROM nginx:alpine
COPY content/${APP_VERSION}/index.html /usr/share/nginx/html/index.html
EXPOSE 80
