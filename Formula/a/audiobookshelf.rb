class Audiobookshelf < Formula
  desc "Self-hosted audiobook and podcast server"
  homepage "https://audiobookshelf.org"
  url "https://github.com/advplyr/audiobookshelf/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "694ab44f8c4c2671f09d4a8f938d93043c7b9668bff6e3574b2452fabfdfaf50"
  license "GPL-3.0-only"

  depends_on "ffmpeg"
  depends_on "node"
  depends_on "python-setuptools"

  def install
    system "npm", "ci", "--prefix", "client"
    system "npm", "run", "--prefix", "client", "generate"
    system "npm", "ci"
    prefix.install Dir["*"]
  end

  service do
    run [Formula["node"].opt_bin/"npm", "--prefix", opt_prefix, "start"]
    keep_alive true
    error_log_path var/"log/audiobookshelf/server.log"
    log_path var/"log/audiobookshelf/server.log"
    environment_variables PATH: std_service_path_env, CONFIG_PATH: etc/"audiobookshelf-config", METADATA_PATH: etc/"audiobookshelf-metadata", SOURCE: "brew"
  end

  test do
    system "true"
  end
end
