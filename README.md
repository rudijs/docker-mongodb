docker-mongodb
==============

MongoDB Docker image using mounted mongodb.conf and data directory

## Build Image

If you prefer to build the image instead of pulling from the public docker registry

    cd docker-mongodb/
    sudo docker build -t <your-name>/mongodb .

Review the new image

    sudo docker images

## Using the MongoDB image

Create a shared data directory to be mounted into the container (this can be anywhere you prefer)

    MONGO_DATA_DIR=/tmp/data
    mkdir -p $MONGO_DATA_DIR

Copy in the mongodb configuration file to the shared data directory

    cp mongodb.conf $MONGO_DATA_DIR

Run the mongodb container (replace rudijs with <your-name> if you built your own docker image)

    sudo docker run -d -v $MONGO_DATA_DIR:/data -p 27017:27017 -name mongodb rudijs/mongodb

Check the status

    sudo docker ps -a
    sudo docker logs mongodb

Review the shared data

    du -sh $MONGO_DATA_DIR/*
    tree $MONGO_DATA_DIR

## Admin Shell

For when you need the `mongo` shell to run command line operations against your mongo instance

Get the IP address of the current running mongod

    sudo docker inspect mongodb
    IP_ADDRESS=$(sudo docker inspect mongodb | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[0]["NetworkSettings"]["IPAddress"]')

Create a new container, override the entrypoint and use the IP address from the above output (replace rudijs with <your-name> if you built your own docker image)

    sudo docker run -i -t -name mongo -entrypoint="mongo" rudijs/mongodb $IP_ADDRESS

## Mongo Import

If you would like to load some data up

Copy in the test database fixture data

    cp test/fixtures/db/*.json $MONGO_DATA_DIR

Get the IP address of the current running mongod using either of these commands

    sudo docker inspect mongodb
    sudo docker inspect mongodb | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[0]["NetworkSettings"]["IPAddress"]'

Create a new container mounting the shared data/ directory and overriding the entrypoint to drop into the command line
(replace rudijs with <your-name> if you built your own docker image)

    sudo docker run -i -t -name mongoimport -entrypoint="/bin/bash" -v $MONGO_DATA_DIR:/data rudijs/mongodb

Inside the container use the IP from above with mongoimport (change the database naem and collections as required for your data)

    mongoimport -h 172.17.0.2 --db demo --collection users --file /data/users.json
    mongoimport -h 172.17.0.2 --db demo --collection articles --file /data/articles.json

Exit `Ctrl-c` the container and clean up

    rm $MONGO_DATA_DIR/*.json

## Some Docker Utility Commands

List all containers ever created

    sudo docker ps -a

Clean up all non-running containers (free's up disk space)

    sudo docker ps -a -q | xargs sudo docker rm