require 'formula'

class Asco < Formula
  homepage 'http://asco.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/asco/files/asco/0.4.9/ASCO-0.4.9.tar.gz'
  sha256 'd17ed1431e89886d9992aebe1993d25e4e64428072007f03ce3b13de31c1b79e'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def patches
    # expand build scripts
    system "tar", "xvfz", "Autotools.tar.gz"

    # patch configure.ac to set Darwin as Unix
    # point to correct include location
    # remove deprecated header include (FreeBSD)
    DATA
  end

  def install
    system "touch", "NEWS" # automake complain if it is not there
    system "aclocal"
    system "automake", "-f", "-c", "-a"
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "asco", "h"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 6d362b0..6300469 100644
--- a/configure.ac
+++ b/configure.ac
@@ -53,6 +53,13 @@ if test "x$GCC" = xyes; then
   fi
 fi
 
+dnl Force the Unix definition
+case $host_os in
+  *darwin*)
+  CFLAGS="$CFLAGS -DUNIX -I/usr/include/malloc"
+  ;;
+esac
+
 dnl Check for MP-ICC.
 AC_PATH_PROG(CC_MPI, mpicc, :)
 AM_CONDITIONAL(MPI, test "$CC_MPI" != ":")

diff --git a/de36.c b/de36.c
index b573d5c..5955197 100644
--- a/de36.c
+++ b/de36.c
@@ -475,6 +475,8 @@ int DE(int argc, char *argv[])
 	char laux[LONGSTRINGSIZE];
 	int ii;
 
+  setvbuf(stdout, NULL, _IONBF, 0); /* set unbuffered */
+
 	#ifdef MPI
 	double tmp_y[MAXPOP][MAXDIM], trial_cost_y[MAXPOP];
 	int k, m, count;
diff -ur orig/asco/nmlatest.c ./asco/nmlatest.c
--- a/nmlatest.c	2006-05-22 10:54:00.000000000 +0200
+++ b/nmlatest.c	2014-02-18 22:05:13.000000000 +0100
@@ -52,7 +52,6 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#include <malloc.h>
 #include <math.h>
 
 /* #include "auxfunc.h" */
