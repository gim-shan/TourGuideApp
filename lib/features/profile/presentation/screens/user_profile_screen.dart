import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hidmo_app/core/widgets/profile_avatar.dart';
import 'package:hidmo_app/core/widgets/custom_app_bar.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/user_profile_repository.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileRepository _repository = UserProfileRepository();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    try {
      final profile = await _repository.getCurrentUserProfile();
      setState(() {
        _profile = profile;
        if (profile != null) {
          _nameController.text = profile.name;
          _emailController.text = profile.email ?? '';
          _phoneController.text = profile.phone ?? '';
          _locationController.text = profile.location ?? '';
          _bioController.text = profile.bio ?? '';
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
      final updatedProfile = _profile!.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _locationController.text,
        bio: _bioController.text,
      );

      await _repository.updateUserProfile(updatedProfile);

      setState(() => _profile = updatedProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 238, 238),
      appBar: CustomAppBar(
        title: 'My Profile',
        showBackButton: true,
        isProfileScreen: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1b9c4d)),
              ),
            )
          : SingleChildScrollView(
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
                        ProfileAvatar(
                          userName: _profile?.name ?? 'User',
                          size: 80,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profile?.name ?? 'User',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1b3a20),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _profile?.location ?? 'No location added',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(
                                    0xff666666,
                                  ).withOpacity(0.8),
                                ),
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
                      color: Color(0xff1b3a20),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name Field
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 12),

                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),

                  // Phone Field
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),

                  // Location Field
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 12),

                  // Bio Field
                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1b9c4d),
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Favorites Section
                  const Text(
                    'Favorite Tours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1b3a20),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildFavoritesSection(),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/', (route) => false);
                        }
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
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
          prefixIcon: Icon(icon, color: const Color(0xff1b9c4d), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesSection() {
    if (_profile?.favoriteTours.isEmpty ?? true) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xff1b9c4d).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.favorite_border,
              size: 48,
              color: const Color(0xff1b9c4d).withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No favorite tours yet',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xff666666).withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add tours to your favorites by clicking the heart icon',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xff999999).withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_profile?.favoriteTours.length} tour${_profile!.favoriteTours.length > 1 ? 's' : ''} in your favorites',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff1b9c4d),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _profile!.favoriteTours.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, thickness: 1),
            itemBuilder: (context, index) {
              final tourId = _profile!.favoriteTours[index];
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: const Color(0xff1b9c4d),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tourId,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
