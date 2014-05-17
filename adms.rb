require 'formula'

class Adms < Formula
  homepage 'https://github.com/Qucs/ADMS'
  url 'http://sourceforge.net/projects/mot-adms/files/adms-source/2.3/adms-2.3.2.tar.gz'
  sha1 'ada4bcc90903a8b8bd698a888ee432a540fd42f5'

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
