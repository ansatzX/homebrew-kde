require_relative "../lib/cmake"

class Kdiagram < Formula
  desc "Powerful libraries for creating business diagrams"
  homepage "https://api.kde.org/kdiagram/index.html"
  url "https://download.kde.org/stable/kdiagram/2.8.0/kdiagram-2.8.0.tar.xz"
  sha256 "579dad3bd1ea44b5a20c0f133ebf47622e38960f9c7c8b3a316be30a369f431f"
  head "https://invent.kde.org/graphics/kdiagram.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "qt@5"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      find_package(KChart REQUIRED)
      find_package(KGrantt REQUIRED)
    EOS
    system "cmake", ".", "-Wno-dev"
  end
end
