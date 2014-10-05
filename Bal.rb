require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb

class Bal < Formula
  homepage "https://sourceforge.net/projects/biflib/"
  url "http://sourceforge.net/projects/biflib/files/Releases/Beta/0.9/bal-0.9.5.tar.gz"
  sha1 "702f729956de6d98dcfa82ed787818af5c454d4f"


  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'boost' => :build
  depends_on 'sundials' => :build
  depends_on 'hdf5'

  #depends_on 'python'

  # don't handle warning as error
  # search for boost libs
  # fix call to cvode
  patch :DATA

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    system "aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "-a", "-c"

    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps


    cd "python" do
      system "python", "setup.py", "install", "--prefix=#{prefix}"
    end
  end

end

__END__
diff --git a/configure.ac b/configure.ac
index 3df6578..f5e2084 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,7 +5,7 @@ AC_PREREQ([2.61])
 AC_INIT([bal], [0.9.5], [danielelinaro@gmail.com])
 AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_SRCDIR([src/balObject.h])
-AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AM_INIT_AUTOMAKE([-Wall foreign])
 LT_INIT
 
 # operating system's information
@@ -64,11 +64,16 @@ AC_CHECK_LIB([hdf5_hl], [H5LTmake_dataset_double], [], [
 echo "Can't find HDF5 library."
 exit
 ])
-AC_CHECK_LIB([boost_thread], [pthread_create], [], [
-echo "Can't find boost thread library."
-exit
+AC_CHECK_LIB(boost_thread-mt, pthread_create, , [
+  AC_CHECK_LIB(boost_thread, pthread_create, , [
+    AC_MSG_ERROR("Can't find boost thread library.")
+  ])
+])
+AC_CHECK_LIB(boost_system-mt, main, , [
+  AC_CHECK_LIB(boost_system, main, , [
+    AC_MSG_ERROR("Cant't fine boost system library.")
+  ])
 ])
-
 # defines
 LIB_CURRENT=0
 LIB_REVISION=0

diff --git a/src/balDynamicalSystem.cpp b/src/balDynamicalSystem.cpp
index d41f9ed..bb435af 100644
--- a/src/balDynamicalSystem.cpp
+++ b/src/balDynamicalSystem.cpp
@@ -165,7 +165,7 @@ int DynamicalSystem::JacobianWrapper (long int N, DenseMat J, realtype t, N_Vect
 					 N_Vector fy, void *sys, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3) {
 #endif
 #ifdef CVODE26
-int DynamicalSystem::JacobianWrapper (int N, realtype t, N_Vector x, N_Vector fy, 
+int DynamicalSystem::JacobianWrapper (long N, realtype t, N_Vector x, N_Vector fy, 
 					 DlsMat J, void *sys, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3) {
 #endif
   DynamicalSystem * bds = (DynamicalSystem *) sys;
diff --git a/src/balDynamicalSystem.h b/src/balDynamicalSystem.h
index fccba5c..9ad417f 100644
--- a/src/balDynamicalSystem.h
+++ b/src/balDynamicalSystem.h
@@ -80,7 +80,7 @@ class DynamicalSystem : public Object {
 #endif
   
 #ifdef CVODE26
-  static int JacobianWrapper (int N, realtype t, N_Vector x, N_Vector fy, 
+  static int JacobianWrapper (long N, realtype t, N_Vector x, N_Vector fy, 
 			      DlsMat J, void *sys, N_Vector tmp1, N_Vector tmp2, N_Vector tmp3);
   static int JacobianFiniteDifferences (long int N, realtype t, N_Vector x,
 					DlsMat J, void *sys);

