docker stop fabric.machinelearning.r
docker rm fabric.machinelearning.r
docker build -t healthcatalyst/fabric.machinelearning.r . 

docker run --rm --name fabric.machinelearning.r -t healthcatalyst/fabric.machinelearning.r