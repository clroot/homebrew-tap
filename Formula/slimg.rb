class Slimg < Formula
  desc "Image optimization CLI — convert, compress, and resize images using MozJPEG, OxiPNG, WebP, AVIF, and QOI"
  homepage "https://github.com/clroot/slimg"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.3.0/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "086d941d39a88eca13623de065b6a5d85a6356c362df7611bc6a9be939839c35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.3.0/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "72edfe9ea5db1a02b6fc00f24fe247d2f07af1a700889448694a14563cf1d39f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.3.0/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8d9308520d0916eb131d4b71e9aa0843b176ebabd0354d3dd13a4ab9c8f5277"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.3.0/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a654556660da1639c26dc92b6965c51d7340d2c68bc04bf2de24b5e84cf33213"
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
