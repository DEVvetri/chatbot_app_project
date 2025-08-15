import cohere

# Initialize the Cohere client
client = cohere.Client(api_key="LTdCzgQQkSoPoIzgKRwhd5kRQLxvXnEW9i1SuhuR")  # Replace with your actual API key

# Define rules as part of the model prompt
predefined_rules = """
if user said a summary the nyou have to get user name and email and phone number 
your work to extract this thinks from user given statment

"""

# Terminal chatbot function
def main():
    print("Welcome to AURAMEMO.AI! (Type 'exit' to quit the chat)")
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
