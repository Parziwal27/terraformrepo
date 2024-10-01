pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = '381492312721'  // Replace with your AWS Account ID
        AWS_REGION     = 'ap-south-1'     // Replace with your AWS region
        S3_BUCKET      = 'my-terraform-state-bucket-pz-202310056'  // Replace with your bucket name
    }
    stages {
        stage('Clone repository') {
            steps {
                // Clone the Git repository
                git 'https://github.com/Parziwal27/terraformrepo'
            }
        }
        stage('Terraform Init') {
            steps {
                // Provide AWS credentials and run Terraform init
                withCredentials([
                    usernamePassword(
                        credentialsId: 'e9612560-85f0-4df0-9e9e-bc5437cf1590',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    dir('.') { // Change '.' to the correct directory if your .tf files are not in the root
                        sh '''
                        terraform init -backend-config="bucket=${S3_BUCKET}" \
                                       -backend-config="key=terraform.tfstate" \
                                       -backend-config="region=${AWS_REGION}"
                        '''
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                // Run Terraform apply
                withCredentials([
                    usernamePassword(
                        credentialsId: 'e9612560-85f0-4df0-9e9e-bc5437cf1590',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    dir('.') { // Change '.' to the correct directory if your .tf files are not in the root
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
    post {
        failure {
            echo 'Job failed. Running terraform destroy to clean up resources...'
            withCredentials([
                usernamePassword(
                    credentialsId: 'e9612560-85f0-4df0-9e9e-bc5437cf1590',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )
            ]) {
                dir('.') { // Change '.' to the correct directory if your .tf files are not in the root
                    sh '''
                    terraform init -backend-config="bucket=${S3_BUCKET}" \
                                   -backend-config="key=terraform.tfstate" \
                                   -backend-config="region=${AWS_REGION}"
                    terraform destroy -auto-approve
                    '''
                }
            }
        }
        always {
            cleanWs()
        }
    }
}
