FROM ubuntu:20.04

RUN apt update && apt -y install iputils-ping wget curl python3 python3-pip

RUN python3 -m pip install requests mysql-connector-python

COPY ./hm.py /tools/hm.py
RUN chmod +x /tools/hm.py
WORKDIR /tools

ENTRYPOINT ["python3", "/tools/hm.py"]
CMD ["--targets", "./targets.txt"]
