import matplotlib.pyplot as plt
import numpy as np
import warnings

from pathlib import Path

def compute_mandelbrot(max_iter: int, threshold: float, width: int, height: int) -> np.ndarray:
    """
    Computes the Mandelbrot set over a specified grid.

    Parameters:
    - max_iter: maximum number of iterations per point
    - threshold: escape threshold
    - width: number of points along the x-axis
    - height: number of points along the y-axis
    """
    x = np.linspace(-2, 1, width)
    y = np.linspace(-1.5, 1.5, height)
    c = x[:, None] + 1j * y[None, :]

    z = c.copy()

    # Suppress any overflow.
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        for _ in range(max_iter):
            z = z**2 + c
        mandelbrot_set = (np.abs(z) < threshold)

    return mandelbrot_set

if __name__ == '__main__':
    MAX_ITER = 50
    THRESHOLD = 50.0
    WIDTH = 600
    HEIGHT = 400

    mandelbrot_set = compute_mandelbrot(MAX_ITER, THRESHOLD, WIDTH, HEIGHT)

    plt.imshow(mandelbrot_set.T, extent=[-2, 1, -1.5, 1.5])

    # Save the file and print out where it was located.
    file_path = Path('example.png')
    plt.savefig(file_path)
    print("File created at:\n\t{}".format(file_path.resolve()))
