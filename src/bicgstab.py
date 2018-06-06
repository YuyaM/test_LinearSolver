
import numpy as np
import scipy.io
import scipy.sparse.linalg

print("A:", scipy.io.mminfo('poisson3Da/poisson3Da.mtx'))
print("b:", scipy.io.mminfo('poisson3Da/poisson3Da_b.mtx'))

A = scipy.io.mmread('poisson3Da/poisson3Da.mtx')
b = scipy.io.mmread('poisson3Da/poisson3Da_b.mtx')

x, info = scipy.sparse.linalg.bicgstab(A, b, tol=1e-12, maxiter=160)
print(info, x[0])
np.savetxt("x0.csv", x, delimiter="\n", fmt="%10.4f")
