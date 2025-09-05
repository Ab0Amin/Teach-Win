import 'package:flutter_riverpod/flutter_riverpod.dart';

import './repo/user_repo.dart';

// Repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});
