class Slimg < Formula
  desc "Image optimization CLI — convert, compress, and resize images using MozJPEG, OxiPNG, WebP, AVIF, and QOI"
  homepage "https://github.com/clroot/slimg"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.6.1/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "7866e5669eb22ffa54270b7ee7249aa7cbc3f5e287d4399f03b4ed9b586a5c90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.6.1/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "13d01167647c5d2300216cc96526f61b1fc152a813e13911b9d263ec98837d17"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.6.1/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6223aa3a5493ecdb74b819c1cdc88c1cfd5ec22b3c4178bda5f8744b8982d7c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.6.1/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e7684485e2740ce4f980d58c65372f19b59f2546e039ee6530133e9b0372a707"
    end
  end
  license "MIT"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "slimg"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "slimg"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "slimg"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "slimg"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
