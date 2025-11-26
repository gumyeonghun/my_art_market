import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _newItemNotifications = true;
  bool _priceDropNotifications = true;
  bool _orderNotifications = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _pushNotifications = prefs.getBool('push_notifications') ?? true;
        _emailNotifications = prefs.getBool('email_notifications') ?? true;
        _newItemNotifications = prefs.getBool('new_item_notifications') ?? true;
        _priceDropNotifications = prefs.getBool('price_drop_notifications') ?? true;
        _orderNotifications = prefs.getBool('order_notifications') ?? true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSetting(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('설정 저장 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // General Notifications Section
                const Text(
                  '일반 알림',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSwitchTile(
                  icon: Icons.notifications_active,
                  title: '푸시 알림',
                  subtitle: '앱 푸시 알림을 받습니다',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                    _saveSetting('push_notifications', value);
                  },
                ),
                const SizedBox(height: 12),
                _buildSwitchTile(
                  icon: Icons.email,
                  title: '이메일 알림',
                  subtitle: '이메일로 알림을 받습니다',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                    _saveSetting('email_notifications', value);
                  },
                ),
                const SizedBox(height: 30),

                // Category Notifications Section
                const Text(
                  '카테고리별 알림',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSwitchTile(
                  icon: Icons.new_releases,
                  title: '신규 작품',
                  subtitle: '새로운 작품이 등록되면 알림을 받습니다',
                  value: _newItemNotifications,
                  onChanged: (value) {
                    setState(() {
                      _newItemNotifications = value;
                    });
                    _saveSetting('new_item_notifications', value);
                  },
                ),
                const SizedBox(height: 12),
                _buildSwitchTile(
                  icon: Icons.trending_down,
                  title: '가격 인하',
                  subtitle: '관심 작품의 가격이 내려가면 알림을 받습니다',
                  value: _priceDropNotifications,
                  onChanged: (value) {
                    setState(() {
                      _priceDropNotifications = value;
                    });
                    _saveSetting('price_drop_notifications', value);
                  },
                ),
                const SizedBox(height: 12),
                _buildSwitchTile(
                  icon: Icons.shopping_cart,
                  title: '주문 알림',
                  subtitle: '주문 상태 변경 시 알림을 받습니다',
                  value: _orderNotifications,
                  onChanged: (value) {
                    setState(() {
                      _orderNotifications = value;
                    });
                    _saveSetting('order_notifications', value);
                  },
                ),
                const SizedBox(height: 30),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '알림 설정은 즉시 적용됩니다',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.red),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
