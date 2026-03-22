import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuideTourPackagesScreen extends StatefulWidget {
  const GuideTourPackagesScreen({super.key});

  @override
  State<GuideTourPackagesScreen> createState() =>
      _GuideTourPackagesScreenState();
}

class _GuideTourPackagesScreenState extends State<GuideTourPackagesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snapshot = await _firestore
          .collection('guide_packages')
          .where('guideId', isEqualTo: user.uid)
          .get();

      List<Map<String, dynamic>> packages = [];
      for (var doc in snapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        packages.add(data);
      }

      setState(() {
        _packages = packages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showAddPackageDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          _AddPackageBottomSheet(onPackageAdded: _loadPackages),
    );
  }

  void _editPackage(Map<String, dynamic> package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddPackageBottomSheet(
        package: package,
        onPackageAdded: _loadPackages,
      ),
    );
  }

  void _deletePackage(String packageId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Package'),
        content: const Text('Are you sure you want to delete this package?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firestore.collection('guide_packages').doc(packageId).delete();
        _loadPackages();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Package deleted')));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting package: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPackageDialog,
        backgroundColor: const Color(0xFF1E4D3C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Package', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _packages.isEmpty
          ? _buildEmptyState()
          : _buildPackagesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tour, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text(
              'No Tour Packages Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E4D3C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add your first tour package to start\noffering tours to tourists.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _showAddPackageDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E4D3C),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Package',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _packages.length,
      itemBuilder: (context, index) {
        final package = _packages[index];
        return _PackageCard(
          package: package,
          onEdit: () => _editPackage(package),
          onDelete: () => _deletePackage(package['id']),
        );
      },
    );
  }
}

class _PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PackageCard({
    required this.package,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder or actual image
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: package['imageUrl'] != null && package['imageUrl'].isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      package['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    ),
                  )
                : _buildPlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        package['title'] ?? 'Tour Package',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4D3C),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: package['isActive'] == true
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        package['isActive'] == true ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: package['isActive'] == true
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF1E4D3C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      package['duration'] ?? 'Duration not set',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Color(0xFF1E4D3C),
                    ),
                    Text(
                      package['price'] ?? 'Price not set',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (package['description'] != null &&
                    package['description'].isNotEmpty)
                  Text(
                    package['description'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1E4D3C),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(Icons.landscape, size: 50, color: Colors.grey[400]),
    );
  }
}

class _AddPackageBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? package;
  final VoidCallback onPackageAdded;

  const _AddPackageBottomSheet({this.package, required this.onPackageAdded});

  @override
  State<_AddPackageBottomSheet> createState() => _AddPackageBottomSheetState();
}

class _AddPackageBottomSheetState extends State<_AddPackageBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxParticipantsController = TextEditingController();

  bool _isActive = true;
  bool _isSaving = false;

  final List<String> _tourTypes = [
    'Historical Tours',
    'Nature & Wildlife',
    'Beach & Water Sports',
    'Adventure Sports',
    'Cultural Tours',
    'Food & Culinary',
    'Photography Tours',
    'Religious Pilgrimages',
    'City Tours',
    'Eco Tourism',
  ];

  List<String> _selectedTourTypes = [];

  @override
  void initState() {
    super.initState();
    if (widget.package != null) {
      _titleController.text = widget.package!['title'] ?? '';
      _descriptionController.text = widget.package!['description'] ?? '';
      _durationController.text = widget.package!['duration'] ?? '';
      _priceController.text = widget.package!['price'] ?? '';
      _imageUrlController.text = widget.package!['imageUrl'] ?? '';
      _locationController.text = widget.package!['location'] ?? '';
      _maxParticipantsController.text =
          widget.package!['maxParticipants']?.toString() ?? '';
      _isActive = widget.package!['isActive'] ?? true;
      _selectedTourTypes = List<String>.from(
        widget.package!['tourTypes'] ?? [],
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _locationController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  Future<void> _savePackage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not logged in');

      final packageData = {
        'guideId': user.uid,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'duration': _durationController.text,
        'price': _priceController.text,
        'imageUrl': _imageUrlController.text,
        'location': _locationController.text,
        'maxParticipants': int.tryParse(_maxParticipantsController.text) ?? 1,
        'tourTypes': _selectedTourTypes,
        'isActive': _isActive,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };

      final firestore = FirebaseFirestore.instance;

      if (widget.package != null) {
        // Update existing package
        await firestore
            .collection('guide_packages')
            .doc(widget.package!['id'])
            .update(packageData);
      } else {
        // Create new package
        packageData['createdAt'] = DateTime.now().millisecondsSinceEpoch;
        await firestore.collection('guide_packages').add(packageData);
      }

      widget.onPackageAdded();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.package != null ? 'Package updated!' : 'Package added!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving package: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title
                Text(
                  widget.package != null ? 'Edit Package' : 'Add New Package',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E4D3C),
                  ),
                ),
                const SizedBox(height: 24),

                // Title Field
                _buildTextField(
                  controller: _titleController,
                  label: 'Package Title',
                  icon: Icons.tour,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Field
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Duration and Price Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _durationController,
                        label: 'Duration',
                        icon: Icons.access_time,
                        hint: 'e.g., 3 Days / 2 Nights',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _priceController,
                        label: 'Price',
                        icon: Icons.attach_money,
                        hint: 'e.g., \$500',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location and Max Participants Row
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _locationController,
                        label: 'Location',
                        icon: Icons.location_on,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _maxParticipantsController,
                        label: 'Max Participants',
                        icon: Icons.group,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Image URL Field
                _buildTextField(
                  controller: _imageUrlController,
                  label: 'Image URL (optional)',
                  icon: Icons.image,
                  hint: 'https://example.com/image.jpg',
                ),
                const SizedBox(height: 24),

                // Tour Types
                const Text(
                  'Tour Types',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E4D3C),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tourTypes.map((type) {
                    final isSelected = _selectedTourTypes.contains(type);
                    return FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTourTypes.add(type);
                          } else {
                            _selectedTourTypes.remove(type);
                          }
                        });
                      },
                      selectedColor: const Color(0xFF1E4D3C).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF1E4D3C),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Active Switch
                SwitchListTile(
                  title: const Text('Active'),
                  subtitle: const Text('Package will be visible to tourists'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() => _isActive = value);
                  },
                  activeColor: const Color(0xFF1E4D3C),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E4D3C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isSaving ? null : _savePackage,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            widget.package != null
                                ? 'Update Package'
                                : 'Add Package',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xff666666)),
        prefixIcon: Icon(icon, color: const Color(0xFF1E4D3C)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E4D3C)),
        ),
      ),
    );
  }
}
