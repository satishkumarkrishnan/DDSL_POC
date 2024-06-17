variable "region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "name" {
  description = "The name of the Glue catalogue database"
  type        = string
  default     = "tokyo_glue_catalogue"
  }

variable "description" {
  description = "DB description"
  type        = string
  default     = "Demo DB"
}

variable "catalogue_id" {
  description = "ID of the Glue catalogue to create the database"
  type        = string
  default     = ""
}

variable "location_uri" {
  description = "The location of the db"
  type        = string  
  default     = "null" 
}

variable "parameters" {
  description = "A map of key-value pairs that define parameters and properties of the database"
  type        = map(string)
  default     = {}
}

variable "target_database" {
  description = "Configuration block for a target db"
  default     = []
  type = list(object({
    catalogue_id = string,
    database_name = string
  }))
}

variable "database_name" {
  description = "Glue db for results updation"
  type        = string
  default     = "null" 
}

variable "glue_crawler_description" {
  description = "Description of the crawler"
  type        = string
  default     = "Tokyo Glue Crawler"
}

variable "role" {
  description = "IAM role for the crawler"
  type        = string   
  default     = "null" 
}