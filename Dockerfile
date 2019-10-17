FROM python:3.7
ENV PYTHONUNBUFFERED 1
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt
COPY . /usr/src/app
WORKDIR /usr/src/app/
EXPOSE 8080
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8080"]
