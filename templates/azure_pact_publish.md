# publish-pact-files action

> Publishes pact files to a Pact Broker

See pipeline template, for all available inputs.

## Example

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
- template: templates/azure_pact_publish.yml@pact_templates
  parameters:
    pactfiles: pacts
    token: $(PACT_BROKER_TOKEN) # token should be set as secret variable, in users pipeline
```
