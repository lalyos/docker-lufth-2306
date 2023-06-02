FROM ubuntu
RUN apt-get update -q
RUN apt-get install -y curl nginx
EXPOSE 80
COPY start.sh /
RUN chmod +x /start.sh
CMD [ "/start.sh" ]
# last line ...