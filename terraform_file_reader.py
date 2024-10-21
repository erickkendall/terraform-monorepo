import re

def read_terraform_file(file_name):
    try:
        with open(file_name, 'r') as file:
            return file.read()
    except FileNotFoundError:
        print(f"Error: The file '{file_name}' was not found.")
        return None
    except IOError:
        print(f"Error: There was an issue reading the file '{file_name}'.")
        return None

def extract_variables(content):
    # This regex pattern looks for variable blocks
    pattern = r'variable\s+"([a-zA-Z_][a-zA-Z0-9_]*)"\s*{([^}]*)}'
    matches = re.findall(pattern, content, re.DOTALL)

    for name, block in matches:
      print(f"name {name}")
    

def main():
    file_name = input("Enter the name of the Terraform file: ")
    content = read_terraform_file(file_name)
    
    if content:
        variables = extract_variables(content)

if __name__ == "__main__":
    main()
