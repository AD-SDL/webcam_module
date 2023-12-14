FROM ghcr.io/ad-sdl/wei

LABEL org.opencontainers.image.source=https://github.com/AD-SDL/webcam_module
LABEL org.opencontainers.image.description="An example module that implements a simple webcam snapshot action"
LABEL org.opencontainers.image.licenses=MIT

USER wei
WORKDIR /home/wei

RUN mkdir -p webcam_module

COPY --chown=wei:wei ./src webcam_module/src
COPY --chown=wei:wei ./README.md webcam_module/README.md
COPY --chown=wei:wei ./pyproject.toml webcam_module/pyproject.toml

RUN pip install ./webcam_module

CMD ["python", "webcam_module/src/webcam_rest_node.py"]
