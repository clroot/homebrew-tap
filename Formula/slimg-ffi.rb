class SlimgFfi < Formula
  desc "UniFFI bindings for slimg-core image optimization library"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.3/slimg-ffi-aarch64-apple-darwin.tar.xz"
      sha256 "7047f4e94f42b9cff3c72f3911ed6c07a38002a6a7c3fbaeb3efb3da8311849a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.3/slimg-ffi-x86_64-apple-darwin.tar.xz"
      sha256 "7e11e7ba2f95ba36be6e6ef8e4b49fb96befa987a6afa7c1afad6a7bd83e84fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clroot/slimg/releases/download/v0.1.3/slimg-ffi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b8a302513f5e83c49aca9d779c0e5aa5c6307cbe206c032baf1404447e8ec3cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clroot/slimg/releases/download/v0.1.3/slimg-ffi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "12c41c03b1ac861369fb63747de09174c4ec375e002fcb51d44520c44a48a098"
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
    bin.install "uniffi-bindgen" if OS.mac? && Hardware::CPU.arm?
    bin.install "uniffi-bindgen" if OS.mac? && Hardware::CPU.intel?
    bin.install "uniffi-bindgen" if OS.linux? && Hardware::CPU.arm?
    bin.install "uniffi-bindgen" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
