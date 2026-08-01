# SVOpenADSSDK binary package

Distribute this directory only after running `../build_xcframework.sh`:

- `SVOpenADSSDK.xcframework` contains the compiled implementation.
- Its `Headers` directory exposes the public `SV*` API only.
- Do not include `../Sources` or any `.m` files in the delivered archive/repository.

Consumers import the public entry point with:

```objective-c
@import SVOpenADSSDK;
```

The podspec at the repository root packages the XCFramework instead of source files. Binary distribution prevents ordinary consumers from reading the Objective-C implementation, but—as with any iOS binary—it cannot make reverse engineering impossible.
