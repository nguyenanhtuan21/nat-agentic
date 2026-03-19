# Nat Agentic Formula for Homebrew
# https://nat-agentic.dev

class NatAgentic < Formula
  desc "Custom Claude Code Distribution with Curated Plugins"
  homepage "https://nat-agentic.dev"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/nat-agentic/nat-agentic/archive/refs/tags/v#{version}.tar.gz"
      sha256 "PLACEHOLDER_SHA256"
    end
    on_arm do
      url "https://github.com/nat-agentic/nat-agentic/archive/refs/tags/v#{version}.tar.gz"
      sha256 "PLACEHOLDER_SHA256"
    end
  end

  on_linux do
    url "https://github.com/nat-agentic/nat-agentic/archive/refs/tags/v#{version}.tar.gz"
    sha256 "PLACEHOLDER_SHA256"
  end

  depends_on "node" => [:recommended]
  depends_on "bun" => [:optional]

  def install
    # Install bin scripts
    bin.install "bin/nat"
    bin.install "bin/nat-setup"

    # Install configuration
    (etc/"nat-agentic").install Dir["config/*"]

    # Install marketplace plugins
    (prefix/"marketplace").install Dir["marketplace/*"]

    # Install branding
    (prefix/"branding").install Dir["branding/*"]

    # Create symlinks for config
    (var/"nat-agentic/config").mkpath
    (var/"nat-agentic/marketplace").mkpath
  end

  def post_install
    # Set up home directory
    home_dir = Pathname.new(ENV["HOME"]) / ".nat-agentic"
    config_dir = home_dir / "config"
    marketplace_dir = home_dir / "marketplace" / "plugins"

    # Create directories
    [home_dir, config_dir, marketplace_dir].each(&:mkpath)

    # Copy default settings if not exists
    settings_file = config_dir / "settings.json"
    unless settings_file.exist?
      default_settings = etc / "nat-agentic" / "settings-default.json"
      FileUtils.cp(default_settings, settings_file) if default_settings.exist?
    end

    # Copy plugins if not exists
    bundled_plugins = prefix / "marketplace" / "plugins"
    if bundled_plugins.exist?
      bundled_plugins.children.each do |plugin|
        dest = marketplace_dir / plugin.basename
        FileUtils.cp_r(plugin, dest) unless dest.exist?
      end
    end

    ohai "Nat Agentic installed successfully!"
    ohai "Run 'nat' to start, or 'nat --help' for options."
  end

  def caveats
    <<~EOS
      Nat Agentic has been installed!

      To get started:
        1. Run 'nat' to start an interactive session
        2. Run 'nat --help' to see available options
        3. Visit https://nat-agentic.dev/docs for documentation

      Configuration is stored in ~/.nat-agentic/
    EOS
  end

  test do
    assert_match "Nat Agentic", shell_output("#{bin}/nat --nat-version")
  end
end
