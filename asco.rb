require 'formula'

class Asco < Formula
  homepage 'http://asco.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/asco/files/asco/0.4.9/ASCO-0.4.9.tar.gz'
  sha1 '1025587696f84c6959e672ad890971690c63a0a4'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def patches
    # expand build scripts
    system "tar", "xvfz", "Autotools.tar.gz"

    # patch configure.ac to set Darwin as Unix
    # point to correct include location
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

