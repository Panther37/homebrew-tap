# frozen_string_literal: true

cask "freshenmac" do
  version "2.1.1"
  sha256 "61bb6c27cfc7861d9bdd13423e31d6679191fc3f3814e0463eca13be8503c727"

  url "https://github.com/Panther37/FreshenMac/archive/refs/tags/v#{version}.tar.gz"
  name "FreshenMac"
  desc "Automated, polite maintenance tool for Homebrew and App Store"
  homepage "https://github.com/Panther37/FreshenMac"

  depends_on macos: :monterey

  # Symlinks #{HOMEBREW_PREFIX}/bin/freshenmac -> #{staged_path}/FreshenMac-#{version}/src/FreshenMac.py.
  # Because LaunchAgent executes #{HOMEBREW_PREFIX}/bin/freshenmac directly and Python automatically
  # resolves the symlink target's directory (`.../src`) onto sys.path[0], every `brew upgrade`
  # automatically points the next scheduled LaunchAgent run to the new version with zero file copying.
  binary "FreshenMac-#{version}/src/FreshenMac.py", target: "freshenmac"

  # Set-and-forget install:
  # - On first install (plist not yet present): runs `--action Install` with `sudo: true`.
  # - On upgrade (plist already present): does nothing! Homebrew already updated the
  #   `#{HOMEBREW_PREFIX}/bin/freshenmac` symlink to the new version.
  postflight_steps do
    unless_path_exists "/Library/LaunchAgents/com.panther37.FreshenMac.plist" do
      run "{{HOMEBREW_PREFIX}}/bin/freshenmac",
          args: ["--action", "Install"],
          sudo: true
    end
  end

  zap delete: [
        "/etc/sudoers.d/freshenmac",
        "/Library/LaunchAgents/com.panther37.FreshenMac.plist",
        "/Library/Logs/FreshenMac.log",
        "/Library/Preferences/com.panther37.FreshenMac.plist",
        "/Library/scripts/User/freshenmac", # Legacy script directory
      ],
      trash:  [
        "~/Library/LaunchAgents/com.panther37.FreshenMac.plist", # Legacy user LaunchAgent
        "~/Library/Logs/FreshenMac.log",                        # Legacy user log
        "~/Library/Preferences/com.panther37.FreshenMac.plist", # Legacy user preferences
      ]

  caveats <<~EOS
    FreshenMac is installed and scheduled! To run an update check manually:
      freshenmac

    For schedule help:
      freshenmac --schedule

    To uninstall while preserving logs:
      brew uninstall freshenmac

    To completely uninstall and remove all logs/preferences:
      brew uninstall --zap freshenmac
  EOS
end
