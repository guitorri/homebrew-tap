require 'formula'

class Adms < Formula
  homepage ''
  #url 'http://sourceforge.net/projects/mot-adms/files/adms-source/2.3/adms-2.3.0.tar.gz'
  #sha1 'c15a78d5c7e3a0bce4d52a4b336da107ae90b091'

  head 'https://github.com/upverter/ADMS.git', :branch => 'upverter'

  depends_on 'automake'
  depends_on 'autoconf'

  depends_on 'flex' => :build
  depends_on 'bison' => :build
  depends_on 'libtool' => :build
  depends_on 'XML::LibXML' => :perl
  depends_on 'GD' => :perl

  def install
    ENV.j1 # does not build in parallel

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "admsXml"
  end
end
