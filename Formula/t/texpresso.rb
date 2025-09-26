class Texpresso < Formula
  desc "TeXpresso: live rendering and error reporting for LaTeX"
  homepage "https://github.com/let-def/texpresso"
  head "https://github.com/let-def/texpresso.git", branch: "main"
  url "https://github.com/let-def/texpresso.git", tag: "v0.1"
  license "MIT"

  patch :DATA

  depends_on "rust"
  depends_on "mupdf-tools"
  depends_on "SDL2"
  depends_on "pkg-config" => :build
  depends_on "freetype" => :build
  depends_on "icu4c" => :build
  depends_on "libpng" => :build
  depends_on "graphite2" => :build
  depends_on "harfbuzz" => :build
  depends_on "glib" => :build

  def install
    system "make", "BREW=#{HOMEBREW_PREFIX}", "BREW_ICU4C=#{Formula['icu4c'].prefix}"
    bin.install "build/texpresso", "build/texpresso-tonic"

  end
end


__END__
diff --git a/Makefile b/Makefile
index f140fe7..ca2f511 100644
--- a/Makefile
+++ b/Makefile
@@ -48,7 +48,7 @@ config:
 	echo >>Makefile.config 'CC=gcc $$(CFLAGS)'
 	echo >>Makefile.config 'LDCC=g++ $$(CFLAGS)'
 	echo >>Makefile.config "LIBS=-L$(BREW)/lib -lmupdf -lm `CC=gcc ./mupdf-config.sh -L$(BREW)/lib` -lz -ljpeg -ljbig2dec -lharfbuzz -lfreetype -lopenjp2 -lSDL2"
-	echo >>Makefile.config "TECTONIC_ENV=PKG_CONFIG_PATH=$(BREW_ICU4C)/lib/pkgconfig C_INCLUDE_PATH=$(BREW_ICU4C)/include LIBRARY_PATH=$(BREW_ICU4C)/lib"
+	echo >>Makefile.config "TECTONIC_ENV=C_INCLUDE_PATH=$(BREW_ICU4C)/include LIBRARY_PATH=$(BREW_ICU4C)/lib"
 endif
 
 texpresso-tonic:
