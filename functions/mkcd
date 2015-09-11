# -*- shell-script -*-
# mkcd: a script which declares a function, mkcd.

# Time-stamp: <2010-10-07 09:57:40 root mkcd>

# mkcd creates a directory hierarchy, then cds into it all in one
# swell foop. To use it in your shell, run it as:

# . /path/mkcd

# That will execute it without launching a new shell, so that it
# changes your current shell's environment.

# You can then use the function in scripts or from the terminal to
# create a new directory or directory hierarchy, and cd into it. E.g:

# mkcd foo/bar/baz

# 2010-10-07: Added ability to allow spaces in directory names
# (yucch), per http://onethingwell.org/post/586977440/mkcd-improved.

function mkcd
{
  dir="$*";
  mkdir -p "$dir" && cd "$dir";
}
