import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hidmo_app/core/services/push_notification_service.dart';

class PaymentScreen extends StatefulWidget {
  final String packageName;
  final double totalAmount;
  final int numberOfPeople;
  final DateTime bookingDate;
  final Map<String, dynamic> packageDetails;
  final String? guideId;
  final String? guideName;

  const PaymentScreen({
    super.key,
    required this.packageName,
    required this.totalAmount,
    required this.numberOfPeople,
    required this.bookingDate,
    required this.packageDetails,
    this.guideId,
    this.guideName,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  bool _isProcessing = false;
  Map<String, dynamic>? _paymentIntentData;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a PaymentIntent on your backend
      _paymentIntentData = await _createPaymentIntent(
        widget.totalAmount.toInt() * 100, // Convert to cents
        'usd',
      );

      if (_paymentIntentData != null &&
          _paymentIntentData!['client_secret'] != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: _paymentIntentData!['client_secret'],
            merchantDisplayName: 'TourGuideApp',
            customerId: FirebaseAuth.instance.currentUser?.uid,
            style: ThemeMode.dark,
            billingDetailsCollectionConfiguration:
                const BillingDetailsCollectionConfiguration(
                  name: CollectionMode.always,
                  email: CollectionMode.always,
                ),
          ),
        );
      } else {
        _showError('Payment initialization failed. Please try again.');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to initialize payment: ${e.toString()}');
    }
  }

  // For local testing, use 'http://localhost:3000'
  // For emulator testing, use 'http://10.0.2.2:3000' (Android emulator)
  // For production, use Firebase Cloud Functions URL
  static const String _paymentServerUrl = 'http://10.121.182.41:3000';

  Future<Map<String, dynamic>?> _createPaymentIntent(
    int amount,
    String currency,
  ) async {
    try {
      // Call your payment server to create payment intent
      final response = await http.post(
        Uri.parse('$_paymentServerUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
          'customerId': FirebaseAuth.instance.currentUser?.uid,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Server returns clientSecret (camelCase), convert to snake_case for consistency
        if (data['clientSecret'] != null) {
          data['client_secret'] = data['clientSecret'];
        }
        return data;
      } else {
        _showError('Failed to create payment intent');
        return null;
      }
    } catch (e) {
      // Return null if backend is not available - will show error to user
      _showError(
        'Cannot connect to payment server. Please ensure the server is running.',
      );
      return null;
    }
  }

  Future<void> _presentPaymentSheet() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await Stripe.instance.presentPaymentSheet();

      // Payment successful - save booking to Firestore
      await _saveBookingToFirestore();

      if (mounted) {
        _showSuccess('Payment successful! Your booking has been confirmed.');
      }
    } on StripeException catch (e) {
      _showError(
        'Payment failed: ${e.error.localizedMessage ?? e.error.message}',
      );
    } catch (e) {
      _showError('An error occurred: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _saveBookingToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showError('Please log in to complete your booking');
        return;
      }

      final bookingData = {
        'userId': user.uid,
        'userEmail': user.email,
        'packageName': widget.packageName,
        'packageDetails': widget.packageDetails,
        'totalAmount': widget.totalAmount,
        'numberOfPeople': widget.numberOfPeople,
        'bookingDate': FieldValue.serverTimestamp(),
        'paymentStatus': 'paid',
        'paymentId': 'pi_${DateTime.now().millisecondsSinceEpoch}',
        'status': 'pending', // Set to pending so guide can accept/reject
        // Guide assignment (if guide was selected)
        if (widget.guideId != null) 'guideId': widget.guideId,
        if (widget.guideName != null) 'guideName': widget.guideName,
      };

      // Create the booking
      final bookingRef = await FirebaseFirestore.instance
          .collection('bookings')
          .add(bookingData);

      // If a guide was assigned, send notification to the guide
      if (widget.guideId != null) {
        // Get tourist name for the notification
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final touristName =
            userDoc.data()?['name'] ?? user.displayName ?? 'A tourist';

        // Send notification to the guide
        await PushNotificationService.sendTourAssignedNotification(
          guideId: widget.guideId!,
          touristName: touristName,
          packageName: widget.packageName,
          bookingId: bookingRef.id,
        );
      }
    } catch (e) {
      _showError('Failed to save booking: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xFF1E4D3C),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Summary Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Booking Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E4D3C),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow('Package', widget.packageName),
                          _buildSummaryRow(
                            'Number of People',
                            '${widget.numberOfPeople}',
                          ),
                          const Divider(height: 24),
                          _buildSummaryRow(
                            'Total Amount',
                            '\$${widget.totalAmount.toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Payment Method Section
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E4D3C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CardFormField(
                        style: CardFormStyle(
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                          placeholderColor: Colors.grey,
                          borderRadius: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _presentPaymentSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E4D3C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Pay \$${widget.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Security Note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Secured by Stripe',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF1E4D3C) : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: const Color(0xFF1E4D3C),
            ),
          ),
        ],
      ),
    );
  }
}
