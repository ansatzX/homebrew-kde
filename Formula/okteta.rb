require_relative "../lib/cmake"

class Okteta < Formula
  desc "KDE hex editor for viewing and editing the raw data of files"
  homepage "https://apps.kde.org/okteta"
  url "https://download.kde.org/stable/okteta/0.26.9/src/okteta-0.26.9.tar.xz"
  sha256 "16854c4d4e94838219ae3115a42ba385fda5c87dc6c9865ac90d3774f8d05ffb"
  head "https://invent.kde.org/utilities/okteta.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/okteta/"
    regex(/href=["']?(\d+(?:\.\d+)+)/i)
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build
  depends_on "shared-mime-info" => :build

  depends_on "hicolor-icon-theme"
  depends_on "ansatzX/homebrew-kde/kf5-breeze-icons"
  depends_on "ansatzX/homebrew-kde/kf5-kcmutils"
  depends_on "ansatzX/homebrew-kde/kf5-knewstuff"
  depends_on "ansatzX/homebrew-kde/kf5-kparts"
  depends_on "qca"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/okteta.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/okteta"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/okteta/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/okteta.app/Contents/MacOS/okteta --help")
  end
end
