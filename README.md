
# rpki-validator-alpine

This is not the official RIPE RPKI release.  This is a modified version to play nice with a Docker deployment.  

Requires both RTR-SEVER and VALIDATOR containers below.  

Docker Hub:
https://hub.docker.com/r/toomscj7/rpki3-rtr-server-alpine/
https://hub.docker.com/r/toomscj7/rpki3-validator-alpine/
 
GitHub:
https://github.com/sethgarrett/rpki-rtr-server-alpine
https://github.com/sethgarrett/rpki-validator-alpine

```docker run -d -p 8080:8080 toomscj7/rpki3-validator-alpine```

# Localhost & ARIN TAL
Both containers set to listen on localhost only by default. RPKI Validator can be changed at docker run to listen on all interfaces via env variable (listen_any=true).  Ensure you have proper security in place before using this option.  This gets changed via if statement in rpki-validator-3.sh.  RIPE advises to use nginx or apache proxy to secure 8080.  

```docker run -d -e listen_any=true -p 8080:8080 toomscj7/rpki3-validator-alpine```

The ARIN TAL is not installed by default.  This can be set to be pulled at run time with the get_arin_tal=true env variable.  Official site located here: https://www.arin.net/resources/rpki/tal.html.  You will need to read the conditions of their relying party agreement.  

```docker run -d -e listen_any=true -e get_arin_tal=true -p 8080:8080 toomscj7/rpki3-validator-alpine```

You can use the TAL from the ARIN OTE (Operational Test and Evaluation) environment with the use_arin_ote_tal=true env variable.

```docker run -d -e listen_any=true -e use_arin_ote_tal=true -p 8080:8080 toomscj7/rpki3-validator-alpine```

rtr-server container connects to rpki3-validator-alpine on host.docker.internal.  
