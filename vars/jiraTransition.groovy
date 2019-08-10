def call() {
        	withEnv(['JIRA_SITE=agilesolutions']) {
        			echo "Complete JIRA deployment ticket ${env.JIRA_ISSUE_KEY}"
        			def transitionInput =
						[
        						transition: [id: '761']
    					]

				jiraTransitionIssue idOrKey:  env.JIRA_ISSUE_KEY, input: transitionInput

            } // end with
}
