import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_art_market/image_sale/image_sale_detail.dart';
import 'package:my_art_market/video_sale/video_sale_detail.dart';
import 'package:my_art_market/documents_sale/documents_sale_detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all'; // all, image, video, documents

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _performSearch() async {
    if (_searchQuery.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> results = [];

    // Search in image_sales
    if (_selectedCategory == 'all' || _selectedCategory == 'image') {
      final imageSnapshot = await FirebaseFirestore.instance
          .collection('image_sales')
          .orderBy('createdAt', descending: true)
          .get();
      
      for (var doc in imageSnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toString().toLowerCase();
        final content = (data['content'] ?? '').toString().toLowerCase();
        
        if (title.contains(_searchQuery.toLowerCase()) ||
            content.contains(_searchQuery.toLowerCase())) {
          results.add({
            ...data,
            'id': doc.id,
            'type': 'image_sales',
          });
        }
      }
    }

    // Search in video_sales
    if (_selectedCategory == 'all' || _selectedCategory == 'video') {
      final videoSnapshot = await FirebaseFirestore.instance
          .collection('video_sales')
          .orderBy('createdAt', descending: true)
          .get();
      
      for (var doc in videoSnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toString().toLowerCase();
        final content = (data['content'] ?? '').toString().toLowerCase();
        
        if (title.contains(_searchQuery.toLowerCase()) ||
            content.contains(_searchQuery.toLowerCase())) {
          results.add({
            ...data,
            'id': doc.id,
            'type': 'video_sales',
          });
        }
      }
    }

    // Search in documents_sales
    if (_selectedCategory == 'all' || _selectedCategory == 'documents') {
      final docsSnapshot = await FirebaseFirestore.instance
          .collection('documents_sales')
          .orderBy('createdAt', descending: true)
          .get();
      
      for (var doc in docsSnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] ?? '').toString().toLowerCase();
        final content = (data['content'] ?? '').toString().toLowerCase();
        
        if (title.contains(_searchQuery.toLowerCase()) ||
            content.contains(_searchQuery.toLowerCase())) {
          results.add({
            ...data,
            'id': doc.id,
            'type': 'documents_sales',
          });
        }
      }
    }

    return results;
  }

  Widget _buildResultItem(Map<String, dynamic> item) {
    String type = item['type'];
    Color cardColor;
    IconData icon;
    String typeLabel;

    switch (type) {
      case 'image_sales':
        cardColor = Colors.green[400]!;
        icon = Icons.image;
        typeLabel = '이미지';
        break;
      case 'video_sales':
        cardColor = Colors.red[400]!;
        icon = Icons.play_circle_fill;
        typeLabel = '영상';
        break;
      case 'documents_sales':
        cardColor = Colors.blue[400]!;
        icon = Icons.description;
        typeLabel = '문서';
        break;
      default:
        cardColor = Colors.grey[400]!;
        icon = Icons.help;
        typeLabel = '기타';
    }

    return GestureDetector(
      onTap: () {
        Widget detailPage;
        switch (type) {
          case 'image_sales':
            detailPage = ImageSaleDetail(
              docId: item['id'] ?? '',
              title: item['title'] ?? '',
              imageAddress: item['imageAddress'] ?? '',
              content: item['content'] ?? '',
            );
            break;
          case 'video_sales':
            detailPage = VideoSaleDetail(
              docId: item['id'] ?? '',
              title: item['title'] ?? '',
              videoAddress: item['videoAddress'] ?? '',
              content: item['content'] ?? '',
              thumbnailUrl: item['thumbnailUrl'],
            );
            break;
          case 'documents_sales':
            detailPage = DocumentsSaleDetail(
              docId: item['id'] ?? '',
              title: item['title'] ?? '',
              documentAddress: item['documentAddress'] ?? '',
              content: item['content'] ?? '',
              thumbnailUrl: item['thumbnailUrl'],
            );
            break;
          default:
            return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => detailPage),
        );
      },
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            typeLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['content'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '제목 또는 내용으로 검색',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('전체', 'all'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('이미지', 'image'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('영상', 'video'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('문서', 'documents'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          '검색어를 입력하세요',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : FutureBuilder<List<Map<String, dynamic>>>(
                    future: _performSearch(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('오류가 발생했습니다: ${snapshot.error}'),
                        );
                      }

                      final results = snapshot.data ?? [];

                      if (results.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off,
                                  size: 80, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                '검색 결과가 없습니다',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildResultItem(results[index]),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = _selectedCategory == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = value;
        });
      },
      selectedColor: Colors.red,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
