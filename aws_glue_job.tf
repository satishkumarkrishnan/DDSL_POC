#AWS Glue job for a Python script
resource "aws_glue_job" "example" {
  name = "DDSL_Glue_job"
  role_arn = aws_iam_role.gluerole.arn
  max_capacity = "1.0"
  glue_version = "4.0"
  command {
    #name            = "pythonshell"
    script_location = "s3://${aws_s3_bucket.example1.bucket}/segregate.py"
    python_version = "3"
  }
   default_arguments = {    
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.glue_job_log_group.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
  }
}

#AWS Glue job for a Py script
resource "aws_glue_job" "data_lineage" {
  name = "DDSL_Datalineage_job"
  role_arn = aws_iam_role.gluerole.arn
  max_capacity = "1.0"
  glue_version = "4.0"
  command {
    #name            = "pythonshell"
    script_location = "s3://${aws_s3_bucket.example1.bucket}/pyspark.py"
    python_version = "3"
  }
  
   default_arguments = {    
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.data_lineage_log_group.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
   # "--additional-python-modules"        ="s3://ddsl-rawdata-bucket/Lib.zip"
   # "package                             ==3.4.3"
  }
}