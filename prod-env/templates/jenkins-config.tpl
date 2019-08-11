{{- define "override_config_map" }}

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ template "jenkins.fullname" . }}
data:
  config.xml: |-
    <?xml version='1.0' encoding='UTF-8'?>
    <hudson>
      <disabledAdministrativeMonitors/>
      <version>{{ .Values.Master.ImageTag }}</version>
      <numExecutors>0</numExecutors>
      <mode>NORMAL</mode>
      <useSecurity>{{ .Values.Master.UseSecurity }}</useSecurity>
      <authorizationStrategy class="hudson.security.FullControlOnceLoggedInAuthorizationStrategy">
        <denyAnonymousReadAccess>true</denyAnonymousReadAccess>
      </authorizationStrategy>
      <securityRealm class="hudson.security.LegacySecurityRealm"/>
      <disableRememberMe>false</disableRememberMe>
      <projectNamingStrategy class="jenkins.model.ProjectNamingStrategy$DefaultProjectNamingStrategy"/>
      <workspaceDir>${JENKINS_HOME}/workspace/${ITEM_FULLNAME}</workspaceDir>
      <buildsDir>${ITEM_ROOTDIR}/builds</buildsDir>
      <markupFormatter class="hudson.markup.EscapedMarkupFormatter"/>
      <jdks/>
      <viewsTabBar class="hudson.views.DefaultViewsTabBar"/>
      <myViewsTabBar class="hudson.views.DefaultMyViewsTabBar"/>
      <clouds>
        <org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud plugin="kubernetes@{{ template "jenkins.kubernetes-version" . }}">
          <name>kubernetes</name>
          <templates>
{{- if .Values.Agent.Enabled }}
            <org.csanchez.jenkins.plugins.kubernetes.PodTemplate>
              <inheritFrom></inheritFrom>
              <name>default</name>
              <instanceCap>2147483647</instanceCap>
              <idleMinutes>0</idleMinutes>
              <label>{{ .Release.Name }}-{{ .Values.Agent.Component }}</label>
              <nodeSelector>
                {{- $local := dict "first" true }}
                {{- range $key, $value := .Values.Agent.NodeSelector }}
                  {{- if not $local.first }},{{- end }}
                  {{- $key }}={{ $value }}
                  {{- $_ := set $local "first" false }}
                {{- end }}</nodeSelector>
                <nodeUsageMode>NORMAL</nodeUsageMode>
              <volumes>
{{- range $index, $volume := .Values.Agent.volumes }}
                <org.csanchez.jenkins.plugins.kubernetes.volumes.{{ $volume.type }}Volume>
{{- range $key, $value := $volume }}{{- if not (eq $key "type") }}
                  <{{ $key }}>{{ $value }}</{{ $key }}>
{{- end }}{{- end }}
                </org.csanchez.jenkins.plugins.kubernetes.volumes.{{ $volume.type }}Volume>
{{- end }}
              </volumes>
              <containers>
                <org.csanchez.jenkins.plugins.kubernetes.ContainerTemplate>
                  <name>jnlp</name>
                  <image>{{ .Values.Agent.Image }}:{{ .Values.Agent.ImageTag }}</image>
{{- if .Values.Agent.Privileged }}
                  <privileged>true</privileged>
{{- else }}
                  <privileged>false</privileged>
{{- end }}
                  <alwaysPullImage>{{ .Values.Agent.AlwaysPullImage }}</alwaysPullImage>
                  <workingDir>/home/jenkins</workingDir>
                  <command></command>
                  <args>${computer.jnlpmac} ${computer.name}</args>
                  <ttyEnabled>false</ttyEnabled>
                  <resourceRequestCpu>{{.Values.Agent.Cpu}}</resourceRequestCpu>
                  <resourceRequestMemory>{{.Values.Agent.Memory}}</resourceRequestMemory>
                  <resourceLimitCpu>{{.Values.Agent.Cpu}}</resourceLimitCpu>
                  <resourceLimitMemory>{{.Values.Agent.Memory}}</resourceLimitMemory>
                  <envVars>
                    <org.csanchez.jenkins.plugins.kubernetes.ContainerEnvVar>
                      <key>JENKINS_URL</key>
                      <value>http://{{ template "jenkins.fullname" . }}.{{ .Release.Namespace }}:{{.Values.Master.ServicePort}}{{ default "" .Values.Master.JenkinsUriPrefix }}</value>
                    </org.csanchez.jenkins.plugins.kubernetes.ContainerEnvVar>
                  </envVars>
                </org.csanchez.jenkins.plugins.kubernetes.ContainerTemplate>
              </containers>
              <envVars/>
              <annotations/>
{{- if .Values.Agent.ImagePullSecret }}
              <imagePullSecrets>
                <org.csanchez.jenkins.plugins.kubernetes.PodImagePullSecret>
                  <name>{{ .Values.Agent.ImagePullSecret }}</name>
                </org.csanchez.jenkins.plugins.kubernetes.PodImagePullSecret>
              </imagePullSecrets>
{{- else }}
              <imagePullSecrets/>
{{- end }}
              <nodeProperties/>
            </org.csanchez.jenkins.plugins.kubernetes.PodTemplate>
{{- end -}}
          </templates>
          <serverUrl>https://kubernetes.default</serverUrl>
          <skipTlsVerify>false</skipTlsVerify>
          <namespace>{{ .Release.Namespace }}</namespace>
          <jenkinsUrl>http://{{ template "jenkins.fullname" . }}.{{ .Release.Namespace }}:{{.Values.Master.ServicePort}}{{ default "" .Values.Master.JenkinsUriPrefix }}</jenkinsUrl>
          <jenkinsTunnel>{{ template "jenkins.fullname" . }}-agent.{{ .Release.Namespace }}:50000</jenkinsTunnel>
          <containerCap>10</containerCap>
          <retentionTimeout>5</retentionTimeout>
          <connectTimeout>0</connectTimeout>
          <readTimeout>0</readTimeout>
        </org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud>
      </clouds>
      <quietPeriod>5</quietPeriod>
      <scmCheckoutRetryCount>0</scmCheckoutRetryCount>
      <views>
        <hudson.model.AllView>
          <owner class="hudson" reference="../../.."/>
          <name>All</name>
          <filterExecutors>false</filterExecutors>
          <filterQueue>false</filterQueue>
          <properties class="hudson.model.View$PropertyList"/>
        </hudson.model.AllView>
        <listView>
          <owner class="hudson" reference="../../.."/>
          <name>DEMO</name>
          <filterExecutors>false</filterExecutors>
          <filterQueue>false</filterQueue>
          <properties class="hudson.model.View$PropertyList"/>
          <jobNames>
            <comparator class="hudson.util.CaseInsensitiveComparator"/>
            <string>release-demo</string>
            <string>deploy-demo</string>
            <string>jira-deploy-demo</string>
          </jobNames>
          <jobFilters/>
          <columns>
            <hudson.views.StatusColumn/>
            <hudson.views.WeatherColumn/>
            <hudson.views.JobColumn/>
            <hudson.views.LastSuccessColumn/>
            <hudson.views.LastFailureColumn/>
            <hudson.views.LastDurationColumn/>
            <hudson.views.BuildButtonColumn/>
            <hudson.plugins.favorite.column.FavoriteColumn plugin="favorite@2.3.2"/>
          </columns>
          <recurse>false</recurse>
        </listView>
      </views>
      <primaryView>All</primaryView>
      <slaveAgentPort>50000</slaveAgentPort>
      <disabledAgentProtocols>
{{- range .Values.Master.DisabledAgentProtocols }}
        <string>{{ . }}</string>
{{- end }}
      </disabledAgentProtocols>
      <label></label>
{{- if .Values.Master.CSRF.DefaultCrumbIssuer.Enabled }}
      <crumbIssuer class="hudson.security.csrf.DefaultCrumbIssuer">
{{- if .Values.Master.CSRF.DefaultCrumbIssuer.ProxyCompatability }}
        <excludeClientIPFromCrumb>true</excludeClientIPFromCrumb>
{{- end }}
      </crumbIssuer>
{{- end }}
      <nodeProperties/>
      <globalNodeProperties/>
      <noUsageStatistics>true</noUsageStatistics>
    </hudson>
{{- if .Values.Master.ScriptApproval }}
  scriptapproval.xml: |-
    <?xml version='1.0' encoding='UTF-8'?>
    <scriptApproval plugin="script-security@1.27">
      <approvedScriptHashes/>
      <approvedSignatures>
{{- range $key, $val := .Values.Master.ScriptApproval }}
        <string>{{ $val }}</string>
{{- end }}
      </approvedSignatures>
      <aclApprovedSignatures/>
      <approvedClasspathEntries/>
      <pendingScripts/>
      <pendingSignatures/>
      <pendingClasspathEntries/>
    </scriptApproval>
{{- end }}
  com.ceilfors.jenkins.plugins.jiratrigger.JiraTriggerGlobalConfiguration.xml: |-
    <?xml version='1.1' encoding='UTF-8'?>
    <com.ceilfors.jenkins.plugins.jiratrigger.JiraTriggerGlobalConfiguration plugin="jira-trigger@1.0.0">
      <jiraRootUrl>https://jira-uat.agilesolutions.com/</jiraRootUrl>
      <jiraUsername>jctadmin</jiraUsername>
      <jiraPassword>{AQAAABAAAAAQlXg6bFfz7H0jzCbPm5+LkHbZmf3okreva+E1MfRTEjM=}</jiraPassword>
      <jiraCommentReply>true</jiraCommentReply>
    </com.ceilfors.jenkins.plugins.jiratrigger.JiraTriggerGlobalConfiguration>
  org.thoughtslive.jenkins.plugins.jira.Config.xml: |-
    <?xml version='1.1' encoding='UTF-8'?>
    <org.thoughtslive.jenkins.plugins.jira.Config_-ConfigDescriptorImpl plugin="jira-steps@1.4.5">
      <sites>
        <org.thoughtslive.jenkins.plugins.jira.Site>
          <name>bjb</name>
          <url>https://jira-uat.agilesolutions.com/</url>
          <loginType>BASIC</loginType>
          <timeout>10000</timeout>
          <readTimeout>10000</readTimeout>
          <userName>jctadmin</userName>
          <password>{AQAAABAAAAAQ5qWnEpQwri1NT8xR4rkynQbUE1lHgJuIxEsuSe7crnY=}</password>
          <consumerKey></consumerKey>
          <privateKey></privateKey>
          <secret>{AQAAABAAAAAQz4s2cYrww9uq3yRxjbj1W1Hh2DgF4ZWPOk3+Q1yElrU=}</secret>
          <token>{AQAAABAAAAAQE6nih1Ok85YTLiqJBz3BPRc27oe5S1wuslIi1bS0L20=}</token>
        </org.thoughtslive.jenkins.plugins.jira.Site>
      </sites>
    </org.thoughtslive.jenkins.plugins.jira.Config_-ConfigDescriptorImpl>
  org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml: |-
    <?xml version='1.1' encoding='UTF-8'?>
    <org.jenkinsci.plugins.workflow.libs.GlobalLibraries plugin="workflow-cps-global-lib@2.13">
      <libraries>
        <org.jenkinsci.plugins.workflow.libs.LibraryConfiguration>
          <name>bjb</name>
          <retriever class="org.jenkinsci.plugins.workflow.libs.SCMSourceRetriever">
            <scm class="jenkins.plugins.git.GitSCMSource" plugin="git@3.10.0">
              <id>2ed2ea8e-c8da-4b08-89a0-16256d3c12d0</id>
              <remote>https://bitbucket.agilesolutions.com/scm/res/springboot-helm-kubernetes.git</remote>
              <credentialsId>jenkins</credentialsId>
              <traits>
                <jenkins.plugins.git.traits.BranchDiscoveryTrait/>
              </traits>
            </scm>
          </retriever>
          <defaultVersion>master</defaultVersion>
          <implicit>true</implicit>
          <allowVersionOverride>true</allowVersionOverride>
          <includeInChangesets>true</includeInChangesets>
        </org.jenkinsci.plugins.workflow.libs.LibraryConfiguration>
      </libraries>
    </org.jenkinsci.plugins.workflow.libs.GlobalLibraries>
  plugins.txt: |-
{{- if .Values.Master.InstallPlugins }}
{{- range $index, $val := .Values.Master.InstallPlugins }}
{{ $val | indent 4 }}
{{- end }}
{{- end }}
{{- end -}}
