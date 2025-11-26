import 'package:flutter/material.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

class PaymentPage extends StatefulWidget {
  final String title;
  final int price;

  const PaymentPage({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late PaymentWidget _paymentWidget;
  final String _clientKey = 'test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm'; // Test Client Key
  final String _customerKey = 'test_customer_key'; // Random customer key for testing

  @override
  void initState() {
    super.initState();
    _paymentWidget = PaymentWidget(
      clientKey: _clientKey,
      customerKey: _customerKey,
    );
    _paymentWidget.renderPaymentMethods(
      selector: 'methods',
      amount: Amount(value: widget.price, currency: Currency.KRW, country: 'KR'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  PaymentMethodWidget(
                    paymentWidget: _paymentWidget,
                    selector: 'methods',
                  ),
                  AgreementWidget(
                    paymentWidget: _paymentWidget,
                    selector: 'agreement',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final paymentResult = await _paymentWidget.requestPayment(
                        paymentInfo: PaymentInfo(
                          orderId: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
                          orderName: widget.title,
                        ),
                      );
                      
                      if (paymentResult.success != null) {
                        // Payment success
                        if (mounted) {
                          // ignore: use_build_context_synchronously
ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('결제가 완료되었습니다.')),
                          );
                          Navigator.pop(context);
                        }
                      } else if (paymentResult.fail != null) {
                        // Payment failed
                        if (mounted) {
                          // ignore: use_build_context_synchronously
ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('결제 실패: ${paymentResult.fail?.errorMessage}')),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        // ignore: use_build_context_synchronously
ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('오류 발생: $e')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    '결제하기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
