# Overview

The point of this repository is to test whether various calls in
object-oriented Fortran code are inlined by the intel compiler.

My hypothesis was that a call to an object-oriented routine would
prevent inline due to the need for dynamic dispatch.

# Compilation & running

Before compiling these, I sourced `env_mach_specific.sh` to get the
right environment on cheyenne.

I then compiled everything using `make all`, and then ran the resulting
executables from the cheyenne login nodes. (I ran them each a few times,
but there was very little variability between runs of a given
executable. The total runtime of each was 0.01 - 0.03 sec.)

# Results

## Calling a non-OO routine (`non_oo_routine.f90`)

The timing and assembly both suggest that this is inlined. (The timing
and assembly are both effectively the same as the "inline.f90" version.)
This is confirmed by the optrpt.

## Calling an OO routine (`oo_routine.f90`)

The timing (about 3x as long), assembly (search for 'vaddsd') and optrpt
all suggest that this was NOT inlined. This is consistent with my
hypothesis.

## Calling a non-overridable OO routine (`oo_nonoverridable_routine.f90`)

This was no better than `oo_routine.f90` (based on timing, assembly and
optrpt). I had hoped that declaring the subroutine to be non-overridable
would allow the compiler to inline it (because I think dynamic dispatch
shouldn't be needed in this case). However, the resulting assembly was
effectively identical to `oo_routine.f90`.

# Conclusions

If you want a subroutine call to be inlined, it should be written in a
procedural, not object-oriented way.

In the CESM / CTSM context, this means: If you want to avoid the
overhead of procedure calls, allow loops to be vectorized, etc., then
routines that operate on a single point should be written in a
procedural manner. Object-oriented routines should have loops over
points inside them, rather than being called from within a loop over
points.

# Other things I have tried

## Things I have tried

- Compiling with `-O3` rather than `-O2`: made essentially no difference
  to any of the test cases

- Using the `FORCEINLINE` intel compiler directives
  (https://software.intel.com/en-us/articles/procedure-inlining-intel-fortran-compiler):
  I tried this with `oo_nonoverridable_routine.f90`; the timing was not
  improved, and the optrpt still suggests that this was NOT inlined.
