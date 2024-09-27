# How to setup Mosquitto MQTT broker with docker

### 1. Prerequisites

###### Get docker and docker compose:
```
https://docs.docker.com/engine/install/
https://docs.docker.com/compose/install/
```

###### Install openssl:
```bash
sudo apt install openssl
```

###### Clone this repository to your working directory and remove placeholder files:
```bash
git clone https://github.com/gq97a6/mosquitto_server_docker .
rm ./configs/enabled/remove.me ./certs/trusted/remove.me ./certs/self/remove.me ./certs/client/remove.me ./scripts/outputs/remove.me
```

### 2. Directories and files

- **certs**
  - client - ***Contains client CA certificates***
  - self - ***Contains self-signed certificates***
  - trusted - ***Contains trusted certificates***

- **configs**
  - enabled - ***Stores currently used configuration***
  - disabled - ***Stores disabled configuration***

- **scripts**
  - outputs - ***Output directory for scripts below***
  - copy_cert.sh - ***Copies Let's Encrypt trusted certificate to ./certs/trusted***
  - gen_cert.sh - ***Generates self-signed server certificate (openssl required)***
  - gen_client_ca.sh - ***Generates client authority certificates***
  - gen_new_client.sh - ***Generates new client certificate***
  - server.conf - ***Configuration for generating self-signed server certificate***

- mosquitto.conf - ***Main mosquitto configuration file***
- passwordfile - ***Stores credentials for login/password authentication method***


### 3. Get certificate

A) If you have own trusted certificate from Let's Encrypt:
###### Modify this line below in `./scripts/copy_cert.sh` to match your domain:
```bash
letsencrypt_dir="/etc/letsencrypt/live/domain.com"
```

###### Run the script:
```bash
bash copy_cert.sh
```

B) If you with to generate self-signed certificate:
###### Modify this lines below in `./scripts/server.conf` to match your configuration:
```bash
days = 365
commonName = mqtt.domain.com
DNS.0 = mqtt.domain.com
```

###### Generate server certificate and copy it's outputs to `./certs/self`:
```bash
bash gen_cert.sh
```

### 3. Generate client certificates (optional)

> [!IMPORTANT]  
> Each generated client certificate is considered valid as long as same client CA certificates are used in server configuration

###### Generate client CA with script below and copy it's outputs to `./certs/client`:
```bash
bash gen_client_ca.sh
```

###### Generate certificates for each client:
```bash
bash gen_new_client.sh
```

### 4. Select configuration file
This are example configuration files stored in `./configs/disabled`
- tcp.conf - ***Most basic configuration with MQTT over TCP***
- ssl.conf - ***Configuration with MQTT over TLS***
- ssl_self.conf - ***Configuration with MQTT over TLS using self-signed certificates***
- ssl_self_cert_auth.conf - ***Same as above but includes client authentication using certificates***
- ws.conf - ***Configuration with MQTT over WebSockets***
- wss.conf - ***Configuration with MQTT over secure WebSockets***

Each listener is also secured by default with basic login/password authentication method\
To change this remove this line below in `./mosquitto.conf`
```bash
password_file /mosquitto/config/passwordfile
```

> [!TIP]  
> To create new passwordfile use:
> `mosquitto_passwd -c passwordfile user`\
> To create add new user to password file use:
> `mosquitto_passwd -b passwordfile`

###### Copy and modify if needed one of example configurations above to:
```bash
./configs/enabled
```

### 5. Run container

###### Modify `./docker-compose.yml` to match your configuration:
```yml
services:
  mosquitto:
    container_name: mosquitto
    hostname: mosquitto
    image: eclipse-mosquitto
    restart: unless-stopped
    ports:
      - 1883:1883
    volumes:
      - ./mosquitto/config:/mosquitto/config
      - ./mosquitto/data:/mosquitto/data
      - ./mosquitto/log:/mosquitto/log
```

###### Run container:
```bash
docker compose up -d
```
