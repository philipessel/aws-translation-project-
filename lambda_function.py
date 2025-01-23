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
        TargetLanguageCode='es'
    )

    # Save and upload the translated text
    translated_text = result['TranslatedText']
    with open('/tmp/output.json', 'w') as file:
        file.write(translated_text)
    s3.upload_file('/tmp/output.json', 'translation-responses', key)
