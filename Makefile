
# From a cheyenne intel non-debug case from cime tag: branch_tags/cime5.8.3_chint17-05
FFLAGS = -qno-opt-dynamic-align  -convert big_endian -assume byterecl -ftz -traceback -assume realloc_lhs -fp-model source    -qopt-report -xCORE_AVX2 -no-fma  -O2 -debug minimal

all: inline non_oo_routine oo_routine oo_nonoverridable_routine

inline: inline.f90
	ifort ${FFLAGS} -S -fsource-asm -o inline.s inline.f90
	ifort ${FFLAGS} -o inline inline.f90

non_oo_routine: non_oo_routine.f90
	ifort ${FFLAGS} -S -fsource-asm -o non_oo_routine.s non_oo_routine.f90
	ifort ${FFLAGS} -o non_oo_routine non_oo_routine.f90

oo_routine: oo_routine.f90
	ifort ${FFLAGS} -S -fsource-asm -o oo_routine.s oo_routine.f90
	ifort ${FFLAGS} -o oo_routine oo_routine.f90

oo_nonoverridable_routine: oo_nonoverridable_routine.f90
	ifort ${FFLAGS} -S -fsource-asm -o oo_nonoverridable_routine.s oo_nonoverridable_routine.f90
	ifort ${FFLAGS} -o oo_nonoverridable_routine oo_nonoverridable_routine.f90

clean:
	rm -f *.mod *.o *.s *.optrpt inline non_oo_routine oo_routine oo_nonoverridable_routine
