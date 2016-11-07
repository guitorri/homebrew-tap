require 'formula'

class Adms < Formula
  homepage 'https://github.com/Qucs/ADMS'
  url 'http://sourceforge.net/projects/mot-adms/files/adms-source/2.3/adms-2.3.5.tar.gz'
  sha256 'c8472b201f3601952b20a70dcd5a784956c1109da2d9f6452271d0337e8d8634'

  head do
    url 'https://github.com/Qucs/ADMS.git'
    depends_on 'cmake' => :build
    depends_on 'XML::LibXML' => :perl
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
