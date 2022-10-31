void call() {
    String minioSecretNamespace = "${env.dnsWildcard}".contains('cicd') ?
            'mdtu-ddm-edp-cicd' : 'control-plane'
    String minioAccessKeyId = sh(script: "oc -n $minioSecretNamespace get secret backup-credentials -o jsonpath={.data.backup-s3-like-storage-access-key-id} " +
            "| base64 --decode", returnStdout: true)
    String minioSecretAccessKey = sh(script: "oc -n $minioSecretNamespace get secret backup-credentials -o jsonpath={.data.backup-s3-like-storage-secret-access-key} " +
            " | base64 --decode", returnStdout: true)
    def minioSecretString = """[global]
repo1-s3-key=$minioAccessKeyId
repo1-s3-key-secret=$minioSecretAccessKey""".bytes.encodeBase64().toString()
    sh """ set +x; oc -n $NAMESPACE create secret generic s3-conf --from-literal=s3.conf=mock || :
           oc -n $NAMESPACE patch secret s3-conf -p '{"data": {"s3.conf": "${minioSecretString}"}}' || : """
}

return this;
