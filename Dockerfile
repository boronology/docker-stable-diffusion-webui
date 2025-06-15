FROM debian:12

RUN apt-get update ;\
    apt-get install -y \
    wget \
    git \
    python3 \
    python3-venv \
    libgl1 \
    libglib2.0-0 \
    tar ; \
    mkdir /.cache

RUN groupadd -g 1111 webui; \
    useradd -l -u 1111 -g 1111 -m -d /opt/webui webui; \
    chown 1111:1111 -R /1111 ; \
    chown 1111:1111 -R /.cache

USER 1111:1111

WORKDIR /opt/webui

ENV PYTORCH_TRACING_MODE=TORCHFX
ENV COMMANDLINE_ARGS="--skip-torch-cuda-test --precision full --no-half" 

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui v1.10.1 --depth 1

ADD --chown=1111:1111 setup.py /opt/webui/v1.10.1/setup.py
RUN env LAUNCH_SCRIPT=setup.py bash /opt/webui/v1.10.1/webui.sh

EXPOSE 7860

# RUN wget https://github.com/AUTOMATIC1111/stable-diffusion-webui/archive/refs/tags/v1.10.1.tar.gz -O sdwu.tar.gz; \
#     tar xf sdwu.tar.gz ;

ENTRYPOINT [ "bash", "/opt/webui/v1.10.1/webui.sh", "--share", "--autolaunch", "--listen", "--port", "7860" ]