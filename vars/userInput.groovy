def call() {
   timeout(time: 5, unit: 'MINUTES') {
             env.RELEASE_SCOPE = input message: 'User input 				required', ok: 'Release!',
             parameters: [choice(name: 'RELEASE_SCOPE', choices: 		'SIT\nUAT\nPROD', description: 'What is the release scope?')]
            }
}
