require_relative "../lib/cmake"

class Kmymoney < Formula
  desc "Personal finance manager similar to MS-Money or Quicken"
  homepage "https://kmymoney.org"
  url "https://download.kde.org/stable/kmymoney/5.1.3/src/kmymoney-5.1.3.tar.xz"
  sha256 "3938b8078b7391ba32e12bb4239762fae134683a0c2ec1a75105c302ca3e5e3f"
  head "https://invent.kde.org/office/kmymoney.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "shared-mime-info" => :build

  depends_on "aqbanking"
  depends_on "boost"
  depends_on "gpgme"
  depends_on "ansatzX/homebrew-kde/kdiagram"
  depends_on "ansatzX/homebrew-kde/kf5-kactivities"
  depends_on "ansatzX/homebrew-kde/kf5-kcmutils"
  depends_on "ansatzX/homebrew-kde/kf5-kio"
  depends_on "ansatzX/homebrew-kde/kf5-kitemmodels"
  depends_on "ansatzX/homebrew-kde/kf5-kross"
  depends_on "ansatzX/homebrew-kde/libalkimia"
  depends_on "libical"
  depends_on "libofx"
  depends_on "sqlcipher"

  def install
    system "cmake", "-DENABLE_WEBENGINE=ON", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kmymoney.app/Contents/Info.plist"
  end

  def post_install
    system HOMEBREW_PREFIX/"bin/update-mime-database", HOMEBREW_PREFIX/"share/mime"

    if build.stable?
      mkdir_p HOMEBREW_PREFIX/"share/kmymoney"
      ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/kmymoney/icontheme.rcc"
    end
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/kmymoney.app/Contents/MacOS/kmymoney --help")
  end
end
