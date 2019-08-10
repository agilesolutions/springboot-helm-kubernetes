#!groovy
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import groovy.json.*
import java.text.SimpleDateFormat
def call(String profile) {
	// like this date format 2017-09-14T17:48:24+02:00
	def dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
	dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
	def startDate = new Date()
	startDate.setDate(startDate.getDate())
	def endDate = new Date()
	endDate.setTime(endDate.getTime() + 1800000)
	def USER = wrap([$class: 'BuildUser']) {
    	return env.BUILD_USER
	}		
	sh(returnStdout: true, script: "curl --silent --insecure -o profile.json https://jctd/rest/profile/${profile}")
	def data = readJSON file:'profile.json'
//	def configurationItem = "SI-JBOSS-${data.prefix}-${data.hostName}".toUpperCase()
	def configurationItem = "SI-JBOSS-${data.hostName}".toUpperCase()
	echo "set Outage on CI ${configurationItem}"
		
	withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'CMDB',usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
		def url = "https://hpsmprod01.agilesolutions.com:13192/SM/9/rest/PlannedOutages"
		def payload = JsonOutput.toJson(["PlannedOutage":["action": "create","cis":["${configurationItem}"],"description":["Outage because of JCT deployment"],"title": "Outage with RestAPI","outageEnd":dateFormat.format(endDate),"outageStart":dateFormat.format(startDate),"requestedBy":"u15968"]])
		def response = sh(returnStdout: true, script: "curl -s --insecure -o response.json -u ${USERNAME}:${PASSWORD} -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '${payload}' ${url} --connect-timeout 5").trim()
		def responseData = readJSON file:'response.json'
	    echo "set Outage change ID " + responseData.PlannedOutage.changeId
	    return responseData.PlannedOutage.changeId;
	}
}
