import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_contact/Feature/HomeScreen/model/view_model_api_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_contact/Core/Http/service_url.dart';

final contactListProvider =
    StateNotifierProvider<ContactListNotifier, List<ViewModelApiProfile>>(
        (ref) {
  return ContactListNotifier();
});

final fetchContactsProvider = FutureProvider<void>((ref) async {
  await ref.read(contactListProvider.notifier).fetchContact();
});

final starredItemsProvider =
    StateNotifierProvider<StarredItemsNotifier, Set<int>>((ref) {
  return StarredItemsNotifier();
});

final currentTabProvider = StateProvider<int>((ref) => 0);

final searchTextProvider = StateProvider<String>((ref) => '');

class ContactListNotifier extends StateNotifier<List<ViewModelApiProfile>> {
  ContactListNotifier() : super([]);

  bool localUrl = false;

  Future<void> fetchContact() async {
    var url = localUrl ? ServiceUrl.laravelUrl : ServiceUrl.profileUrl;
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> users = data['data'];
      state = users.map((user) => ViewModelApiProfile.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  void deleteContact(int id) {
    state = state.where((item) => item.id != id).toList();
  }

  void createNewUser() {
    final newUser = ViewModelApiProfile(
      id: DateTime.now().millisecondsSinceEpoch,
      firstName: 'syahmi',
      lastName: 'samuri',
      email: '',
      avatar: '',
    );
    state = [...state, newUser];
  }

  void updateContact(ViewModelApiProfile updatedProfile) {
    state = state.map((item) {
      return item.id == updatedProfile.id ? updatedProfile : item;
    }).toList();
  }
}

class StarredItemsNotifier extends StateNotifier<Set<int>> {
  StarredItemsNotifier() : super({});

  void toggleStarred(int id) {
    if (state.contains(id)) {
      state = Set.from(state)..remove(id);
    } else {
      state = Set.from(state)..add(id);
    }
  }
}
