import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthService {
  User? getCurrentUser();
  String getUsername(User? user);
  String getEmail(User? user);
  String getCreationDate(User? user);
  Future<void> signOut();
}

// Supabase に依存した UserService の実装
class SupabaseUserService implements AuthService {
  final SupabaseClient client;

  SupabaseUserService(this.client);

  @override
  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  @override
  String getUsername(User? user) {
    return user?.userMetadata?['username'] ?? '不明';
  }

  @override
  String getEmail(User? user) {
    return user?.email ?? '不明';
  }

  @override
  String getCreationDate(User? user) {
    final createdAt =
        user?.createdAt != null ? DateTime.parse(user!.createdAt) : null;
    return createdAt?.toIso8601String() ?? '不明';
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
  }
}
