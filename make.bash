#!/bin/bash

rm -r bin
mkdir bin
mpifort -fbounds-check -g -Wall -o ./bin/bicgstab ./src/bicgstab.F90 -I../lis_bin/include -L../lis_bin/lib -llis -fopenmp
