from confluent_kafka import Producer

# Kafka producer configuration
conf = {'bootstrap.servers': "localhost:9092"}

# Create a Kafka producer
producer = Producer(conf)

def produce_message(topic, key, value):
    # Produce the message to the specified Kafka topic
    producer.produce(topic=topic, key=key.encode('utf-8'), value=value.encode('utf-8'))
    # Flush the producer to ensure the message is sent
    producer.flush()