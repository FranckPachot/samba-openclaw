#!/usr/bin/env bash
set -euo pipefail

# Usage: ./deploy_lambda.sh <function-name>

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <lambda-function-name>"
  exit 1
fi
FUNC_NAME=$1

# Create a temporary build directory
BUILD_DIR=$(mktemp -d)

# Copy Python source files needed for the Lambda
cp ../lambda/handler.py "$BUILD_DIR/"
cp ../src/db_worker.py "$BUILD_DIR/"

# Install dependencies into the build dir (only those that work in Lambda)
# For this demo we only need SQLAlchemy; heavy DB drivers are omitted.
cd "$BUILD_DIR"
python3 -m pip install --target . "SQLAlchemy==2.0.20" >/dev/null 2>&1

# Zip the contents
zip -r9 ../lambda_package.zip . > /dev/null
cd - > /dev/null

# Deploy using AWS CLI – create if not exists, otherwise update
if aws lambda get-function --function-name "$FUNC_NAME" > /dev/null 2>&1; then
  echo "Updating existing Lambda function $FUNC_NAME..."
  aws lambda update-function-code --function-name "$FUNC_NAME" \
    --zip-file fileb://lambda_package.zip
else
  echo "Creating new Lambda function $FUNC_NAME..."
  aws lambda create-function \
    --function-name "$FUNC_NAME" \
    --runtime python3.11 \
    --handler handler.lambda_handler \
    --zip-file fileb://lambda_package.zip \
    --role "arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_LAMBDA_EXEC_ROLE"
fi

# Clean up
rm -f lambda_package.zip
rm -rf "$BUILD_DIR"

echo "Deployment complete."
