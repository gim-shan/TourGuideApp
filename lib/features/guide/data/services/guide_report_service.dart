import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hidmo_app/features/guide/data/models/guide_report.dart';

class GuideReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _reportsCollection = 'guide_reports';

  // Save or update a report for the current guide
  Future<void> saveReport(GuideReport report) async {
    try {
      await _firestore
          .collection(_reportsCollection)
          .doc(report.id)
          .set(report.toMap());
    } catch (e) {
      throw Exception('Failed to save report: $e');
    }
  }

  // Generate and save a report based on current bookings
  Future<GuideReport> generateReport({
    required String periodType, // 'daily', 'weekly', 'monthly', 'all'
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Get date range based on period
    final now = DateTime.now();
    DateTime periodStart;
    DateTime periodEnd = now;

    switch (periodType) {
      case 'daily':
        periodStart = DateTime(now.year, now.month, now.day);
        break;
      case 'weekly':
        periodStart = now.subtract(const Duration(days: 7));
        break;
      case 'monthly':
        periodStart = DateTime(now.year, now.month, 1);
        break;
      case 'all':
      default:
        periodStart = DateTime(2020, 1, 1); // Beginning of the app
    }

    // Get bookings for this guide within the period
    QuerySnapshot bookingsSnapshot;

    if (periodType == 'all') {
      bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('guideId', isEqualTo: user.uid)
          .get();
    } else {
      bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('guideId', isEqualTo: user.uid)
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: periodStart.millisecondsSinceEpoch,
          )
          .get();
    }

    // Calculate statistics
    int totalBookings = 0;
    int pendingBookings = 0;
    int acceptedBookings = 0;
    int completedBookings = 0;
    int rejectedBookings = 0;
    double totalEarnings = 0.0;
    double periodEarnings = 0.0;

    for (var doc in bookingsSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      totalBookings++;

      // Count by status
      final status = data['status'] ?? 'pending';
      switch (status) {
        case 'pending':
          pendingBookings++;
          break;
        case 'accepted':
          acceptedBookings++;
          break;
        case 'completed':
          completedBookings++;
          break;
        case 'rejected':
          rejectedBookings++;
          break;
      }

      // Calculate earnings (guide typically gets 70% of the total)
      final totalAmount = data['totalAmount'];
      if (totalAmount != null) {
        final amount = (totalAmount is String)
            ? double.tryParse(totalAmount.replaceAll(RegExp(r'[^\d.]'), '')) ??
                  0
            : (totalAmount as num).toDouble();

        // Guide earns 70% of the total (this is configurable)
        final guideShare = amount * 0.70;
        totalEarnings += guideShare;

        // Calculate period-specific earnings
        if (status == 'completed' || status == 'accepted') {
          periodEarnings += guideShare;
        }
      }
    }

    // Create report ID
    final reportId = '${user.uid}_${periodType}_${now.millisecondsSinceEpoch}';

    final report = GuideReport(
      id: reportId,
      guideId: user.uid,
      totalBookings: totalBookings,
      pendingBookings: pendingBookings,
      acceptedBookings: acceptedBookings,
      completedBookings: completedBookings,
      rejectedBookings: rejectedBookings,
      totalEarnings: totalEarnings,
      monthlyEarnings: periodEarnings,
      periodStart: periodStart,
      periodEnd: periodEnd,
      generatedAt: now,
    );

    // Save to Firestore
    await saveReport(report);

    return report;
  }

  // Get all reports for the current guide
  Future<List<GuideReport>> getReports() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final snapshot = await _firestore
          .collection(_reportsCollection)
          .where('guideId', isEqualTo: user.uid)
          .orderBy('generatedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => GuideReport.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get reports: $e');
    }
  }

  // Get a specific report by ID
  Future<GuideReport?> getReportById(String reportId) async {
    try {
      final doc = await _firestore
          .collection(_reportsCollection)
          .doc(reportId)
          .get();

      if (doc.exists) {
        return GuideReport.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get report: $e');
    }
  }

  // Delete a report
  Future<void> deleteReport(String reportId) async {
    try {
      await _firestore.collection(_reportsCollection).doc(reportId).delete();
    } catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }

  // Get the latest report for the current guide
  Future<GuideReport?> getLatestReport() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      final snapshot = await _firestore
          .collection(_reportsCollection)
          .where('guideId', isEqualTo: user.uid)
          .orderBy('generatedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return GuideReport.fromMap(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
