program test
implicit none
#include "lisf.h"

  integer*4   :: my_rank,nprocs
  LIS_INTEGER :: matrix_type, comm
  LIS_INTEGER :: omp_get_num_procs, omp_get_max_threads
  LIS_INTEGER :: i,n,gn,ln,is,ie,iter,ierr
  LIS_MATRIX  :: A
  LIS_VECTOR  :: x,b
  LIS_SOLVER  :: solver
  LIS_SCALAR  :: xtmp
  real(8),allocatable :: phi(:)

  n = 12

  ! 初期化
  call lis_initialize(ierr)
  comm = LIS_COMM_WORLD
  ! MPI
#ifdef USE_MPI
  call MPI_Comm_size(comm,nprocs,ierr)
  call MPI_Comm_rank(comm,my_rank,ierr)
#else
  nprocs  = 1
  my_rank = 0
#endif
  ! 行列のサイズ
  n = 12
  ln = 0
  ! CSR形式で格納
  matrix_type = LIS_MATRIX_CSR

  ! OpenMPI, OpenMPの確認
      if (my_rank .eq. 0) then
         write(*,'(a)') ''
         write(*,'(a,i0)') 'number of processes = ',nprocs
#ifdef _OPENMP
         write(*,'(a,i0)') 'max number of threads = ',omp_get_num_procs()
         write(*,'(a,i0)') 'number of threads = ', omp_get_max_threads()
#endif
      endif

  ! 行列Aの作成
  call lis_matrix_create(comm, A, ierr)
  call lis_vector_create(comm, b, ierr)
  call lis_vector_create(comm, x, ierr)
  call lis_matrix_set_type(A, matrix_type, ierr)
  call lis_input(A, b, x, "poisson3Da/poisson3Da_b_lis.mtx",ierr)
  write(*,*) "Input Success"
  ! 解ベクトルの作成　コピー
  call lis_vector_duplicate(b,x,ierr)
  call lis_vector_get_size(x,n,ln,ierr)
 
  ! Solver 
  call lis_solver_create(solver,ierr)
  call lis_solver_set_option("-print mem",solver,ierr)
  call lis_solver_set_option('-i bicgstab -p none', solver, ierr)
  call lis_solver_set_option('-tol 1.0e-12,', solver, ierr)
  call lis_solver_set_optionC(solver,ierr)
  call CHKERR(ierr)      
  call lis_solve(A,b,x,solver,ierr)
  call lis_solver_get_iter(solver,iter,ierr)
  write(*,'(a,i0)') 'number of iterations = ', iter
  write(*,'(a)') ''
  allocate(phi(n))
  ! Print
  open(100, file="x1.csv")
  do i=1, n
    call lis_vector_get_value(x, i, xtmp, ierr)
    phi(i) = xtmp
    write(100,'(F10.4)') xtmp
  enddo
  close(100)

  write(*,*) "Solution is ", n
  write(*,*) "Solution is ", phi(1) 
  ! Clean
  call lis_matrix_destroy(A,ierr)
  call lis_vector_destroy(b,ierr)
  call lis_vector_destroy(x,ierr)
  call lis_solver_destroy(solver,ierr)
  call lis_finalize(ierr)

end program test
