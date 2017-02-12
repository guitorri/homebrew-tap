require 'formula'

class Freehdl < Formula
  homepage ''
  url 'http://sourceforge.net/projects/qucs/files/qucs/0.0.16/freehdl-0.0.8.tar.gz'
  sha256 '7f0978f8252329450de43e98c04c15fdd8a3f2bdc5ca91f75f8f5dd280c6ed84'

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'bison' => :build
  depends_on 'flex' => :build

  # fix lib extension
  patch :DATA

  fails_with :clang do
    cause 'not sure about the reason'
  end

  # failed attempt to fix it for gcc-6:
  # https://github.com/guitorri/homebrew-tap/commit/67cefd067b4815bc8a79cacb711b027645109a78
  fails_with :gcc => "6" do
    cause 'multiple errors'
  end

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  bottle do
    root_url "https://dl.bintray.com/guitorri/homebrew-tap"
    sha256 "a4a2f00c98d7f5bdad2162a7db511de837217108a0dd47a81358f179e1b1c70a" => :sierra
  end
end

__END__
diff --git a/freehdl/freehdl-config b/freehdl/freehdl-config
index d99af96..ab74589 100644
--- a/freehdl/freehdl-config
+++ b/freehdl/freehdl-config
@@ -30,6 +30,13 @@ cxxflags=`pkg-config --variable cxxflags freehdl`
 cxx=`pkg-config --variable cxx freehdl`
 linker=`pkg-config --variable libtool freehdl`
 
+unamestr=`uname`
+if [[ "$unamestr" == 'Linux' ]]; then
+  ext=la
+elif [[ "$unamestr" == 'Darwin' ]]; then
+  ext=dylib
+fi
+
 case "$option" in
 
   --version | -version | -v)
@@ -39,10 +46,10 @@ case "$option" in
 	echo "-L$libdir" ;;
 
   --libtool | -libtool | -libs)
-	echo "$libdir/libfreehdl-kernel.la $libdir/libfreehdl-std.la" ;;
+	echo "$libdir/libfreehdl-kernel.$ext $libdir/libfreehdl-std.$ext" ;;
 
   --ieee | -ieee)
-	echo "$libdir/freehdl/libieee.la" ;;
+	echo "$libdir/freehdl/libieee.$ext" ;;
 
   --cxxflags | -cxxflags | -c)
 	echo "$cxxflags -I$includedir" ;;

diff --git a/kernel/fhdl_stream.cc b/kernel/fhdl_stream.cc
index b56cbfe..dcdf745 100644
--- a/kernel/fhdl_stream.cc
+++ b/kernel/fhdl_stream.cc
@@ -3,6 +3,7 @@
 #include <unistd.h>
 #endif
 #include <sstream>
+#include <cstring>
 #include <assert.h>
 #include <freehdl/kernel-error.hh>
 #include <freehdl/kernel-fhdl-stream.hh>

