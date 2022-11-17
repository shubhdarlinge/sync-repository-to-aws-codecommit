# Sync Repository to AWS CodeCommit

Syncs a repository to AWS CodeCommit using AWS Credentials authorized through GitHub OIDC token.

## Parameters

|Name|Meaning|Required?|Default Value|
|-|-|-|-|
|`role-to-assume`|The ARN for AWS IAM Role to be assumed while making requests to AWS CodeCommit|Yes|N/A|
|`repository`|The name of repository being synced|No|Context Value: `github.repository`|

## Pre-requisites

- Configure GitHub OIDC in AWS for authorization. See
  [this](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services).
- The IAM Role used for OIDC should have permissions for AWS CodeCommit's `GetRepository`, `CreateRepository` and
  `GitPush` APIs.

## Example Usage

In the repository you want to sync to AWS CodeCommit, create a GitHub workflow to invoke this action.

```yml
name: Sync Repository to AWS CodeCommit

on:
  push:
    branches: [ "**" ]

jobs:
  sync:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Sync to AWS CodeCommit
        uses: shubhdarlinge/sync-repository-to-aws-codecommit@v2
        with:
          role-to-assume: arn:aws:iam::1234567890:role/FakeRepositorySyncRole
```
