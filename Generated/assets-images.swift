// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let homeDark = ImageAsset(name: "home dark")
    internal static let homeGreen = ImageAsset(name: "home green")
    internal static let homeSelected = ImageAsset(name: "home_selected")
    internal static let icBackDark = ImageAsset(name: "ic_back_dark")
    internal static let icBackWhite = ImageAsset(name: "ic_back_white")
    internal static let icCross = ImageAsset(name: "ic_cross")
    internal static let icEdit = ImageAsset(name: "ic_edit")
    internal static let icLauncher = ImageAsset(name: "ic_launcher")
    internal static let icLocate = ImageAsset(name: "ic_locate")
    internal static let icTarget = ImageAsset(name: "ic_target")
    internal static let iconsEdit = ImageAsset(name: "icons_Edit")
    internal static let iconsBack = ImageAsset(name: "icons_back")
    internal static let iconsBackWhite = ImageAsset(name: "icons_back_white")
    internal static let iconsCross = ImageAsset(name: "icons_cross")
    internal static let iconsLocate = ImageAsset(name: "icons_locate")
    internal static let iconsTarget = ImageAsset(name: "icons_target")
    internal static let information = ImageAsset(name: "information")
    internal static let launchBackground = ImageAsset(name: "launch_background")
    internal static let launchLogo = ImageAsset(name: "launch_logo")
    internal static let location = ImageAsset(name: "location")
    internal static let markerGreen = ImageAsset(name: "marker-green")
    internal static let markerPerple = ImageAsset(name: "marker-perple")
    internal static let picAbout = ImageAsset(name: "pic_about")
    internal static let search = ImageAsset(name: "search")
    internal static let searchSelected = ImageAsset(name: "search_selected")
    internal static let share = ImageAsset(name: "share")
    internal static let tick = ImageAsset(name: "tick")
  }
  internal enum Colors {
    internal static let aquaBlue = ColorAsset(name: "aqua_blue")
    internal static let black = ColorAsset(name: "black")
    internal static let blue = ColorAsset(name: "blue")
    internal static let blueDark = ColorAsset(name: "blue_dark")
    internal static let blueDark40 = ColorAsset(name: "blue_dark_40")
    internal static let blueDark70 = ColorAsset(name: "blue_dark_70")
    internal static let blueDark90 = ColorAsset(name: "blue_dark_90")
    internal static let blueDark95 = ColorAsset(name: "blue_dark_95")
    internal static let bluePurple = ColorAsset(name: "blue_purple")
    internal static let bluePurple85 = ColorAsset(name: "blue_purple_85")
    internal static let bluePurple90 = ColorAsset(name: "blue_purple_90")
    internal static let bluePurple95 = ColorAsset(name: "blue_purple_95")
    internal static let bluishGrey = ColorAsset(name: "bluish_grey")
    internal static let brightLightBlue = ColorAsset(name: "bright_light_blue")
    internal static let darkGreyBlue = ColorAsset(name: "dark_grey_blue")
    internal static let golden = ColorAsset(name: "golden")
    internal static let green = ColorAsset(name: "green")
    internal static let greenSelected = ColorAsset(name: "green_selected")
    internal static let greenish10 = ColorAsset(name: "greenish_10")
    internal static let lightGreen = ColorAsset(name: "light_green")
    internal static let lightGreen40 = ColorAsset(name: "light_green_40")
    internal static let misty = ColorAsset(name: "misty")
    internal static let pink = ColorAsset(name: "pink")
    internal static let pink85 = ColorAsset(name: "pink_85")
    internal static let transparent = ColorAsset(name: "transparent")
    internal static let white = ColorAsset(name: "white")
    internal static let white50 = ColorAsset(name: "white_50")
    internal static let white60 = ColorAsset(name: "white_60")
    internal static let white80 = ColorAsset(name: "white_80")
    internal static let whiteAlpha = ColorAsset(name: "white_alpha")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
