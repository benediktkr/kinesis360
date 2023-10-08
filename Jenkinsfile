// https://zmk.dev/docs/development/setup#install-west

pipeline {
    agent any
    options {
        timestamps()
        ansiColor("xterm-256color")
        disableConcurrentBuilds()
        buildDiscarder(logRotator(daysToKeepStr: '30', numToKeepStr: '10', artifactNumToKeepStr: '1'))
    }
      environment {
        VENV = "${env.WORKSPACE}@tmp/cache/venv"
        PATH = "${env.VENV}/bin:${HOME}/.local/bin:${PATH}"
    }
    stages {
        stage('checkout') {
            steps {
                script {
                    env.VERSION = sh(script: "date -I", returnStdout: true).trim().replace("-",".")
                    currentBuild.description = env.VERSION
                    sh "ls --color=always -l"
                }
            }
        }
        stage('virtualenv') {
            steps {
                sh "python3 -m venv ${env.VENV}"
                sh "pip install -U west"
            }
        }
        stage('make') {
            steps {
                sh "make"
            }
        }
    }
    post {
        success {
            archiveArtifacts(
                artifacts: "firmware/Adv360-firmware_${env.VERSION}.tar.gz,firmware/*.sha256.txt",
                fingerprint: true
                )
            withCredentials([string(credentialsId: "gitea-user-ben-full-token", variable: 'GITEA_SECRET')]) {
                sh 'curl -s -i -f -H "Authorization: token $GITEA_SECRET" --upload-file firmware/Adv360-firmware_${VERSION}.tar.gz https://git.sudo.is/api/packages/ben/generic/kinesis360/${VERSION}/Adv360-firmware_${VERSION}.tar.gz'
            }
        }
        always {
            //sh "which python3 python pip hatch"
            sh "python3 --version"
            //sh "hatch --version"
        }
        cleanup {
            cleanWs(deleteDirs: true, disableDeferredWipeout: true, notFailBuild: true)
       }
   }
}
