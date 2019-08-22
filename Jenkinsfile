node ('packer && awscli') {

    // Pipeline parameters
    properties([
        parameters([
        stringParam(
            description: 'Docker registry URL',
            name: 'REGISTRY_URL',
            defaultValue: 'registry.hub.docker.com'
        ),
        stringParam(
            description: 'Jenkins credentials for the Docker registry',
            name: 'REGISTRY_CREDENTIALS'
        ),
        stringParam(
            description: 'Docker image (REPO/NAME:TAG)',
            name: 'DOCKER_IMAGE',
            defaultValue: 'alpine'
        ),
        stringParam(
            description: 'S3 Bucket for storing the disk image',
            name: 'S3_BUCKET'
        ),
        stringParam(
            description: 'Container format (possible values: ova)',
            name: 'CONTAINER_FORMAT',
            defaultValue: 'ova'
        ),
        stringParam(
            description: 'Disk image format (possible values: VMDK, RAW or VHD)',
            name: 'DISK_IMAGE_FORMAT',
            defaultValue: 'VMDK'
        ),
        stringParam(
            description: 'Target environment (possible values: citrix, vmware or microsoft)',
            name: 'TARGET_ENVIRONMENT',
            defaultValue: 'vmware'
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
                                -var s3_bucket=${params.S3_BUCKET} \
                                -var container_format=${params.CONTAINER_FORMAT} \
                                -var disk_image_format=${params.DISK_IMAGE_FORMAT} \
                                -var target_environment=${params.TARGET_ENVIRONMENT} \
                                -var ami_name=${env.JOB_BASE_NAME}-${env.BUILD_NUMBER} \
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
