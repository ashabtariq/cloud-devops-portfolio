import boto3
from boto3.dynamodb.conditions import Key, Attr

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('url_shortner_db') # Replace with your table name

# table.put_item(
#     TableName='url_shortner_db',
#     Item={
#         'short_code': {'S': '2222fdc'},
#         'long_url': {'S': 'http://google.com'},
#         'short_url': {'S': 'http://bit.ly/345234'}
        
        
#     }
# )

shortCode = '2222fdc'


try:
  #Retrieve an item
  response = table.get_item(
    Key={'short_code': shortCode},
    # ... other parameters ... https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/dynamodb.html#DynamoDB.Table.get_item
)
  item = response['Item']
except Exception as e:
    print(f"Error querying DynamoDB: {e}")

#response = dynamodb.describe_table(TableName='url_shortner_db')
print(item)