#!/bin/bash

# Set the IAM role ARN
IAM_ROLE_ARN="arn:aws:iam::679670268270:role/temp_role"

# Set the source file path
SOURCE_FILE_PATH="/home/sai/pod.yml"
# Set the destination S3 bucket and object key
DESTINATION_BUCKET="may25-test-bucket"
DESTINATION_OBJECT_KEY="pod.yml"


# Set the AWS region
REGION="us-east-2" 

# Assume the IAM role
TEMP_ROLE=$(aws sts assume-role --role-arn "$IAM_ROLE_ARN" --role-session-name "AssumeRoleSession" --region "us-east-2" --profile firstuser)

#echo $TEMP_ROLE
# Extract temporary credentials from the assumed role response
AWS_ACCESS_KEY_ID=$(echo "$TEMP_ROLE" | jq -r '.Credentials.AccessKeyId')
#echo "$AWS_ACCESS_KEY_ID"
AWS_SECRET_ACCESS_KEY=$(echo "$TEMP_ROLE" | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo "$TEMP_ROLE" | jq -r '.Credentials.SessionToken')

# Configure the AWS CLI with the temporary credentials
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set aws_session_token "$AWS_SESSION_TOKEN"

# Upload the file to S3
aws s3 cp "$SOURCE_FILE_PATH" "s3://$DESTINATION_BUCKET/$DESTINATION_OBJECT_KEY" --region "$REGION"
