require 'formula'

class RmlMmc < Formula
  homepage 'http://www.ida.liu.se/labs/pelab/rml'
  url 'http://build.openmodelica.org/apt/pool/contrib/rml-mmc_260.orig.tar.gz'
  version '2.6.0'
  sha1 '22acb73e9d5e0a52c853a8cf73cf10d02d749d36'

  # Attention, has a self-signed certificate and svn will prompt you, so
  # do not use --HEAD as a dependency or automatic installation (built-bot).
  head 'https://openmodelica.org/svn/MetaModelica/trunk', :using => :svn

  depends_on 'smlnj'

  def install
    ENV.j1
    # Change the next lines to Formula.factory("smlnj").prefix/'SMLNJ_HOME'
    # once https://github.com/mxcl/homebrew/pull/16355 is pulled!
    # Setting the path will no longer be necessary, then.
    ENV['SMLNJ_HOME'] = Formula.factory("smlnj").libexec
    ENV.append 'PATH', "#{ENV['SMLNJ_HOME']}/bin"

    system "./configure --prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/rml", "-v"
  end
end
