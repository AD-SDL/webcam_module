FROM python:3.11

RUN mkdir -p /webcam_module

COPY ./src /webcam_module/src
COPY ./README.md /webcam_module/README.md
COPY ./pyproject.toml /webcam_module/pyproject.toml

RUN pip install ./webcam_module

CMD ["python", "/webcam_module/src/webcam_rest_node.py"]
