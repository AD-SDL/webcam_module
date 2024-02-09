FROM ghcr.io/ad-sdl/wei

LABEL org.opencontainers.image.source=https://github.com/AD-SDL/webcam_module
LABEL org.opencontainers.image.description="An example module that implements a simple webcam snapshot action"
LABEL org.opencontainers.image.licenses=MIT

#########################################
# Module specific logic goes below here #
#########################################

RUN mkdir -p webcam_module

COPY ./src webcam_module/src
COPY ./README.md webcam_module/README.md
COPY ./pyproject.toml webcam_module/pyproject.toml
COPY ./tests webcam_module/tests

RUN --mount=type=cache,target=/root/.cache \
    pip install -e ./webcam_module

CMD ["python", "webcam_module/src/webcam_rest_node.py"]

# Add user to video group to access webcam
RUN usermod -a -G video app

#########################################
