import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_flutter/domain/entities/product.dart';
import 'package:stock_flutter/providers/auth_providers.dart';
import 'package:stock_flutter/providers/category_providers.dart';
import 'package:stock_flutter/providers/repository_providers.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minStockController = TextEditingController();
  String? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  void _addProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _minStockController.text.isEmpty ||
        _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateNotifierProvider);
      if (user == null) throw Exception('User not found');

      final product = Product(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId!,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        minStockLevel: int.parse(_minStockController.text),
        userId: user.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final productRepository = ref.read(productRepositoryProvider);
      await productRepository.addProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit ajouté avec succès')),
        );
        context.go('/products');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(allCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un produit'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom du produit',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            categories.when(
              data: (categoryList) {
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: categoryList
                      .map((category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategoryId = value);
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, __) => Text('Erreur: $error'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Prix',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixText: '€',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantité',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _minStockController,
              decoration: InputDecoration(
                labelText: 'Stock minimum',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _addProduct,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Ajouter le produit'),
            ),
          ],
        ),
      ),
    );
  }
}
