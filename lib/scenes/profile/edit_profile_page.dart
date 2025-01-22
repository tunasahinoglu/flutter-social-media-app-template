import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';
import 'package:project_template/core/user/user_model.dart';
import 'package:project_template/core/user/user_repository.dart';
import 'package:image/image.dart' as img;
import 'package:project_template/scenes/auth/widgets/common_text_field.dart';

class EditProfilePage extends StatefulWidget {
  final UserRepository userRepository;

  EditProfilePage({required this.userRepository});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _bioController;
  late final AppUser _currentUser;
  File? _newProfileImage;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.userRepository.currentUser;
    _bioController = TextEditingController(text: _currentUser.bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });
    }
  }

  Future<Uint8List> compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) throw Exception('Failed to decode image');

    final compressedImage =
        img.copyResize(image, width: 500); 
    return Uint8List.fromList(img.encodeJpg(compressedImage, quality: 70));
  }

  Future<void> _saveChanges() async {
    String profileImageUrl = _currentUser.profileImageUrl;

    if (_newProfileImage != null) {
      try {
        // Delete the old profile image if it exists
        if (profileImageUrl.isNotEmpty) {
          final oldImageRef =
              FirebaseStorage.instance.refFromURL(profileImageUrl);
          await oldImageRef.delete();
        }

        // Compress the new image
        Uint8List compressedImageData = await compressImage(_newProfileImage!);

        // Define the new image path in Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('${_currentUser.userId}/profile_image/profile_image.jpg');

        // Upload the compressed image
        await storageRef.putData(compressedImageData);
        profileImageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
        );
        return;
      }
    }

    // Update the user information in Firestore
    final updatedUser = _currentUser.copyWith(
      bio: _bioController.text,
      profileImageUrl: profileImageUrl,
    );

    await widget.userRepository.updateUser(updatedUser);

    // Navigate back to the profile page with the updated username
    context.go('/nav');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile.edit_profile'), style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(tr('profile.save'), style: AppTextStyles.body),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _newProfileImage != null
                      ? FileImage(_newProfileImage!)
                      : (_currentUser.profileImageUrl.isNotEmpty
                          ? NetworkImage(_currentUser.profileImageUrl)
                          : null) as ImageProvider?,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            CommonTextFieldWidget(labelText: tr("profile.bio"), controller: _bioController, isSuffixIcon: false, keyboard: TextInputType.text)
          ],
        ),
      ),
    );
  }
}
