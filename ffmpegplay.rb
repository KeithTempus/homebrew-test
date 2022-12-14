class Ffmpegplay < Formula
  desc "FFmpeg with --enable-decklink and --enable-libsrt"
  homepage "https://ffmpeg.org/"
  url "https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n4.4.tar.gz"
  sha256 "bea6d9f91cdbe4c5ad98e0878955ad5077df3883ef321fd4668ee1076de793fe"
  revision 2
  head "https://github.com/FFmpeg/FFmpeg.git"
  keg_only "anything that needs this will know where to look"

  option "with-iec61883", "Enable DV device (Linux)" if OS.linux?
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build

  depends_on "KeithTempus/test/sdl@2022"
  depends_on "amiaopensource/amiaos/decklinksdk"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "lame"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "openjpeg"
  depends_on "opus"
  depends_on "snappy"
  depends_on "srt"
  depends_on "theora"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz"

  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-shared
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-gpl
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libopenjpeg
      --enable-libopus
      --enable-libsnappy
      --enable-libsrt
      --enable-libtheora
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libx265
      --enable-libxvid
      --enable-libfontconfig
      --disable-libjack
      --disable-indev=jack
    ]

    args << "--enable-libiec61883" if (build.with? "iec61883") && OS.linux?

    # decklink options
    args << "--enable-nonfree"
    args << "--enable-decklink"
    args << "--extra-cflags=-I#{HOMEBREW_PREFIX}/include"
    args << "--extra-ldflags=-L#{HOMEBREW_PREFIX}/include"

    system "./configure", *args
    system "make"

    bin.install "ffmpeg" => "ffmpeg-srt"
    bin.install "ffprobe" => "ffprobe-srt"
    bin.install "ffplay" => "ffplay-srt"

  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg-srt", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
