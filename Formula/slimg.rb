class Slimg < Formula
  desc "Image optimization CLI — convert, compress, and resize images using MozJPEG, OxiPNG, WebP, AVIF, and QOI"
  homepage "https://github.com/clroot/slimg"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.2.0/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "99ff39c8e539dd3e9f4d86b55344e24a58bba25f89ee94e1bacb1aa7ab1da8e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.2.0/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "aa7c8a0cc6eb73089202c2703b2c96846b145b2313f825e25c88b70cb1db2376"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.2.0/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "88650a4eeb864d7795b7b1c4f215c1d594ffa49cc0d86b77e4ed7ce6b8b60e89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.2.0/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89a67cb13fbbbac03fd097fb01a323dfcca9f7221656111a487ba92331100d69"
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
