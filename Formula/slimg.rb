class Slimg < Formula
  desc "Image optimization CLI — convert, optimize, resize"
  homepage "https://github.com/clroot/slimg"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.3/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "0fb9f39e83036d3cd0b66be344a28db851d26ee3c319fbb333d47cd4556e1c92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.3/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "d4234f704b5f0012a0b8c1c7adc9ae1a577bc191d0e514260be675613e05f152"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.3/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f5c10f46f6135f6d99c20ad6097c4344c5f3637b2c0618bab13e02ce9d58fd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.3/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cf965b28381a24a9fbabca5e06eca71b5ec83d58d7c17337bac899f0c516f36c"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "slimg" if OS.mac? && Hardware::CPU.arm?
    bin.install "slimg" if OS.mac? && Hardware::CPU.intel?
    bin.install "slimg" if OS.linux? && Hardware::CPU.arm?
    bin.install "slimg" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
