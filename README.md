#LlamaEdge-Demo

```yaml

apiVersion: datasance.com/v3
kind: Application
metadata:
  name: llamaedge-demo
spec:
  microservices:
    - name: llamaedge-demo
      agent:
        name: wasm-demo
      images:
        registry: remote
        x86: ghcr.io/datasance/llamaedge-api-server:latest 
        arm: ghcr.io/datasance/llamaedge-api-server:latest
      container:
        rootHostAccess: false
        runtime: io.containerd.wasmedge.v1
        cdiDevices: []
        ports:
          - internal: 8080
            external: 8080
            protocol: tcp
            # public:
            #   protocol: http
            #   schemes:
            #     - http
            #   enabled: true
        volumes:
          - hostDestination: /home/pot/model # path to gguf model
            containerDestination: /resource
            accessMode: ro
            type: bind
        env:
          - key: WASMEDGE_WASINN_PRELOAD
            value: default:GGML:CPU:/resource/Llama-3.2-1B-Instruct-Q5_K_M.gguf
          - key: WASMEDGE_PLUGIN_PATH
            value: /opt/containerd/lib
        extraHosts: []
        commands:
          # - "llama-api-server.wasm"
          - --prompt-template 
          - llama-3-chat
          - --ctx-size
          - "4096"
          - --batch-size
          - "4096"
          - --model-name 
          - llama-3-1b
          - --web-ui 
          - ./chatbot-ui
      config: {}
  routes: []

```
