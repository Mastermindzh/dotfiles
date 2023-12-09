#!/bin/bash
# Kubernetes commands
alias mkubectl='microk8s.kubectl'
alias kubestart='microk8s.start'
alias kubestop='microk8s.stop'
alias kubecontexts='kubectl config get-contexts'

# function to switch kubernetes namespace
kubenamespaceswitch() {
  if [ -z "$1" ]; then
    echo "please specify a namespace to switch to"
  else
    kubectl config set-context --current --namespace="$1"
  fi
}

# function to switch kubernetes context
kubecontextswitch() {
  if [ -z "$1" ]; then
    echo "please specify a context to switch to, the following contexts are available:"
    kubectl config get-contexts
  else
    kubectl config use-context "$1"
  fi
}

# function to switch to a different azure kubernetes cluster
azkubeswitch() {
  if [ -z "$2" ]; then
    echo "please execute with the following params: azkubeswitch {resourcegroupname} {clustername}"
  else
    az aks get-credentials --resource-group "$1" --name "$2"
  fi
}

# get old resources from kubernetes
kube-get-old() {
  if [ -z "$1" ]; then
    echo "please provide a resource type, examples:"
    echo "  kube-get-old pods"
    echo "  kube-get-old namespaces"
    echo ""
    echo "you can pass extra arguments as the second param, examples:"
    echo "  kube-get-old pods --all-namespaces"
    echo '  kube-get-old namespaces "--all-namespaces --second"'
  else

    kubectl get "$1" ${2:+"$2"} -o go-template --template '{{range .items}}{{.metadata.name}} {{.metadata.creationTimestamp}}{{"\n"}}{{end}}' | awk -v twoWeeksAgo="date -d '-14 days'" -F':' '$2<twoWeeksAgo' | awk '{print $1}'
  fi
}
