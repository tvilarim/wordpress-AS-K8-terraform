#!/bin/bash
IP=$(minikube ip)
echo "{\"output\": \"${IP}\"}"
