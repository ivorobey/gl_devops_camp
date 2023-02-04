import hudson.model.*
import hudson.security.*
import hudson.tasks.Mailer

def instance = jenkins.model.Jenkins.instance

def user = instance.securityRealm.createAccount(env.JENKINS_USER, env.JENKINS_PASS)
user.addProperty(new Mailer.UserProperty(env.JENKINS_EMAIL));
user.setFullName(env.JENKINS_FULLNAME)
user.setDescription("Account via groovy generated")
user.save()