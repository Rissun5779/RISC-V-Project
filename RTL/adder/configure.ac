#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.71])
AC_INIT([adder-proj], [0.1], [rissun57@gmail.com])
AM_INIT_AUTOMAKE
AC_PROG_CC

AC_CHECK_PROGS([IVERILOG], [iverilog], [no])
AC_CHECK_PROGS([VVP], [vvp], [no])

if test "x$IVERILOG" = "xno"; then
    AC_MSG_ERROR([iverilog not found])
fi

if test "x$VVP" = "xno"; then
    AC_MSG_ERROR([vvp not found])
fi
# Checks for programs.

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
