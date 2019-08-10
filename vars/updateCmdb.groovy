#!groovy
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import groovy.json.*
import java.text.SimpleDateFormat
def call(String version) {
		// like this date format 2017-09-14T17:48:24+02:00
		def dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
		def date = new Date()
		date.setDate(date.getDate()+1)
		withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'CMDB',usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
		def url = "http://hpsmuat01.agilesolutions.com:13190/SM/9/rest/cmdbUpdateV001"
		def payload = JsonOutput.toJson(["cmdbUpdate":["requestedBy": "requestedBy","plannedEnd":dateFormat.format(date),"title":"Test","description": ["jenkins pipeline test"], "updateContent": [["ciName":"${env.CI}","ciField":"version","newValue":"${version}"]]]])
		def response = sh(returnStdout: true, script: "curl -s -u ${USERNAME}:${PASSWORD} -H \"Accept: application/json;charset=UTF-8\" -H \"Content-type: application/json\" -X POST -d '${payload}' ${url}").trim()
	}
}
