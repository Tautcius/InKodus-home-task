# Stage 1: Build the application
FROM python:3.11-alpine AS builder
# set the working directory
WORKDIR /code
# Copy the requirements file
COPY ./requirements.txt ./
# Install the dependencies
RUN pip install --user --no-cache-dir --upgrade -r /code/requirements.txt
# 
COPY ./src ./src
# Stage 2: Create the final image
FROM python:3.11-alpine
# Set the working directory
COPY --from=builder /root/.local /root/.local
WORKDIR /code
# Copy the application files from the builder stage
COPY --from=builder /code .
ENV PATH=/root/.local/bin:$PATH
EXPOSE 80
# Set the command to run the application
# CMD ["python", "src/main.py"]
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]