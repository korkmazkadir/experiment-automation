#!/usr/bin/python3

import os
import sys
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

client = WebClient(token=os.environ['SLACK_BOT_TOKEN'])

message=sys.argv[1]

try:
    response = client.chat_postMessage(channel='#experiment-status', text=message)
except SlackApiError as e:
    # You will get a SlackApiError if "ok" is False
    assert e.response["ok"] is False
    assert e.response["error"]  # str like 'invalid_auth', 'channel_not_found'
    print(f"Got an error: {e.response['error']}")