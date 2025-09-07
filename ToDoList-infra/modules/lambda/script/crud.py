import json
import boto3
from uuid import uuid4
import os
TABLE_NAME = os.environ.get("TASKS_TABLE", "TasksTable")
REGION = os.environ.get("REGION", "us-east-1")
client = boto3.resource('dynamodb',region_name=REGION)
table = client.Table(TABLE_NAME)

def lambda_handler(event, context):
    # TODO implement
    http_method = event['httpMethod']
    path = event['path']
    response_message={}
    if http_method == 'GET' and path == '/tasks':
        response=table.scan()
        response_message={'message':'Here are all the tasks','info':response["Items"]}
    elif http_method == 'POST' and path == '/tasks':
        data = json.loads(event['body'])
        task_id=str(uuid4())
        task={
        'id': task_id,
        'task': data['title'],
        'description': data['description'],
        'completed': False
         }
        response=table.put_item(Item=task)
        response_message={'message':'Task added successfully','info':f'Task {task_id} has been created'}

    elif http_method == 'PUT' and path.startswith('/tasks'):
        taskid=path.split('/')[-1]
        body = json.loads(event['body'])
        response=table.update_item(
            Key={"id": taskid},
            UpdateExpression="set title=:t, description=:d, completed=:c",
            ExpressionAttributeValues={
                ":t": body["title"],
                ":d": body["description"],
                ":c": body["completed"],
            },
            ReturnValues="UPDATED_NEW"
        )
        response_message={'message':'Task updated successfully','info':f'Task {taskid} has been updated'}
  
    elif http_method == 'DELETE' and path.startswith('/tasks'):
        taskid=path.split('/')[-1]
        response=table.delete_item(Key={'id':taskid})
        response_message={'message':'Task deleted successfully','info':f'Task {taskid} has been deleted'}
    
    else : 
        return {
            'statusCode' : 400,
            'body' : json.dumps({
                'message' : 'Invalid request'
            })
        }
    return {
        'statusCode': 200,
        'body': json.dumps(response_message)
    }

