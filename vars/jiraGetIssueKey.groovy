#!/usr/bin/groovy
def call() {
    try {
        echo "Get JIRA issue key from current branchname - ${env.BRANCH_NAME}"

        def keyId = "${env.BRANCH_NAME}".substring("${env.BRANCH_NAME}".indexOf("/") + 1);
        def firstIndx = keyId.indexOf('-') + 1;
        def secIndex = keyId.indexOf('-', firstIndx);

        if(secIndex > 0) {
            env.JIRA_ISSUE_KEY = keyId.substring(0, secIndex);
        }

        echo "JIRA Ticket Id - ${env.JIRA_ISSUE_KEY}"

    } catch (Exception e) {
        echo "Error in the build release, " + e.getMessage()
        return e
    }
}