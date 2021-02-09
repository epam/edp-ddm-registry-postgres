void call() {

    sh "oc scale statefulset/citus-worker --replicas=0 -n $NAMESPACE || true"
    sh "oc scale statefulset/citus-worker-rep --replicas=0 -n $NAMESPACE || true"
    def masterPodsNames = sh(script: "oc get pods -o custom-columns=POD:.metadata.name --no-headers " +
            "-n $NAMESPACE | grep citus-master", returnStdout: true).tokenize()
    ['postgres', 'registry'].each { dbName ->
        masterPodsNames.each { masterPod ->
            def workersNumber = sh(script: "oc exec $masterPod -n $NAMESPACE -c citus -- psql $dbName -U postgres -t -c " +
                    "\"select COUNT(*) from master_get_active_worker_nodes();\"", returnStdout: true).trim()
            if (workersNumber.toInteger() > 0) {
                def workersList = sh(script: "oc exec $masterPod -n $NAMESPACE -c citus -- psql $dbName -U postgres -t -c " +
                        "\"select node_name from master_get_active_worker_nodes();\" | grep -v '^\$'", returnStdout: true)
                        .trim().tokenize()
                workersList.each { worker ->
                    sh "oc exec $masterPod -n $NAMESPACE -c citus -- psql $dbName -U postgres -c " +
                            "\"select citus_remove_node('${worker}', 5432);\""
                }
            }
        }
    }
}

return this;
