#!/bin/bash
set -e  # Exit immediately if a command fails

echo "Step 1: Verifying Lex-Lambda Resource-Based Policy..."
# Fetch the policy and check for the Lex V2 principal
POLICY=$(aws lambda get-policy --function-name "$FUNCTION_NAME" --query 'Policy' --output text)

if echo "$POLICY" | grep -q "lexv2.amazonaws.com"; then
  echo "✅ Permission verified: Lex V2 is authorized to invoke $FUNCTION_NAME."
else
  echo "❌ Error: Lex V2 permission missing from Lambda policy!"
  exit 1
fi

echo "Step 2: Running Translation Logic Integration Test..."
# Invoke the Lambda with the corrected Lex V2 payload
aws lambda invoke \
  --function-name "$FUNCTION_NAME" \
  --cli-binary-format raw-in-base64-out \
  --payload '{
    "sessionState": {
      "intent": {
        "name": "TranslateIntent",
        "slots": {
          "phrase": { "value": { "interpretedValue": "Hello" } },
          "target_language": {
              "value": {
                  "interpretedValue": "fr",
                  "originalValue": "fr"
              }
          }
        }
      }
    }
  }' \
  response.json

# Debug: Display response for logs
echo "Lambda Response:"
cat response.json

# Check for expected translation (case-insensitive)
if grep -qi "Bonjour" response.json; then
  echo "✅ Integration Test Passed: 'Bonjour' found in response."
else
  echo "❌ Integration Test Failed: 'Bonjour' not found in response."
  exit 1
fi
