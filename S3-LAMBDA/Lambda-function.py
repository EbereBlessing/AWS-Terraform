import json
import csv
import boto3
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    try:
        # Get the S3 bucket and object key from the event
        source_bucket = event['Records'][0]['s3']['bucket']['name']
        object_key = event['Records'][0]['s3']['object']['key']
        
        # Extract the filename without extension, the ensure persist file name conversion
        base_filename = os.path.splitext(object_key)[0]
        
        # Download the JSON file from S3
        download_path = '/tmp/{}'.format(object_key)
        s3.download_file(source_bucket, object_key, download_path)
        
        # Read and process the JSON data
        with open(download_path, 'r') as json_file:
            try:
                data = json.load(json_file)
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON: {e}")
                return {
                    'statusCode': 400,
                    'body': json.dumps('Error decoding JSON')
                }
        
        # Ensure the 'json_data' key exists and is a list
        if 'json_data' not in data (data['json_data'], list):
            print(f"Expected 'json_data' to be a list, but got {type(data.get('json_data')).__name__}")
            return {
                'statusCode': 400,
                'body': json.dumps('Invalid JSON structure')
            }
        
        # Filter and group data
        json_data = data['json_data']
        filtered_data = [item for item in json_data if item.get('status_reason') != "think_it_passed"]
        grouped_data = {}
        for item in filtered_data:
            status = item.get('status')
            reason = item.get('status_reason')
            if status not in grouped_data:
                grouped_data[status] = {}
            if reason not in grouped_data[status]:
                grouped_data[status][reason] = 0
            grouped_data[status][reason] += 1
        
        # Convert to CSV
        csv_data = []
        for status, reasons in grouped_data.items():
            for reason, count in reasons.items():
                csv_data.append([status, reason, count])
        
        csv_file_path = '/tmp/{}.csv'.format(base_filename)
        with open(csv_file_path, 'w', newline='') as csvfile:
            csvwriter = csv.writer(csvfile)
            csvwriter.writerow(['Status', 'Status Reason', 'Count'])
            csvwriter.writerows(csv_data)
        
        # Upload the CSV file to the destination S3 bucket
        destination_bucket = 'aws-destination-001'  #input destination bucket name
        s3.upload_file(csv_file_path, destination_bucket, '{}.csv'.format(base_filename))
        
        return {
            'statusCode': 200,
            'body': json.dumps('CSV file created and uploaded successfully!')
        }
    except Exception as e:
        print(f"An error occurred: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('An internal error occurred')
        }
