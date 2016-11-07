require 'formula'

class Asco < Formula
  homepage 'http://asco.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/asco/files/asco/0.4.10/ASCO-0.4.10.tar.gz'
  sha256 '54f769909157c358055b21ff48abac7eff6cc10651bee977e7bf23d6045b3985'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def install
    system "tar", "xvfz", "Autotools.tar.gz"
    system "aclocal"
    system "automake", "-f", "-c", "-a"
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "asco", "h"
  end
end
