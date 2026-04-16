# ${{ values.pipelineName }}

${{ values.description }}

## Overview

| Property | Value |
|---|---|
| **Owner** | ${{ values.owner }} |
| **Type** | ${{ values.pipelineType }} |
| **Source** | ${{ values.sourceType }} |
| **Destination** | ${{ values.destinationType }} |
{% if values.pipelineType == 'batch-etl' %}| **Schedule** | `${{ values.schedule }}` |{% endif %}

## Links

- [Airflow DAG](https://airflow.example.com/dags/${{ values.pipelineName }})
- [Datadog Dashboard](https://app.datadoghq.com/dashboard/${{ values.pipelineName }})
- [GitHub Repository](https://github.com/${{ values.repoOrg }}/${{ values.repoName }})
