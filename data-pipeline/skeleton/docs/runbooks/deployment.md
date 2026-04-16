# Deployment Runbook

## Deploying the Pipeline

```bash
# Build and push Docker image
docker build -t ${{ values.pipelineName }} .
docker push <ecr-uri>/${{ values.pipelineName }}:latest

# Trigger Airflow DAG manually
airflow dags trigger ${{ values.pipelineName }}
```

## Monitoring

- Check [Datadog Dashboard](https://app.datadoghq.com/dashboard/${{ values.pipelineName }}) for pipeline metrics
- Check [Airflow](https://airflow.example.com/dags/${{ values.pipelineName }}) for DAG run history

## Rollback

Re-trigger the previous successful DAG run from the Airflow UI.
