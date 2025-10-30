import boto3
from dotenv import load_dotenv
import os
load_dotenv()
s3 = boto3.client('s3', 
                  aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'), 
                  aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
                  region_name=os.getenv('AWS_REGION'))

#print available buckets
response = s3.list_buckets()
print('Existing buckets:')
for bucket in response['Buckets']:
    print(f'  {bucket["Name"]}')


#download a file from s3 bucket
s3.download_file('devops-s3-buckets', 'Aadhaar.txt', '/home/tarun-panduri/Projects/Devops/aws/s3_buckets/Aadhaar.txt') 
print("Download Successful!")

#upload a file to s3 bucket
s3.upload_file('/home/tarun-panduri/Projects/Devops/aws/s3_buckets/Aadhaar.txt', 'devops-s3-buckets', 'Aadhaar.txt')
print("Upload Successful!")

#delete a file from s3 bucket
s3.delete_object(Bucket='devops-s3-buckets', Key='Aadhaar.txt')
print("Delete Successful!")

#list files in s3 bucket
response = s3.list_objects_v2(Bucket='devops-s3-buckets')
print('Files in bucket:')
for obj in response.get('Contents', []):
    print(f'  {obj["Key"]}')    