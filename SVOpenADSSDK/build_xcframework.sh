#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="${TMPDIR:-/tmp}/SVOpenADSSDK-build"
PUBLIC_HEADERS="$BUILD_DIR/Headers"
OUTPUT_DIR="$SCRIPT_DIR/Distribution"
WINDMILL_ROOT="${WINDMILL_ROOT:-$PROJECT_ROOT/Example/Pods/ToBid-iOS-RC/tobid-sdk-ios-cocoapods-cn/Core/WindMillSDK.xcframework}"

if [[ ! -d "$WINDMILL_ROOT/ios-arm64/WindMillSDK.framework" ]]; then
  echo "WindMillSDK for ToBid-iOS-RC 5.7.2 was not found at: $WINDMILL_ROOT" >&2
  echo "Run pod install in Example or set WINDMILL_ROOT to the matching XCFramework." >&2
  exit 1
fi

rm -rf "$BUILD_DIR" "$OUTPUT_DIR/SVOpenADSSDK.xcframework"
mkdir -p "$BUILD_DIR/iphoneos" "$PUBLIC_HEADERS" "$OUTPUT_DIR"

for header in SVAdsOpen.h SVAdsRequest.h SVAdsSdk.h SVAdsSdkInterstitial.h SVAdsSdkReward.h SVAdsSdkSplash.h SVBannerView.h SVNativeAd.h SVNativeAdView.h SVNativeAdsManager.h; do
  cp "$SCRIPT_DIR/Sources/$header" "$PUBLIC_HEADERS/$header"
done
cp "$SCRIPT_DIR/PublicHeaders/module.modulemap" "$PUBLIC_HEADERS/module.modulemap"

build_library() {
  local platform="$1"
  local arch="$2"
  local sdk
  local min_flag
  local framework
  local object_dir

  sdk="$(xcrun --sdk "$platform" --show-sdk-path)"
  min_flag="-miphoneos-version-min=13.0"
  [[ "$platform" == "iphonesimulator" ]] && min_flag="-mios-simulator-version-min=13.0"
  framework="$WINDMILL_ROOT/$([ "$platform" = "iphoneos" ] && echo ios-arm64 || echo ios-arm64_x86_64-simulator)/WindMillSDK.framework"
  object_dir="$BUILD_DIR/$platform-$arch"
  mkdir -p "$object_dir"
  mkdir -p "$BUILD_DIR/module-cache-$platform"

  for source in "$SCRIPT_DIR"/Sources/*.m; do
    xcrun --sdk "$platform" clang -arch "$arch" -isysroot "$sdk" "$min_flag" \
      -fobjc-arc -fmodules -fmodules-cache-path="$BUILD_DIR/module-cache-$platform" \
      -F "$(dirname "$framework")" -I "$SCRIPT_DIR/Sources" \
      -c "$source" -o "$object_dir/$(basename "${source%.m}").o"
  done
  xcrun --sdk "$platform" libtool -static -o "$BUILD_DIR/libSVOpenADSSDK-$platform-$arch.a" "$object_dir"/*.o
}

build_library iphoneos arm64
cp "$BUILD_DIR/libSVOpenADSSDK-iphoneos-arm64.a" "$BUILD_DIR/iphoneos/libSVOpenADSSDK.a"

if nm -u "$BUILD_DIR/iphoneos/libSVOpenADSSDK.a" | grep -q '_OBJC_CLASS_\$_WindMillAdRequest'; then
  echo "The generated library references the obsolete Objective-C WindMill ABI." >&2
  exit 1
fi

xcodebuild -create-xcframework \
  -library "$BUILD_DIR/iphoneos/libSVOpenADSSDK.a" -headers "$PUBLIC_HEADERS" \
  -output "$OUTPUT_DIR/SVOpenADSSDK.xcframework"

echo "Created $OUTPUT_DIR/SVOpenADSSDK.xcframework"
