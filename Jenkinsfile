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
                    sh "env"
                    sh "git config --global color.ui true"
                    sh "ls --color=always -l"
                    env.VERSION = sh(script: "bin/version.py", returnStdout: true).trim()
                    currentBuild.description = env.VERSION
                }
            }
        }
        //stage('virtualenv') {
        //    steps {
        //        sh "python3 -m venv ${env.VENV}"
        //        sh "pip install -U west"
        //    }
        //}
        stage('make') {
            steps {
                sh "make firmware"
            }
        }
        //stage('keymap-editor-web') {
        //    steps {
        //        script {
        //            dir("Adv360-Pro-KeymapEditor") {
        //                git "https://github.com/KinesisCorporation/Adv360-Pro-KeymapEditor"
        //            }
        //            sh ".pipeline/build-keymap-editor-web.sh"
        //        }
        //    }
        //}
        stage('publish') {
            when {
                branch "main"
            }
            steps {
                archiveArtifacts(
                    artifacts: "dist/firmware/Adv360-firmware_${env.VERSION}.tar.gz,dist/firmware/Adv360_firmware_${env.VERSION}.txt",
                    fingerprint: true
                )
                withCredentials([string(credentialsId: "gitea-user-ben-full-token", variable: 'GITEA_SECRET')]) {
                    sh 'curl -i -H "Authorization: token $GITEA_SECRET" --upload-file dist/firmware/Adv360-firmware_${VERSION}.tar.gz https://git.sudo.is/api/packages/ben/generic/kinesis360/${VERSION}/Adv360-firmware_${VERSION}.tar.gz'
                    // add -s -f to silence and fail on errors
                }
            }
        }
    }
    post {
        always {
            sh "docker image ls"
        }
        cleanup {
            sh "make clean"
            cleanWs(deleteDirs: true, disableDeferredWipeout: true, notFailBuild: true)
            dir(env.VENV) {
                deleteDir()
            }
       }
   }
}
