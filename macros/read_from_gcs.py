
from google.cloud import storage
import pandas as pd
import pyarrow.parquet as pq

def read_from_gcs(bucket_name, file_path):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_path)
    data = blob.download_as_string()

    # Read Parquet file using pyarrow
    return pq.read_table(io.BytesIO(data)).to_pandas()