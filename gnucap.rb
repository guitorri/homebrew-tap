class Gnucap < Formula
  desc "Gnu Circuit Analysis Package"
  homepage "http://gnucap.org/dokuwiki/doku.php?id=gnucap:start"
  url "http://git.savannah.gnu.org/cgit/gnucap.git/snapshot/gnucap-20171003.tar.gz"
  sha256 "2facf5e945cf253727bef9b8e2602767599ea77a6c0d8c5d91101764544fa09a"

  # compiler error, reported upstream
  patch :p1 do
    url "http://git.savannah.gnu.org/cgit/gnucap.git/patch/?id=3b114917182fa7941489b58cbdc0fba7a79c812b"
    sha256 "b708666fae23419ecfde290bb21abec56ff6b696d31494b6f4e26586be8a10f4"
  end

  # fix library search path at build time
  patch :p1 do
    url "https://raw.githubusercontent.com/guitorri/homebrew-tap/master/patches/gnucap-0001-DYLD_LIBRARY_PATH-behave-as-LD_LIBRARY_PATH-on-OSX.patch"
    sha256 "94b5f08d1ad5f6a465ff7452018716a9b47acd246a9ddc14477ae6d5c206fdad"
  end
  # let unresolved symbols in the plugin module
  patch :p1 do
    url "https://raw.githubusercontent.com/guitorri/homebrew-tap/master/patches/gnucap-0002-osx-resolve-gnucap-default-plugins-at-runtime.patch"
    sha256 "5b250140088c789a570f07dc1b0a9051a9a31b38aa9572899abf491c3cfc4f6d"
  end
  # fix positional parsing of prefix
  patch :p1 do
    url "https://raw.githubusercontent.com/guitorri/homebrew-tap/master/patches/gnucap-0003-parse-arguments-on-configure.patch"
    sha256 "f7ccd300f30b1e272f13838fedcb0a2ad7b2e03f37aacd27fb0ca70344afdc87"
  end

  def install
    system "./configure --prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"divider.ckt").write <<~EOS
    * voltage divider
    vi 1 0 1.0
    r1 1 2 10K
    r2 2 0 10K
    .list
    * run DC
    .print op v(1) v(2)
    .op
    * run DC sweep
    .width out=80
    .plot dc v(1)(0,1) v(2)(0,1)
    .dc vi 0.0 1.0 .1
    .end
    EOS

    system "gnucap", "-b", "divider.ckt"
  end
end

