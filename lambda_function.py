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
