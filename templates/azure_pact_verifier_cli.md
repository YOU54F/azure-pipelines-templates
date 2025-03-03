# Pact Verifier CLI

```yml
pool:
  vmImage: ubuntu-latest

resources:
  repositories:
    - repository: pact_templates
      type: github
      name: you54f/azure-pipelines-templates
      endpoint: azure-templates-pact-github # azure service connection to allow read-only access to github repo
      # ref: refs/heads/templates # point to a commit / branch / tag

steps:
- template: templates/azure_pact_verifier_cli.yml@pact_templates
- script: pact_verifier_cli --help
  displayName: pact_verifier_cli
```