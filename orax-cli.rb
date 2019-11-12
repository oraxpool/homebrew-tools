class OraxCli < Formula
  desc "CLI tool for the PegNet mining pool Orax"
  homepage "https://www.oraxpool.com"
  url "https://oraxpool.s3.ca-central-1.amazonaws.com/orax-cli/orax-cli-darwin-amd64-1.0.8.tar.gz"
  sha256 "b6e00ca2dd5e14aa009340a1afa2e914b35706233544340af7cd0f094fca4a16"

  bottle :unneeded

  option "with-background-cores=", "The number of cores to use for the background service."

  def install
    mv "orax-cli-darwin-amd64", "orax-cli"
    bin.install "orax-cli"
  end

  def caveats
    s = <<~EOS
    Register your miner by running:
      orax-cli register

    Full instructions for getting started:
      https://docs.oraxpool.com/getting-started/quickstart-guide
    EOS
    s
  end

  plist_options :startup => false
  plist_options :manual => "orax-cli mine"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/orax-cli</string>
        <string>mine</string>
        #{ARGV.value("with-background-cores") ? '<string>-n</string>' : ''}
        #{ARGV.value("with-background-cores") ? "<string>#{ARGV.value("with-background-cores")}</string>" : ''}
      </array>
      <key>RunAtLoad</key>
      <false/>
      <key>KeepAlive</key>
      <true/>
      <key>StandardOutPath</key>
      <string>#{var}/log/orax-cli-output.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/orax-cli-error.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/orax-cli", "--version"
  end
end