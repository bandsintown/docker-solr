#!/usr/bin/env bash

function setup(){
  teardown
}

function teardown() {
  # Deregister service
  deregister_service zookeeper
  delete_keys
  rm -f /opt/solr/bin/solr.in.sh
}

function require_env {
    if [[ -z ${!1} ]]; then
        errecho "This test requires the $1 environment variable to be set in order to run."
        exit 1
    fi
}

function register_service {
    service=$1
    address=$2
    port=$3

body=$(cat << EOF
{
  "Datacenter": "dc1",
  "Node": "node-$address",
  "Address": "$address",
  "Service": {
    "ID": "$service",
    "Service": "$service",
    "Address": "$address",
    "Port": $port
  },
  "Check": {
    "Node": "node-$address",
    "CheckID": "service:$service",
    "Name": "Health check for service $service",
    "Notes": "Script based health check",
    "Status": "passing",
    "ServiceID": "$service"
  }
}
EOF
)
    echo "Registering service '$service' (Address : $address, Port: $port)"
    curl -H 'Content-Type: application/json' -XPUT -d "${body}" http://${CONSUL_HTTP_ADDR}/v1/catalog/register
}

function deregister_service {
    require_env CONSUL_HTTP_ADDR
    local service=$1
body=$(cat << EOF
{
  "Datacenter": "dc1",
  "Node": "node-$service",
  "ServiceID": "$service"
}
EOF
)
    echo "Deregistering service '$service' "
    curl -s -H 'Content-Type: application/json' -XPUT -d "${body}" "http://${CONSUL_HTTP_ADDR}/v1/catalog/deregister"  > /dev/null
}

function register_key {
    require_env CONSUL_HTTP_ADDR

    key=$1
    value=$2

    echo "Registering key '$key'"
    curl -s -H 'Content-Type: application/json' -XPUT -d "${value}" "http://${CONSUL_HTTP_ADDR}/v1/kv/$key"  > /dev/null
}

function delete_keys {
    require_env CONSUL_HTTP_ADDR
    key_prefix=$1
    echo "Deleting keys"
    curl -s -H 'Content-Type: application/json' -XDELETE "http://${CONSUL_HTTP_ADDR}/v1/kv/$key_prefix?recurse"  > /dev/null
}

function random_ip {
    echo $(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
}

function random_port {
    echo $(shuf -i30000-50000 -n1)
}
