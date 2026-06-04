import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_flutter/domain/entities/movement.dart';
import 'package:stock_flutter/providers/auth_providers.dart';
import 'package:stock_flutter/providers/movement_providers.dart';
import 'package:stock_flutter/providers/product_providers.dart';
import 'package:stock_flutter/providers/repository_providers.dart';
import 'package:uuid/uuid.dart';

class MovementsScreen extends ConsumerStatefulWidget {
  const MovementsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends ConsumerState<MovementsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
  }

  @override
  Widget build(BuildContext context) {
    final movements = ref.watch(movementsProvider((_startDate!, _endDate!)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mouvements de Stock'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Du: ${_startDate?.toLocal().toString().split(' ')[0] ?? 'Date'}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Au: ${_endDate?.toLocal().toString().split(' ')[0] ?? 'Date'}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: movements.when(
              data: (movementList) {
                if (movementList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun mouvement',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: movementList.length,
                  itemBuilder: (context, index) {
                    final movement = movementList[index];
                    final isEntry = movement.type == MovementType.entry;

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          isEntry ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isEntry ? Colors.green : Colors.red,
                        ),
                        title: Text(movement.reason),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Quantité: ${movement.quantity}'),
                            Text(
                              'Date: ${movement.createdAt.toLocal().toString().split('.')[0]}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            '${isEntry ? '+' : '-'}${movement.quantity}',
                            style: TextStyle(
                              color: isEntry ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, __) => Center(child: Text('Erreur: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddMovementDialog();
        },
        label: const Text('Ajouter Mouvement'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMovementDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddMovementDialog(),
    );
  }
}

class _AddMovementDialog extends ConsumerStatefulWidget {
  const _AddMovementDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<_AddMovementDialog> createState() => _AddMovementDialogState();
}

class _AddMovementDialogState extends ConsumerState<_AddMovementDialog> {
  late final _quantityController = TextEditingController();
  late final _reasonController = TextEditingController();
  MovementType _type = MovementType.entry;
  String? _selectedProductId;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _addMovement() async {
    if (_quantityController.text.isEmpty ||
        _reasonController.text.isEmpty ||
        _selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    try {
      final user = ref.read(authStateNotifierProvider);
      if (user == null) throw Exception('User not found');

      final movement = Movement(
        id: const Uuid().v4(),
        productId: _selectedProductId!,
        type: _type,
        quantity: int.parse(_quantityController.text),
        reason: _reasonController.text.trim(),
        userId: user.id,
        createdAt: DateTime.now(),
      );

      final movementRepository = ref.read(movementRepositoryProvider);
      await movementRepository.addMovement(movement);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mouvement enregistré')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductsProvider);

    return AlertDialog(
      title: const Text('Ajouter un mouvement'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<MovementType>(
              segments: const [
                ButtonSegment(
                  value: MovementType.entry,
                  label: Text('Entrée'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: MovementType.exit,
                  label: Text('Sortie'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (value) {
                setState(() => _type = value.first);
              },
            ),
            const SizedBox(height: 16),
            products.when(
              data: (productList) {
                return DropdownButtonFormField<String>(
                  value: _selectedProductId,
                  decoration: const InputDecoration(
                    labelText: 'Produit',
                    border: OutlineInputBorder(),
                  ),
                  items: productList
                      .map((product) => DropdownMenuItem(
                            value: product.id,
                            child: Text(product.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedProductId = value);
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, __) => Text('Erreur: $error'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantité',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Raison',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _addMovement,
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
