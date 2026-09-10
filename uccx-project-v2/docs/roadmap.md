
The below are in the Roadmap for future improvements to the solution.
- Add more automated quality checks: freshness, accepted values, and improve upon deduplication rules.
- Add orchestration for scheduled runs, dependencies, retries, and pipeline monitoring.
- Adapt the architecture for cloud deployment, for example using S3 for raw storage and Redshift as the transformation and analytics warehouse. Moving from on premises to the cloud would add reversibility and flexibility in the architecture decisions that can be made. In this case, we could also add infrastructure automation by using an IaC tool such as Terraform to create the required cloud resources.
