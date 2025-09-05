import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/user_view_model.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users MVVM with Riverpod'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(userViewModelProvider.notifier).fetchUsers(),
          ),
        ],
      ),
      body: _buildBody(userState, ref),
    );
  }

  Widget _buildBody(UserState state, WidgetRef ref) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            ElevatedButton(
              onPressed: () =>
                  ref.read(userViewModelProvider.notifier).clearError(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: state.users.length,
      itemBuilder: (context, index) {
        final user = state.users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          leading: CircleAvatar(
            child: Text(user.name[0]),
          ),
        );
      },
    );
  }
}

// Alternative using AsyncNotifier approach
// class UserListScreen extends ConsumerWidget {
//   const UserListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final usersAsync = ref.watch(userViewModelProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Users with Async Notifier'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => ref.read(userViewModelProvider.notifier),
//           ),
//         ],
//       ),
//       body: usersAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Error: $error'),
//               ElevatedButton(
//                 onPressed: () => ref.invalidate(userViewModelProvider),
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//         data: (users) => ListView.builder(
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//             return ListTile(
//               title: Text(user.name),
//               subtitle: Text(user.email),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
