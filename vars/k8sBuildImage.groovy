def call(image, version) {
    //tagBeta = "${currentBuild.displayName}-${env.BRANCH_NAME}"
    sh 'docker image build -t ${image}:${version} --build-arg some_variable_name=${version} .'
    withCredentials([usernamePassword(
        credentialsId: "docker",
        usernameVariable: "USER",
        passwordVariable: "PASS")]) {
        	sh 'docker login -u $USER -p $PASS'
    	}
    sh 'docker image push ${image}:${version}'
}