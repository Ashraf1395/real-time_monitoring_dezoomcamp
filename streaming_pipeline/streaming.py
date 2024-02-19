from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark.context import SparkContext
from pyspark.sql.functions import from_json, col
import os
from config import TOPIC

os.environ['PYSPARK_SUBMIT_ARGS'] = '--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.3.1,org.apache.spark:spark-avro_2.12:3.3.1 pyspark-shell'

credentials_location = './docker/mage/google-cred.json'

conf = SparkConf() \
    .setMaster('local[*]') \
    .setAppName('test') \
    .set("spark.jars", "./data/gcs-connector-hadoop3-2.2.5.jar , ./data/spark-bigquery-latest_2.12.jar , ./data/gcs-connector-hadoop3-2.2.0-shaded.jar") \
    .set("spark.hadoop.google.cloud.auth.service.account.enable", "true") \
    .set("spark.hadoop.google.cloud.auth.service.account.json.keyfile", credentials_location)\

sc = SparkContext(conf=conf)

hadoop_conf = sc._jsc.hadoopConfiguration()

hadoop_conf.set("fs.AbstractFileSystem.gs.impl",  "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS")
hadoop_conf.set("fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem")
hadoop_conf.set("fs.gs.auth.service.account.json.keyfile", credentials_location)
hadoop_conf.set("fs.gs.auth.service.account.enable", "true")
hadoop_conf.set("fs.AbstractFileSystem.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS")

spark = SparkSession.builder \
    .config(conf=sc.getConf()) \
    .getOrCreate()

gcs_bucket_path = "gs://de-zoomcamp-project-data/"

df_raw_stream = spark \
        .readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", "localhost:9092,broker:29092") \
        .option("subscribe", TOPIC ) \
        .option("startingOffsets", "earliest") \
        .option("checkpointLocation", "checkpoint") \
        .load()

# Convert the 'value' column from binary to string
df_raw_stream = df_raw_stream.withColumn("value_str", df_raw_stream["value"].cast("string"))

# Define the schema of your JSON data
json_schema = "module_name string, module_id string, email string, time_homework string, time_lectures string, score string"

# Apply the transformation to create separate columns for each field
df_with_json = df_raw_stream.select("*",from_json(col("value_str"), json_schema).alias("value_json")).select("*","value_json.*").drop("value_str", "value_json")

# Selecting columns and casting their types
df_with_json = df_with_json.select(
    'module_name','module_id','email',
    col('time_homework').cast('float').alias('time_homework'),
    col('time_lectures').cast('float').alias('time_lectures'),
    col('score').cast('float').alias('score'),
    'timestamp','offset'
)

# def sink_console(df, output_mode: str = 'complete', processing_time: str = '5 seconds'):
#     write_query = df.writeStream \
#         .outputMode(output_mode) \
#         .trigger(processingTime=processing_time) \
#         .format("console") \
#         .option("truncate", False) \
#         .start()
#     return write_query # pyspark.sql.streaming.StreamingQuery

# write_query = sink_console(df_with_json, output_mode='append')

def sink_memory(df, query_name, query_template):
    write_query = df \
        .writeStream \
        .queryName(query_name) \
        .format('memory') \
        .start()
    query_str = query_template.format(table_name=query_name)
    query_results = spark.sql(query_str)
    return write_query, query_results

def write_to_gcs(batch_df, batch_id):
    # Define the output path for this batch
    output_path = gcs_bucket_path + f"streaming_data/"
    # Write the batch to GCS
    batch_df \
        .write \
        .format("parquet") \
        .mode("append") \
        .option("header", "true") \
        .save(output_path)

query_name = 'fact_scores'
query_template = 'select email,module_id,score from {table_name}'
write_fact_query, fact_scores = sink_memory(df=df_with_json, query_name=query_name, query_template=query_template)

query_name = 'fact_time'
query_template = 'select email,module_id,time_homework,time_lectures from {table_name}'
write_time_query, fact_time = sink_memory(df=df_with_json, query_name=query_name, query_template=query_template)



# Start streaming queries
write_fact_query = fact_scores.writeStream \
    .foreachBatch(write_to_gcs) \
    .start()

write_time_query = fact_time.writeStream \
    .foreachBatch(write_to_gcs) \
    .start()


def stop_query(query_name=None):
    if query_name is None:
        # Stop all queries
        write_fact_query.stop()
        write_time_query.stop()
        # Add more queries here if needed
    elif query_name == "write_fact_query":
        write_fact_query.stop()
    elif query_name == "write_time_query":
        write_time_query.stop()
    # Add more conditions for other query names if needed
    else:
        print("Invalid query name")

# # Example usage to stop a specific query
# stop_query("write_fact_query")  # Stop only the "write_fact_query" query

# # Example usage to stop all queries
# stop_query()  # Stop all queries
