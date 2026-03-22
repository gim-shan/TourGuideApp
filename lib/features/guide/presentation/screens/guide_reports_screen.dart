import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class GuideReportsScreen extends StatefulWidget {
  const GuideReportsScreen({super.key});

  @override
  State<GuideReportsScreen> createState() => _GuideReportsScreenState();
}

class _GuideReportsScreenState extends State<GuideReportsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = true;
  int _totalBookings = 0;
  int _pendingBookings = 0;
  int _acceptedBookings = 0;
  int _completedBookings = 0;
  int _rejectedBookings = 0;
  double _totalEarnings = 0.0;
  double _monthlyEarnings = 0.0;
  List<Map<String, dynamic>> _recentBookings = [];

  String _selectedPeriod = 'All Time';

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Get all bookings for this guide
      final bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('guideId', isEqualTo: user.uid)
          .get();

      List<Map<String, dynamic>> allBookings = [];
      double totalEarnings = 0.0;
      double monthlyEarnings = 0.0;

      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);

      for (var doc in bookingsSnapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;

        // Get tourist info
        if (data['userId'] != null) {
          final touristDoc = await _firestore
              .collection('users')
              .doc(data['userId'])
              .get();
          if (touristDoc.exists) {
            data['touristName'] = touristDoc.data()?['name'] ?? 'Unknown';
          }
        }

        allBookings.add(data);

        // Calculate earnings
        if (data['paymentStatus'] == 'completed') {
          final price = data['guideEarnings'] ?? data['totalPrice'];
          if (price != null) {
            totalEarnings += (price is String)
                ? double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0
                : (price as num).toDouble();

            // Check if completed this month
            if (data['status'] == 'completed' && data['endDate'] != null) {
              try {
                DateTime endDate;
                if (data['endDate'] is int) {
                  endDate = DateTime.fromMillisecondsSinceEpoch(
                    data['endDate'],
                  );
                } else {
                  endDate = DateTime.parse(data['endDate']);
                }
                if (endDate.isAfter(firstDayOfMonth)) {
                  monthlyEarnings += (price is String)
                      ? double.tryParse(
                              price.replaceAll(RegExp(r'[^\d.]'), ''),
                            ) ??
                            0
                      : (price as num).toDouble();
                }
              } catch (_) {}
            }
          }
        }
      }

      // Calculate statistics
      int pending = 0;
      int accepted = 0;
      int completed = 0;
      int rejected = 0;

      for (var booking in allBookings) {
        final status = booking['status'] ?? 'pending';
        switch (status) {
          case 'pending':
            pending++;
            break;
          case 'accepted':
            accepted++;
            break;
          case 'completed':
            completed++;
            break;
          case 'rejected':
            rejected++;
            break;
        }
      }

      // Sort by date (most recent first)
      allBookings.sort((a, b) {
        final aDate = a['createdAt'] ?? 0;
        final bDate = b['createdAt'] ?? 0;
        return bDate.compareTo(aDate);
      });

      setState(() {
        _totalBookings = allBookings.length;
        _pendingBookings = pending;
        _acceptedBookings = accepted;
        _completedBookings = completed;
        _rejectedBookings = rejected;
        _totalEarnings = totalEarnings;
        _monthlyEarnings = monthlyEarnings;
        _recentBookings = allBookings.take(10).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadReports,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    _buildSummaryCards(),
                    const SizedBox(height: 24),

                    // Earnings Section
                    _buildEarningsSection(),
                    const SizedBox(height: 24),

                    // Bookings Statistics
                    _buildBookingsStats(),
                    const SizedBox(height: 24),

                    // Recent Bookings
                    const Text(
                      'Recent Bookings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E4D3C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRecentBookingsList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Bookings',
          _totalBookings.toString(),
          Icons.calendar_today,
          const Color(0xFF1E4D3C),
        ),
        _buildStatCard(
          'Completed',
          _completedBookings.toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Pending',
          _pendingBookings.toString(),
          Icons.pending,
          Colors.orange,
        ),
        _buildStatCard(
          'Rejected',
          _rejectedBookings.toString(),
          Icons.cancel,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSection() {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E4D3C), Color(0xFF2E7D5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Earnings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            currencyFormat.format(_totalEarnings),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Earnings',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'This Month: ${currencyFormat.format(_monthlyEarnings)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsStats() {
    final total = _totalBookings > 0 ? _totalBookings : 1;
    final completedPercent = (_completedBookings / total * 100).toStringAsFixed(
      1,
    );
    final pendingPercent = (_pendingBookings / total * 100).toStringAsFixed(1);
    final acceptedPercent = (_acceptedBookings / total * 100).toStringAsFixed(
      1,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4D3C),
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            'Completed',
            _completedBookings,
            total,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildProgressBar('Accepted', _acceptedBookings, total, Colors.blue),
          const SizedBox(height: 12),
          _buildProgressBar('Pending', _pendingBookings, total, Colors.orange),
          const SizedBox(height: 12),
          _buildProgressBar('Rejected', _rejectedBookings, total, Colors.red),
          const SizedBox(height: 16),
          Text(
            'Acceptance Rate: $acceptedPercent%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E4D3C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, int value, int total, Color color) {
    final percentage = total > 0 ? value / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              '$value (${(percentage * 100).toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildRecentBookingsList() {
    if (_recentBookings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'No bookings yet',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentBookings.length,
      itemBuilder: (context, index) {
        final booking = _recentBookings[index];
        return _buildBookingItem(booking);
      },
    );
  }

  Widget _buildBookingItem(Map<String, dynamic> booking) {
    final status = booking['status'] ?? 'pending';
    Color statusColor;
    String statusText;

    switch (status) {
      case 'accepted':
        statusColor = Colors.green;
        statusText = 'Accepted';
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusText = 'Completed';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(
            status == 'completed'
                ? Icons.check_circle
                : status == 'rejected'
                ? Icons.cancel
                : Icons.pending,
            color: statusColor,
          ),
        ),
        title: Text(
          booking['packageName'] ?? 'Tour Package',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(booking['touristName'] ?? 'Unknown Tourist'),
            if (booking['startDate'] != null)
              Text(
                _formatDate(booking['startDate']),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Date not set';
    try {
      DateTime dateTime;
      if (date is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(date);
      } else {
        dateTime = DateTime.parse(date.toString());
      }
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (_) {
      return 'Date not set';
    }
  }
}
