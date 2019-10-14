module test_timing_mod

  implicit none
  private

  type, public :: test_timing_type
   contains
     procedure, public  :: test_timing_wrapper
  end type test_timing_type

contains

  subroutine test_timing_wrapper(this)
    class(test_timing_type), intent(inout) :: this

    double precision :: x
    double precision :: t1, t2
    integer :: i
    integer, parameter :: iters = 10000000

    x = 0.d00
    call cpu_time(t1)
    do i = 1, iters
       x = x + 1.d00
    end do
    call cpu_time(t2)
    print *, 'elapsed time, x = ', t2 - t1, x
  end subroutine test_timing_wrapper

end module test_timing_mod

program test_timing_prog
  use test_timing_mod, only : test_timing_type

  ! Make this allocatable to prevent the test_timing_wrapper call from being inlined
  class(test_timing_type), allocatable :: t
  allocate(t, source=test_timing_type())

  call t%test_timing_wrapper()
end program test_timing_prog
