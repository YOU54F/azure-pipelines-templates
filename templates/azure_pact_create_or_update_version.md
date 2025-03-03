# create-or-update-version action

> Create or update pacticipant version by version number

See pipeline template, for all available inputs.

## Example

```yml
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
- template: templates/azure_create_or_update_version.yml@pact_templates
  parameters:
    application_name: $(PACTICIPANT)
    token: $(PACT_BROKER_TOKEN)
    version: "1.2.3" # optional, defaults to git sha if not specified
    branch: "test" # optional, defaults to git branch if not specified
    tag: "test" # optional
```
