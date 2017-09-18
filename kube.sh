#!/bin/bash

services_filter="kube-*.yml"
configmaps_filter="*configmap.yml"
credentials_filter="*credential.yml"

services_dir="kubernetes"
configmaps_dir="kubernetes/configmaps"
credentials_dir="kubernetes/credentials"

cmd=$1; shift

function get_services() {
  for file in ${services_dir}/${services_filter}; do
    echo -n "$file "
  done
}

function get_configmaps() {
  for file in ${configmaps_dir}/${configmaps_filter}; do
    echo -n "$file "
  done
}

function get_credentials() {
  for file in ${credentials_dir}/${credentials_filter}; do
    echo -n "$file "
  done
}

function kubectl_cmd() {
  local cmd="$1"; shift
  local service_file="$1"; shift
  kubectl "$cmd" -f "$service_file"
  return $?
}

function kube_create_cmd() {
  local cmd="$1"; shift
  local res_list=$($1); shift
  for resource in ${res_list}; do
    kubectl_cmd "${cmd}" "${resource}"
    if [ $? -ne 0 ]; then
      echo "ERROR: Operation FAILED"
    else
      echo ""
    fi
  done
}


function usage() {
  echo "Usage:"
  echo "$1 <command> [<service_file> [<service_file>] ...]"
  echo
  echo "where:"
  echo "<command>       One of the commands from list: list, create, delete, recreate"
  echo "  list          List all the services in the '${services_dir}' folder"
  echo
  echo "  status        Show kubernetes Pods status (equivalent to 'kubectl get pods')"
  echo
  echo "  create        Run kubectl create or delete command respectively"
  echo "  delete"
  echo
  echo "  recreate      Delete and create services"
  echo
  echo "<service_file>  One or more services to work on specified as kubernetes files"
  echo
  echo "NOTE: If no <service_file> specified, the script will work with all the services in '${services_dir}' folder"
  echo
}

case "$cmd" in
  create)
    kube_create_cmd create get_credentials "$@"
    kube_create_cmd create get_configmaps "$@"
    kube_create_cmd create get_services "$@"
    ;;
  delete)
    kube_create_cmd delete get_credentials "$@"
    kube_create_cmd delete get_configmaps "$@"
    kube_create_cmd delete get_services "$@"
    ;;
  recreate)
    kube_create_cmd delete get_services "$@"
    kube_create_cmd create get_services "$@"
    ;;
  list)
    services_list=$(get_services)
    echo "List of available services:"
    for service in ${services_list}; do
      echo "  ${service}"
    done
    ;;
  status)
    echo "Pods list:"
    kubectl get pods
    ;;
  *)
    echo "ERROR: Invalid command(s) provided"
    usage "$0"
    exit 1
    ;;
esac
