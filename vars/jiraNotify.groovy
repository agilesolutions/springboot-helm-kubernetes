def call() {
        	withEnv(['JIRA_SITE=agilesolutions']) {
        		echo "Notify JIRA watchers ${env.JIRA_ISSUE_KEY}"
				def notify = [ subject: 'Update about ',
                    textBody: 'Update on deployment ticket ...',
                   	htmlBody: 'Update on deployment ticket ...',
                   	to: [ reporter: true,assignee: true]]
    			jiraNotifyIssue idOrKey: env.JIRA_ISSUE_KEY, notify: notify
            } // end with
}
