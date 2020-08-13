#!/bin/bash
kubectl create secret tls self-signed-ca \
		-n devops \
		--key="self-signed-CA/rootCA-key.pem" \
		--cert="self-signed-CA/rootCA.pem"
