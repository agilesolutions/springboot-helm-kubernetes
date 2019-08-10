def call(String mailRecipients, String message) {
            emailext (
      		subject: "${message}",
      		body: "${message}",
	        to: "${mailRecipients}",
      		replyTo: "java-admin@agilesolutions.com")
}
