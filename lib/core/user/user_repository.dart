import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:project_template/core/user/user_model.dart';

class UserRepository {
  static final UserRepository _userRepository = UserRepository._internal();

  factory UserRepository() {
    return _userRepository;
  }

  UserRepository._internal();

  late AppUser currentUser;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addUserLocal(AppUser user) async {
    var userBox = await Hive.openBox('userBox');
    await userBox.put('userId', user.userId);
    await userBox.put('username', user.username);
    await userBox.put('email', user.email);
    await userBox.put('profileImageUrl', user.profileImageUrl);
    await userBox.put('bio', user.bio);
    await userBox.put('createdAt', user.createdAt.toIso8601String());

    currentUser = user;
  }

  Future<bool> isUserExistLocal() async {
    var userBox = await Hive.openBox('userBox');
    if (userBox.containsKey('userId') &&
        userBox.containsKey('username') &&
        userBox.containsKey('email') &&
        userBox.containsKey('profileImageUrl') &&
        userBox.containsKey('bio') &&
        userBox.containsKey('createdAt')) {
      currentUser = AppUser(
        userId: userBox.get('userId'),
        username: userBox.get('username'),
        email: userBox.get('email'),
        profileImageUrl: userBox.get('profileImageUrl'),
        bio: userBox.get('bio'),
        createdAt: DateTime.parse(userBox.get('createdAt')),
      );
      return true;
    } else {
      return false;
    }
  }

  Future<void> removeUserLocal() async {
    var userBox = await Hive.openBox('userBox');
    await userBox.clear();
  }

  Future<bool> isUsernameTaken(String username) async {
    final usernameDoc = await _userCollection.doc(username).get();
    return usernameDoc.exists;
  }

  Future<bool> isEmailTaken(String email) async {
    final emailQuery =
        await _userCollection.where('email', isEqualTo: email).get();
    return emailQuery.docs.isNotEmpty;
  }

  Future<void> addUserRemote(AppUser user) async {
    await _userCollection.doc(user.username).set(user.toMap());
    currentUser = user;
  }

  Future<bool> isUserExistRemote(String username, String email) async {
    final usernameDoc = await _userCollection.doc(username).get();

    // Check if username exists
    if (usernameDoc.exists) {
      AppUser user = AppUser.fromMap(
          usernameDoc.data() as Map<String, dynamic>, usernameDoc.id);

      // Check if email matches
      if (user.email == email) {
        currentUser = user;
        return true;
      } else {
        throw Exception('Username already exists');
      }
    }

    // Check if email exists
    final emailQuery =
        await _userCollection.where('email', isEqualTo: email).get();
    if (emailQuery.docs.isNotEmpty) {
      throw Exception('Email already exists');
    }

    return false;
  }

  Future<AppUser> getUserRemote(String username, String email) async {
    final usernameDoc = await _userCollection.doc(username).get();
    if (usernameDoc.exists) {
      AppUser user = AppUser.fromMap(
          usernameDoc.data() as Map<String, dynamic>, usernameDoc.id);

      if (user.email == email) {
        return user;
      } else {
        throw Exception('Email does not match the username.');
      }
    } else {
      throw Exception('User not found.');
    }
  }

  Future<String?> getEmailByUsername(String username) async {
    try {
      final usernameDoc = await _userCollection.doc(username).get();
      if (usernameDoc.exists) {
        var userData = usernameDoc.data() as Map<String, dynamic>;
        return userData['email'] as String?;
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      print('Error fetching email: $e');
      return null;
    }
  }

  Future<List<AppUser>> getAllUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      return snapshot.docs.map((doc) {
        return AppUser.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load users: ${e.toString()}');
    }
  }

  Future<AppUser> getUserByUsername(String username) async {
    final doc = await FirebaseFirestore.instance.collection('Users').doc(username).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!, doc.id);
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> updateUser(AppUser user) async {
    await _userCollection.doc(user.username).update(user.toMap());
    var userBox = await Hive.openBox('userBox');
    await userBox.put('username', user.username);
    await userBox.put('profileImageUrl', user.profileImageUrl);
    await userBox.put('bio', user.bio);
    currentUser = user;
  }
}
