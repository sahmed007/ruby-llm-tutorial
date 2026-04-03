if defined?(WasmHTTP::Connection)
  WasmHTTP::Connection.proxy_url = "https://cors-proxy.samad-188.workers.dev/proxy?"
  WasmHTTP::Connection.proxy_hosts = [
    "api.openai.com",
    "api.anthropic.com",
    "generativelanguage.googleapis.com",
    "openrouter.ai",
    "api.mistral.ai",
    "api.together.xyz",
    "api.groq.com",
    "api.cohere.com",
    "api.deepseek.com"
  ]
end
