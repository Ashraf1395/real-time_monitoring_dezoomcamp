from confluent_kafka import Consumer, KafkaError

# Kafka consumer configuration
conf = {'bootstrap.servers': "localhost:9092", 'group.id': "ashraf.de-zoomcamp-form-data", 'auto.offset.reset': 'earliest'}
consumer = Consumer(conf)

# Subscribe to the Kafka topic
topic = 'ashraf-de-form-submissions'
consumer.subscribe([topic])

try:
    while True:
        # Poll for new messages
        msg = consumer.poll(timeout=1.0)
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                # End of partition, ignore
                continue
            else:
                # Error occurred
                print(msg.error())
                break
        # Process the message
        print('Received message: {}'.format(msg.value().decode('utf-8')))
except KeyboardInterrupt:
    pass
finally:
    # Close the consumer
    consumer.close()
