import 'package:flutter/material.dart';
import 'package:my_art_market/services/image_sale_service.dart';
import 'package:my_art_market/image_sale/image_sale_home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ImageSaleWrite extends StatefulWidget {
  const ImageSaleWrite({super.key});

  @override
  State<ImageSaleWrite> createState() => _ImageSaleWriteState();
}

class _ImageSaleWriteState extends State<ImageSaleWrite> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  // final TextEditingController imageAddressController = TextEditingController(); // Removed
  final ImageSaleService _imageSaleService = ImageSaleService();
  bool _isLoading = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('image_sales/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(_image!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> onCreate() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields and select an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Attempting to add sale...');
      
      final String? imageUrl = await _uploadImage();
      if (imageUrl == null) {
        throw Exception('Image upload failed');
      }

      await _imageSaleService.addSale(
        title: titleController.text,
        content: contentController.text,
        imageAddress: imageUrl,
      );
      print('Sale added successfully');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error adding sale: $e');
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

  @override
  void dispose() {
    titleController.dispose();
    // imageAddressController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'IMAGE',
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
                        return const ImageSaleHome();
                      }));
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: const Text(
                      '이미지 판매목록 바로가기',
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
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(20)),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.lightBlue,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    '이미지를 업로드 해주세요',
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
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey, width: 3),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: TextField(
                  //     maxLines: 1,
                  //     controller: imageAddressController,
                  //     decoration: const InputDecoration(
                  //       hintText: '이미지 파일 주소',
                  //     ),
                  //   ),
                  // ),
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
