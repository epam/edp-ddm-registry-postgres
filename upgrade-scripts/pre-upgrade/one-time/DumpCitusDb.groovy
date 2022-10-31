void call() {
    sh "if oc -n $NAMESPACE get secret citus-secrets 2> /dev/null; then oc apply -f ./resources/create-citus-dump-pod.yaml -n $NAMESPACE; fi"
}

return this;
