#!/bin/sh
#export TARGET_URL=http://slow-backend-guillaume-perf.apps.vlab-sno.vlab.com/vertx
#export TARGET_URL=http://localhost:8080/vertx
#export TARGET_URL=http://localhost:8081/vertx
HTTP_CLIENT=$1 # one of vertx, netty or ahc
NUM_REQ=$2
TARGET_URL=http://localhost:8081
for i in `seq 1 ${NUM_REQ}`
do
curl $TARGET_URL/${HTTP_CLIENT} &
done
wait