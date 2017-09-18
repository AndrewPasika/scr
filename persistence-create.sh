#!/bin/bash

# MariaDB for CM
kubectl create -f kubernetes/mariadb/kube-pv.yml
kubectl create -f kubernetes/mariadb/kube-mariadb-persistence.yml

# Cassandra for EPTS
kubectl create -f kubernetes/cassandra/kube-pv.yml
kubectl create -f kubernetes/cassandra/kube-cassandra-persistence.yml

# MongoDB for EPR
kubectl create -f kubernetes/mongo/kube-pv.yml
kubectl create -f kubernetes/mongo/kube-mongo-persistence.yml
