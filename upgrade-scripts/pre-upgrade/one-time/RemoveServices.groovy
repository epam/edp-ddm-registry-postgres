void call() {
    sh "oc -n $NAMESPACE delete svc citus-master 2> /dev/null || : &&" +
            "oc -n $NAMESPACE delete svc citus-master-rep 2> /dev/null || : "
}

return this;
