# java-tomcat

**Execute from Openshift CLI**

```
oc new-project tomcat
oc new-app https://github.com/shah-zobair/java-tomcat.git
```

**Check status**

```
oc get pods
oc logs -f <Build_Pod_Name>
```
