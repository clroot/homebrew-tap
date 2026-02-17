class Slimg < Formula
  desc "Image optimization CLI — convert, optimize, resize"
  homepage "https://github.com/clroot/slimg"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.2/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "d32b7bbcb3d1e16df045021949140903c19e055be4d42afeafa3e88a37a36027"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.2/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "fbcda56fef03db35bedf4365306f27d31a92d883f97d7ab1130e1d3434334998"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.2/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f2581af9a8d76e3dbe4046817ff17f990a114723e68ea5d71e3c0dd71d0ca1b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.2/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fec792f227b31264ef0cfe939af418219c764791c542aef4a04495b409949981"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]
  depends_on "dav1d"

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
