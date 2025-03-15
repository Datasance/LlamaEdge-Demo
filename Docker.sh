docker run -v ~/.wasmedge/plugin/libwasmedgePluginWasiNN.so:/.wasmedge/plugin/libwasmedgePluginWasiNN.so \
  -v /home/pot/model:resource/\
  --env WASMEDGE_PLUGIN_PATH=/opt/containerd/lib \
  --env WASMEDGE_WASINN_PRELOAD=default:GGML:CPU:/resource/Llama-3.2-1B-Instruct-Q5_K_M.gguf\
  --rm --runtime=io.containerd.wasmedge.v1 \
  emirhandurmus/llama-edge-demo:latest t estggml llama-api-server.wasm \
  --prompt-template llama-3-chat \
  --ctx-size 4096 \
  --model-name llama-3-1b

docker run -v /home/pot/model:/resource \
  --env WASMEDGE_PLUGIN_PATH=/opt/containerd/lib \
  --env WASMEDGE_WASINN_PRELOAD=default:GGML:CPU:/resource/Llama-3.2-1B-Instruct-Q5_K_M.gguf\
  --rm --runtime=io.containerd.wasmedge.v1 \
  --net=host \
  emirhandurmus/llamaedge-demo:latest  testggml llama-api-server.wasm \
  --prompt-template llama-3-chat \
  --ctx-size 4096 \
  --model-name llama-3-1b


wasmedge --dir .:. --nn-preload default:GGML:AUTO:Meta-Llama-3.1-8B-Instruct-Q5_K_M.gguf llama-chat.wasm -p llama-3-chat

wasmedge --dir .:. --nn-preload default:GGML:AUTO:Meta-Llama-3.1-8B-Instruct-Q5_K_M.gguf llama-api-server.wasm -p llama-3-chat



wasmedge --dir .:. --nn-preload default:GGML:AUTO:Meta-Llama-3-8B-Instruct.Q5_K_M.gguf llama-chat.wasm -p llama-3-chat

curl -LO https://huggingface.co/second-state/Llama-2-7B-Chat-GGUF/resolve/main/Llama-2-7b-chat-hf-Q5_K_M.gguf

wasmedge --dir .:. --nn-preload default:GGML:AUTO:Llama-2-7b-chat-hf-Q5_K_M.gguf \
  llama-api-server.wasm \
  --prompt-template llama-2-chat \
  --ctx-size 4096 \
  --model-name llama-2-7b-chat


wasmedge --dir .:. \
  --env n_predict=100 \
  --nn-preload default:GGML:AUTO:Llama-2-7b-chat-hf-Q5_K_M.gguf \
  wasmedge-ggml-basic.wasm default

docker run --rm --runtime=io.containerd.wasmedge.v1 --platform wasip1/wasm \
  -v /model:/model \
  -v $PWD:/resource \
  --env WASMEDGE_PLUGIN_PATH=/.wasmedge/plugin \
  --env WASMEDGE_WASINN_PRELOAD=default:GGML:AUTO:/model/Meta-Llama-3-8B-Instruct-Q5_K_M.gguf  \
  -p 8080:8080 \
  emirhandurmus/llamaedge-demo \
  --model-alias llama3-chat

docker run --rm --runtime=io.containerd.wasmedge.v1 --platform wasip1/wasm \
  -v /Llama-3.2-1B-Instruct-Q5_K_M.gguf:/Llama-3.2-1B-Instruct-Q5_K_M.gguf \
  --env WASMEDGE_PLUGIN_PATH=/.wasmedge/plugin \
  --env WASMEDGE_WASINN_PRELOAD=default:GGML:AUTO:/Llama-3.2-1B-Instruct-Q5_K_M.gguf  \
  -p 8080:8080 \
  emirhandurmus/llamaedge-demo \
  --model-alias llama3-chat

docker run --runtime=io.containerd.wasmedge.v1 --env WASMEDGE_WASINN_PRELOAD=default:GGML:AUTO:/Meta-Llama-3-8B-Instruct-Q5_K_M.gguf  -p 8080:8080 kuasario/llama-api-server:v2

sudo docker run --rm --runtime=io.containerd.wasmedge.v1 \
    --net=host \
    -v /home/pot/.wasmedge/plugin:/opt/containerd/lib:ro \
    -e WASMEDGE_PLUGIN_PATH=/opt/containerd/lib \
    -v /home/pot/model:/resource:ro \
    -e WASMEDGE_WASINN_PRELOAD=default:GGML:CPU:/resource/Llama-3.2-1B-Instruct-Q5_K_M.gguf \
    docker.io/emirhandurmus/llamaedge-demo:latest \
    --prompt-template llama-3-chat \
    --ctx-size 4096 \
    --model-name llama-3-1b