CAS Docker Overlay
==================
# Docker Compose setup using a multi-stage build:
* Run the following commands to generate self-signed keystore.
```keytool -genkey -noprompt -alias cas -keystore etc/cas/thekeystore -storepass changeit -keypass changeit -validity 3650 -keysize 2048 -keyalg RSA -dname "CN=cas, OU=MyOU, O=MyOrg, L=Somewhere, S=VA, C=US"```
```keytool -export -file etc/cas/config/cas.crt -storepass changeit -keystore etc/cas/thekeystore -alias cas```


* First stage builds a Docker image that:
  * clones https://github.com/apereo/cas-overlay-template
  * copies the src (local overlay) tree into it
  * builds cas.war
* Second stage runs CAS in a Docker container
  * copies the directory etc/cas into the container at /etc/cas
  * loads self-signed keystore to JAVA keystore
  * copies the cas.war file from the first stage
  * exposes port 8443
  * runs /usr/bin/java -jar cas.war (using the embedded Tocmat server)

To use
=====
* To build & run CAS in Docker type:
```docker-compose up --force-recreate --no-cache```

* Open up a page at https://localhost:8443/cas/login and login as:
  * user: casuser
  * password: Mellon

* Type ctrl-c to exit, then type this to cleanup:
```docker-compose down --rmi all```

* [Demo CAS client instructions](https://docs.google.com/document/d/1AKcMnKP_3WxY9pk44pmL7BO-XrD0Oq-t47ya8vdxAsg/edit)

Push to docker hub
=====
```docker-compose build cas```
```docker-compose compose push```


References
==========
[BasedOn](https://github.com/crpeck/cas-overlay-docker)  
[Notes](https://docs.google.com/document/d/1AKcMnKP_3WxY9pk44pmL7BO-XrD0Oq-t47ya8vdxAsg/edit)
