class Audiobookshelf < Formula
  desc "Self-hosted audiobook and podcast server"
  homepage "https://audiobookshelf.org"
  url "https://github.com/advplyr/audiobookshelf/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "b0a3072c3274658c8de35af66a1ddffb5fee33eb5ec293046edb26a865a2519e"
  license "GPL-3.0-only"

  depends_on "ffmpeg"
  depends_on "node"
  depends_on "python-setuptools"

  def install
    system Formula["node"].libexec/"bin/npm", "ci", "--prefix", "client"
    system Formula["node"].libexec/"bin/npm", "run", "--prefix", "client", "generate"
    system Formula["node"].libexec/"bin/npm", "ci"
    prefix.install Dir["*"]
  end

  service do
    run [Formula["node"].libexec/"bin/npm", "--prefix", opt_prefix, "start"]
    keep_alive true
    error_log_path var/"log/audiobookshelf/server.log"
    log_path var/"log/audiobookshelf/server.log"
    environment_variables PATH: std_service_path_env, CONFIG_PATH: etc/"audiobookshelf-config", METADATA_PATH: etc/"audiobookshelf-metadata", SOURCE: "brew"
  end

  test do
    system "true"
  end
end
