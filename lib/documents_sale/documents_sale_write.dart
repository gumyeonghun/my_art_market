import 'package:flutter/material.dart';
import 'package:my_art_market/services/documents_sale_service.dart';
import 'package:my_art_market/documents_sale/documents_sale_home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DocumentsSaleWrite extends StatefulWidget {
  const DocumentsSaleWrite({super.key});

  @override
  State<DocumentsSaleWrite> createState() => _DocumentsSaleWriteState();
}

class _DocumentsSaleWriteState extends State<DocumentsSaleWrite> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController documentAddressController =
      TextEditingController();
  final TextEditingController thumbnailUrlController = TextEditingController();
  final DocumentsSaleService _documentsSaleService = DocumentsSaleService();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  String? _uploadedThumbnailUrl;
  XFile? _selectedImage;

  Future<void> onCreate() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        documentAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload image if selected
      String? finalThumbnailUrl = _uploadedThumbnailUrl;
      if (_selectedImage != null && finalThumbnailUrl == null) {
        finalThumbnailUrl = await _uploadImage(_selectedImage!);
      }
      
      // Use uploaded URL or manual URL
      final thumbnailUrl = finalThumbnailUrl ?? 
          (thumbnailUrlController.text.isEmpty
              ? null
              : thumbnailUrlController.text);

      await _documentsSaleService.addSale(
        title: titleController.text,
        content: contentController.text,
        documentAddress: documentAddressController.text,
        thumbnailUrl: thumbnailUrl,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding sale: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
          thumbnailUrlController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<String> _uploadImage(XFile image) async {
    final String fileName = 'thumbnails/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    
    final File file = File(image.path);
    final UploadTask uploadTask = storageRef.putFile(file);
    
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    
    return downloadUrl;
  }

  @override
  void dispose() {
    titleController.dispose();
    documentAddressController.dispose();
    thumbnailUrlController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'DOCUMENTS',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 70,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const DocumentsSaleHome();
                      }));
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: const Text(
                      '문서 판매목록 바로가기',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 10,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 5),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(
                      Icons.description,
                      size: 100,
                      color: Colors.lightBlue,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    '문서를 업로드 해주세요',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: titleController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: '제목',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      maxLines: 1,
                      controller: documentAddressController,
                      decoration: const InputDecoration(
                        hintText: '문서 파일 주소',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Thumbnail section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '썸네일 이미지',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (_selectedImage != null)
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text('핸드폰에서 이미지 선택'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 10),
                      const Text(
                        '또는',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          maxLines: 1,
                          controller: thumbnailUrlController,
                          enabled: _selectedImage == null,
                          decoration: const InputDecoration(
                            hintText: '썸네일 이미지 URL 입력',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      maxLines: null,
                      controller: contentController,
                      decoration: const InputDecoration(
                        hintText: '내용',
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: onCreate,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.redAccent),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        child: const Text(
                          '판매등록',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
