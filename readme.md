# Docker for beginners: Devs edition

## What is docker needed for?
A web application usually has bunch of pre-requisites. For example you need to have a specific version of node installed on your machine. Then you maybe need  a specific version of postgresql installed.

You need a "container" that has all these stuff already installed and separated from the rest of your computer. Then later if you take this container and start it on any computer it should work exactly the same.

In the past, there used to be the concept of virtual machines. Another computer running on the top of your computer. the difference is simple containers are super light weight as they still use the underlying os of the "host computer" instead of installing a full OS on it. However, from a user prespective you shouldnt feel the difference.

## Important terminology

* **Image**: An image is like a class, it is basically the definition of how containers of this image should look like. You use Dockerfiles to define an "image". Commands like "docker pull", "docker images"
* **Container**: It is an instance of an image, so a running machine above your machine that has all the stuff defined in the image. Commands like "docker run", "docker exec" and "docker ps"
* **Host machine**: The computer where docker is installed and runs containers on top
* **Docker Daemon**: the docker software running on the host machine to manage docker containers
* **Dockerhub**: Just like github, an online registry that has loads of docker images that you can pull stuff from.

## Nodejs

Now let's do a test of all these thoeries. let's imagine we just want a linux "alpine" computer running on our computer.

First run

`docker pull alpine`

Then run

`docker images`

You should find the alpine image there

then run 
`docker run alpine`

Nothing will happen because you didn't specify the interactive flag on docker run.

so again run
`docker run -it alpine`

Okay, now you can go on and install on this "container" node and use it but once you stop the container everything you installed is gone because the image only stops at alpine.

So we need to define an image that already has node installed on it. Lucky for us almost any technology will ahve its ready base image so for node let's check

https://hub.docker.com/_/node

Here you can see, that the same image can have multiple tags. So node is available as node:14-alpine or node:14 or node:latest

We want to use `node:14-alpine`, The default command defined for this image is `node` so if you just run `docker run -it node:14-alpine` 
* It will look for the image locally
* It won't find it, so it will pull it for you from dockerhub and add it to your local images
* it will start a new container from it
* and then it will run `node` on it opening a node console
* but you can also try `docker run -it node:14:alpine ash` which instead of running `node` will run `ash` starting a power shell inside the container
* you can now run `node -v` and realise that it is installed

## Hello World server

Okay, Now I defined a very simple hello world node js server that serves the application on port 5000.

How do I copy this file inside this container.

* First create a dockerfile to start your new definition of a new docker image of your application.

In this dockerfile, you always have to start with a `FROM` command. What this is saying is basically starting from a base image execute the following commands to make a new image.

In this case our base image is going to be `node:14-alpine` so an alpine linux machine with node installed already on it.

```
FROM node:14-alpine
COPY . ./
```

now you need to build your image, which means executing the steps in the docker file and storing the output image in your host machine's images.

To do so, you need to run
`docker build -t my-node-app:1 .`

Now if you run `docker run -it my-node-app:1 ash` and then do `ls` you will find your application files put to the root of your container.

This is not convinient so we usually create a directory using the command `WORKDIR` which will create the directory(if it does not exist) and navigate to it

so your dockerfile should look like this

```
From node:14-alpine
WORKDIR /usr/src/app
COPY . ./
CMD ['node', 'app.js']
```

now let's rebuild to a new tag 2 `docker build -t my-node-app:2 .` now if you run your command 
`docker run -it my-node-app:2 ash` you will already find yourself inside the work directory `/usr/src/app` and your application files are there.

Okay now let's try to start our application so instead of running ash we want to run `node app.js`
and instead of making it `it` we can make it run in daemon mode `-d`
so `docker run -d my-node-app:2 node app.js`

So yes if you go to the browser you can't still reach the application. as it is running in port 5000 of your container not really your host. So you need to run it while mounting the ports using the option `-p HOST_PORT:CONTAINERPORT`

`docker run -d -p 5000:5000 my-node-app:2 node app.js`

one final small thing, instead of having to explicitly call the `node app.js` command you can set it up as your default command using the `CMD` command

```
From node:14-alpine
WORKDIR /usr/src/app
COPY . ./
CMD ['node', 'app.js']
```

Now let's build the third tag
`docker build -t my-node-app:3 .`

and run `docker run -d -p 5000:5000 my-node-app:3`


Now you have an image that if you pulled to any computer with docker daemon on it it will work without anything else installed.


## docker-compose

Now there is another thing that comes installed with docker that simplifies two things.

* How your container deals with the host machine
* How your container deal with other containers like for example postgres container