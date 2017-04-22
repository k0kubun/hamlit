#ifndef HAMLIT_RUBINIUS_COMPAT_H
# define HAMLIT_RUBINIUS_COMPAT_H
# include "ruby/defines.h"

# ifdef RUBINIUS
#  define ST_CONTINUE 0
#  define UNLIMITED_ARGUMENTS (-1)

static inline int
rb_check_arity(int argc, int min, int max)
{
  if ((argc < min) || (max != UNLIMITED_ARGUMENTS && argc > max))
    rb_exc_raise(rb_eArgError);
  return argc;
}

#  define rb_ary_sort_bang(buf) rb_funcall(buf, rb_intern("sort!"), 0);

# endif

#endif
