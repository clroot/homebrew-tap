class Slimg < Formula
  desc "Image optimization CLI — convert, compress, and resize images using MozJPEG, OxiPNG, WebP, AVIF, and QOI"
  homepage "https://github.com/clroot/slimg"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.5.0/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "c40527c90932014569464103284208a0766fb86f066e154bc8beed17a67bb62c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.5.0/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "3818521dfed3ace16ae9720b6bf78df12b4ca395ccd467e8e984556fcf446b40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.5.0/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "615bc1c17d0c4b926afe4cc33106c6ed79c25aee36d76b7e35a1d99822391517"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.5.0/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8af2ebf6758767d8a745b01518e09e8c8515e9b78e2001c33f65414abc0e197c"
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
