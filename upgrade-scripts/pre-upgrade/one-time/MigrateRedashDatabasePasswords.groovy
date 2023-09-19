void call(){
    String cli = "oc -n ${NAMESPACE}"
    String targetSecretName = "citus-roles-secrets"

    ["admin","viewer"].each {name ->
        String secretName = "redash-" + name + "-secret"
        String databasePodName = "redash-" + name + "-postgresql-0"
        String targetKeyName = "redash"+ name.capitalize() + "RolePass"
        def checkDatabasesExist = sh(script: "${cli} get pod ${databasePodName}"
                + " --ignore-not-found", returnStdout: true)
        if (checkDatabasesExist) {
            String secretData = sh(script: "${cli} get secret ${secretName} " +
                    "-o jsonpath={.data.postgresqlPassword}", returnStdout: true).trim()
            sh "${cli} patch secret $targetSecretName --type=json " +
                    " -p='[{\"op\":\"add\",\"path\": \"/data/$targetKeyName\",\"value\": \"$secretData\"}]'"
        }
    }
}

return  this;