// Remote state in S3 with DynamoDB locking, so concurrent Jenkins runs cannot
// corrupt the state file. The bucket and table are supplied at init time and are
// deliberately not committed:
//
//   terraform init \
//     -backend-config="bucket=<your-state-bucket>" \
//     -backend-config="dynamodb_table=<your-lock-table>"
//
// The lock table needs a single partition key named LockID of type String.

terraform {
  backend "s3" {
    key     = "certask/staging/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
