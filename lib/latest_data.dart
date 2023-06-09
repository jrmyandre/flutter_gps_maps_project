class LatestData {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final bool isManual;
  final String phoneNumber;

  LatestData({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.isManual,
    required this.phoneNumber,
  });
}