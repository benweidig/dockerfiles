# X86/IDEA

Running JetBrain Intellij IDEA 2016.3.2 Ultimate in a docker container.


## Build Arguments

| Argument      | Default         |
| ------------- | --------------- |
| IDEA_VERSION  | 2016.3.2        |
| JETTY_VERSION | 9.4.0.v20161208 |
| USERID        | 1000            |
| GROUPID       | 1000            |


## Volumes you need to map

- /home/docker/.IntelliJIdea2016.3 \
- /home/docker/.java \
- /etc/localtime:ro \
- /etc/timezone:ro \
- /tmp/.X11-unix \


## Volumes you should map

- A folder that contains your code
- Your .hgrc / .gitconfig files


## Ports to map

- Whatever port you want to use from the outside


## Run the container

This is just an example

```
docker run --rm \
           --name idea \
           -v ~/code:/home/docker/code \
           -v ~/.dotfiles/hgrc:/home/docker/.hgrc:ro \
           -v ~/.dotfiles/gitconfig:/home/docker/.gitconfig:ro \
           -v ~/.docker-data/idea/settings:/home/docker/.IntelliJIdea2016.3 \
           -v ~/.docker-data/idea/java:/home/docker/.java \
           -v /etc/localtime:/etc/localtime:ro \
           -v /etc/timezone:/etc/timezone:ro \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -e DISPLAY=$DISPLAY \
           -e SWT_GTK3=0 \
           -p 8888:8888 \
           x86/idea
```
