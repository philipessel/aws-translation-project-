""" 
import boto3

s3 = boto3.client('s3')
translate = boto3.client('translate')

def process_translation(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Download file
    s3.download_file(bucket, key, '/tmp/input.json')

    # Read and translate text
    with open('/tmp/input.json', 'r') as file:
        text = file.read()
    result = translate.translate_text(
        Text=text,
        SourceLanguageCode='en',
        TargetLanguageCode='de'
    )

    # Save and upload the translated text
    translated_text = result['TranslatedText']
    with open('/tmp/output.json', 'w') as file:
        file.write(translated_text)
    s3.upload_file('/tmp/output.json', 'translation-responses-229895649975', key)

 """

""""
import boto3
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client('s3')
translate = boto3.client('translate')

def process_translation(event, context):
    try:
        # Log incoming event
        logger.info("Received event: %s", event)
        
        # Extract S3 bucket and key from the event
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        logger.info(f"Processing file from bucket: {bucket}, key: {key}")

        # Download file from S3
        logger.info(f"Downloading file {key} from bucket {bucket}...")
        s3.download_file(bucket, key, '/tmp/input.json')
        logger.info(f"File downloaded successfully: {key}")

        # Read and translate text
        with open('/tmp/input.json', 'r') as file:
            text = file.read()
        logger.info("Text read from file successfully.")

        # Translate text using AWS Translate
        logger.info("Starting translation...")
        result = translate.translate_text(
            Text=text,
            SourceLanguageCode='en',
            TargetLanguageCode='es'
        )
        logger.info("Translation successful.")

        # Save and upload the translated text to S3
        translated_text = result['TranslatedText']
        with open('/tmp/output.json', 'w') as file:
            file.write(translated_text)
        logger.info("Translated text written to /tmp/output.json.")

        # Upload the translated file back to S3
        s3.upload_file('/tmp/output.json', 'translation-responses-229895649975', key)
        logger.info(f"Translated file uploaded to S3 bucket: translation-responses-229895649975, key: {key}")

    except Exception as e:
        logger.error(f"Error during translation process: {str(e)}")
        raise e

    logger.info("Translation process completed successfully.")
 """


import json
import boto3
import logging
import os
import uuid

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client('s3')
translate = boto3.client('translate')

RESPONSE_BUCKET = 'translation-responses-229895649975'  # Replace with your actual response bucket name

def process_translation(event, context):
    try:
        if event['httpMethod'] == 'POST':
            # Log incoming event for POST request
            logger.info("Received event for POST: %s", event)
            
            # Extract text from event (assumed to be in the body for POST request)
            body = event['body']
            if body:
                text = body
                logger.info("Received text for translation: %s", text)

                # Store text in input S3 bucket
                s3_key = f"input_{uuid.uuid4()}.json" # Use unique ID for the input key
                s3.put_object(Bucket=event['REQUEST_BUCKET'], Key=s3_key, Body=text)

                # Translate text using AWS Translate
                logger.info("Starting translation...")
                result = translate.translate_text(
                    Text=text,
                    SourceLanguageCode='en',
                    TargetLanguageCode='de'
                )
                logger.info("Translation successful.")

                # Save and upload the translated text to S3
                translated_text = result['TranslatedText'] 
                output_key = f"output_{uuid.uuid4()}.json" # Use unique ID for the output key
                s3.put_object(Bucket=RESPONSE_BUCKET, Key=output_key, Body=translated_text)
                logger.info(f"Translated text uploaded to S3 with key: {output_key}")

                # Return translated text
                return {
                    "statusCode": 200,
                    "body": json.dumps({"translatedText": translated_text, "id": output_key})
                }

        elif event['httpMethod'] == 'GET':
            # Log incoming event for GET request
            logger.info("Received event for GET: %s", event)
            
            # Extract request ID from path parameters
            request_id = event['pathParameters']['id']
            logger.info(f"Retrieving translation result for ID: {request_id}")

            # Retrieve the translated text from the output S3 bucket
            try:
                response = s3.get_object(Bucket=RESPONSE_BUCKET, Key=request_id)
                translated_text = response['Body'].read().decode('utf-8')
                logger.info(f"Retrieved translated text for ID: {request_id}")

                # Return the translated text
                return {
                    "statusCode": 200,
                    "body": json.dumps({"translatedText": translated_text})
                }
            except Exception as e:
                logger.error(f"Error retrieving translation: {str(e)}")
                return {
                    "statusCode": 404,
                    "body": json.dumps({"error": f"Translation result not found for ID: {request_id}"})
                }

    except Exception as e:
        logger.error(f"Error during processing: {str(e)}")
        raise e
