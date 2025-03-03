# Pact Azure Pipeline Templates

Azure Pipeline Templates to perform Pact & PactFlow commands.

## Available Commands / CLI applications

Available Pact Commands

| Type | Template Name |
| ---- | ------------- |
| `can-i-deploy` |[azure_pact_can_i_deploy.yml](./templates/azure_pact_can_i_deploy.yml)|
| `create_version_tag` |[azure_pact_create_version_tag.yml](./templates/azure_pact_create_version_tag.yml)|
| `create-or-update-version` |[azure_pact_create_or_update_version.yml](./templates/azure_pact_create_or_update_version.yml)|
| `delete-branch` |[azure_pact_delete_branch.yml](./templates/azure_pact_delete_branch.yml)|
| `publish` |[azure_pact_publish.yml](./templates/azure_pact_publish.yml)|
| `publish-provider-contract` |[azure_pact_publish_provider_contract.yml](./templates/azure_pact_publish_provider_contract.yml)|
| `record-deployment` |[azure_pact_record_deployment.yml](./templates/azure_pact_record_deployment.yml)|
| `record-release` |[azure_pact_record_release.yml](./templates/azure_pact_record_release.yml)|
| Recommended env vars (`BRANCH`/`COMMIT`/`BUILD_URI`) |[azure_pact_variables.yml](./templates/azure_pact_variables.yml)|

Available Pact CLI applications

| Type | Template Name |
| ---- | ------------- |
| `pact-standalone-cli` |azure_pact_cli.yml|
| `pact_mock_server_cli` |azure_pact_mock_server_cli.yml|
| `pact-plugin-cli` |azure_pact_plugin_cli.yml|
| `pact_verifier_cli` |azure_pact_verifier_cli.yml|
| `pact-stub-server` |azure_pact_stub_server_cli.yml|

## Instructions

### Configure access to the azure templates

There are a few ways you can re-use the templates, in your Azure Pipelines workflow.

1. Create an [Azure Service Connection - GitHub Repos](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops#github-service-connection) to GitHub, in order to allow connection to this template repository. Read-only access is sufficient.
2. Clone this repository directly in your work, and reference the templates by path.
3. Mirror this repository, to the same Azure organization that your code resides in. If you mirror to another Azure organization, you will need to create a [Azure Service Connection - Azure Repos](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops#azure-repos)

### Setup your workflow to use the Azure templates

1. For each pipeline, create an [Azure Service Connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops#create-a-service-connection) to connect to GitHub.
   1. Read-Only access to Contents is sufficient.
   2. You can scope access to this repository only
2. Setup a Repository Resource Connection to GitHub, to this template repository
   1. See the [sample templates](./samples/templates), and update `resources.repositories.repository["pact_templates"].endpoint` to the same of the Azure Service Connection created in Step 1.
3. You can now reference the templates in your workflow.
   1. `- template: templates/<template_name>.yml@pact_templates`
4. Some examples can take parameters, see the associated README file, located next to the template.

     ```yml
      - template: templates/azure_pact_can_i_deploy.yml@pact_templates
        parameters:
          to_environment: production
          application_name: $(PACTICIPANT)
          token: $(PACT_BROKER_TOKEN)
    ```

### Examples of real-world use

1. Consumer
   1. CDCT - Pact-Net
      1. [Consumer Pipeline](https://github.com/YOU54F/example-consumer-dotnet/blob/master/azure-pipelines.yml) (Publish Pacts -> Can-I-Deploy -> Record-Deployment)
2. Provider
   1. CDCT - Pact-Net
      1. [Provider Pipeline](https://github.com/YOU54F/example-provider-dotnet/blob/master/azure-pipelines.yml)
      2. [Provider Pipeline - Contract Requiring Verification Published](https://github.com/YOU54F/example-provider-dotnet/blob/master/azure-pipelines-contract_requiring_verification_published.yml)
         1. [Webhooks](./webhooks/azure-pipelines-contract_requiring_verification_published-webhook.md)
   2. BDCT - PactFlow / Schemathesis
      1. [Provider Pipeline](https://github.com/YOU54F/example-bi-directional-provider-dotnet/blob/main/azure-pipelines.yml)

## Inspiration

- Reworked scripts from https://github.com/pactflow/actions designed for GitHub Actions
- [Feature Request](https://github.com/pact-foundation/roadmap/issues/114) on Pact-Foundation Roadmap
