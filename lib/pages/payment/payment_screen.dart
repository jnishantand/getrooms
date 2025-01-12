import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Set up listeners for the payment result
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //  _razorpay.on(Razorpay.EVENT_PAYMENT_CANCELLED, _handlePaymentCancelled);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Clean up Razorpay instance
  }

  // Payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful: ${response.paymentId}')),
    );
  }

  // Payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  // Payment cancelled
  // void _handlePaymentCancelled(PaymentCancellationResponse response) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Payment cancelled: ${response.paymentId}')),
  //   );
  // }

  // Trigger Razorpay payment
  void _startPayment() {
    var options = {
      'key': 'rzp_test_NnwHzEjUGkWpnS', // Your Razorpay Key ID
      'amount': 100, // Amount in paise (100 paise = 1 INR)
      'name': 'Room Booking',
      'description': 'Room Payment',
      'prefill': {
        'contact': '1234567890', // User's contact number
        'email': 'user@example.com', // User's email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Razorpay Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: _startPayment,
          child: Text('Pay Now'),
        ),
      ),
    );
  }
}
