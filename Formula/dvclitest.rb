class Dvclitest < Formula
  desc "A Rust library for interacting with the Dataverse API."
  homepage "https://github.com/gdcc/rust-dataverse"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gdcc/rust-dataverse/releases/download/v0.0.1/rust-dataverse-aarch64-apple-darwin.tar.xz"
      sha256 "7cd5e6e461d019ed44a6be16b531495d905df06a48dcb571c935f23240280ff5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gdcc/rust-dataverse/releases/download/v0.0.1/rust-dataverse-x86_64-apple-darwin.tar.xz"
      sha256 "b300ee92c5d056ba2c60589db4518e262b09239ee30bea49e93d2eddbf92f50b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gdcc/rust-dataverse/releases/download/v0.0.1/rust-dataverse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "be3cfbd221428c4027c594138c5167a9cae8482cd4de1a2ebca36430f5ed4711"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gdcc/rust-dataverse/releases/download/v0.0.1/rust-dataverse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "53eff7507eaad9b1033983ca662c80abee1cfd9f8bf6a7e11a4c638b1e2bcc6d"
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
    bin.install "dvcli" if OS.mac? && Hardware::CPU.arm?
    bin.install "dvcli" if OS.mac? && Hardware::CPU.intel?
    bin.install "dvcli" if OS.linux? && Hardware::CPU.arm?
    bin.install "dvcli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
