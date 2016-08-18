# X86/SCP

A SCP-only SSHD container with public-key-only authentication.
You can configure a little bit, like the userid/groupid so the files will have the correct ownership.

The authorized keys file has to be provided!


## Build Arguments

| Argument | Default | Description                      |
| ------------------ | ------------------------- ------ |
| DATA     | /data   | Data Directory / Home Folder     |
| USERID   | 1000    | uid of user you're connecting to |
| GROUPID  | 1000    | gid of user you're connecting to |
| -------- | ------- | -------------------------------- |


## Exposed ports

22


## Volumes in Dockerfile

- $DATA (default: /data)


## Required Volumes

You have to link the authorized_keys file into the container!

- /authorized_keys

## Run the container

```
docker run \
    -d \
    --name scp \
    -p 22:2222 \
    -v ~/authorized_keys:/authorized_keys:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    x86/scp
```
