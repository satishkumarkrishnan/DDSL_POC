/*resource "aws_glue_crawler" "tokyo_crawler" {
  database_name = var.database_name
  description   = var.glue_crawler_description
  role          = var.role  


}*/

resource "aws_glue_crawler" "example" {
  #database_name = "${aws_glue_catalog_database.example.name}"
  database_name = var.database_name
  name          = "tokyo_crawler"
  role          = aws_iam_role.gluerole.arn

  s3_target {
    path = "s3://${aws_s3_bucket.example1.id}"
  }  
}