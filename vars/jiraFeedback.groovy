def call(String comment) {

   if (env.JIRA_ISSUE_KEY) {
        withEnv(['JIRA_SITE=agilesolutions']) {
          echo "Tagging JIRA deployment ticket - ${env.JIRA_ISSUE_KEY}"
          jiraAddComment idOrKey: env.JIRA_ISSUE_KEY , comment: "${comment}"
       }
   }
}
