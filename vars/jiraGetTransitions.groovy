def call() {
        	withEnv(['JIRA_SITE=agilesolutions']) {
				def transitions = jiraGetIssueTransitions  idOrKey:  env.JIRA_ISSUE_KEY
				echo transitions.data.toString()
            } // end with
}
