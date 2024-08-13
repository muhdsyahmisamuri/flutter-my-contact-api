import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_contact/Feature/HomeScreen/model/view_model_api_profile.dart';
import 'package:my_contact/Screen/Widget/Style/model_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;
  String searchText = '';
  final List<String> tab = ['All', 'Favourite'];
  List<ViewModelApiProfile> items = [];
  Set<int> starredItems = <int>{};
  List<ViewModelApiProfile> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchContact();
  }

  Future<List<ViewModelApiProfile>> fetchContact() async {
    const url = 'https://reqres.in/api/users?page=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> users = data['data'];

      setState(() {
        items =
            users.map((user) => ViewModelApiProfile.fromJson(user)).toList();
        filteredItems = items;
      });

      return items;
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  void navigateToSendEmail(BuildContext context, ViewModelApiProfile profile,
      bool isFavorite) async {
    final updatedData = await context.push<ViewModelApiProfile>(
      '/send_email',
      extra: {
        'profile': profile,
        'favorite': isFavorite,
      },
    );

    // if (updatedData != null) {
    //   final int itemId = updatedData['id'];
    //   final updatedItem = items.firstWhere(
    //     (item) => item.id == itemId,
    //     orElse: () => ViewModelApiProfile(
    //       id: 0, email: '', firstName: '', lastName: '', avatar: ''),
    //   );

    //   if (updatedItem.id != 0) {
    //     setState(() {
    //       updatedItem.firstName = updatedData['first_name'];
    //       updatedItem.lastName = updatedData['last_name'];
    //       updatedItem.email = updatedData['email'];
    //     });
    //   }
    // }
  }

  void updateContact() async {
    const url = 'https://reqres.in/api/users/4';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, String> body = {
      "name": "morpheus",
      "job": "zion resident",
    };

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
    } else {}
  }

  void deleteContact(int id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
      filteredItems.removeWhere((item) => item.id == id);
      starredItems.remove(id);
    });
  }

  void createNewUser() {
    final newUser = ViewModelApiProfile(
      id: DateTime.now().millisecondsSinceEpoch,
      firstName: 'syahmi',
      lastName: 'samuri',
      email: '',
      avatar: '',
    );
    setState(() {
      filteredItems.add(newUser);
    });
  }

  void filterContacts(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        filteredItems = items;
      } else {
        enteredKeyword = enteredKeyword.toLowerCase();
        filteredItems = items.where((item) {
          final fullName = '${item.firstName} ${item.lastName}'.toLowerCase();
          final email = item.email.toLowerCase();

          return fullName.contains(enteredKeyword) ||
              email.contains(enteredKeyword);
        }).toList();
      }

      if (filteredItems.isEmpty) {
        filteredItems = [
          ViewModelApiProfile(
              id: 0,
              email: '',
              firstName: 'No result',
              lastName: '',
              avatar: ''),
        ];
      }
    });
  }

  void navigateToEditProfile(
      BuildContext context, ViewModelApiProfile profile) async {
    final result = await context.push<ViewModelApiProfile>(
      '/edit_profile',
      extra: profile,
    );

    if (result != null) {
      final index = items.indexWhere((item) => item.id == result.id);
      if (index != -1) {
        items[index] = result;
        filteredItems = List.from(items);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createNewUser,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: ModelStyle.bgGreen,
        centerTitle: true,
        title: Text(
          "My Contacts",
          style: ModelStyle.defaultAppBarTextStyle,
        ),
        toolbarHeight: 80,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: IconButton(
              onPressed: fetchContact,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 19, right: 19),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  filterContacts(searchText);
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Contact',
                labelStyle: ModelStyle.defaultLabelStyle,
                border: ModelStyle.defaultborderStyle,
                contentPadding: const EdgeInsets.only(
                  top: 13,
                  left: 24,
                  bottom: 13,
                ),
                focusedBorder: ModelStyle.defaultFocusedBorderStyle,
                suffixIcon: Icon(
                  Icons.search,
                  size: 24,
                  color: ModelStyle.grey,
                ),
              ),
              style: ModelStyle.defaultTextStyle,
            ),
          ),
          customTabBar(),
          Expanded(
            child: current == 0
                ? ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      if (filteredItems[index].firstName == 'No result') {
                        return const ListTile(
                          title: Text('No result'),
                        );
                      } else {
                        final item = filteredItems[index];
                        final fullName = '${item.firstName} ${item.lastName}';
                        final avatarUrl = item.avatar;
                        final id = item.id;
                        final isFavorite = starredItems.contains(id);

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  navigateToEditProfile(context, item);
                                },
                                backgroundColor: ModelStyle.bgGreen,
                                foregroundColor: ModelStyle.fgYellow,
                                icon: Icons.edit,
                              ),
                              const Divider(
                                indent: 2,
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  deleteContact(id);
                                },
                                backgroundColor: ModelStyle.bgGreen,
                                foregroundColor: Colors.red,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: avatarUrl.isNotEmpty
                                  ? NetworkImage(avatarUrl)
                                  : null,
                              radius: 30,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              navigateToSendEmail(context, item, isFavorite);
                            },
                            title: Row(
                              children: [
                                Text(fullName),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isFavorite) {
                                        starredItems.remove(id);
                                      } else {
                                        starredItems.add(id);
                                      }
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.star : Icons.star_border,
                                    color: isFavorite ? Colors.yellow : null,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(item.email),
                          ),
                        );
                      }
                    },
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final id = item.id;
                      final isFavorite = starredItems.contains(id);

                      if (isFavorite) {
                        final fullName = '${item.firstName} ${item.lastName}';
                        final avatarUrl = item.avatar;

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {},
                                backgroundColor: ModelStyle.bgGreen,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                              ),
                              const Divider(color: Colors.black),
                              SlidableAction(
                                onPressed: (_) {},
                                backgroundColor: ModelStyle.bgGreen,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: avatarUrl.isNotEmpty
                                ? Image.network(avatarUrl)
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              navigateToSendEmail(context, item, isFavorite);
                            },
                            title: Row(
                              children: [
                                Text(fullName),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isFavorite) {
                                        starredItems.remove(id);
                                      } else {
                                        starredItems.add(id);
                                      }
                                    });
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.star : Icons.star_border,
                                    color: isFavorite ? Colors.yellow : null,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(item.email),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget customTabBar() {
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      height: 60,
      child: ListView.builder(
        itemCount: tab.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              width: 70,
              height: 26,
              decoration: BoxDecoration(
                color: current == index ? ModelStyle.bgGreen : Colors.white70,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  tab[index],
                  style: TextStyle(
                    color: current == index ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
