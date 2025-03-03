# delete-branch action

> Deletes a pacticipant branch. Does not delete the versions or pacts/verifications associated with the branch, but does make the pacts inaccessible for verification via consumer versions selectors or WIP pacts.

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
- template: templates/azure_delete_branch.yml@pact_templates
  parameters:
    application_name: $(PACTICIPANT) # The pacticipant name of which the branch belongs to
    token: $(PACT_BROKER_TOKEN)
    branch: "test" # The branch name
    error_when_not_found: false # (Optional) - Raise an error if the branch that is to be deleted is not found, default true
```
