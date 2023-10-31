class CustomDialog {
  static CustomDialog? _instance;

  // Avoid self instance
  CustomDialog._();
  static CustomDialog get instance => _instance ??= CustomDialog._();

  static void showTripInfoDiaolg() {}
}

// CustomDialog customDialog = CustomDialog.instance;

