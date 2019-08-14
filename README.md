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
    docker build -t CrossFireServer:release .
    ```
5. **Start docker container**
    ```
    docker run -p 8000:8000 --name cross_fire CrossFireServer:release
    ```
### Next we build the HTTP client
1. ** Install docker**
    
    You can fellow the [docker official document](https://docs.docker.com/) to install the docker for you system.
2. **Install git**
    ```
    sudo apt-get install git
    ```
4. **Build the docker image**
    The client docker file is in branch "client", you need to checkout it first.
    ```
    cd CrossFire
    git checkout client
    docker build -t CrossFireClient:release .
    ```
    Please pay attention here, you need to create your own certifation first before build the docker image.
    And this certifation must named stunnel.pem, the file in repository is a blank file, you need to create you own to replease it.
    You can create yours fellow below steps( with openssl ):
    ```
    openssl req -new -x509 -days 365 -nodes -out stunnel.pem -keyout stunnel.pem
    ```
5. **Start docker container**
    ```
    docker run -p 8000:8000 --name cross_fire_client CrossFireClient:release
    ```
6. **Set proxy**
    Than you need to set the proxy to local port.
    ```
    export http_proxy=http://127.0.0.1:8000/
    ```
    Please attention, if you want to deploy the server and the client in the same phystical computer, the exposed port should be different, like that:
    ```
    docker run -p 8000:8000 --name cross_fire_server CrossFireServer:release
    docker run -p 8000:8080 --name cross_fire_client CrossFireClient:release
    ```
    Now the client listen port 8080 and you should set your proxy like that:
    ```
    export http_proxy=http://127.0.0.1:8080/
    ```

## Some Questions

### Can I use the client in Windows ?

Of course, you can download a [windows edition stunnel client](https://www.stunnel.org/downloads.html), and install it. 

### Can I devide Squid and Stunnel to two docker containers ?

Of course, you can do it yourself or checkout to branch "server_single" to get it.


    
