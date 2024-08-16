import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_contact/Feature/HomeScreen/controller/home_screen_provider.dart';
import 'package:my_contact/Feature/HomeScreen/model/view_model_api_profile.dart';
import 'package:my_contact/Screen/Widget/Style/model_style.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactList = ref.watch(contactListProvider);
    final starredItems = ref.watch(starredItemsProvider);
    final currentTab = ref.watch(currentTabProvider);
    final searchText = ref.watch(searchTextProvider);

    ref.listen<AsyncValue<void>>(fetchContactsProvider, (previous, next) {
      next.when(
        data: (_) {},
        loading: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fetching contacts...')),
        ),
        error: (err, stack) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch contacts: $err')),
        ),
      );
    });

    final filteredItems = contactList.where((item) {
      final fullName = '${item.firstName} ${item.lastName}'.toLowerCase();
      final email = item.email.toLowerCase();

      return fullName.contains(searchText.toLowerCase()) ||
          email.contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(contactListProvider.notifier).createNewUser(),
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
              onPressed: () =>
                  ref.read(contactListProvider.notifier).fetchContact(),
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
                ref.read(searchTextProvider.notifier).state = value;
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
          customTabBar(ref),
          Expanded(
            child: currentTab == 0
                ? ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
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
                                ref
                                    .read(contactListProvider.notifier)
                                    .deleteContact(id);
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
                                  ref
                                      .read(starredItemsProvider.notifier)
                                      .toggleStarred(id);
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
                                    ref
                                        .read(starredItemsProvider.notifier)
                                        .toggleStarred(id);
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

  Widget customTabBar(WidgetRef ref) {
    List<String> tab = ['All', 'Favourite'];
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
              if (index == 0 &&
                  ref.read(currentTabProvider.notifier).state == 1) {
                ref.read(currentTabProvider.notifier).state--;
              }
              if (index == 1 &&
                  ref.read(currentTabProvider.notifier).state == 0) {
                ref.read(currentTabProvider.notifier).state++;
              }
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              width: 70,
              height: 26,
              decoration: BoxDecoration(
                  color: ref.read(currentTabProvider.notifier).state == index
                      ? ModelStyle.bgGreen
                      : Colors.white70,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 0.5, color: ModelStyle.bcDisable)),
              child: Center(
                child: Text(
                  tab[index],
                  style: TextStyle(
                    color: ref.read(currentTabProvider.notifier).state == index
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void navigateToEditProfile(
      BuildContext context, ViewModelApiProfile profile) {
    context.push('/edit_profile', extra: profile);
  }

  void navigateToSendEmail(
      BuildContext context, ViewModelApiProfile profile, bool isFavorite) {
    context.push('/send_email',
        extra: {'profile': profile, 'isFavorite': isFavorite});
  }
}
