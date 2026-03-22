import 'package:flutter/material.dart';
import 'package:hidmo_app/core/widgets/profile_avatar.dart';
import 'package:hidmo_app/features/auth/presentation/screens/choose_role_screen.dart';
import '../../data/models/guide_profile.dart';
import '../../data/services/guide_profile_service.dart';

class GuideProfileScreen extends StatefulWidget {
  final String? guideId; // If provided, view another guide's profile
  final Map<String, Object>? info; // Legacy support for old Map data

  const GuideProfileScreen({super.key, this.guideId, this.info});

  @override
  State<GuideProfileScreen> createState() => _GuideProfileScreenState();
}

class _GuideProfileScreenState extends State<GuideProfileScreen> {
  final GuideProfileService _service = GuideProfileService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  late TextEditingController _experienceController;
  late TextEditingController _certificationController;

  GuideProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isViewMode = false; // True when viewing another guide's profile

  final List<String> _availableLanguages = [
    'English',
    'Sinhala',
    'Tamil',
    'German',
    'French',
    'Spanish',
    'Italian',
    'Japanese',
    'Chinese',
    'Korean',
    'Russian',
    'Arabic',
  ];

  final List<String> _availableSpecializations = [
    'Historical Tours',
    'Nature & Wildlife',
    'Beach & Water Sports',
    'Adventure Sports',
    'Cultural Tours',
    'Food & Culinary',
    'Photography',
    'Religious Pilgrimages',
    'Wine Tours',
    'Eco Tourism',
    'City Tours',
    'Night Tours',
  ];

  List<String> _selectedLanguages = [];
  List<String> _selectedSpecializations = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    _experienceController = TextEditingController();
    _certificationController = TextEditingController();

    // Check if we're viewing another guide's profile or editing own profile
    if (widget.guideId != null) {
      _isViewMode = true;
      _loadGuideProfileById(widget.guideId!);
    } else {
      _isViewMode = false;
      _loadGuideProfile();
    }
  }

  void _loadGuideProfileById(String guideId) async {
    try {
      final profile = await _service.getGuideProfileById(guideId);
      setState(() {
        _profile = profile;
        if (profile != null) {
          _nameController.text = profile.name;
          _emailController.text = profile.email ?? '';
          _phoneController.text = profile.phone ?? '';
          _locationController.text = profile.location ?? '';
          _bioController.text = profile.bio ?? '';
          _experienceController.text = profile.yearsOfExperience.toString();
          _certificationController.text = profile.certification ?? '';
          _selectedLanguages = List<String>.from(profile.languages);
          _selectedSpecializations = List<String>.from(profile.specializations);
        }
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      setState(() => _isLoading = false);
    }
  }

  void _loadGuideProfile() async {
    try {
      final profile = await _service.getCurrentGuideProfile();
      setState(() {
        _profile = profile;
        if (profile != null) {
          _nameController.text = profile.name;
          _emailController.text = profile.email ?? '';
          _phoneController.text = profile.phone ?? '';
          _locationController.text = profile.location ?? '';
          _bioController.text = profile.bio ?? '';
          _experienceController.text = profile.yearsOfExperience.toString();
          _certificationController.text = profile.certification ?? '';
          _selectedLanguages = List<String>.from(profile.languages);
          _selectedSpecializations = List<String>.from(profile.specializations);
        }
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      setState(() => _isLoading = false);
    }
  }

  void _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      final experience = int.tryParse(_experienceController.text) ?? 0;

      final updatedProfile = _profile!.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _locationController.text,
        bio: _bioController.text,
        yearsOfExperience: experience,
        certification: _certificationController.text,
        languages: _selectedLanguages,
        specializations: _selectedSpecializations,
      );

      await _service.updateGuideProfile(updatedProfile);

      setState(() => _profile = updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _certificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 238, 238),
      appBar: _isViewMode
          ? AppBar(
              title: Text(_profile?.name ?? 'Guide Profile'),
              backgroundColor: const Color(0xFF1E4D3C),
              foregroundColor: Colors.white,
            )
          : null,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E4D3C)),
              ),
            )
          : _isViewMode
          ? _buildViewMode()
          : _buildEditMode(),
    );
  }

  Widget _buildViewMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ProfileAvatar(userName: _profile?.name ?? 'Guide', size: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profile?.name ?? 'Guide',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4D3C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            _profile != null && _profile!.rating > 0
                                ? _profile!.rating.toStringAsFixed(1)
                                : 'New',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${_profile?.totalTours ?? 0} tours)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Personal Details Section (View Mode)
          _buildInfoCard(
            title: 'Personal Details',
            icon: Icons.person,
            children: [
              _buildInfoRow(Icons.badge, 'Name', _profile?.name ?? 'N/A'),
              _buildInfoRow(Icons.email, 'Email', _profile?.email ?? 'N/A'),
              _buildInfoRow(Icons.phone, 'Phone', _profile?.phone ?? 'N/A'),
              _buildInfoRow(
                Icons.location_on,
                'Location',
                _profile?.location ?? 'N/A',
              ),
              _buildInfoRow(Icons.description, 'Bio', _profile?.bio ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 16),

          // Experience Section (View Mode)
          _buildInfoCard(
            title: 'Experience & Qualifications',
            icon: Icons.work_history,
            children: [
              _buildInfoRow(
                Icons.timer,
                'Years of Experience',
                _profile?.yearsOfExperience.toString() ?? '0',
              ),
              _buildInfoRow(
                Icons.verified,
                'Certifications',
                _profile?.certification ?? 'N/A',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Languages Section (View Mode)
          if (_selectedLanguages.isNotEmpty)
            _buildInfoCard(
              title: 'Languages Spoken',
              icon: Icons.language,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedLanguages.map((lang) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E4D3C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        lang,
                        style: const TextStyle(
                          color: Color(0xFF1E4D3C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Specializations Section (View Mode)
          if (_selectedSpecializations.isNotEmpty)
            _buildInfoCard(
              title: 'Specializations',
              icon: Icons.category,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedSpecializations.map((spec) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E4D3C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        spec,
                        style: const TextStyle(
                          color: Color(0xFF1E4D3C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1E4D3C), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E4D3C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value.isNotEmpty ? value : 'N/A',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ProfileAvatar(userName: _profile?.name ?? 'Guide', size: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profile?.name ?? 'Guide',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E4D3C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            _profile != null && _profile!.rating > 0
                                ? _profile!.rating.toStringAsFixed(1)
                                : 'New',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${_profile?.totalTours ?? 0} tours)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Personal Details Section
          const Text(
            'Personal Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4D3C),
            ),
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _locationController,
            label: 'Location',
            icon: Icons.location_on,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _bioController,
            label: 'About Me / Bio',
            icon: Icons.description,
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          // Experience Section
          const Text(
            'Experience & Qualifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4D3C),
            ),
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _experienceController,
            label: 'Years of Experience',
            icon: Icons.work_history,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _certificationController,
            label: 'Certifications',
            icon: Icons.verified,
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Languages Section
          const Text(
            'Languages Spoken',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4D3C),
            ),
          ),
          const SizedBox(height: 12),

          _buildMultiSelectChips(
            options: _availableLanguages,
            selectedOptions: _selectedLanguages,
            onChanged: (selected) {
              setState(() {
                _selectedLanguages = selected;
              });
            },
          ),
          const SizedBox(height: 24),

          // Specializations Section
          const Text(
            'Specializations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E4D3C),
            ),
          ),
          const SizedBox(height: 12),

          _buildMultiSelectChips(
            options: _availableSpecializations,
            selectedOptions: _selectedSpecializations,
            onChanged: (selected) {
              setState(() {
                _selectedSpecializations = selected;
              });
            },
          ),
          const SizedBox(height: 32),

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
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Save Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFF1E4D3C), width: 2),
              ),
              onPressed: _logout,
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E4D3C),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xff666666), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF1E4D3C), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectChips({
    required List<String> options,
    required List<String> selectedOptions,
    required Function(List<String>) onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = List<String>.from(selectedOptions);
            if (selected) {
              newSelection.add(option);
            } else {
              newSelection.remove(option);
            }
            onChanged(newSelection);
          },
          selectedColor: const Color(0xFF1E4D3C).withOpacity(0.2),
          checkmarkColor: const Color(0xFF1E4D3C),
          labelStyle: TextStyle(
            color: isSelected ? const Color(0xFF1E4D3C) : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
