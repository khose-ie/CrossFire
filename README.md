# CrossFire
An HTTP proxy server docker image built with Squid and Stunnel in Alpine Linux.

## What is it ?
Not something specially, only a HTTP proxy server built by Squil and Stunnel. And I make them into a Alpine linux docker continer.

## How to use it ?
First, you need a phystical server and then install an operating system in it, and fellow below steps to build this HTTP proxy server.
Example comment in below steps is in Ubuntu 18.04, if you use the same, fortunately you can copy it.

To use the HTTP proxy functon, you should has a proxy server and a proxy client, and you need to build them separately.

### Now we build the HTTP proxy server
1. **Install docker**
    
    You can fellow the [docker official document](https://docs.docker.com/) to install the docker for you system.

2. **Install git**

    ```
    sudo apt-get install git
    ```
3. **Clone this repository**

    ```
    git clone https://github.com/Kloye/CrossFire.git
    ```
4. **Build the docker image**

    ```
    cd CrossFire
    docker build -t crossfire-server:alpine .
    ```
5. **Start docker container**

    ```
    docker run -p 8000:8000 --name cross_fire crossfire-server:alpine
    ```
### Next we build the HTTP client
1. **Install docker**
    
    You can fellow the [docker official document](https://docs.docker.com/) to install the docker for you system.
2. **Install git**

    ```
    sudo apt-get install git
    ```
3. **Write your customs configuration**

    And then you may need to modify something in Dockerfile, it is the IP address for your proxy server.
    Because I couldn't know it and wrote it for you, but don't warry it is simple.
    
    First open the Dockerfile
    ```
    cd CrossFire
    git checkout client
    vi Dockerfile
    ```
    Second find below line:
    ```
    echo "connect = 192.168.0.1:8000" >> /etc/stunnel/stunnel.conf; \
    ```
    You can see the "192.168.0.1:0\8000" is your IP and port of your server, so chagne it, that is OK.
4. **Build the docker image**

    The client docker file is in branch "client", you need to checkout it first.
    ```
    docker build -t crossfire-client:alpine .
    ```
    Please pay attention here, you need to create your own certifation first before build the docker image.
    And this certifation must named stunnel.pem, the file in repository is a blank file, you need to create you own to replease it.
    You can create yours fellow below steps( with openssl ):
    ```
    openssl req -new -x509 -days 365 -nodes -out stunnel.pem -keyout stunnel.pem
    ```
5. **Start docker container**

    ```
    docker run -p 8000:8000 --name cross_fire_client crossfire-client:alpine
    ```
6. **Set proxy**

    Than you need to set the proxy to local port.
    ```
    export http_proxy=http://127.0.0.1:8000/ # You can change 127.0.0.1 to your IP
    ```
    Now the client listen port 8080 and you should set your proxy like that:
    ```
    export http_proxy=http://127.0.0.1:8080/ # You can change 127.0.0.1 to your IP
    ```

## Some Questions

### Can I use the client in Windows ?

Of course, you can download a [windows edition stunnel client](https://www.stunnel.org/downloads.html), and install it. 

### Can I devide Squid and Stunnel to two docker containers ?

Of course, you can do it yourself or checkout to branch "server_single" to get it.

### Can I deploy server and client on one physical computer ?

Oh, if not necessary, it is better don't to do it. But if you inisit on it, so...

First you can deploy the server in the normally way.

Second, after you delpoied the server, you should check its IP address, use below comments:
```
docker exec -it cross_fire_server /bin/bash
ifconfig
```
Remember the IP address and then write them into your client Dockerfile:
```
echo "connect = 192.168.0.1:8000" >> /etc/stunnel/stunnel.conf; \
```
Replace "192.168.0.1" to your server IP address.

Third, you also need to change a port for your client because the 8000 has been used by server:

```
echo "accept = 8000" >> /etc/stunnel/stunnel.conf; \
```
Change "8000" to any other port not in use, like 8080.

Last, you need to expose different port when you start up docker:
```
docker run -p 8000:8080 --name cross_fire_client crossfire-client:alpine
```

### Could you show some information about these branches ?
    master          ==>     HTTP proxy server docker image with alpine 3.10.0 with squid and stunnel.
    server_ubuntu   ==>     HTTP proxy server docker image with ubuntu 18.04 with squid and stunnel.
    server_single   ==>     HTTP proxy server docker image with alpine 3.10.0, squid and stunnel in two docker container.
    client          ==>     HTTP proxy client docker image with alpine 3.10.0 with stunnel.
    client_ubuntu   ==>     HTTP proxy client docker image with ubuntu 18.04 with stunnel.

