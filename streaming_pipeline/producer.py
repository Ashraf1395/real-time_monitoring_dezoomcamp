from confluent_kafka import Producer
from config import BOOTSTRAP_SERVERS
import json
# Kafka producer configuration
conf = {'bootstrap.servers': BOOTSTRAP_SERVERS}

# Create a Kafka producer
producer = Producer(conf)

def produce_message(topic, key, value):
    # Convert the value dictionary to a JSON string
    json_value = json.dumps(value)
    # Produce the message to the specified Kafka topic
    producer.produce(topic=topic, key=str(key), value=json_value)
    # Flush the producer to ensure the message is sent
    producer.flush()
