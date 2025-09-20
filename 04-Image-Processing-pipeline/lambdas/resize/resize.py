import json
import urllib.parse
import boto3
from PIL import Image
import io
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)
s3 = boto3.client('s3')

def resize_image(event, context):
    logger.info("Lambda triggered")
    logger.debug(f"Event: {json.dumps(event)}")
    # The event payload contains a 'Records' list.
    for record in event['Records']:

        # Extract bucket name and object key
        bucket = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        
        # Define destination bucket and key
        destination_bucket_name = 'pipeline-output-images-ashab'
        resized_object_key = f"resized_{object_key}"

        try:
            # Download image from source S3
            response = s3.get_object(Bucket=bucket, Key=object_key)
            image_content = response['Body'].read()

            # Open and resize image using Pillow
            img = Image.open(io.BytesIO(image_content))
            img.thumbnail((128, 128))  # Example: resize to a thumbnail size

            # Save resized image to BytesIO object
            buffer = io.BytesIO()
            img.save(buffer, format=img.format)
            buffer.seek(0)

            # Upload resized image to destination S3
            s3.put_object(
                Bucket=destination_bucket_name,
                Key=resized_object_key,
                Body=buffer,
                ContentType=f"image/{img.format.lower()}"
            )
            print(f"Successfully resized {object_key} and uploaded to {destination_bucket_name}/{resized_object_key}")

        except Exception as e:
            print(f"Error processing {object_key}: {e}")
            raise e
        
        # # The object key is URL-encoded, so it must be unquoted.
        # unquoted_key = urllib.parse.unquote_plus(key)

        # print(f"New object created in bucket '{bucket}' with key '{unquoted_key}'")

        # # Your custom logic goes here. For example, download the file
        # # or process its contents using boto3.