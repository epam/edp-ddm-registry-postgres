void call() {

//remove old serviceaccount
    sh(script: "oc delete serviceaccount citus -n $NAMESPACE --ignore-not-found")
//services
    ["citus-master", "citus-master-rep", "operational-pool"].each {
        sh(script: "oc annotate --overwrite service $it meta.helm.sh/release-name='registry-postgres' -n $NAMESPACE || :")
    }
//configmaps
    ["rm-template-stat-statements", "operational-pool-config"].each {
        sh(script: "oc annotate --overwrite configmap $it meta.helm.sh/release-name='registry-postgres' -n $NAMESPACE || :")
    }
//secret
    sh(script: "oc annotate --overwrite secret citus-roles-secrets meta.helm.sh/release-name='registry-postgres' -n $NAMESPACE || :")
//deployment
    sh(script: "oc annotate --overwrite deployment operational-pool meta.helm.sh/release-name='registry-postgres' -n $NAMESPACE || :")
    sh(script: "oc patch deployment operational-pool -p '{\"spec\": {\"template\": {\"spec\": {\"serviceAccountName\": \"registry-postgres\"}}}}' -n $NAMESPACE || :")
//PostgresClusters
    ["operational", "analytical"].each {
        sh(script: "oc annotate --overwrite postgrescluster $it meta.helm.sh/release-name='registry-postgres' -n $NAMESPACE || :")
    }
//podmonitor
    sh(script: "oc annotate --overwrite podmonitor crunchy-postgres-exporter -$NAMESPACE meta.helm.sh/release-name='registry-postgres' -n openshift-monitoring || :")

//Delete pg-exporter-chart
    sh(script: "helm uninstall pg-exporter-chart -n $NAMESPACE || :")

}

return this;
