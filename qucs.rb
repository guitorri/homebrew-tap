require 'formula'

class Qucs < Formula
  homepage 'http://sourceforge.net/projects/qucs/'

  stable do
    url 'http://sourceforge.net/projects/qucs/files/qucs/0.0.18/qucs-0.0.18.tar.gz'
    sha1 'e13580c12fa4f9d7a09f6a2b412bd772362e44ac'
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
  depends_on 'adms' => :recomended
  depends_on 'asco' => :recomended
  #depends_on 'octave' => :optional

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

