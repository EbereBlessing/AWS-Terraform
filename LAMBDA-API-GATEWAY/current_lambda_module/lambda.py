import json
import os

def lambda_handler(event, context):
    version = os.getenv('VERSION', 'initial')
    response = {
        'statusCode': 200,
        'body': json.dumps({
            'message': f'Hello From Canary Deployment  {version}!',
            'input': event
        })
    }
    return response


   

