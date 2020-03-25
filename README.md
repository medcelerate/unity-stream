## Streaming station in a box.

### Requirements:

#### Docker

Make sure to install **docker** on the host machine running this. Though it will work on mac we highly recommend using a linux server. Our system runs this on kubernetes but we have previously run this on 12 core vps with 16gb ram with minimal issues.

### To run simply execute the following commands.

```
git clone https://github.com/medcelerate/unity-stream.git
cd unity-stream
docker-compose -f docker-compose-noproxy.yml up
```

If you want to run it in the background.

```
docker-compose -f docker-compose-noproxy.yml -d up
```