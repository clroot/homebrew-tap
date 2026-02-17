class Slimg < Formula
  desc "Image optimization CLI — convert, optimize, resize"
  homepage "https://github.com/clroot/slimg"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.0/slimg-aarch64-apple-darwin.tar.xz"
      sha256 "7d0b01ee9914de8dcbf5994446c690c93da95566cb34e8c765b3d2dc64e44cf6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.0/slimg-x86_64-apple-darwin.tar.xz"
      sha256 "d9555a343d5f88864cbb686093aeedccc040c526e8c653fe5d1102a50faeea98"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.0/slimg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bf51b99fe1ba71768ddf9ed4bed2d2702f4dbca09447fd6198f54599b8e38661"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.0/slimg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "936be83883d824390c01609ca5929e3c493ae4b179f3f270d06e37dd9c10f07c"
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
