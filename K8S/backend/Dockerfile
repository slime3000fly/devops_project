FROM python:3.8
 
COPY . /app
WORKDIR /app
 
RUN pip install -r requirements.txt
EXPOSE 5000
EXPOSE 8000
 
CMD ["python3", "backend.py"]