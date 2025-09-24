import boto3
import logging
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

iam = boto3.client("iam")


def handler(event, context):
    logger.info("Received event: %s", json.dumps(event['detail']))  # ✅ Proper logging

    try:
        user = event['detail']['responseElements']['accessKey']['userName']
        logger.info(user)
    except KeyError:
        logger.error("No userName found in event: %s", json.dumps(event)['detail'])
        return {"status": "error", "reason": "No userName"}
    
    # List access keys for this user
    keys = iam.list_access_keys(UserName=user)["AccessKeyMetadata"]
    logger.info("Found %d keys for user %s", len(keys), user)
    
    for key in keys:
        key_id = key["AccessKeyId"]
        iam.update_access_key(UserName=user, AccessKeyId=key_id, Status="Inactive")
        logger.info("Disabled key %s for user %s", key_id, user)

    return {"status": "Key Deactivated", "user": user, "keys": key_id}

    
    
