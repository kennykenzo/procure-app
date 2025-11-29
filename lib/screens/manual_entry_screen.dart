import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:procurement_scanner/widgets/location_selector.dart';

/// Manual entry screen for adding items
class ManualEntryScreen extends ConsumerStatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  ConsumerState<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends ConsumerState<ManualEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _materialCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _specificationController = TextEditingController();
  final _unitOfMeasureController = TextEditingController(text: 'pcs');
  final _barcodeController = TextEditingController();
  final _nfcIdController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _categoryController = TextEditingController();
  final _supplierController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedLocationId;
  bool _isOfficeStock = false;

  @override
  void dispose() {
    _materialCodeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _specificationController.dispose();
    _unitOfMeasureController.dispose();
    _barcodeController.dispose();
    _nfcIdController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedLocationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location')),
        );
        return;
      }

      // Create new item (in real app, this would use the item model)
      // For now, just show success and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Entry'),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Material Code
            TextFormField(
              controller: _materialCodeController,
              decoration: const InputDecoration(
                labelText: 'Material Code *',
                hintText: 'e.g., MAT-001',
                prefixIcon: Icon(Icons.qr_code_2),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter material code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Item Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name *',
                hintText: 'Enter item name',
                prefixIcon: Icon(Icons.inventory_2),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Item description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Specification
            TextFormField(
              controller: _specificationController,
              decoration: const InputDecoration(
                labelText: 'Specification',
                hintText: 'Technical specifications',
                prefixIcon: Icon(Icons.info_outline),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Location
            LocationSelector(
              selectedLocationId: _selectedLocationId,
              onLocationChanged: (locationId) {
                setState(() {
                  _selectedLocationId = locationId;
                });
              },
              label: 'Location *',
            ),
            const SizedBox(height: 16),

            // Unit of Measure
            TextFormField(
              controller: _unitOfMeasureController,
              decoration: const InputDecoration(
                labelText: 'Unit of Measure',
                hintText: 'pcs, kg, m, etc.',
                prefixIcon: Icon(Icons.straighten),
              ),
            ),
            const SizedBox(height: 16),

            // Quantity
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity *',
                hintText: '1',
                prefixIcon: Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity < 1) {
                  return 'Please enter a valid quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Barcode
            TextFormField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                labelText: 'Barcode',
                hintText: 'Optional',
                prefixIcon: Icon(Icons.qr_code),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // NFC ID
            TextFormField(
              controller: _nfcIdController,
              decoration: const InputDecoration(
                labelText: 'NFC ID',
                hintText: 'Optional',
                prefixIcon: Icon(Icons.nfc),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'e.g., Electronics, Furniture',
                prefixIcon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 16),

            // Supplier
            TextFormField(
              controller: _supplierController,
              decoration: const InputDecoration(
                labelText: 'Supplier',
                hintText: 'Optional',
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 16),

            // Office Stock Toggle
            Card(
              child: SwitchListTile(
                title: const Text('Office Stock'),
                subtitle: const Text('Mark as office stock item'),
                value: _isOfficeStock,
                onChanged: (value) {
                  setState(() {
                    _isOfficeStock = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Additional information',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

