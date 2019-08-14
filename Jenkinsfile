node ('packer && virtualbox') {

    // Pipeline parameters
    properties([
        parameters([
        stringParam(
            description: 'Docker registry URL',
            name: 'REGISTRY_URL'
        ),
        stringParam(
            description: 'Jenkins credentials for the Docker registry',
            name: 'REGISTRY_CREDENTIALS'
        ),
        stringParam(
            description: 'Docker image (REPO/NAME:TAG)',
            name: 'DOCKER_IMAGE'
        )
        ])
    ])

    try {
        stage ("Checkout") {
            checkout scm
        }

        stage ("Build") {
            withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${params.REGISTRY_CREDENTIALS}",
                                                                      usernameVariable: 'REGISTRY_USERNAME', 
                                                                      passwordVariable: 'REGISTRY_PASSWORD']]) {
                ansiColor('xterm') {
                    sh """
                    packer build -var registry_url=${params.REGISTRY_URL} \
                                -var registry_username=$REGISTRY_USERNAME \
                                -var registry_password=$REGISTRY_PASSWORD \
                                -var docker_image=${params.DOCKER_IMAGE} \
                                ubuntu1804.json
                    """
                }
            }
        }
    } catch (err) {
        echo err.getMessage()
        currentBuild.result = 'FAILURE'
    } finally {
        stage ('Clean workspace') {
            deleteDir()
        }
    }
}
