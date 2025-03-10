class ConverterController {
  // Constants for conversion
  static const double _kmToMileFactor = 0.621371;
  static const double _mileToKmFactor = 1.60934;

  // Convert kilometers to miles
  double kilometersToMiles(double kilometers) {
    return kilometers * _kmToMileFactor;
  }

  // Convert miles to kilometers
  double milesToKilometers(double miles) {
    return miles * _mileToKmFactor;
  }
}