require 'formula'

class Freehdl < Formula
  homepage ''
  url 'http://sourceforge.net/projects/qucs/files/qucs/0.0.16/freehdl-0.0.8.tar.gz'
  sha1 'fa89707d1340e8729eb444062a6af91f360b0259'

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'bison' => :build
  depends_on 'flex' => :build

  fails_with :clang do
    cause 'not sure about the reason'
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
