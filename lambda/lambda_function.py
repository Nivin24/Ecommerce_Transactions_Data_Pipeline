import boto3
import json
import time

def lambda_handler(event, context):
    glue_client = boto3.client('glue')

    print("Event: ", json.dumps(event))

    # Step 1: Start Glue job
    print("Starting Glue job: pandas_etl_job")
    try:
        response = glue_client.start_job_run(JobName='pandas_etl_job')
        job_run_id = response['JobRunId']
        print(f"Glue Job started successfully: {job_run_id}")
    except Exception as e:
        print("Error starting Glue job:", str(e))
        return {
            'statusCode': 500,
            'body': json.dumps({"error": str(e)})
        }

    # Step 2: Wait until Glue job completes
    while True:
        job_status = glue_client.get_job_run(
            JobName='pandas_etl_job',
            RunId=job_run_id
        )['JobRun']['JobRunState']

        print(f"Current Glue Job Status: {job_status}")

        if job_status in ['SUCCEEDED', 'FAILED', 'STOPPED']:
            break

        time.sleep(15)  # Check every 15 seconds

    # Step 3: If job succeeded, start crawler
    if job_status == 'SUCCEEDED':
        try:
            crawler_name = 'curated_to_analysis_crawler'  
            glue_client.start_crawler(Name=crawler_name)
            print(f"Crawler '{crawler_name}' started successfully.")
            return {
                'statusCode': 200,
                'body': json.dumps({
                    "message": "Glue Job completed & crawler started",
                    "JobRunId": job_run_id
                })
            }
        except Exception as e:
            print("Error starting Glue crawler:", str(e))
            return {
                'statusCode': 500,
                'body': json.dumps({"error": str(e)})
            }
    else:
        print("Glue Job failed or stopped, not starting crawler.")
        return {
            'statusCode': 500,
            'body': json.dumps({"error": "Glue Job failed or stopped"})
        }