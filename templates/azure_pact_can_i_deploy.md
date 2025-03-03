# can-i-deploy action

> Checks you can deploy based on target environment or tag

Check https://docs.pact.io/pact_broker/can_i_deploy for an overview of can-i-deploy

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
- template: templates/azure_pact_can_i_deploy.yml@pact_templates
  parameters:
    to_environment: production
    application_name: $(PACTICIPANT)
    token: $(PACT_BROKER_TOKEN)
```

Set only 1 of `to_environment` or `to` depending on whether you are targeting your deployment location using `environments`(recommended) or `tags`

Read more about migrating from tags to branches [here](https://docs.pact.io/pact_broker/branches#migrating-from-tags-to-branches)
