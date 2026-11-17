**SageMath** is a free, open-source mathematics software system licensed under the GPL. It builds on top of many existing open-source Python libraries and specialized mathematical engines (such as Maxima, GAP, Singular, PARI/GP, and NumPy) to provide a unified, powerful environment for advanced mathematics.

Its primary design goal is to create a viable, free, open-source alternative to proprietary systems like **Magma, Maple, Mathematica, and MATLAB**. Because SageMath is built on **Python**, you can use full programming constructs (loops, functions, object-oriented programming) alongside heavy-duty mathematical computation.

---

### Core Areas Covered by SageMath

* **Calculus:** Symbolic differentiation, integration, limits, and differential equations.
* **Algebra & Linear Algebra:** Matrix operations, polynomial rings, group theory, and abstract algebra.
* **Number Theory & Cryptography:** Prime factorization, elliptic curves, and modular arithmetic.
* **Geometry & Topology:** Polyhedra, manifolds, and graph theory.
* **Plotting:** 2D and 3D visualization of mathematical functions and geometric structures.

---

### Practical Code Examples

Here are several examples showing how SageMath handles various mathematical tasks using Python syntax:

#### 1. Calculus (Differentiation and Integration)

Sage allows you to define symbolic variables easily and perform calculus operations effortlessly.

```python
# Define a symbolic variable
x = var('x')

# Define a function
f = x^2 * sin(x)

# Find the derivative
df = diff(f, x)
print("Derivative:", df)

# Find the indefinite integral
integral_f = integrate(f, x)
print("Integral:", integral_f)

```

#### 2. Linear Algebra

You can create matrices, compute determinants, inverses, and find eigenvalues natively.

```python
# Define a 2x2 matrix
A = Matrix([[1, 2], [3, 4]])

# Compute determinant
print("Determinant:", A.det())

# Compute inverse
print("Inverse:\n", A.inverse())

# Find eigenvalues
print("Eigenvalues:", A.eigenvalues())

```

#### 3. Number Theory and Cryptography

Sage excels in number theory tasks, making it popular for cryptographic research and testing.

```python
# Check if a number is prime
print("Is 2027 prime?", is_prime(2027))

# Factorize an integer
print("Prime factors of 2026:", factor(2026))

# Perform modular arithmetic (e.g., 3^45 mod 100)
print("Modular exponentiation:", power_mod(3, 45, 100))

```

#### 4. Solving Equations

You can solve linear, non-linear, and algebraic equations symbolically.

```python
x, y = var('x y')

# Solve a single algebraic equation
eq = x^3 - 4*x == 0
solutions = solve(eq, x)
print("Solutions to x^3 - 4x = 0:", solutions)

# Solve a system of linear equations
system = [x + y == 5, 2*x - y == 1]
print("System solutions:", solve(system, x, y))

```

#### 5. Plotting Functions

SageMath has built-in 2D and 3D plotting capabilities using libraries like Matplotlib and Three.js under the hood.

```python
# Plot a 2D trigonometric function
p = plot(sin(x) * cos(x/2), (x, 0, 2*pi), color='purple', legend_label='sin(x)cos(x/2)')
p.show()

```

---

### How to Use SageMath

1. **Online (No Installation):** You can test Sage code instantly without installing anything via **[SageCell Server](https://sagecell.sagemath.org/)** or **CoCalc** (Collaborative Calculation).
2. **Jupyter Notebook:** SageMath comes with a built-in Jupyter kernel, allowing you to write interactive notebooks mixing markdown and Python/Sage code.
3. **Local Installation:** It can be installed natively on Linux, macOS, or via Windows Subsystem for Linux (WSL).