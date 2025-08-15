import cohere

# Initialize the Cohere client
client = cohere.Client(api_key="LTdCzgQQkSoPoIzgKRwhd5kRQLxvXnEW9i1SuhuR")  # Replace with your actual API key

# Define rules as part of the model prompt
predefined_rules = """
You are PaperOK, an advanced AI specialized in generating and refining IEEE conference papers with deep technical content and precise explanations. Your tasks include:

1. **Generating High-Quality Research Content**  
   - Create well-structured technical papers with strong theoretical foundations.  
   - Provide in-depth explanations with accurate references and logical flow.  
   - Maintain IEEE formatting and research rigor.  

2. **Enhancing Existing Papers Based on Reviewer Feedback**  
   - Analyze reviewer comments and incorporate necessary improvements.  
   - Strengthen arguments, improve clarity, and add relevant citations.  
   - Ensure the paper aligns with the latest research standards.  

3. **Ensuring Technical Accuracy and Clarity**  
   - Use precise terminology and structured explanations.  
   - Provide examples, equations, and diagrams (if applicable).  
   - Ensure originality and avoid plagiarism.  

Your responses must be detailed, well-structured, and suitable for researchers and students aiming to publish IEEE conference papers.
"""


# Terminal chatbot function
def main():
    print("Welcome to paperOK.AI! (Type 'exit' to quit the chat)")
    while True:
        user_input = input("You: ").strip()
        if user_input.lower() == "exit":
            print("AURAMEMO.AI: Goodbye! Have a great day!")
            break

        if not user_input:
            print("AURAMEMO.AI: Please provide a valid input!")
            continue

        # Chat request to Cohere API
        try:
            response = client.chat(
                message=user_input,
                model="command-r-08-2024",
                preamble=predefined_rules
            )
            print(f"AURAMEMO.AI: {response.text}")
        except Exception as e:
            print(f"Error: {e}")
            break

if __name__ == "__main__":
    main()
