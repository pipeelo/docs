FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html custom.css openapi.json /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/
COPY vendor/ /usr/share/nginx/html/vendor/

EXPOSE 8080
