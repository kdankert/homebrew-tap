class Audiobookshelf < Formula
  desc "Self-hosted audiobook and podcast server"
  homepage "https://audiobookshelf.org"
  url "https://github.com/advplyr/audiobookshelf/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "8926ef45166c66c8b686c01a30408cb1a9dc02ef6a4465ef876f2702d3c4bb94"
  license "GPL-3.0-only"

  depends_on "ffmpeg"
  depends_on "node"
  depends_on "python-setuptools"

  def install
    system "npm", "ci", "--prefix", "client"
    system "npm", "run", "--prefix", "client", "generate"
    system "npm", "ci"
    prefix.install Dir["*"]
    (bin/"audiobookshelf").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{opt_prefix}/index.js"
    EOS
    chmod 0555, bin/"audiobookshelf"
  end

  service do
    run [opt_bin/"audiobookshelf"]
    keep_alive true
    error_log_path var/"log/audiobookshelf/server.log"
    log_path var/"log/audiobookshelf/server.log"
    environment_variables PATH:          std_service_path_env,
                          CONFIG_PATH:   etc/"audiobookshelf-config",
                          METADATA_PATH: etc/"audiobookshelf-metadata",
                          SOURCE:        "brew"
  end
end
