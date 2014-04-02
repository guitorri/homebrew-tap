require 'formula'

class Qucs < Formula
  homepage 'http://sourceforge.net/projects/qucs/'
  url 'http://sourceforge.net/projects/qucs/files/qucs/0.0.17/qucs-0.0.17.tar.gz'
  sha1 '756f993aa27f291faae92303d459f372940590bc'

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'bison' => :build
  depends_on 'flex' => :build
  depends_on 'qt' => [:build, "with-qt3support"]

  depends_on "apple-gcc42" if MacOS.version >= :mavericks

  #depends_on 'octave' => :optional

  #./qucs-0.0.17.mountain_lion.bottle.tar.gz
  #bottle do
  #  sha1 '130e6ad1d76b554a8a22cf46e025ce450e551048' => :mountain_lion
  #end

  def patches
    # configure asco as Unix
    DATA
  end

  def install

    if ENV.compiler == :clang
      opoo <<-EOS.undent
        Qucs 0.0.17 will fail with latest Clang.
        Please use:
          brew install qucs --cc=gcc-4.2
      EOS
    end

    # update asco configure script after patching
    cd 'asco' do
    system "autoconf"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    qucs.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{prefix}/qucs.app ~/Applications
    EOS
  end

end

__END__
diff --git a/asco/configure.ac b/asco/configure.ac
index 6d362b0..6300469 100644
--- a/asco/configure.ac
+++ b/asco/configure.ac
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

