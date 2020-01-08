FROM ripencc/rpki-validator-3-docker:alpine
RUN apk add --no-cache bash

WORKDIR /var/lib/rpki-validator-3
ADD application.properties /var/lib/rpki-validator-3/conf/
ADD rpki-validator-3.sh /var/lib/rpki-validator-3/
ADD arin-ote.tal /var/lib/rpki-validator-3/

RUN chmod 755 /var/lib/rpki-validator-3/rpki-validator-3.sh

ENTRYPOINT ["./rpki-validator-3.sh"]
EXPOSE 8080
