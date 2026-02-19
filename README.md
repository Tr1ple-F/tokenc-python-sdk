# tokenc - Python SDK

Compress LLM prompts to reduce costs and latency. 100K tokens compressed in ~85ms.

## Install

```bash
pip install tokenc
```

## Usage

```python
from tokenc import TokenClient

client = TokenClient(api_key="your-api-key")

result = client.compress_input(
    input="Your long prompt here...",
    aggressiveness=0.5  # 0.1 = light, 0.5 = balanced, 0.9 = aggressive
)

print(result.output)           # compressed text
print(result.tokens_saved)     # tokens removed
print(result.compression_ratio) # e.g. 1.8x
```

## With Custom Settings

```python
from tokenc import TokenClient, CompressionSettings

client = TokenClient(api_key="your-api-key")

result = client.compress_input(
    input="Your text...",
    compression_settings=CompressionSettings(
        aggressiveness=0.7,
        max_output_tokens=100,
    )
)
```

## Context Manager

```python
with TokenClient(api_key="your-api-key") as client:
    result = client.compress_input(input="Your text...", aggressiveness=0.5)
```

## Performance

Requests are gzip-compressed and use HTTP keep-alive automatically.

| Input Size | E2E Latency | Throughput |
|---|---|---|
| 10K tokens | 38ms | 198K tok/s |
| 100K tokens | 85ms | 975K tok/s |
| 1M tokens | 542ms | 1.5M tok/s |

## Error Handling

```python
from tokenc import TokenClient, AuthenticationError, RateLimitError, APIError

try:
    result = client.compress_input(input="Your text...")
except AuthenticationError:
    print("Invalid API key")
except RateLimitError:
    print("Rate limit exceeded")
except APIError as e:
    print(f"API error: {e}")
```

## Links

- Get API keys: https://thetokencompany.com
- Issues: https://github.com/TheTokenCompany/tokenc-python-sdk/issues
