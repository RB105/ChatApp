import 'package:chatapp/provider/remote/chat_provider.dart';
import 'package:chatapp/provider/total/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChatThemeProvider(),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Settings").tr(),
            ),
            body: Column(
              children: [
                ListTile(
                    leading: const CircleAvatar(
                        child: Icon(
                      Icons.bedtime_sharp,
                      size: 26,
                    )),
                    title: Text(
                      "Night Mode".tr(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: ElevatedButton(
                        onPressed: () {
                          context
                              .read<ChatThemeProvider>()
                              .changeTheme(context);
                        },
                        child: const Text("Change Theme").tr())),
                ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                            height: 500,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Divider(
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Cancel").tr()),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Set").tr())
                                  ],
                                ),
                              ],
                            ));
                      },
                    );
                  },
                  title:  Text(
                    "Text Size".tr(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.text_fields_sharp, size: 30),
                ),
                ListTile(
                  onTap: () async{
                     Provider.of<ChatProvider>(context, listen: false)
                            .changeLang();
                        await context.setLocale(Locale(
                            Provider.of<ChatProvider>(context, listen: false)
                                .langs[Provider.of<ChatProvider>(context,
                                    listen: false)
                                .currentIndex]));
                  },
                  title: const Text(
                    "Change Language",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ).tr(),
                  trailing:  const Icon(Icons.language),
                )
              ],
            ),
          );
        });
  }
}
