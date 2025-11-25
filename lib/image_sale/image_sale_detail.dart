import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_art_market/providers/cart_provider.dart';
import 'package:my_art_market/home_page_appbar.dart';
import 'package:my_art_market/services/image_sale_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSaleDetail extends StatefulWidget {
  const ImageSaleDetail({
    required this.docId,
    required this.title,
    required this.imageAddress,
    required this.content,
    super.key,
  });

  final String docId;
  final String title;
  final String imageAddress;
  final String content;

  @override
  State<ImageSaleDetail> createState() => _ImageSaleDetailState();
}

class _ImageSaleDetailState extends State<ImageSaleDetail> {
  final ImageSaleService _service = ImageSaleService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageAddressController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    _imageAddressController = TextEditingController(text: widget.imageAddress);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageAddressController.dispose();
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
        imageAddress: _imageAddressController.text,
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
        backgroundColor: Colors.orange,
        title: const Text('IMAGE',
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
                  _imageAddressController.text = widget.imageAddress;
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
                      type: 'image',
                      imageUrl: widget.imageAddress,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('장바구니에 추가되었습니다')),
                  );
                },
              ),
              HomePageAppbar(),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Image
                Container(
                  child: AspectRatio(
                    aspectRatio: 1.5 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _isEditing
                            ? _imageAddressController.text
                            : widget.imageAddress,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 50),
                          );
                        },
                      ),
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

                // Image Address
                const Text('이미지 파일주소',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (_isEditing)
                  TextField(
                    controller: _imageAddressController,
                    decoration: const InputDecoration(
                      labelText: '이미지 주소',
                      border: OutlineInputBorder(),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => _launchURL(widget.imageAddress),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.imageAddress,
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
