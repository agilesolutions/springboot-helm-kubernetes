def call(String mailRecipients, String message) {
   emailext (
       subject: "Input required for deployment ${env.JOB_NAME}",
       body: "${message}",
       to: "${mailRecipients}",
       replyTo: "java-admin@agilesolutions.com",
       recipientProviders: [[$class: 'DevelopersRecipientProvider']])
}
