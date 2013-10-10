require 'formula'

class Openmodelica < Formula
  homepage 'http://www.openmodelica.org/'
  url 'https://build.openmodelica.org/apt/pool/contrib/openmodelica_17628.orig.tar.gz'
  sha1 'cb31e8cb1e7b6b1c1e34491dc526bffebf234c6a'
  version '1.9.0'

  head 'https://openmodelica.org/svn/OpenModelica/trunk' , :using => :svn

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'cmake' => :build
  depends_on 'bison' => :build
  depends_on 'flex' => :build
  depends_on 'rml-mmc' => :build
  depends_on 'readline' => :build
  depends_on 'sundials' => :build
  depends_on 'sqlite' => :build
  depends_on 'gettext' => :build
  depends_on 'cmake' => :build
  depends_on 'qt' => :build
  depends_on 'qwt' => :build
  depends_on 'lp_solve' => [:build, 'python']
  depends_on 'omniorb' => [:build, 'with-python']

  # skip unwanted tools, configure Qt framework on OMPlot
  def patches
    DATA
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}",
                          "--with-omniORB=#{Formula.factory('omniorb').opt_prefix}",
                          "--with-qwt=#{Formula.factory('qwt').opt_prefix}",
                          "--without-paradiseo",
                          "--with-lapack=-framework Accelerate", # avoid the included OpenBlas
                          "--enable-modelica3d=no",
                          "--enable-omnotebook=no"
    system "make"
    system "make", "install"
  end

  test do
    system "omc", "++v"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 9ea401d..c12b406 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -78,7 +78,7 @@ omoptimbasis: mkbuilddirs
 	$(MAKE) -C OMOptimBasis/build -f Makefile.unix
 endif
 
-qtclients: @OMNOTEBOOK@ omshell omedit omplot omoptim omoptimbasis
+qtclients: @OMNOTEBOOK@ omplot # omshell omedit omoptim omoptimbasis
 
 qtclean: qtclean-common
 	$(MAKE) -C OMShell/OMShellGUI -f Makefile.unix clean
diff --git a/OMPlot/OMPlotGUI/OMPlotGUI.config.in b/OMPlot/OMPlotGUI/OMPlotGUI.config.in
index c9f2c57..60d6196 100644
--- a/OMPlot/OMPlotGUI/OMPlotGUI.config.in
+++ b/OMPlot/OMPlotGUI/OMPlotGUI.config.in
@@ -2,5 +2,7 @@ QMAKE_CC  = @CC@
 QMAKE_CXX = @CXX@
 QMAKE_LINK = @CXX@
 
-LIBS += -lqwt@with_qwt_suffix@
-INCLUDEPATH += @with_qwt@
+QMAKEFEATURES += @with_qwt@/features
+CONFIG += qwt
+LIBS += -F@with_qwt@/lib/ -framework qwt
+INCLUDEPATH += @with_qwt@/lib/qwt.framework/Headers

