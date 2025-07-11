FROM rbgcsail/diffdock:v1.1.3 AS builder

# Stage 2: Runtime Environment
FROM nvidia/cuda:11.7.1-runtime-ubuntu22.04

ENV APPUSER="appuser"
ENV HOME=/home/$APPUSER

ENV ENV_NAME="diffdock"
ENV DIR_NAME="DiffDock"

RUN useradd -m -u 1001 $APPUSER
USER $APPUSER
WORKDIR $HOME

COPY --from=builder --chown=$APPUSER:users --chmod=777 $HOME $HOME
RUN chmod 777 /home/$APPUSER
USER $APPUSER

# Set the environment variables
ENV PATH=$HOME/bin:$HOME/.local/bin:$PATH
ENV MAMBA_ROOT_PREFIX=/home/appuser/micromamba
RUN micromamba shell init -s bash --root-prefix $MAMBA_ROOT_PREFIX

# Expose ports for streamlit and gradio
EXPOSE 7860 8501

# Default command
CMD ["sh", "-c", "micromamba run -n ${ENV_NAME} python utils/print_device.py"]
