class Slimg < Formula
  desc "Image optimization CLI — convert, optimize, resize"
  homepage "https://github.com/clroot/slimg"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.1/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "6288ef1a47d839d603355cf5528ac75aff06333daa14173e761161ed43b907dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.1/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "5d920eee190e0f7c9eaeac865866621758a1e4183d84d7ace7d5fa3a222d9f39"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.1/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d962bd6232255657d8ef4f177f7ce4d190c5e9d91b713af66cc48bb80aa9b67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.1/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03c02c1a2ed467470047974f1ebe7fcc440c76b3cdc0d3d044a3553028a3c93b"
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
