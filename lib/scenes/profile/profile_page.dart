import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';
import 'package:project_template/core/user/user_model.dart';
import 'package:project_template/core/user/user_repository.dart';

class ProfilePage extends StatefulWidget {
  final UserRepository userRepository;
  final String username;

  const ProfilePage({
    Key? key,
    required this.userRepository,
    required this.username,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser? user;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final fetchedUser = await widget.userRepository.getUserByUsername(widget.username);
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'User not found';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = widget.userRepository.currentUser.username == widget.username;

    return Scaffold(
      appBar: AppBar(
       
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.go('/edit_profile');
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: user!.profileImageUrl.isNotEmpty
                              ? NetworkImage(user!.profileImageUrl)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                          child: Text(
                        widget.username,
                        style: AppTextStyles.headline,
                      )),
                      const SizedBox(height: 8),
                      Text('Username: ${user!.username}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Email: ${user!.email}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Bio: ${user!.bio}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                          'Joined on: ${user!.createdAt.toLocal()}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
    );
  }
}