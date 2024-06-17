import boto3
import botocore

def read_file_from_s3(bucket_name, file_key):
    # Initialize the S3 client
    s3 = boto3.client('s3')

    try:
        # Attempt to read the object from S3
        print(f"Attempting to read file '{file_key}' from bucket '{bucket_name}'...")
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        body = response['Body']

        # Read the content into memory and decode it
        content = body.read().decode('utf-8')
        print(f"Successfully read content from '{file_key}'.")
        return content.splitlines()
    except botocore.exceptions.ClientError as e:
        # Handle specific error types
        error_code = e.response['Error']['Code']
        if error_code == 'NoSuchKey':
            print(f"Error: The file with key '{file_key}' does not exist in bucket '{bucket_name}'.")
        else:
            print(f"Unexpected error: {e}")
        return None

def segregate_records(lines):
    records = {}
    footer_info = {}
    for line in lines:
        fields = line.strip().split('|')
        if len(fields) < 2:
            continue
        record_type = fields[0]
        if record_type == 'T':  # Assuming footer record type is 'T'
            footer_info = parse_footer(fields)
        elif record_type not in ('H', 'T'):
            records.setdefault(record_type, []).append(line)
    return records, footer_info

def parse_footer(fields):
    footer_info = {}
    for field in fields[1:]:
        key, value = field.split('~')
        footer_info[key] = int(value)
    return footer_info

def write_segregated_files(records, footer_info):
    for record_type, lines in records.items():
        total_records = footer_info.get(record_type, 0)
        with open(f"{record_type}_segregated.txt", 'w') as file:
            for line in lines:
                file.write(line.strip() + f"|{total_records}\n")
#
# Define your bucket name and file key
input_bucket_name = 'ddsl-rawdata-bucket'
input_file_key = 'AccountExtract_6150_20231213.TXT'
output_bucket_name = 'ddsl-extension-bucket'
output_prefix = 'updatedsegted_files'
#
# Read the file from S3
lines = read_file_from_s3(input_bucket_name, input_file_key)
if lines:
    # Segregate records
    records, footer_info = segregate_records(lines)

    # Write segregated files locally
    write_segregated_files(records, footer_info)

    # Upload segregated files to S3
    s3 = boto3.client('s3')
    for record_type in records:
        file_key = f"{output_prefix}/{record_type}_segregated.txt"
        with open(f"{record_type}_segregated.txt", 'rb') as file:
            try:
                print(f"Uploading file '{file_key}' to bucket '{output_bucket_name}'...")
                s3.upload_fileobj(file, output_bucket_name, file_key)
                print(f"Successfully uploaded file '{file_key}' to bucket '{output_bucket_name}'.")
            except Exception as e:
                print(f"Failed to upload file '{file_key}' to bucket '{output_bucket_name}': {e}")
else:
    print("No content found or error reading the file.")
