require 'formula'

class Adms < Formula
  homepage 'https://github.com/Qucs/ADMS'
  url 'http://sourceforge.net/projects/mot-adms/files/adms-source/2.3/adms-2.3.4.tar.gz'
  sha256 '63498c24c3064ae86eae135ac7324e532bc8bb772eca5208204814df8f27931a'

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
