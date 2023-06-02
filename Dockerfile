FROM ubuntu
RUN apt-get update -q
RUN apt-get install -y curl nginx
RUN echo lalyos have a lunchbreak > /var/www/html/index.html
CMD ["nginx", "-g", "daemon off;"]