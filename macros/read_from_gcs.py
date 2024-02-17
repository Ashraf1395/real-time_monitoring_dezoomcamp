from google.cloud import storage
import pandas as pd

def read_from_gcs(bucket_name, file_path):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_path)
    data = blob.download_as_string()
    return pd.read_csv(io.BytesIO(data))