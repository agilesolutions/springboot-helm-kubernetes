def call() {
             withEnv(['JIRA_SITE=agilesolutions']) {
	             def issue = jiraGetIssue idOrKey: env.JIRA_ISSUE_KEY, site: 'agilesolutions'
			     env.VERSION = issue.data.fields.get("summary")
			     echo "deploying version ${env.VERSION} through deployment ticket ${env.JIRA_ISSUE_KEY}"
			 }
}
