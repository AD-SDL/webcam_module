FROM ghcr.io/ad-sdl/wei

LABEL org.opencontainers.image.source=https://github.com/AD-SDL/webcam_module
LABEL org.opencontainers.image.description="An example module that implements a simple webcam snapshot action"
LABEL org.opencontainers.image.licenses=MIT

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG CONTAINER_USER=app
ARG CONTAINER_GROUP=app
USER ${CONTAINER_USER}
WORKDIR /home/${CONTAINER_USER}

# Add python packages to path
ENV PATH="$PATH:/home/${CONTAINER_USER}/.local/bin"

#########################################
# Module specific logic goes below here #
#########################################

RUN mkdir -p webcam_module

COPY --chown=${CONTAINER_USER}:${CONTAINER_GROUP} ./src webcam_module/src
COPY --chown=${CONTAINER_USER}:${CONTAINER_GROUP} ./README.md webcam_module/README.md
COPY --chown=${CONTAINER_USER}:${CONTAINER_GROUP} ./pyproject.toml webcam_module/pyproject.toml
COPY --chown=${CONTAINER_USER}:${CONTAINER_GROUP} ./tests webcam_module/tests

RUN --mount=type=cache,target=/home/${CONTAINER_USER}/.cache,uid=${USER_ID},gid=${GROUP_ID} \
    pip install -e ./webcam_module

CMD ["python", "webcam_module/src/webcam_rest_node.py"]

#########################################
# Enable automatic host user matching
USER root

# Add user to video group to access webcam
RUN usermod -a -G video app
