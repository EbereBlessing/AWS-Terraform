import json
import os

def lambda_handler(event, context):
    # Get the version from an environment variable
    version = os.getenv('VERSION', 'v1')
    response = {
        'statusCode': 200,
        'body': json.dumps({
            'message': f'Hello From New Version Canary Deployment {version}!',
            'input': event
        })
    }
    return response
