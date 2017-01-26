class Qucs < Formula
  homepage "http://sourceforge.net/projects/qucs/"

  url "http://sourceforge.net/projects/qucs/files/qucs/0.0.19/qucs-0.0.19.tar.gz"
  sha256 "45c6434fde24c533e63550675ac21cdbd3cc6cbba29b82a1dc3f36e7dd4b3b3e"

  depends_on "cartr/qt4/qt"
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "adms" => :build

  resource "documentation" do
    url "https://sourceforge.net/projects/qucs/files/qucs-binary/0.0.19/qucs-doc-0.0.19-PDF.tar.gz"
    sha256 "69f1c36192b9c5fc7c0463d44009ead91e11dc286728e55e53520497d6a097b5"
  end

  # work around multiple Qt versions (official and brew)
  patch :p1 do
    # the first one below no longer applies
    #url "https://trac.macports.org/export/125874/trunk/dports/science/qucs/files/patch-configure.diff"
    url "https://raw.githubusercontent.com/guitorri/homebrew-tap/master/patches/patch-configure-0.0.19.patch"
    sha256 "bf9ffced83ef5631922e551f1950e7fdaad5747ca481b97406b64cad5ca4c90e"
  end

  def install
      # for some reason the documentation must be installed first.
      share.install resource("documentation")

      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-sdk",  # don"t look for SDK
                            "--disable-doc",
                            "--prefix=#{prefix}"
      system "make", "install"

      # note, macdeploy is currenlty failing, but the binaries should still work.
  end

  def caveats; <<-EOS.undent
    qucs.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        ln -s #{prefix}/qucs.app /Applications
    EOS
  end

end

