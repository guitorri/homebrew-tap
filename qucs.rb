require 'formula'

class Qucs < Formula
  homepage 'http://sourceforge.net/projects/qucs/'

  stable do
    url 'http://sourceforge.net/projects/qucs/files/qucs/0.0.18/qucs-0.0.18.tar.gz'
    sha256 '3609a18b57485dc9f19886ac6694667f3251702175bd1cbbbea37981b2c482a7'
  end

  head do
    url  'https://github.com/Qucs/qucs.git', :branch => 'master'
    depends_on 'asco' => :build
    depends_on 'libtool' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'bison' => :build
  depends_on 'flex' => :build
  depends_on 'qt' => [:build, "with-qt3support"]

  # use ADMS and ASCO formulae, disable configure/build of shipped packages
  depends_on 'adms' => :recommended
  depends_on 'asco' => :recommended
  #depends_on 'octave' => :optional

  # work around multiple Qt versions (official and brew)
  stable do
    patch :p0 do
      url "https://trac.macports.org/export/125874/trunk/dports/science/qucs/files/patch-configure.diff"
      sha256 "0b8742377637b8f6638cef7b3cdd12a3cf16c6497012cc85aaf566c2bc68d711"
    end
  end

  def install

    if build.head?

      cd 'qucs' do
        system "sh", "autogen.sh"
        system "./configure", "--enable-maintainer-mode", "--prefix=#{prefix}"
        system "make", "install"
      end

      ENV.j1 # head does not build in parallel, race on ADMS? issue with newer bison fix adms

      cd 'qucs-core' do
        system "sh", "bootstrap.sh"
        system "./configure", "--enable-maintainer-mode", "--prefix=#{prefix}"
        system "make", "install"
      end

    # stable
    else
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-asco", # use formula
                            "--disable-adms", # use formula
                            "--disable-sdk",  # don't look for SDK
                            "--prefix=#{prefix}"
      system "make", "install"
    end # if stable
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

