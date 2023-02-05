pipeline {
   agent any
   stages {
       stage('Test Code') {
           steps {
               echo "This test is running ${env.BUILD_ID} on ${env.JENKINS_URL}"
               sh '''
               echo "----TEST CODE-----"
               echo "-----------------------"
              
               '''
           }
       }
      stage('Deploy Code') {
          steps {
               sh '''
               echo "Deploying Code"
               echo "-------------"
               '''
          }
      }
      stage ('Notification on Telegram') {
         steps {
            telegramSend 'Deploy on branch MAIN was SUCCESS'
            
         }
      }
   }
}
