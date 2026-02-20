class Slimg < Formula
  desc "Image optimization CLI — convert, compress, and resize images using MozJPEG, OxiPNG, WebP, AVIF, and QOI"
  homepage "https://github.com/clroot/slimg"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.5.1/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "b904c948503778211e412c9df128e0513dfc5e4a13da47edf40f5c846a227071"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.5.1/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "15f1653c8b130addffc0082b1405a3e2c61a63bdf6e690ee1d56a507f17fdcf5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.5.1/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "05586a7ca96266bca0e5b54920f89762137d1fbebaf3fdf493d41fd3272b1708"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.5.1/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e2bbe31ad3bfcd74750cb2a58af0b49263983a870ae3b1efece3446307f4a6d2"
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
