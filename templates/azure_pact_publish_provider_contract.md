# publish-provider-contract action

> Publishes OAS and test evidence to a Pactflow server for 'bi-directional' testing (relies on [actions/checkout](https://github.com/marketplace/actions/checkout) being called first).

See pipeline template, for all available inputs.

## Pre-Requisities

- A Pactflow account
  - Don't have one - sign up 👉 [here](https://pactflow.io/try-for-free) - don't worry, the developer tier is free.
- A Pactflow API Token
  - Log in to your Pactflow account (`https://<your-subdomain>.pactflow.io`), and go to Settings > API Tokens - See [here](/#configuring-your-api-token) for the docs

## Example

This is designed to setup the `azure_publish_provider_contract.yml` template twice, once if the provider verification is successful and once if it fails. If it fails, it will additional pass in a failing verification code to PactFlow, denoting that the self-verification was unsuccessful.

```yaml
pool:
  vmImage: ubuntu-latest

variables:
  - template: templates/azure_pact_variables.yml@pact_templates # re-use common variables, to set commit, branch and build uri
  - name: PACTICIPANT
    value: "pactflow-example-consumer-dotnet"
  - name: PACT_BROKER_BASE_URL
    value: https://testdemo.pactflow.io

resources:
  repositories:
    - repository: pact_templates
      type: github
      name: you54f/azure-pipelines-templates
      endpoint: azure-templates-pact-github # azure service connection to allow read-only access to github repo
      # ref: refs/heads/templates # point to a commit / branch / tag

steps:
# perform your tests here
- template: templates/azure_publish_provider_contract.yml@pact_templates
  displayName: Publish provider contract on passing test run
  parameters:
    application_name: $(PACTICIPANT) # The pacticipant name of which the branch belongs to
    token: $(PACT_BROKER_TOKEN)
    tag: prod
    version: "1.2.3" # autodetected if not provided
    contract: src/oas/user.yml
    contract_content_type: application/yaml # optional, defaults to application/yml
    verification_results: src/results/report.md
- template: templates/azure_publish_provider_contract.yml@pact_templates
  condition: failed()
  displayName: Publish provider contract on failing test run
  parameters:
    application_name: $(PACTICIPANT) # The pacticipant name of which the branch belongs to
    token: $(PACT_BROKER_TOKEN)
    tag: prod
    version: "1.2.3" # autodetected if not provided
    contract: src/oas/user.yml
    contract_content_type: application/yaml # optional, defaults to application/yml
    verification_results: src/results/report.md
    verification_exit_code: 1 # defaults to 0 (success)
```

## Notes

- If you change your `application_name` you will need to inform your consumers (their pact tests rely on the name you use here).
- Assumes 'success = true' (you can control this action by depending on an earlier successful test job).
- You must ensure `additionalProperties` in your OAS is set to `false` on any response body, to ensure a consumer won't get false positives if they add a new field that isn't actually part of the spec.
