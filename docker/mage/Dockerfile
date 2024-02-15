FROM mageai/mageai:latest

# Set the working directory inside the container
WORKDIR /home/src

# Copy the entire current directory (.) into the container at /home/src
COPY . .

# Copy the specific Python files into the container at their respective locations
COPY ./batch_pipeline/exporter/export_to_gcs_1.py /home/src/batch_pipeline/exporter/export_to_gcs_1.py
COPY ./batch_pipeline/exporter/export_to_gcs_2.py /home/src/batch_pipeline/exporter/export_to_gcs_2.py
COPY ./batch_pipeline/exporter/export_to_postgres.sql /home/src/batch_pipeline/exporter/export_to_postgres.sql
COPY ./batch_pipeline/exporter/export_to_postgres_2.sql /home/src/batch_pipeline/exporter/export_to_postgres_2.sql
