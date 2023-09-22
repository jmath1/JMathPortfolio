# Use an official Python runtime as a parent image
FROM python:3.8

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE portfolio.settings

# Create and set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container
COPY requirements.txt /app/

# Install system dependencies for your project (e.g., PostgreSQL client)
# RUN apt-get update && apt-get install -y <package-name>

# Install Python dependencies using pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install psycopg2-binary;

# Copy the rest of your Django project files into the container
COPY . /app/

# Expose the port that your Gunicorn application will run on (default is 8000)
EXPOSE 8000

# Start Gunicorn to run your Django application
CMD ["gunicorn", "portfolio.wsgi:application", "--bind", "0.0.0.0:8000"]
