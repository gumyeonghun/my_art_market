import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도움말'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // FAQ Section
          const Text(
            '자주 묻는 질문 (FAQ)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildFAQItem(
            question: '작품을 어떻게 구매하나요?',
            answer: '원하는 작품을 선택한 후 "구매하기" 버튼을 클릭하세요. 결제 정보를 입력하고 주문을 완료하면 됩니다.',
          ),
          _buildFAQItem(
            question: '작품을 판매하고 싶어요',
            answer: '홈 화면에서 각 카테고리(이미지, 비디오, 문서)의 "+" 버튼을 클릭하여 작품을 등록할 수 있습니다.',
          ),
          _buildFAQItem(
            question: '결제는 어떻게 하나요?',
            answer: '토스페이먼츠를 통해 안전하게 결제할 수 있습니다. 신용카드, 계좌이체 등 다양한 결제 수단을 지원합니다.',
          ),
          _buildFAQItem(
            question: '환불은 가능한가요?',
            answer: '디지털 콘텐츠 특성상 다운로드 후에는 환불이 어렵습니다. 구매 전 미리보기를 통해 신중히 확인해주세요.',
          ),
          _buildFAQItem(
            question: '비밀번호를 잊어버렸어요',
            answer: '로그인 화면에서 "비밀번호 찾기"를 클릭하시면 이메일로 재설정 링크를 받을 수 있습니다.',
          ),
          const SizedBox(height: 30),

          // User Guide Section
          const Text(
            '사용 가이드',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildGuideItem(
            icon: Icons.shopping_cart,
            title: '작품 구매하기',
            description: '1. 원하는 작품 선택\n2. 상세 정보 확인\n3. 장바구니 추가 또는 바로 구매\n4. 결제 완료',
          ),
          _buildGuideItem(
            icon: Icons.upload,
            title: '작품 판매하기',
            description: '1. 카테고리 선택 (이미지/비디오/문서)\n2. 작품 정보 입력\n3. 파일 업로드\n4. 가격 설정 및 등록',
          ),
          _buildGuideItem(
            icon: Icons.account_circle,
            title: '프로필 관리',
            description: '프로필 페이지에서 개인정보, 알림 설정, 비밀번호 변경 등을 관리할 수 있습니다.',
          ),
          const SizedBox(height: 30),

          // Contact Section
          const Text(
            '문의하기',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '추가 문의사항이 있으시면 아래 연락처로 문의해주세요:',
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.email,
                  label: '이메일',
                  value: 'support@myartmarket.com',
                  onTap: () => _launchEmail('support@myartmarket.com'),
                ),
                const SizedBox(height: 12),
                _buildContactItem(
                  icon: Icons.phone,
                  label: '전화',
                  value: '1588-0000',
                  onTap: () => _launchPhone('1588-0000'),
                ),
                const SizedBox(height: 12),
                _buildContactItem(
                  icon: Icons.access_time,
                  label: '운영시간',
                  value: '평일 09:00 - 18:00',
                  onTap: null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // App Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Icon(Icons.palette, size: 48, color: Colors.blue[700]),
                const SizedBox(height: 12),
                const Text(
                  'MY ART MARKET',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '예술 작품 거래 플랫폼',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.red, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Text(
              '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: onTap != null ? Colors.blue : Colors.black,
                decoration: onTap != null ? TextDecoration.underline : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=MY ART MARKET 문의',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
