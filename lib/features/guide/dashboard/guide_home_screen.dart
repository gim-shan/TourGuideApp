import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hidmo_app/features/guide/presentation/screens/guide_profile_screen.dart';
import 'package:hidmo_app/features/guide/presentation/screens/guide_tour_packages_screen.dart';
import 'package:hidmo_app/features/guide/presentation/screens/guide_reports_screen.dart';

class GuideHomeScreen extends StatefulWidget {
  const GuideHomeScreen({super.key});

  @override
  State<GuideHomeScreen> createState() => _GuideHomeScreenState();
}

class _GuideHomeScreenState extends State<GuideHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;
  String? _guideName;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadGuideData();
  }

  Future<void> _loadGuideData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Get guide name
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _guideName = userDoc.data()?['name'] ?? user.displayName ?? 'Guide';
        });
      }

      // Get bookings assigned to this guide
      final bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('guideId', isEqualTo: user.uid)
          .get();

      List<Map<String, dynamic>> bookings = [];
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
            data['touristEmail'] = touristDoc.data()?['email'] ?? '';
            data['touristPhone'] = touristDoc.data()?['phone'] ?? '';
            data['touristProfilePicture'] =
                touristDoc.data()?['profilePictureUrl'] ?? '';
          }
        }

        bookings.add(data);
      }

      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'accepted' ? 'Booking accepted!' : 'Booking rejected!',
          ),
          backgroundColor: status == 'accepted' ? Colors.green : Colors.red,
        ),
      );

      _loadGuideData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update booking'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      // Navigate back to role selection
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/choose-role', (route) => false);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF1E4D3C);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          _selectedIndex == 0
              ? 'Welcome, ${_guideName ?? "Guide"}!'
              : _selectedIndex == 1
              ? 'My Tour Packages'
              : _selectedIndex == 2
              ? 'Reports & Analytics'
              : 'My Profile',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                _showNotifications();
              },
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: primaryColor.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today, color: Color(0xFF1E4D3C)),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.tour_outlined),
            selectedIcon: Icon(Icons.tour, color: Color(0xFF1E4D3C)),
            label: 'Packages',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics, color: Color(0xFF1E4D3C)),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF1E4D3C)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildBookingsView();
      case 1:
        return _buildPackagesView();
      case 2:
        return _buildReportsView();
      case 3:
        return _buildProfileView();
      default:
        return _buildBookingsView();
    }
  }

  Widget _buildBookingsView() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadGuideData,
            child: _bookings.isEmpty
                ? _buildEmptyState()
                : _buildBookingsList(),
          );
  }

  Widget _buildPackagesView() {
    return const GuideTourPackagesScreen();
  }

  Widget _buildReportsView() {
    return const GuideReportsScreen();
  }

  Widget _buildProfileView() {
    return const GuideProfileScreen();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              'No Bookings Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E4D3C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'When a tourist assigns you to a tour package,\nyou will see the details here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        return _BookingCard(
          booking: booking,
          onAccept: () => _updateBookingStatus(booking['id'], 'accepted'),
          onReject: () => _updateBookingStatus(booking['id'], 'rejected'),
          onViewTourist: () => _viewTouristProfile(booking),
          onViewPackage: () => _viewPackageDetails(booking),
        );
      },
    );
  }

  void _viewTouristProfile(Map<String, dynamic> booking) {
    // Navigate to tourist profile view
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _TouristProfileSheet(
        touristName: booking['touristName'] ?? 'Unknown',
        touristEmail: booking['touristEmail'] ?? '',
        touristPhone: booking['touristPhone'] ?? '',
        touristProfilePicture: booking['touristProfilePicture'] ?? '',
      ),
    );
  }

  void _viewPackageDetails(Map<String, dynamic> booking) {
    // Show package details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PackageDetailsSheet(
        packageName: booking['packageName'] ?? 'Tour Package',
        startDate: booking['startDate'],
        endDate: booking['endDate'],
        totalPrice: booking['totalPrice'] ?? '',
        status: booking['status'] ?? 'pending',
        paymentStatus: booking['paymentStatus'] ?? 'pending',
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_bookings.isEmpty)
              const Text('No new notifications')
            else
              ...(_bookings
                  .where((b) => b['status'] == 'pending')
                  .map(
                    (b) => ListTile(
                      leading: const Icon(Icons.event),
                      title: Text(b['packageName'] ?? 'Tour'),
                      subtitle: Text(
                        '${b['touristName'] ?? 'Unknown'} wants you as their guide',
                      ),
                    ),
                  )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onViewTourist;
  final VoidCallback onViewPackage;

  const _BookingCard({
    required this.booking,
    required this.onAccept,
    required this.onReject,
    required this.onViewTourist,
    required this.onViewPackage,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking['status'] ?? 'pending';
    final paymentStatus = booking['paymentStatus'] ?? 'pending';

    Color statusColor;
    String statusText;
    switch (status) {
      case 'accepted':
        statusColor = Colors.green;
        statusText = 'Accepted';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending';
    }

    Color paymentColor;
    String paymentText;
    switch (paymentStatus) {
      case 'completed':
        paymentColor = Colors.green;
        paymentText = 'Paid';
        break;
      case 'failed':
        paymentColor = Colors.red;
        paymentText = 'Payment Failed';
        break;
      default:
        paymentColor = Colors.orange;
        paymentText = 'Pending Payment';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking['packageName'] ?? 'Tour Package',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E4D3C),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dates
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF1E4D3C),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(booking['startDate']),
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(' - '),
                Text(
                  _formatDate(booking['endDate']),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Tourist Name
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Color(0xFF1E4D3C)),
                const SizedBox(width: 8),
                Text(
                  booking['touristName'] ?? 'Unknown Tourist',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Payment Status
            Row(
              children: [
                Icon(
                  paymentStatus == 'completed'
                      ? Icons.check_circle
                      : Icons.pending,
                  size: 16,
                  color: paymentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  paymentText,
                  style: TextStyle(
                    fontSize: 14,
                    color: paymentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // View Tourist Profile
                TextButton.icon(
                  onPressed: onViewTourist,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Tourist'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1E4D3C),
                  ),
                ),
                // View Package Details
                TextButton.icon(
                  onPressed: onViewPackage,
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: const Text('Package'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1E4D3C),
                  ),
                ),
              ],
            ),

            // Accept/Reject buttons (only show for pending)
            if (status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onReject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[100],
                        foregroundColor: Colors.red[700],
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E4D3C),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Not set';
    if (date is String) return date;
    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return 'Not set';
  }
}

class _TouristProfileSheet extends StatelessWidget {
  final String touristName;
  final String touristEmail;
  final String touristPhone;
  final String touristProfilePicture;

  const _TouristProfileSheet({
    required this.touristName,
    required this.touristEmail,
    required this.touristPhone,
    required this.touristProfilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF1E4D3C),
                backgroundImage: touristProfilePicture.isNotEmpty
                    ? NetworkImage(touristProfilePicture)
                    : null,
                child: touristProfilePicture.isEmpty
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      touristName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Tourist', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Contact Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _ContactRow(
            icon: Icons.email,
            label: 'Email',
            value: touristEmail.isEmpty ? 'Not provided' : touristEmail,
          ),
          const SizedBox(height: 12),
          _ContactRow(
            icon: Icons.phone,
            label: 'Phone',
            value: touristPhone.isEmpty ? 'Not provided' : touristPhone,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E4D3C),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E4D3C)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}

class _PackageDetailsSheet extends StatelessWidget {
  final String packageName;
  final dynamic startDate;
  final dynamic endDate;
  final String totalPrice;
  final String status;
  final String paymentStatus;

  const _PackageDetailsSheet({
    required this.packageName,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Package Details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4D3C),
            ),
          ),
          const SizedBox(height: 24),

          _DetailRow(icon: Icons.tour, label: 'Package', value: packageName),
          const SizedBox(height: 16),

          _DetailRow(
            icon: Icons.calendar_today,
            label: 'Start Date',
            value: _formatDate(startDate),
          ),
          const SizedBox(height: 16),

          _DetailRow(
            icon: Icons.calendar_today,
            label: 'End Date',
            value: _formatDate(endDate),
          ),
          const SizedBox(height: 16),

          _DetailRow(
            icon: Icons.attach_money,
            label: 'Total Price',
            value: totalPrice.isEmpty ? 'Not specified' : totalPrice,
          ),
          const SizedBox(height: 16),

          _DetailRow(
            icon: Icons.info,
            label: 'Booking Status',
            value: status.toUpperCase(),
          ),
          const SizedBox(height: 16),

          _DetailRow(
            icon: Icons.payment,
            label: 'Payment Status',
            value: paymentStatus.toUpperCase(),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E4D3C),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Not set';
    if (date is String) return date;
    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return 'Not set';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E4D3C)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
