from z3 import *

# Create a solver instance
s = Solver()

# Declare two integer variables
x = Int('x')
y = Int('y')

# Add constraints to the solver
s.add(x > 0)
s.add(y < 10)
s.add(x + y == 7)

# Check if the constraints are satisfiable
result = s.check()

if result == sat:
    print("Z3 is working! Solution:")
    model = s.model()
    print("x =", model[x])
    print("y =", model[y])
else:
    print("Z3 is not working properly.")