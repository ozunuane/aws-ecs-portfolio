import json
import boto3
import os
client = boto3.client('ec2')
STARTING_RULE_NUMBER = int(os.environ["STARTING_RULE_NUMBER"])
def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))
    message = event['Records'][0]['Sns']['Message']
    config_data = json.loads(message)
    alert_type=config_data["detail"]["description"]
    if "unauthorized" in alert_type:
         offending_ip = config_data["detail"]["service"]["action"]["networkConnectionAction"]["remoteIpDetails"]["ipAddressV4"]
         vpc_id = config_data["detail"]["resource"]["instanceDetails"]["networkInterfaces"][0]["vpcId"]
    nacl_details = client.describe_network_acls(
        Filters=[{
                'Name' : 'vpc-id',
                'Values' : [vpc_id]
            }],
        MaxResults=5)
    association = nacl_details['NetworkAcls'][0]
    network_acl = association['Associations'][0]['NetworkAclId']
    last_nacl_entry = nacl_details['NetworkAcls'][0]
    rule_counter = 0
    for rules in last_nacl_entry['Entries']:
        if last_nacl_entry['Entries'][rule_counter]['RuleNumber'] == STARTING_RULE_NUMBER:
            acl_entry = (last_nacl_entry['Entries'][-3]['RuleNumber'])+1
            break
        else:
            acl_entry = STARTING_RULE_NUMBER
        rule_counter+=1

    response = client.create_network_acl_entry(
    CidrBlock=offending_ip+"/32",
    Egress=False,
    NetworkAclId=network_acl,
    PortRange={
        'From': 1,
        'To': 65535,
    },
    Protocol = '-1',
    RuleAction = 'deny',
    RuleNumber = acl_entry,
    )