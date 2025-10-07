class Dvclitest < Formula
  desc "Rust library for interacting with the Dataverse API"
  homepage "https://github.com/gdcc/rust-dataverse"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/JR-1991/rust-dataverse/releases/download/v0.0.2/rust-dataverse-aarch64-apple-darwin.tar.xz"
      sha256 "877215b5bbbb7b658046a66b368026de30da32aba453955ab19ec11b49789150"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JR-1991/rust-dataverse/releases/download/v0.0.2/rust-dataverse-x86_64-apple-darwin.tar.xz"
      sha256 "c6dba695c32b07229f576f92cb7ea61dfb45e00443719a049ee47dd1fa453af1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/JR-1991/rust-dataverse/releases/download/v0.0.2/rust-dataverse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "22ee16b7de2d9e7e34f8e8eee47cc0cd48f8802baa5e8bcaf0e42f6a217d7769"
    end
    if Hardware::CPU.intel?
      url "https://github.com/JR-1991/rust-dataverse/releases/download/v0.0.2/rust-dataverse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2c6acbab5275fae4046e4e8b1d009293dcae32bf7fdc2d846381014052b7e8a"
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
