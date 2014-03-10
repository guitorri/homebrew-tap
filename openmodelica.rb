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
  depends_on 'bison' => :build
  depends_on 'flex' => :build
  depends_on 'guitorri/tap/rml-mmc' => :build
  depends_on 'readline' => :build
  depends_on 'sundials' => :build
  depends_on 'sqlite' => [:build, 'universal']
  depends_on 'gettext' => :build
  depends_on 'cmake' => :build
  depends_on 'qt' => :build
  depends_on 'qwt' => :build
  depends_on 'lp_solve' => [:build, 'python']
  depends_on 'omniorb' => :build

  depends_on :fortran  # for ipopt


  def patches
    [
    # 1) select Qt clients to build, skip omoptim omoptimbasis
    "https://gist.githubusercontent.com/guitorri/9475078/raw/faeea3d6abcaa867cc6563340ae84693ba5e6952/openmodelica_select_Qt_tools.patch",
    # 2) pass Qwt as framework for OMPlot
    "https://gist.githubusercontent.com/guitorri/9475193/raw/8bc871dfceefb8ddfb104ba7efb8df66777a4426/openmodlica_omplot_qwt_framework.patch",
    # 3) pass Qwt as framework for OMEdit
    "https://gist.githubusercontent.com/guitorri/9475172/raw/2f658d29c6147f0af0f10863d821c6be0a83aa37/openmodlica_omedit_qwt_framework.patch",
    # 4) fix std:: ref and lock name conflicts with std:ref and std::lock
    "https://gist.githubusercontent.com/guitorri/9475214/raw/703cdc6a07292917e68ecc6d0e32406b184e91d8/openmodelica_corba_name_conflict.patch"
    ]
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

    if ENV.compiler == :clang
      ENV.append 'CXXFLAGS', '-stdlib=libc++'
    end

    system "make"
    system "make", "install"
  end

  test do
    system "omc", "++v"
  end
end

