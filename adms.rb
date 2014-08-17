require 'formula'

class Adms < Formula
  homepage 'https://github.com/Qucs/ADMS'
  url 'http://sourceforge.net/projects/mot-adms/files/adms-source/2.3/adms-2.3.3.tar.gz'
  sha1 'a1cbe5a159c46c90f3d8f9c6ea1fb42dbb3044be'

  head do
    url 'https://github.com/Qucs/ADMS.git'
    depends_on 'cmake' => :build
    depends_on 'XML::LibXML' => :perl
    depends_on 'GD' => :perl
  end

  depends_on 'automake'
  depends_on 'autoconf'
  depends_on 'flex' => :build
  depends_on 'bison' => :build
  depends_on 'libtool' => :build

  def install
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
