# LGGCRA: Lie Group Greater Cane Rat Algorithm

## Introduction

LGGCRA (Lie Group Greater Cane Rat Algorithm) is an improved optimization algorithm based on the Greater Cane Rat Algorithm (GCRA). This algorithm leverages the Lie Group intrinsic mean to replace the reproduction coefficient in GCRA and incorporates a Lie Group kernel function to enhance model robustness. LGGCRA is designed to improve the global search capability, reduce the complexity of parameter tuning, and enhance accuracy and convergence speed.

## Features

- **Lie Group Intrinsic Mean**: Improves the population updating process.
- **Lie Group Kernel Function**: Enhances diversity and robustness.
- **Lie Group Manifold Space Distance**: Replaces the traditional Euclidean distance to better capture the search paths in real-world scenarios.
- **Superior Performance**: Demonstrates improved accuracy, convergence speed, and robustness compared to GCRA and other state-of-the-art algorithms.

## Installation

To install and use LGGCRA, you need to have Python installed on your machine. Clone the repository using the following command:

```bash
git clone https://github.com/shadowmask1130/LGGCRA.git
```
## Usage
Here is a simple example of how to use LGGCRA:
```python
from lggcra import LGGCRA

# Define your objective function
def objective_function(x):
    return sum([xi**2 for xi in x])

# Initialize the LGGCRA optimizer
optimizer = LGGCRA(objective_function, dimension=10, population_size=50, max_iterations=1000)

# Run the optimization
best_solution, best_fitness = optimizer.optimize()

print("Best Solution:", best_solution)
print("Best Fitness:", best_fitness)

```


## Benchmarks
The performance of LGGCRA has been evaluated on the CEC2020 test set and various classical benchmark problems. The results show that LGGCRA achieves superior optimization performance compared to GCRA and other state-of-the-art algorithms.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing
We welcome contributions to enhance LGGCRA. If you would like to contribute, please fork the repository and submit a pull request.
