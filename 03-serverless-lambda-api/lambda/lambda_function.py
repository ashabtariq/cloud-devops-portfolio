import json
from boto3.dynamodb.conditions import Key, Attr
import hashlib
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('url_shortner')


def lambda_handler(event, context):
    body = json.loads(event.get("body", "{}"))
    #original_url = body.get("url")
    long_url = body.get("url")
    short_code = hashlib.sha256(long_url.encode()).hexdigest()[:8]
    shorten_url = 'http://localhost:5000/'+short_code
    table.put_item(Item={'short_code':short_code,'long_url': long_url,'short_url':  shorten_url})
    
    response = {
        "statusCode": 200,
        "body": json.dumps({
            "original_url": long_url,
            "short_url": shorten_url
        }),
    }
    return response
    

