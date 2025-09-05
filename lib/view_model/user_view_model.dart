import 'package:bty5/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../repo/user_repo.dart';

// State class
class UserState {
  final List<User> users;
  final bool isLoading;
  final String? error;

  UserState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// ViewModel
class UserViewModel extends StateNotifier<UserState> {
  final UserRepository userRepository;

  UserViewModel(this.userRepository) : super(UserState());

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await userRepository.getUsers();
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final userViewModelProvider =
    StateNotifierProvider<UserViewModel, UserState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserViewModel(userRepository);
});
