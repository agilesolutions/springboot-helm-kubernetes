 def call(repository, image, version) {
    //tagBeta = "${currentBuild.displayName}-${env.BRANCH_NAME}"
    
    sh 'docker image tag ${image}:${version} ${repository}/${image}:${version}'
    
    withCredentials([usernamePassword(
        credentialsId: "docker",
        usernameVariable: "USER",
        passwordVariable: "PASS")]) {
        	sh 'docker login -u $USER -p $PASS'
    	}
    	sh 'docker image push ${repository}/${image}:${version}'
 }