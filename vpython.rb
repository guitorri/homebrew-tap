require 'formula'

class Vpython < Formula
  homepage 'http://www.vpython.org/index.html'
  url 'http://sourceforge.net/projects/vpythonwx/files/6.05-release/vpython-wx-src.6.05b.zip'
  url 'http://downloads.sourceforge.net/projects/vpythonwx/files/6.05-release/vpython-wx-src.6.05b.zip'
  sha1 '55168f03b0d45e921a4bcf9759a946d444d9e76b'

  head 'https://github.com/BruceSherwood/vpython-wx.git'

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on :python => ['numpy', 'ttfquery']
  depends_on :python => ['Polygon'=> 'Polygon2']
  depends_on :python => ['fontTools' => 'fonttools2']
  depends_on :python => ['Polygon' => 'Polygon3'] if build.with? 'python3'
  depends_on :python => ['fontTools' => 'fonttools3'] if build.with? 'python3'
  depends_on 'boost' # => --build-from-source ? Python module needed
  depends_on 'wxmac' # libtiff needs to be -universal

  def install
    # boost was expected in tree
    inreplace "setup.py",
      "BOOST_DIR = os.path.join(VISUAL_DIR,os.path.join('dependencies','boost_files'))",
      "BOOST_DIR = '#{Formula.factory('boost').opt_prefix}/include/'"
    inreplace "setup.py",
      "BOOST_LIBDIR = os.path.join(BOOST_DIR,'mac_libs')",
      "BOOST_LIBDIR = '#{Formula.factory('boost').opt_prefix}/lib/'"

    if python2
      # fix pip dependencies
      inreplace "setup.py", "Polygon", "Polygon2"
      inreplace "setup.py", "fontTools", "fonttools2"
      # setup.py is pulling /System/Library/Frameworks/Python.framework/
      inreplace "setup.py",
      "os.environ['LDFLAGS'] = '-framework Cocoa -framework OpenGL -framework Python'",
      "os.environ['LDFLAGS'] = '-framework Cocoa -framework OpenGL -L#{python2.libdir} -F#{python2.framework}'"
    end

    if python3
      # fix pip dependencies
      inreplace "setup.py", "Polygon", "Polygon3"
      inreplace "setup.py", "fontTools", "fonttools3"
      # setup.py is pulling /System/Library/Frameworks/Python.framework/
      inreplace "setup.py",
      "os.environ['LDFLAGS'] = '-framework Cocoa -framework OpenGL -framework Python'",
      "os.environ['LDFLAGS'] = '-framework Cocoa -framework OpenGL -L#{python3.libdir} -F#{python3.framework}'"
    end

    system python, "setup.py", "install"

  end

  test do
    (testpath/'test.py').write <<-EOS.undent
      from visual import *

      floor = box (pos=(0,0,0), length=4, height=0.5, width=4, color=color.blue)
      ball = sphere (pos=(0,4,0), radius=1, color=color.red)
      ball.velocity = vector(0,-1,0)
      dt = 0.01

      while 1:
          rate (100)
          ball.pos = ball.pos + ball.velocity*dt
          if ball.y < ball.radius:
              ball.velocity.y = abs(ball.velocity.y)
          else:
              ball.velocity.y = ball.velocity.y - 9.8*dt
    EOS
    python do
      system python, "test.py"
    end
  end
end

