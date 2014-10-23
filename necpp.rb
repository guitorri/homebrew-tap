require "formula"

class Necpp < Formula
  homepage "http://elec.otago.ac.nz/w/index.php/Necpp"

  stable do
    url "https://github.com/tmolteno/necpp/archive/v1.5.3.tar.gz"
    sha1 "eca5084b1996663b9258018d155e97c774ddfda1"
  end

  head do
    url "https://github.com/tmolteno/necpp.git", :branch => 'master'
  end

  depends_on 'libtool' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def install

    ENV.deparallelize  # fails when building in parallel

    # bootstrap
    system "make", "-f", "Makefile.git"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-lapack",
                          "--without-eigen"
    system "make", "install"
  end

  test do
    system "nec2++", "-v"
  end
end
