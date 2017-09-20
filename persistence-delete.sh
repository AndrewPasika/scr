#!/bin/bash

# MariaDB for CM
kubectl delete -f kubernetes/mariadb/kube-pv.yml
kubectl delete -f kubernetes/mariadb/kube-mariadb-persistence.yml

# Cassandra for EPTS
kubectl delete -f kubernetes/cassandra/kube-pv.yml
kubectl delete -f kubernetes/cassandra/kube-cassandra-persistence.yml

# MongoDB for EPR
kubectl delete -f kubernetes/mongo/kube-pv.yml
kubectl delete -f kubernetes/mongo/kube-mongo-persistence.yml

# Deletes data
sudo rm -rf /usr/lib/data/*
sudo rm -rf /usr/lib/cassandra-data/*
sudo rm -rf /usr/lib/mongo-epr-data/*
