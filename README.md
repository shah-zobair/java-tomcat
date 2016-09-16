# java-tomcat

**Execute from Openshift CLI**
```
oc new-project tomcat
oadm policy add-scc-to-user anyuid -z default
oc new-app https://github.com/shah-zobair/java-tomcat.git
```
The Project should have privilege access to run this pod.

**Check status**
```
oc get pods
oc logs -f <Build_Pod_Name>
```


Ref: https://github.com/kirillF/centos-tomcat
