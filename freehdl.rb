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

diff --git a/freehdl/kernel-db.hh b/freehdl/kernel-db.hh
index a6b2a7c..807aece 100644
--- a/freehdl/kernel-db.hh
+++ b/freehdl/kernel-db.hh
@@ -254,7 +254,7 @@ public:
 
 // A hash function template used tp generate a hash number from
 // d
-class db_basic_key_hash : public hash<unsigned long> {
+class db_basic_key_hash : public std::hash<unsigned long> {
 public:
   size_t operator()(const db_basic_key& x) const {
     return (*(hash<unsigned long> *)this)(((unsigned long)x.value)>>2);
diff --git a/freehdl/kernel-util.hh b/freehdl/kernel-util.hh
index 2d0ad21..74e1bea 100644
--- a/freehdl/kernel-util.hh
+++ b/freehdl/kernel-util.hh
@@ -24,7 +24,7 @@ using namespace __gnu_cxx;
 // A hash function template used tp generate a hash number from
 // pointer values.
 template<class T>
-class pointer_hash : public hash<unsigned long> {
+class pointer_hash : public std::hash<unsigned long> {
 public:
   size_t operator()(const T& x) const {
     return (*(hash<unsigned long> *)this)(((unsigned long)x)>>2);

diff --git a/v2cc/v2cc-util.h b/v2cc/v2cc-util.h
index cad6ece..8197c98 100644
--- a/v2cc/v2cc-util.h
+++ b/v2cc/v2cc-util.h
@@ -241,6 +241,7 @@ convert_string(const string &str, int (*f)(int))
 }
 
 /* Convert an integer value into a string */
+/*
 template <class T>
 inline string
 to_string(T i)
@@ -266,6 +267,7 @@ to_string(double i)
     return str + ".0";
 #endif
 }
+*/
 
 /* Print scalar value into a string */
 string

diff --git a/v2cc/v2cc-util.h b/v2cc/v2cc-util.h
index 8197c98..c70c2a3 100644
--- a/v2cc/v2cc-util.h
+++ b/v2cc/v2cc-util.h
@@ -452,7 +452,7 @@ emit_posinfo(pIIR_PosInfo pi, string &str, pIIR_PosInfo_TextFile last_pos, int l
   // Emit line number and file name
   str += "#line " + to_string(pit->line_number);
   if (last_pos == NO_SOURCE_LINE)
-    str += " \"" + to_string(pit->file_name) + "\"\n";
+    str += " \"" + string(pit->file_name) + "\"\n";
   else
     str += "\n";
   

