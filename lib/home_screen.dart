import 'edit_profile.dart';
import 'send_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;
  String searchText = '';
  final List<String> tab = ['All', 'Favourite'];
  List<Map<String, dynamic>> items = [];
  Set<int> starredItems = Set<int>(); // Added set to track starred items
  List<Map<String, dynamic>> filteredItems =
      []; // Added set to track starred items

  @override
  void initState() {
    super.initState();
    fetchContact();
  }

  Future<void> fetchContact() async {
    final url = 'https://reqres.in/api/users?page=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['data'] as List<dynamic>;
      setState(() {
        items = result.cast<Map<String, dynamic>>();
      });
    } else {
      // Handle error if needed
    }
  }

  void navigateToSendEmail(
      BuildContext context, Map item, bool isFavorite) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendEmailUI(profile: item, favorite: isFavorite),
      ),
    );

    if (updatedData != null) {
      final int itemId = updatedData['id'];
      final updatedItem = items.firstWhere(
        (item) => item['id'] == itemId,
        orElse: () =>
            <String, dynamic>{}, // Returns an empty Map if the item isn't found
      );

      if (updatedItem.isNotEmpty) {
        setState(() {
          updatedItem['first_name'] = updatedData['first_name'];
          updatedItem['last_name'] = updatedData['last_name'];
          updatedItem['email'] = updatedData['email'];
          // Update other fields if needed
        });
      }
    }
  }

  void updateContact() async {
    final url = 'https://reqres.in/api/users/4';
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
      print(json); // Print the response
    } else {
      // Handle error if needed
    }
  }

  void deleteContact(int id) {
    setState(() {
      items.removeWhere((item) => item['id'] == id);
      filteredItems.removeWhere((item) => item['id'] == id);
      starredItems.remove(id);
    });
  }

  void filterContacts(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, display all users
        filteredItems = items;
      } else {
        enteredKeyword = enteredKeyword.toLowerCase();
        filteredItems = items.where((item) {
          final fullName =
              '${item['first_name']} ${item['last_name']}'.toLowerCase();
          final email = '${item['email']}'.toLowerCase();

          return (fullName.contains(enteredKeyword) ||
              email.contains(enteredKeyword));
        }).toList();
      }

      if (filteredItems.isEmpty) {
        filteredItems = [
          {'result': 'No result'}
        ];
      }
    });
  }

  void navigateToEditProfile(BuildContext context, Map item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileUI(profile: item),
      ),
    );

    // Handle the changes received from the EditProfileUI
    if (result != null) {
      // Assuming the result is a Map with updated profile information
      // Update the item in the items list or do necessary operations
      setState(() {
        item['first_name'] = result['first_name'];
        item['last_name'] = result['last_name'];
        item['email'] = result['email'];
        //item['avatar'] = result['avatar'];
        // Update other fields as needed
      });
    }

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateContact();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "My Contacts",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              fetchContact(); // Fetch contacts on refresh
            },
            icon: Icon(
              Icons.refresh,
              size: 25,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 19, right: 19),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  filterContacts(searchText);
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Contact',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 180, 184, 184),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.only(
                  top: 13,
                  left: 24,
                  bottom: 13,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 201, 204, 204),
                    width: 2,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  size: 24,
                  color: Color.fromARGB(255, 201, 204, 204),
                ),
              ),
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          customTabBar(),
          Expanded(
            child: current == 0 // Show All tab content
                ? ListView.builder(
                    itemCount: filteredItems.isEmpty
                        ? items.length
                        : filteredItems.length,
                    itemBuilder: (context, index) {
                      if (filteredItems.isNotEmpty &&
                          filteredItems[index]['result'] == 'No result') {
                        return ListTile(
                          title: Text('No result'),
                        );
                      } else {
                        final item = filteredItems.isEmpty
                            ? items[index]
                            : filteredItems[index];
                        final fullName =
                            '${item['first_name']} ${item['last_name']}';
                        final avatarUrl = item['avatar'];
                        final id = item['id'];
                        final isFavorite = starredItems.contains(id);

                        return Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  navigateToEditProfile(context, item);
                                },
                                backgroundColor: Color(0xFF32BAA5),
                                foregroundColor: Color(0xFFF2C94C),
                                icon: Icons.edit,
                              ),
                              Divider(
                                indent: 2,
                              ),
                              SlidableAction(
                                onPressed: (_) {
                                  final id = filteredItems.isEmpty
                                      ? items[index]['id']
                                      : filteredItems[index]['id'];
                                  deleteContact(id);
                                },
                                backgroundColor: Color(0xFF32BAA5),
                                foregroundColor: Colors.red,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(avatarUrl),radius: 30,
                            ),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              navigateToSendEmail(context, item, isFavorite);
                            },
                            title: Row(
                              children: [
                                Text(fullName),
                                SizedBox(
                                  width: 4,
                                ),
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
                            subtitle: Text(item['email']),
                          ),
                        );
                      }
                    },
                  )
                : current == 1 // Show Favorite tab content
                    ? ListView.builder(
                        itemCount: filteredItems.isEmpty
                            ? items.length
                            : filteredItems.length,
                        itemBuilder: (context, index) {
                          if (filteredItems.isNotEmpty &&
                              filteredItems[index]['result'] == 'No result') {
                            return ListTile(
                              title: Text('No result'),
                            );
                          } else {
                            final item = filteredItems.isEmpty
                                ? items[index]
                                : filteredItems[index];
                            final id = item['id'];
                            final isFavorite = starredItems.contains(id);

                            if (isFavorite) {
                              final fullName =
                                  '${item['first_name']} ${item['last_name']}';
                              final avatarUrl = item['avatar'];

                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {},
                                      backgroundColor: Color(0xFF32BAA5),
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                    ),
                                    Divider(color: Colors.black),
                                    SlidableAction(
                                      onPressed: (_) {},
                                      backgroundColor: Color(0xFF32BAA5),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Image.network(avatarUrl),
                                  trailing: Icon(Icons.chevron_right),
                                  title: Row(
                                    children: [
                                      Text(fullName),
                                      SizedBox(width: 4),
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
                                          isFavorite
                                              ? Icons.star
                                              : Icons.star_border,
                                          color:
                                              isFavorite ? Colors.yellow : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(item['email']),
                                ),
                              );
                            } else {
                              return Container(); // Return an empty container if not a favorite
                            }
                          }
                        },
                      )
                    : Container(), // Show an empty container if not the selected tab
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
        itemCount: 2,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  current = index; // Set the current tab index
                });
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: 70,
                height: 26,
                decoration: BoxDecoration(
                    color:
                        current == index ? Color(0xFF32BAA5) : Colors.white70,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(
                    tab[index],
                    style: TextStyle(
                      color: current == index ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
