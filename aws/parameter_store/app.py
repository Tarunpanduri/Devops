# param store retrival from aws
import boto3
from dotenv import load_dotenv
import os
load_dotenv()

ssm = boto3.client('ssm', 
                   aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'), 
                   aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
                   region_name=os.getenv('AWS_REGION')) 

parameter = ssm.get_parameter(Name='calculation_values', WithDecryption=True)
print("Parameter Value:", parameter['Parameter']['Value'])
values = parameter['Parameter']['Value'].split(',')
result = int(values[0]) + int(values[1])
print("Addition Result:", result)


# we can retrive the parameters aand use as per our requirement like mongo db connection strings etc.