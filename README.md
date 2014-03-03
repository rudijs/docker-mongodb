docker-mongodb
==============

MongoDB Docker image using a persistant mounted data directory with ssh for access to MongoDB admin.


# Usage

## Run the public image directly in a local container instance

Create a shared data directory to be mounted into the container (this can be anywhere you prefer)

    MONGO_DATA_DIR=/tmp/data
    mkdir -p $MONGO_DATA_DIR

Run the image: mount the data directory, set SSH port to connect on, set the MongoDB port

    sudo docker run -d -v $MONGO_DATA_DIR:/data -p 2222:22 -p 27017:27017 -name mongodb rudijs/docker-mongodb

SSH to the container, first get the random password created with the new container instance

    sudo docker logs

The SSH password by default is 24 characters long and looks like this example from `sudo docker logs`

    ssh user password: qua0AhD3Ohv1vuzah2aeChae

Now you can ssh in with:

    ssh -p 2222 user@localhost

Enable passwordless ssh log in with

    ssh-copy-id '-p 2222 user@localhost'

If you repeatedly build new containers using the same port you'll need to clear out the old ssh keys with:

    ssh-keygen -f ~/.ssh/known_hosts -R '[localhost]:2222'


## Pull the image without running a new container (if you prefer to build your own see next step)

    sudo docker pull rudijs/docker-mongodb
    
## Build Image

If you prefer to build the image instead of pulling from the public docker registry

    git clone git@github.com:rudijs/docker-mongodb.git
    cd docker-mongodb/
    sudo docker build -t <your-name>/mongodb .

Review the new image

    sudo docker images

## Some Docker Utility Commands

List all containers ever created

    sudo docker ps -a

Clean up all non-running containers (free's up disk space)

    sudo docker ps -a -q | xargs sudo docker rm
