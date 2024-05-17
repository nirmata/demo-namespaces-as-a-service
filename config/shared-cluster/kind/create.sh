#!/bin/bash
UNAMECHK=`uname`
KIND_PATH="/usr/local/bin"
KIND_FILE=$(which kind)


#Host IP Check
if [[ $EXTERNAL_IP == "" ]]; then
	if [[ $UNAMECHK == "Darwin" ]]; then
		EXTERNAL_IP=$(ifconfig | grep "inet " | grep -v  "127.0.0.1" | awk -F " " '{print $2}'|head -n1)
    # echo $EXTERNAL_IP
	else
		EXTERNAL_IP=$(ip a | grep "inet " | grep -v  "127.0.0.1" | awk -F " " '{print $2}'|awk -F "/" '{print $1}'|head -n1)
    # echo $EXTERNAL_IP
	fi
fi

echo "Using IP address $EXTERNAL_IP"

cp config/shared-cluster/kind/kind-config.yaml /tmp/kind-config.yaml

sed -i '' 's/127.0.0.1/'$EXTERNAL_IP'/g' /tmp/kind-config.yaml

echo "created /tmp/kind-config:"
cat /tmp/kind-config.yaml

echo "Create a KIND cluster using:"
echo "  kind create cluster --name shared --config /tmp/kind-config.yaml"
echo " "

