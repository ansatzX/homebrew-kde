require_relative "../lib/cmake"

class Kf5Frameworkintegration < Formula
  desc "Integration of Qt application with KDE workspaces"
  homepage "https://api.kde.org/frameworks/frameworkintegration/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.96/frameworkintegration-5.96.0.tar.xz"
  sha256 "69bece6b66542cfd3985046af1f63174ed909e34fe5a3c972506e250a0c1f1a6"
  head "https://invent.kde.org/frameworks/frameworkintegration.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "ansatzX/homebrew-kde/kf5-knewstuff"
  depends_on "ansatzX/homebrew-kde/kf5-kpackage"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo ansatzX/homebrew-kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5FrameworkIntegration REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
