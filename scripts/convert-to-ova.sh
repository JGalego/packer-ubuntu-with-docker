#!/bin/bash

# Converts an AMI into a disk image using VM import/export
# Tested with aws-cli/1.16.222 Python/2.7.12 Linux/4.4.0-1090-aws botocore/1.12.212
#
# References:
#   + VM Import/Export: https://aws.amazon.com/ec2/vm-import/
#
# Known Issues:
#   + EC2 API export to S3 ACL issue: https://forums.aws.amazon.com/thread.jspa?threadID=99336

echo "Retrieve AMI ID"
AMI_ID=$(aws ec2 describe-images --owners self \
                                 --filters "Name=name,Values=$AMI_NAME" \
                                 --query "Images[0].ImageId" \
                                 --output text)

echo "Starting a new instance from $AMI_ID"
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID \
                                    --count 1 \
                                    --instance-type $INSTANCE_TYPE \
                                    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ova-conversion}]" \
                                    --query "Instances[0].InstanceId" \
                                    --output text)

echo "Waiting for $INSTANCE_ID to start"
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

echo "Exporting instance as OVA"
EXPORT_TASK_ID=$(aws ec2 create-instance-export-task --instance-id $INSTANCE_ID \
                                                     --export-to-s3-task ContainerFormat=$CONTAINER_FORMAT,DiskImageFormat=$DISK_IMAGE_FORMAT,S3Bucket=$S3_BUCKET,S3Prefix=$AMI_NAME \
                                                     --target-environment $TARGET_ENVIRONMENT \
                                                     --query 'ExportTask.ExportTaskId' \
                                                     --output text)

echo "Waiting for the VM export task $EXPORT_TASK_ID to complete"
aws ec2 wait export-task-completed --export-task-ids $EXPORT_TASK_ID

echo "Terminating the instance"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

echo "Waiting for the instance to terminate"
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID
