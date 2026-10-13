cask "herdr-bot" do
  arch arm: "arm64", intel: "x64"

  version "1.1.0"
  sha256 arm:   "667ddfb781fe9d29f9643c39cb611229224939ff9f072ee44ecb630e76e122db",
         intel: "9809d8e7cd13ead787ab6c1dceb535f17b6e6c92e77a96101ba60cce5a6ca41b"

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
