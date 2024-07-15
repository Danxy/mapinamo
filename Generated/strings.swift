// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Mapinamo
  internal static let appName = L10n.tr("Localizable", "app_name")
  /// hidden treasures
  internal static let appNameDescription = L10n.tr("Localizable", "app_name_description")
  /// Latitude: %@\nLongitude: %@\n Altitude: %@m
  internal static func chooseLocationFragLatLngTitle(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
    return L10n.tr("Localizable", "choose_location_frag_lat_lng_title", String(describing: p1), String(describing: p2), String(describing: p3))
  }
  /// Confirm
  internal static let chooseLocationSubmitButton = L10n.tr("Localizable", "choose_location_submit_button")
  /// Treasure has Created
  internal static let createFragFinalMenuTitle = L10n.tr("Localizable", "create_frag_final_menu_title")
  /// create here
  internal static let createTreasureVcButtonCreate = L10n.tr("Localizable", "create_treasure_vc_button_create")
  /// Just now
  internal static let dateFormatJustNowTitle = L10n.tr("Localizable", "date_format_just_now_title")
  /// Today, %@
  internal static func dateFormatTodayTitle(_ p1: Any) -> String {
    return L10n.tr("Localizable", "date_format_today_title", String(describing: p1))
  }
  /// Tomorrow, %@
  internal static func dateFormatTomorrowTitle(_ p1: Any) -> String {
    return L10n.tr("Localizable", "date_format_tomorrow_title", String(describing: p1))
  }
  /// Yesterday, %@
  internal static func dateFormatYesterdayTitle(_ p1: Any) -> String {
    return L10n.tr("Localizable", "date_format_yesterday_title", String(describing: p1))
  }
  /// share
  internal static let fragFinalMenu1ButtonTitle = L10n.tr("Localizable", "frag_final_menu_1_button_title")
  /// home
  internal static let fragFinalMenu2ButtonTitle = L10n.tr("Localizable", "frag_final_menu_2_button_title")
  /// Thank You!
  internal static let fragFinalPickMenuBody = L10n.tr("Localizable", "frag_final_pick_menu_body")
  /// Latitude: 
  internal static let latitude = L10n.tr("Localizable", "latitude")
  /// Location services not enabled, please, turn them on in your settings
  internal static let locatonErrorMessage = L10n.tr("Localizable", "locaton_error_message")
  /// Location fetching error
  internal static let locatonErrorTitle = L10n.tr("Localizable", "locaton_error_title")
  /// Longitude: 
  internal static let longitude = L10n.tr("Localizable", "longitude")
  /// Direction
  internal static let markerDetailsViewControllerBtnDirection = L10n.tr("Localizable", "marker_details_view_controller_btn_direction")
  /// Treasure has Picked
  internal static let pickFragFinalMenuTitle = L10n.tr("Localizable", "pick_frag_final_menu_title")
  /// confirm
  internal static let placeReasureViewControllerBtnPlace = L10n.tr("Localizable", "place_reasure_view_controller_btn_place")
  /// Category: 
  internal static let placeReasureViewControllerLblCategory = L10n.tr("Localizable", "place_reasure_view_controller_lbl_category")
  /// Created:
  internal static let placeReasureViewControllerLblCreated = L10n.tr("Localizable", "place_reasure_view_controller_lbl_created")
  /// Comments: 
  internal static let placeReasureViewControllerLblDescription = L10n.tr("Localizable", "place_reasure_view_controller_lbl_description")
  /// Name:
  internal static let placeReasureViewControllerLblName = L10n.tr("Localizable", "place_reasure_view_controller_lbl_name")
  /// home
  internal static let treasureCreatedViewControllerBtnHome = L10n.tr("Localizable", "treasure_created_view_controller_btn_home")
  /// share
  internal static let treasureCreatedViewControllerBtnShare = L10n.tr("Localizable", "treasure_created_view_controller_btn_share")
  /// TREASURE WAS CREATED
  internal static let treasureCreatedViewControllerLblTitle = L10n.tr("Localizable", "treasure_created_view_controller_lbl_title")
  /// submit
  internal static let treasureDetailsFragConfirmButtonTitle = L10n.tr("Localizable", "treasure_details_frag_confirm_button_title")
  /// Applied image:
  internal static let treasureDetailsFragLabelAppliedImage = L10n.tr("Localizable", "treasure_details_frag_label_applied_image")
  /// Category:
  internal static let treasureDetailsFragSelectACategoryTitle = L10n.tr("Localizable", "treasure_details_frag_select_a_category_title")
  /// TREASURE DETAILS
  internal static let treasureDetailsFragTitle = L10n.tr("Localizable", "treasure_details_frag_title")
  /// Choose category:
  internal static let treasureDetailsLablelCategory = L10n.tr("Localizable", "treasure_details_lablel_category")
  /// Comments (optional):
  internal static let treasureDetailsLablelDescription = L10n.tr("Localizable", "treasure_details_lablel_description")
  /// Item Name:
  internal static let treasureDetailsLablelName = L10n.tr("Localizable", "treasure_details_lablel_name")
  /// I'm offering
  internal static let treasureMainViewControllerBtnCreate = L10n.tr("Localizable", "treasure_main_view_controller_btn_create")
  /// I'm looking for
  internal static let treasureMainViewControllerBtnFind = L10n.tr("Localizable", "treasure_main_view_controller_btn_find")
  /// HIDDEN TREASURES
  internal static let treasureMainViewControllerLblSubtitle = L10n.tr("Localizable", "treasure_main_view_controller_lbl_subtitle")
  /// MAPINAMO
  internal static let treasureMainViewControllerLblTitle = L10n.tr("Localizable", "treasure_main_view_controller_lbl_title")
  /// Show by category
  internal static let treasureMapFragCategoriesTitle = L10n.tr("Localizable", "treasure_map_frag_categories_title")
  /// Category: %@
  internal static func treasureMapFragCategoryTitle(_ p1: Any) -> String {
    return L10n.tr("Localizable", "treasure_map_frag_category_title", String(describing: p1))
  }
  /// Comments: «%@»
  internal static func treasureMapFragCommentTitle(_ p1: Any) -> String {
    return L10n.tr("Localizable", "treasure_map_frag_comment_title", String(describing: p1))
  }
  /// Created: %@
  internal static func treasureMapFragDateTitle(_ p1: Any) -> String {
    return L10n.tr("Localizable", "treasure_map_frag_date_title", String(describing: p1))
  }
  /// Treasure details
  internal static let treasureMapFragMarkerDetails = L10n.tr("Localizable", "treasure_map_frag_marker_details")
  /// pick up
  internal static let treasureMapFragSubmitButton = L10n.tr("Localizable", "treasure_map_frag_submit_button")
  /// picked
  internal static let treasureMapFragSubmitButtonDisabled = L10n.tr("Localizable", "treasure_map_frag_submit_button_disabled")
  /// home
  internal static let treasurePicledViewControllerBtnHome = L10n.tr("Localizable", "treasure_picled_view_controller_btn_home")
  /// TREASURE IS YOURS
  internal static let treasurePicledViewControllerLblTitle = L10n.tr("Localizable", "treasure_picled_view_controller_lbl_title")
  /// pick up
  internal static let treasuresMapViewControllerBtnPickUp = L10n.tr("Localizable", "treasures_map_view_controller_btn_pick_up")
  /// Show photo
  internal static let treasuresMapViewControllerBtnShowPhotos = L10n.tr("Localizable", "treasures_map_view_controller_btn_show_photos")
  /// picked
  internal static let treasuresMapViewControllerBtnStatePicked = L10n.tr("Localizable", "treasures_map_view_controller_btn_state_picked")
  /// Category:
  internal static let treasuresMapViewControllerLblCategory = L10n.tr("Localizable", "treasures_map_view_controller_lbl_category")
  /// Created:
  internal static let treasuresMapViewControllerLblCreatedDate = L10n.tr("Localizable", "treasures_map_view_controller_lbl_created_date")
  /// Comments:
  internal static let treasuresMapViewControllerLblDescription = L10n.tr("Localizable", "treasures_map_view_controller_lbl_description")
  /// pickup is available within a radius of 50 meters
  internal static let treasuresMapViewControllerLblFetchLocationErrorLabelDistanceError = L10n.tr("Localizable", "treasures_map_view_controller_lbl_fetch_location_error_label_distance_error")
  /// please enable location services
  internal static let treasuresMapViewControllerLblFetchLocationErrorLabelError = L10n.tr("Localizable", "treasures_map_view_controller_lbl_fetch_location_error_label_error")
  /// Please update the App to the latest version to use it.
  internal static let update = L10n.tr("Localizable", "update")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
