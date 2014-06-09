require 'formula'

class Freehdl < Formula
  homepage ''
  url 'http://sourceforge.net/projects/qucs/files/qucs/0.0.16/freehdl-0.0.8.tar.gz'
  sha1 'fa89707d1340e8729eb444062a6af91f360b0259'

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'bison' => :build
  depends_on 'flex' => :build

  # fix lib extension
  patch :DATA

  fails_with :clang do
    cause 'not sure about the reason'
  end


  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
