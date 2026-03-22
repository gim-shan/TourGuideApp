class GuideReport {
  final String id;
  final String guideId;
  final int totalBookings;
  final int pendingBookings;
  final int acceptedBookings;
  final int completedBookings;
  final int rejectedBookings;
  final double totalEarnings;
  final double monthlyEarnings;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime generatedAt;

  GuideReport({
    required this.id,
    required this.guideId,
    required this.totalBookings,
    required this.pendingBookings,
    required this.acceptedBookings,
    required this.completedBookings,
    required this.rejectedBookings,
    required this.totalEarnings,
    required this.monthlyEarnings,
    required this.periodStart,
    required this.periodEnd,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guideId': guideId,
      'totalBookings': totalBookings,
      'pendingBookings': pendingBookings,
      'acceptedBookings': acceptedBookings,
      'completedBookings': completedBookings,
      'rejectedBookings': rejectedBookings,
      'totalEarnings': totalEarnings,
      'monthlyEarnings': monthlyEarnings,
      'periodStart': periodStart.millisecondsSinceEpoch,
      'periodEnd': periodEnd.millisecondsSinceEpoch,
      'generatedAt': generatedAt.millisecondsSinceEpoch,
    };
  }

  factory GuideReport.fromMap(Map<String, dynamic> map) {
    return GuideReport(
      id: map['id'] ?? '',
      guideId: map['guideId'] ?? '',
      totalBookings: map['totalBookings'] ?? 0,
      pendingBookings: map['pendingBookings'] ?? 0,
      acceptedBookings: map['acceptedBookings'] ?? 0,
      completedBookings: map['completedBookings'] ?? 0,
      rejectedBookings: map['rejectedBookings'] ?? 0,
      totalEarnings: (map['totalEarnings'] ?? 0.0).toDouble(),
      monthlyEarnings: (map['monthlyEarnings'] ?? 0.0).toDouble(),
      periodStart: map['periodStart'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['periodStart'])
          : DateTime.now(),
      periodEnd: map['periodEnd'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['periodEnd'])
          : DateTime.now(),
      generatedAt: map['generatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['generatedAt'])
          : DateTime.now(),
    );
  }

  GuideReport copyWith({
    String? id,
    String? guideId,
    int? totalBookings,
    int? pendingBookings,
    int? acceptedBookings,
    int? completedBookings,
    int? rejectedBookings,
    double? totalEarnings,
    double? monthlyEarnings,
    DateTime? periodStart,
    DateTime? periodEnd,
    DateTime? generatedAt,
  }) {
    return GuideReport(
      id: id ?? this.id,
      guideId: guideId ?? this.guideId,
      totalBookings: totalBookings ?? this.totalBookings,
      pendingBookings: pendingBookings ?? this.pendingBookings,
      acceptedBookings: acceptedBookings ?? this.acceptedBookings,
      completedBookings: completedBookings ?? this.completedBookings,
      rejectedBookings: rejectedBookings ?? this.rejectedBookings,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      monthlyEarnings: monthlyEarnings ?? this.monthlyEarnings,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
