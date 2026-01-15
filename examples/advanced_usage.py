"""
Advanced usage examples for the tokenc SDK
"""

from tokenc import TokenClient, CompressionSettings

def compare_compression_levels():
    """Compare different compression aggressiveness levels."""
    client = TokenClient(api_key="your-api-key-here")

    text = """
    Artificial intelligence and machine learning technologies have been
    rapidly advancing in recent years. These technologies are transforming
    various industries including healthcare, finance, transportation, and
    many others. Large language models in particular have shown remarkable
    capabilities in understanding and generating human-like text.
    """

    levels = [
        (0.2, "Light"),
        (0.5, "Moderate"),
        (0.8, "Aggressive")
    ]

    print("Comparing Compression Levels")
    print("="*80)

    for aggressiveness, level_name in levels:
        response = client.compress_input(
            input=text,
            aggressiveness=aggressiveness
        )

        print(f"\n{level_name} Compression (aggressiveness={aggressiveness}):")
        print(f"  Output: {response.output}")
        print(f"  Tokens: {response.original_input_tokens} → {response.output_tokens}")
        print(f"  Saved: {response.compression_percentage:.1f}%")


def use_custom_settings():
    """Example using custom compression settings."""
    client = TokenClient(api_key="your-api-key-here")

    text = "Your long text here..." * 50

    # Create custom settings with token constraints
    settings = CompressionSettings(
        aggressiveness=0.6,
        max_output_tokens=200,
        min_output_tokens=100
    )

    response = client.compress_input(
        input=text,
        compression_settings=settings
    )

    print("\nCustom Settings Compression:")
    print(f"  Output tokens: {response.output_tokens}")
    print(f"  Within range: {100 <= response.output_tokens <= 200}")


def use_context_manager():
    """Example using the client as a context manager."""
    with TokenClient(api_key="your-api-key-here") as client:
        response = client.compress_input(
            input="This is a test of the context manager pattern.",
            aggressiveness=0.5
        )
        print("\nContext Manager Usage:")
        print(f"  Compressed: {response.output}")
    # Client session automatically closed


def batch_compression():
    """Example compressing multiple texts."""
    client = TokenClient(api_key="your-api-key-here")

    texts = [
        "First document with lots of content to compress...",
        "Second document with even more verbose content...",
        "Third document that needs compression as well...",
    ]

    total_saved = 0

    print("\nBatch Compression:")
    for i, text in enumerate(texts, 1):
        response = client.compress_input(input=text, aggressiveness=0.5)
        total_saved += response.tokens_saved
        print(f"  Document {i}: {response.tokens_saved} tokens saved")

    print(f"  Total tokens saved: {total_saved}")


if __name__ == "__main__":
    print("Advanced Usage Examples\n")

    compare_compression_levels()
    use_custom_settings()
    use_context_manager()
    batch_compression()
