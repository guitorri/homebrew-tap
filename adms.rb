class Adms < Formula
  homepage 'https://github.com/Qucs/ADMS'
  url 'http://sourceforge.net/projects/mot-adms/files/adms-source/2.3/adms-2.3.6.tar.gz'
  sha256 '7307e8c63967696209c514545001fa496538112af7b812958950b22e0d45c9e6'

  bottle do
    root_url "https://dl.bintray.com/guitorri/homebrew-tap"
    sha256 tag: "49bf86f2750ce1d97f750e4287ef181e6bc10e8bf5de5fe045027e6918f969fc"
  end

  depends_on 'autoconf'
  depends_on 'flex' => :build
  depends_on 'bison' => :build
  depends_on 'libtool' => :build
  depends_on 'automake'

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
