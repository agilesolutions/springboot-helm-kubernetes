def call() {
   timeout(time: 5, unit: 'MINUTES') {
             env.JIRA_ISSUE_KEY = input message: 'Specify ISSUE KEY', parameters: [string(defaultValue: '', description: '', name: 'JIRA_ISSUE_KEY')]
             withEnv(['JIRA_SITE=agilesolutions']) {
	             def issue = jiraGetIssue idOrKey: env.JIRA_ISSUE_KEY, site: 'agilesolutions'
			     env.VERSION = issue.data.fields.get("summary")
			     echo "deploying version ${env.VERSION} through deployment ticket ${env.JIRA_ISSUE_KEY}"
			 }
    }
}
