//UTS - Salsabila Nur Fadhilah Permana

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class WishlistItem {
  int id;
  final String name;
  final double price;
  final String imageUrl;
  final String priority;
  bool isPurchased;

  WishlistItem({
    int? id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.priority,
    this.isPurchased = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'priority': priority,
    'isPurchased': isPurchased,
  };

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
    id: json['id'],
    name: json['name'],
    price: json['price'].toDouble(),
    imageUrl: json['imageUrl'],
    priority: json['priority'],
    isPurchased: json['isPurchased'],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DreamCart',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme() {
    const pinkBright = Color(0xFFF06292);
    const offWhite = Color(0xFFF8F8F8);
    const darkText = Color(0xFF333333);
    const lightText = Colors.white;

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: pinkBright,
      scaffoldBackgroundColor: offWhite,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(foregroundColor: lightText, elevation: 2),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pinkBright,
          foregroundColor: lightText,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(pinkBright),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkText),
        bodyMedium: TextStyle(color: darkText),
        titleLarge: TextStyle(color: darkText),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF06292), Color(0xFFE91E63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late List<WishlistItem> _wishlistItems;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _wishlistItems = [];
    _loadWishlist();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString('wishlist_items');
    if (itemsJson != null && mounted) {
      final List<dynamic> itemsList = jsonDecode(itemsJson);
      setState(() {
        _wishlistItems = itemsList
            .map((json) => WishlistItem.fromJson(json))
            .toList();
      });
    } else {
      setState(() {
        _wishlistItems = [
          WishlistItem(
            name: 'Sepatu Sneakers',
            price: 1999000,
            imageUrl:
                'https://images.novelship.com/product/new_balance_2002r__linen__m2002rek_0_29877.jpeg?fit=fill&bg=FFFFFF&trim=color&auto=format,compress&q=75&h=400',
            priority: 'Tinggi',
          ),
          WishlistItem(
            name: 'Blush On',
            price: 550000,
            imageUrl:
                'https://down-id.img.susercontent.com/file/id-11134207-7qul9-lf0thz91bh2tf7',
            priority: 'Sedang',
          ),
        ];
      });
      await _saveWishlist();
    }
  }

  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final String itemsJson = jsonEncode(
      _wishlistItems.map((item) => item.toJson()).toList(),
    );
    await prefs.setString('wishlist_items', itemsJson);
  }

  void _addItemToWishlist(WishlistItem item) {
    setState(() {
      _wishlistItems.insert(0, item);
      _listKey.currentState?.insertItem(
        0,
        duration: const Duration(milliseconds: 500),
      );
    });
    _saveWishlist();
  }

  void _togglePurchasedStatus(WishlistItem item) {
    setState(() => item.isPurchased = !item.isPurchased);
    _saveWishlist();
    if (item.isPurchased) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('${item.name} dibeli!')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _removeItem(WishlistItem item) {
    final index = _wishlistItems.indexOf(item);
    _wishlistItems.remove(item);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: WishlistCard(item: item, onTap: () {}, onTogglePurchased: () {}),
      ),
      duration: const Duration(milliseconds: 300),
    );
    _saveWishlist();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.name} dihapus.')));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _navigateToWishlist() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WishlistPage(
          wishlistItems: _wishlistItems,
          onTogglePurchased: _togglePurchasedStatus,
          onRemoveItem: _removeItem,
          listKey: _listKey,
          animationController: _animationController,
        ),
      ),
    );
    setState(() {});
  }

  void _navigateToAddItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemPage(onAddItem: _addItemToWishlist),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'DreamCart'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildNavigationCard(
                  icon: Icons.list_alt_rounded,
                  title: 'Lihat Wishlist',
                  subtitle: 'Cek daftar barang impianmu',
                  color: const Color(0xFFF06292),
                  onTap: _navigateToWishlist,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNavigationCard(
                  icon: Icons.add_shopping_cart_rounded,
                  title: 'Tambah Barang',
                  subtitle: 'Masukkan barang baru',
                  color: const Color(0xFF9FA8DA),
                  onTap: _navigateToAddItem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WishlistPage extends StatefulWidget {
  final List<WishlistItem> wishlistItems;
  final Function(WishlistItem) onTogglePurchased;
  final Function(WishlistItem) onRemoveItem;
  final GlobalKey<AnimatedListState> listKey;
  final AnimationController animationController;

  const WishlistPage({
    super.key,
    required this.wishlistItems,
    required this.onTogglePurchased,
    required this.onRemoveItem,
    required this.listKey,
    required this.animationController,
  });

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<WishlistItem> get sortedList {
    final list = List<WishlistItem>.from(widget.wishlistItems);
    list.sort((a, b) {
      if (a.isPurchased != b.isPurchased) {
        return a.isPurchased ? 1 : -1;
      }
      return 0;
    });
    return list;
  }

  void _showItemDetail(BuildContext context, WishlistItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(item.name, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Prioritas: ${item.priority}'),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              ).format(item.price),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSortedList = sortedList;

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Wishlist'),
      body: currentSortedList.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                _buildMiniSummary(context),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentSortedList.length,
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                    itemBuilder: (context, index) {
                      final item = currentSortedList[index];
                      return Dismissible(
                        key: Key(item.id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => widget.onRemoveItem(item),
                        background: Container(
                          color: Colors.red.shade400,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: WishlistCard(
                          item: item,
                          onTogglePurchased: () {
                            widget.onTogglePurchased(item);
                            setState(() {});
                          },
                          onTap: () => _showItemDetail(context, item),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMiniSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryInfo(
            'Total Barang',
            widget.wishlistItems.length.toString(),
            Icons.list_alt_rounded,
            const Color(0xFFF06292),
          ),
          _summaryInfo(
            'Sudah Dibeli',
            widget.wishlistItems.where((i) => i.isPurchased).length.toString(),
            Icons.check_circle_rounded,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _summaryInfo(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: widget.animationController,
            builder: (context, child) => Transform.translate(
              offset: Offset(
                0,
                sin(widget.animationController.value * 2 * pi) * 10,
              ),
              child: child,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Wishlist Anda kosong',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ayo tambahkan barang impianmu!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class AddItemPage extends StatefulWidget {
  final Function(WishlistItem) onAddItem;
  const AddItemPage({super.key, required this.onAddItem});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _priority = 'Sedang';

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newItem = WishlistItem(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        priority: _priority,
      );

      widget.onAddItem(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barang berhasil ditambahkan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      _nameController.clear();
      _priceController.clear();
      _imageUrlController.clear();
      setState(() {
        _priority = 'Sedang';
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tambah Barang'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Harga tidak boleh kosong';
                  if (double.tryParse(value) == null)
                    return 'Harga tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                keyboardType: TextInputType.url,
                validator: (value) => value == null || value.isEmpty
                    ? 'URL Gambar tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Prioritas'),
                items: ['Tinggi', 'Sedang', 'Rendah']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _priority = value);
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Tambah ke Wishlist'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WishlistCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onTogglePurchased;
  final VoidCallback onTap;

  const WishlistCard({
    super.key,
    required this.item,
    required this.onTogglePurchased,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(item.price);

    return Opacity(
      opacity: item.isPurchased ? 0.6 : 1.0,
      child: Card(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: SizedBox(
            width: 70,
            height: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: item.isPurchased
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: item.isPurchased ? Colors.grey : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              formattedPrice,
              style: TextStyle(
                color: item.isPurchased ? Colors.grey : Colors.green.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPriorityChip(item),
              const SizedBox(width: 8),
              Checkbox(
                value: item.isPurchased,
                onChanged: (value) => onTogglePurchased(),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(WishlistItem item) {
    Color color;
    switch (item.priority) {
      case 'Tinggi':
        color = Colors.red.shade400;
        break;
      case 'Sedang':
        color = Colors.orange.shade400;
        break;
      default:
        color = Colors.blue.shade400;
        break;
    }
    return Chip(
      label: Text(
        item.priority,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
