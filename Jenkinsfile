pipeline {
    agent any

    environment {
        EC2_IP = '15.207.105.21'
    }

    stages {

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Approval') {
            steps {
                input message: 'Do you want to create the EC2 instance?', ok: 'Apply'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Deploy Website') {
            steps {
                sh '''
                    echo "Deploying website to $EC2_IP..."

                    ssh -o StrictHostKeyChecking=no \
                        -i ~/.ssh/jenkins_ec2 \
                        ubuntu@$EC2_IP \
                        "sudo mkdir -p /var/www/html"

                    scp -o StrictHostKeyChecking=no \
                        -i ~/.ssh/jenkins_ec2 \
                        index.html \
                        ubuntu@$EC2_IP:/tmp/index.html

                    ssh -o StrictHostKeyChecking=no \
                        -i ~/.ssh/jenkins_ec2 \
                        ubuntu@$EC2_IP \
                        "sudo cp /tmp/index.html /var/www/html/index.html && sudo systemctl restart apache2"

                    echo "Website deployment completed!"
                '''
            }
        }
    }
}
