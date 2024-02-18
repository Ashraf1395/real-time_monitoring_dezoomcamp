from pyspark.sql import SparkSession
import pyspark.sql.functions as F
from config import STREAM_SCHEMA, TOPIC

spark = SparkSession.builder.appName('local[*]').getOrCreate()


df_stream = spark \
        .readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", "localhost:9092,broker:29092") \
        .option("subscribe", TOPIC ) \
        .option("startingOffsets", "earliest") \
        .option("checkpointLocation", "checkpoint") \
        .load()

df_stream.show()
