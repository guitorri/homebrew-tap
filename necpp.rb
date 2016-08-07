require "formula"

class Necpp < Formula
  homepage "http://elec.otago.ac.nz/w/index.php/Necpp"

  stable do
    url "https://github.com/tmolteno/necpp/archive/v1.5.3.tar.gz"
    sha256 "e8e898e81de89e426d50758d71cb569c2aceb1b2972cfaaa201ebe0938e22f50"
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
