cask "herdr-bot" do
  arch arm: "arm64", intel: "x64"

  version "1.2.0"
  sha256 arm:   "d40ebaffb5a1644e2000397e57b1cb709d36049c5441f26bb56817d66676a74a",
         intel: "931a9621c47b19246d77e62308ae2b778f4a13de6719d7fbcb94444ae1982d4d"

  url "https://github.com/speardragon/herdr-bot/releases/download/v#{version}/herdr-bot-#{version}-#{arch}.dmg"
  name "herdr-bot"
  desc "Desktop messenger for the coding agents running in herdr"
  homepage "https://github.com/speardragon/herdr-bot"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :monterey

  app "herdr-bot.app"

  # herdr-bot is not code-signed, so macOS refuses to open it while the download's quarantine flag is
  # on it. Clearing the flag is what opening it from Finder and approving it would do.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/herdr-bot.app"],
        writable_paths: ["{{appdir}}/herdr-bot.app"]
  end

  # Bots and chats live in ~/.herdr-bot and are deliberately left alone.
  zap trash: [
    "~/Library/Application Support/herdr-bot",
    "~/Library/Preferences/dev.herdr.bot.plist",
    "~/Library/Saved Application State/dev.herdr.bot.savedState",
  ]
end
