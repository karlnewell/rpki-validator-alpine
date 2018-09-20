FROM openjdk:8-alpine
RUN apk add --no-cache bash
RUN apk add --no-cache rsync
ADD rpki-validator-3.0-312-dist.tar.gz /usr/src/rpki-valid
ADD application.properties /usr/src/rpki-valid/rpki-validator-3.0-312/conf
ADD rpki-validator-3.sh /usr/src/rpki-valid/rpki-validator-3.0-312/
ADD arin-ote.tal /usr/src/rpki-valid/rpki-validator-3.0-312/
RUN chmod 755 /usr/src/rpki-valid/rpki-validator-3.0-312/rpki-validator-3.sh
WORKDIR /usr/src/rpki-valid/rpki-validator-3.0-312
ENTRYPOINT ["./rpki-validator-3.sh"]
EXPOSE 8080
