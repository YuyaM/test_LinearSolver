import numpy as np
import scipy.io

print("b:", scipy.io.mminfo('poisson3Da_b.mtx'))
b = scipy.io.mmread('poisson3Da_b.mtx')
print("size of b", b.size)
i = np.arange(b.size)

data = np.array([i+1])
np.savetxt("bar.csv", data, delimiter="\n", fmt="%1d")
