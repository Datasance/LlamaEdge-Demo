FROM ubuntu:22.04 AS we-builder
RUN apt-get update && apt-get install -y \
    curl git python3 bash libopenblas-dev \
    build-essential clang


RUN  curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p /root/.wasmedge --plugins wasi_nn-ggml -v 0.14.1

RUN curl -LO https://github.com/second-state/chatbot-ui/releases/latest/download/chatbot-ui.tar.gz; tar xzf chatbot-ui.tar.gz; rm chatbot-ui.tar.gz

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup target add wasm32-wasip1

COPY LlamaEdge /

WORKDIR /LlamaEdge

RUN RUSTFLAGS="--cfg wasmedge --cfg tokio_unstable" cargo build -p llama-api-server  --target=wasm32-wasip1 --release


FROM scratch

COPY --from=we-builder /root/.wasmedge/plugin /opt/containerd/lib
COPY --from=we-builder /target/wasm32-wasip1/release/llama-api-server.wasm /
COPY --from=we-builder chatbot-ui /

ENTRYPOINT [ "llama-api-server.wasm" ]