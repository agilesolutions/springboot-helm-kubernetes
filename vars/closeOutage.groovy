#!groovy
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import groovy.json.*
import java.text.SimpleDateFormat
def call(String changeId) {

		def USER = wrap([$class: 'BuildUser']) {
     		return env.BUILD_USER
		}	
		
		withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'CMDB',usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
		def url = "https://hpsmprod01.agilesolutions.com:13192/SM/9/rest/PlannedOutages"
		def payload = JsonOutput.toJson(["PlannedOutage":["action": "close","changeId":"${changeId}","description":["Outage because of JCT deployment"],"requestedBy":"u15968"]])
		def response = sh(returnStdout: true, script: "curl  -s --insecure -o response.json  u ${USERNAME}:${PASSWORD} -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '${payload}' ${url}").trim()
		def data = readJSON file:'response.json'
		}
}
