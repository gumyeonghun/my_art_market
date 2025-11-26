import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_art_market/providers/cart_provider.dart';
import 'package:my_art_market/home_page_appbar.dart';
import 'package:my_art_market/services/documents_sale_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsSaleDetail extends StatefulWidget {
  const DocumentsSaleDetail({
    required this.docId,
    required this.title,
    required this.documentAddress,
    required this.content,
    this.thumbnailUrl,
    super.key,
  });

  final String docId;
  final String title;
  final String documentAddress;
  final String content;
  final String? thumbnailUrl;

  @override
  State<DocumentsSaleDetail> createState() => _DocumentsSaleDetailState();
}

class _DocumentsSaleDetailState extends State<DocumentsSaleDetail> {
  final DocumentsSaleService _service = DocumentsSaleService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _documentAddressController;
  late TextEditingController _thumbnailUrlController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    _documentAddressController =
        TextEditingController(text: widget.documentAddress);
    _thumbnailUrlController =
        TextEditingController(text: widget.thumbnailUrl ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _documentAddressController.dispose();
    _thumbnailUrlController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('URL을 열 수 없습니다')),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    try {
      await _service.updateSale(
        docId: widget.docId,
        title: _titleController.text,
        content: _contentController.text,
        documentAddress: _documentAddressController.text,
        thumbnailUrl: _thumbnailUrlController.text.isEmpty
            ? null
            : _thumbnailUrlController.text,
      );
      setState(() {
        _isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수정되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제 확인'),
        content: const Text('정말 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _service.deleteSale(widget.docId);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제되었습니다')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: $e')),
          );
        }
      }
    }
  }

  String _getThumbnailUrl() {
    if (_isEditing) {
      return _thumbnailUrlController.text.isEmpty
          ? ''
          : _thumbnailUrlController.text;
    }
    return widget.thumbnailUrl ?? '';
  }

  bool _isImageUrl(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.png') ||
        lowerUrl.endsWith('.gif') ||
        lowerUrl.endsWith('.webp') ||
        lowerUrl.contains('image');
  }

  Widget _buildDocumentPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description,
              color: Colors.white,
              size: 80,
            ),
            SizedBox(height: 10),
            Text(
              'DOCUMENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.exit_to_app, color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        title: const Text('DOCUMENTS',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        centerTitle: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _delete,
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: _saveChanges,
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _titleController.text = widget.title;
                  _contentController.text = widget.content;
                  _documentAddressController.text = widget.documentAddress;
                  _thumbnailUrlController.text = widget.thumbnailUrl ?? '';
                });
              },
            ),
          IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addItem(
                    CartItem(
                      id: widget.docId,
                      title: widget.title,
                      price: 1000,
                      type: 'document',
                      imageUrl: widget.thumbnailUrl,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('장바구니에 추가되었습니다')),
                  );
                },
              ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Document Thumbnail/Icon
                Container(
                  child: AspectRatio(
                    aspectRatio: 1.5 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _getThumbnailUrl().isNotEmpty &&
                              _isImageUrl(_getThumbnailUrl())
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  _getThumbnailUrl(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDocumentPlaceholder();
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Icon(
                                    Icons.description,
                                    color: Colors.white,
                                    size: 40,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : _buildDocumentPlaceholder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                if (_isEditing)
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: '제목',
                      border: OutlineInputBorder(),
                    ),
                  )
                else
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 20),

                // Document Address
                const Text('문서 파일주소',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (_isEditing)
                  TextField(
                    controller: _documentAddressController,
                    decoration: const InputDecoration(
                      labelText: '문서 주소',
                      border: OutlineInputBorder(),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => _launchURL(widget.documentAddress),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.documentAddress,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Content
                const Text('내용',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (_isEditing)
                  TextField(
                    controller: _contentController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: '내용',
                      border: OutlineInputBorder(),
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.content,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 200),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
