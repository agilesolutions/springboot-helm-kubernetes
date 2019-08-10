def call(project, chartVersion, museumAddr, replaceTag = false, failIfExists = false) {
    withCredentials([usernamePassword(credentialsId: "chartmuseum", usernameVariable: "USER", passwordVariable: "PASS")]) {
        if (failIfExists) {
            yaml = readYaml file: "charts/${project}/Chart.yaml"
            out = sh returnStdout: true, script: "curl -u $USER:$PASS http://${museumAddr}/api/charts/${project}/${yaml.version}"
            if (!out.contains("error")) {
                error "Did you forget to increment the Chart version?"
            }
        }
        if (replaceTag) {
            yaml = readYaml file: "charts/${project}/values.yaml"
            yaml.image.tag = currentBuild.displayName
            sh "rm -f charts/${project}/values.yaml"
            writeYaml file: "charts/${project}/values.yaml", data: yaml
        }
        sh "helm package charts/${project}"
        packageName = "${project}-${chartVersion}.tgz"
        if (chartVersion == "") {
            packageName = sh(returnStdout: true, script: "ls ${project}*").trim()
        }
        sh """curl -u $USER:$PASS --data-binary "@${packageName}" http://${museumAddr}/api/charts"""
    }
}
