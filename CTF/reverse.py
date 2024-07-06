from z3 import *

def obscure_function(s):
    result = 0
    for i, char in enumerate(s):
        result ^= ((ord(char) << (i % 4)) & 0xFF)
        result = ((result << 1) | (result >> 7)) & 0xFF
        print(f"After char '{char}' (ord={ord(char)}): {result}")  # Debug print
    return result

def symbolic_obscure_function(chars):
    result = BitVec('result', 8)
    result = 0
    for i, char in enumerate(chars):
        result ^= (char << (i % 4)) & 0xFF
        result = ((result << 1) | (result >> 7)) & 0xFF
    return result

def main():
    secret_value = 148
    user_input = input("Enter the secret string: ")
    
    result = obscure_function(user_input)
    print(f"Function result: {result}")
    print(f"Secret value: {secret_value}")
    
    if result == secret_value:
        print("Congratulations! Flag: CTF{y0u_cr4ck3d_th3_c0d3}")
    else:
        print("Sorry, that's not the correct secret string.")

def reverse_engineer():
    solver = Solver()
    
    # Adjust the length of the symbolic string
    length = 5  # Trying different lengths
    chars = [BitVec(f'char_{i}', 8) for i in range(length)]
    
    result = symbolic_obscure_function(chars)
    
    solver.add(result == 148)
    
    for char in chars:
        solver.add(char >= 32, char <= 126)
    
    if solver.check() == sat:
        model = solver.model()
        solution = ''.join(chr(model[char].as_long()) for char in chars)
        print(f"Found solution: {solution}")
        
        verification_result = obscure_function(solution)
        print(f"Verification result: {verification_result}")
        
        # Compare symbolic and actual results
        symbolic_result = model.eval(symbolic_obscure_function(chars))
        print(f"Symbolic result: {symbolic_result}")
        
        # Re-verify with obscure_function
        if verification_result == 148:
            print(f"Success! Found valid string: {solution}")
        else:
            print("Mismatch found. Debugging required.")
    else:
        print("No solution found")

if __name__ == "__main__":
    print("Original program:")
    main()
    
    print("\nReverse engineering:")
    reverse_engineer()
