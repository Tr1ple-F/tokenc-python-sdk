"""
Basic usage example for the tokenc SDK
"""

from tokenc import TokenClient

def main():
    # Initialize the client with your API key
    client = TokenClient(api_key="your-api-key-here")

    # Example text to compress
    long_text = """
    This is a very long piece of text that contains a lot of unnecessary
    filler words and redundant information. When working with large language
    models, you often want to compress this kind of verbose content to save
    on token usage and reduce costs. The Token Company's compression service
    can help you achieve significant savings while maintaining the core
    meaning and important information from your original text.
    """

    # Compress with default settings (aggressiveness=0.5)
    response = client.compress_input(input=long_text)

    # Display results
    print("Original text:")
    print(long_text)
    print("\n" + "="*80 + "\n")

    print("Compressed text:")
    print(response.output)
    print("\n" + "="*80 + "\n")

    print("Compression Statistics:")
    print(f"  Original tokens: {response.original_input_tokens}")
    print(f"  Compressed tokens: {response.output_tokens}")
    print(f"  Tokens saved: {response.tokens_saved}")
    print(f"  Compression ratio: {response.compression_ratio:.2f}x")
    print(f"  Compression percentage: {response.compression_percentage:.1f}%")
    print(f"  Processing time: {response.compression_time:.3f}s")

if __name__ == "__main__":
    main()
