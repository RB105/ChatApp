import 'package:chatapp/core/widgets/loading_widget.dart';
import 'package:chatapp/data/local/image_picker_service.dart';
import 'package:chatapp/data/remote/firestorage_service.dart';
import 'package:chatapp/provider/remote/chat_provider.dart';
import 'package:chatapp/view/screens/drawer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  bool isVisible = false;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels !=
          scrollController.position.maxScrollExtent) {
        setState(() {
          isVisible = true;
        });
      } else if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isVisible = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    ChatProvider chatProviderRead = context.read<ChatProvider>();
    ChatProvider chatProviderWatch = context.watch<ChatProvider>();

    return ChangeNotifierProvider(
        create: (context) => ChatProvider(),
        builder: (context, child) {
          return Scaffold(
            drawer: const NavDrawer(),
            appBar: _appBar(),
            body: _streamBuild(chatProviderRead, mediaQuery),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton:
                _floatingButton(context, chatProviderWatch, chatProviderRead),
          );
        });
  }

  Container _floatingButton(BuildContext context,
      ChatProvider chatProviderWatch, ChatProvider chatProviderRead) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child: IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const ImageViewWidget();
                        },
                      );
                    },
                    icon: const Icon(Icons.camera_alt))),
            Expanded(
                flex: 10,
                child: TextFormField(
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  controller: chatProviderWatch.messageController,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      hintText: "Write a message".tr(),
                      border: InputBorder.none),
                )),
            Expanded(
                flex: 2,
                child: chatProviderWatch.messageController.text.isEmpty
                    ? IconButton(onPressed: () {}, icon: const Icon(Icons.mic))
                    : IconButton(
                        onPressed: () {
                          chatProviderRead.arrowDown(
                              scrollController: scrollController);
                          chatProviderRead.writemessage();
                          chatProviderRead.clearMessage(
                              controller: chatProviderWatch.messageController);
                        },
                        icon: const Icon(Icons.send_rounded),
                        color: Colors.blue,
                      ))
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> _streamBuild(
      ChatProvider chatProviderRead, Size mediaQuery) {
    return StreamBuilder(
      stream: chatProviderRead.chatStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: loadingWidget(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          List<Map<String, dynamic>> data = [];
          List<String> ides = [];
          snapshot.data!.docs.map((e) {
            ides.add(e.id);
            data.add(e.data() as Map<String, dynamic>);
          }).toList();
          if (data.isEmpty) {
            return  Center(child: const Text("No messages yet").tr());
          } else {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: mediaQuery.height * 0.08),
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Align(
                          alignment: data[index]['token'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: data[index]['token'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? !data[index]['message'].toString().contains(
                                      "https://firebasestorage.googleapis.com/")
                                  ? InkWell(
                                    onLongPress: (){
                                      showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      ListTile(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: TextFormField(
                                                    controller: context
                                                        .watch<ChatProvider>()
                                                        .editingController,
                                                    decoration: InputDecoration(
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey.shade400),
                                                        border: InputBorder.none),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(onPressed: (){
                                                      Navigator.pop(context);
                                                    }, child: const Text("Cancel").tr()),
                                                    ElevatedButton(onPressed: (){
                                                      chatProviderRead.editMessage(id: ides[index]);
                                                    }, child: const Text("Edit").tr())],
                                                );
                                              },
                                            );
                                          },
                                          leading: const Icon(Icons.edit),
                                          title: const Text("Edit").tr()),
                                      ListTile(
                                          onTap: () {
                                            chatProviderRead.deleteMessage(
                                                id: ides[index]);
                                                Navigator.pop(context);
                                          },
                                          leading: const Icon(Icons.delete),
                                          title: const Text("Delete").tr())
                                    ],
                                  ),
                                );
                              },
                            );
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomLeft:
                                                    Radius.circular(20))),
                                        child: Text(
                                          data[index]['message'].toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                  )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        ),
                                        child: SizedBox(
                                          width: mediaQuery.width * 0.5,
                                          child: Image.network(
                                              data[index]['message']),
                                        ),
                                      ),
                                    )
                              : !data[index]['message'].toString().contains(
                                      "https://firebasestorage.googleapis.com/")
                                  ? Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius:
                                              const BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                      child: Text(
                                        data[index]['message'].toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                        child: SizedBox(
                                          width: mediaQuery.width * 0.5,
                                          child: Image.network(
                                              data[index]['message']),
                                        ),
                                      ),
                                    ));
                    },
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: mediaQuery.height * 0.09,
                          right: mediaQuery.width * 0.01),
                      child: Visibility(
                        visible: isVisible,
                        child: FloatingActionButton.small(
                          onPressed: () {
                            chatProviderRead.arrowDown(
                                scrollController: scrollController);
                          },
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                    ))
              ],
            );
          }
        }
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Chat App"),
      actions: const [
        // for User profile picture
        CircleAvatar()
      ],
    );
  }
//   Scaffold _scaffold(BuildContext context, Size mediaQuery) {
//     return Scaffold(
//       drawer: const NavDrawer(),
//       appBar: AppBar(
//       title: const Text("Chat App"),
//       actions: const [
//         // for User profile picture
//         CircleAvatar()
//       ],
//     ),
//       body:StreamBuilder(
//       stream: context.read<ChatProvider>().chatStream,
//       builder: (BuildContext context,
//           AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: loadingWidget(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text(snapshot.error.toString()),
//           );
//         } else {
//           List<Map<String, dynamic>> data = [];
//           snapshot.data!.docs.map((e) {
//             data.add(e.data() as Map<String, dynamic>);
//           }).toList();
//           if (data.isEmpty) {
//             return const Center(child: Text("No messages yet"));
//           } else {
//             return Stack(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(bottom: mediaQuery.height * 0.08),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     controller: scrollController,
//                     itemCount: data.length,
//                     itemBuilder: (context, index) {
//                       return Align(
//                           alignment: data[index]['token'] ==
//                                   FirebaseAuth.instance.currentUser!.uid
//                               ? Alignment.centerRight
//                               : Alignment.centerLeft,
//                           child: data[index]['token'] ==
//                                   FirebaseAuth.instance.currentUser!.uid
//                               ? Container(
//                                   margin: const EdgeInsets.all(8),
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: const BoxDecoration(
//                                       color: Colors.blue,
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20),
//                                           bottomLeft: Radius.circular(20))),
//                                   child: Text(
//                                     data[index]['message'].toString(),
//                                     style: const TextStyle(
//                                         fontSize: 16, color: Colors.white),
//                                   ),
//                                 )
//                               : Container(
//                                   margin: const EdgeInsets.all(8),
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: const BoxDecoration(
//                                       color: Colors.blue,
//                                       borderRadius: BorderRadius.only(
//                                           topRight: Radius.circular(20),
//                                           bottomRight: Radius.circular(20))),
//                                   child: Text(
//                                     data[index]['message'].toString(),
//                                     style: const TextStyle(
//                                         fontSize: 16, color: Colors.white),
//                                   ),
//                                 ));
//                     },
//                   ),
//                 ),
//                 Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           bottom: mediaQuery.height * 0.09,
//                           right: mediaQuery.width * 0.01),
//                       child: Visibility(
//                         visible: isVisible,
//                         child: FloatingActionButton(
//                           onPressed: () {

//                           },
//                           child: const Icon(Icons.arrow_downward_rounded),
//                         ),
//                       ),
//                     ))
//               ],
//             );
//           }
//         }
//       },
//     ),

//  ///
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height * 0.08,
//         decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15), topRight: Radius.circular(15))),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                   flex: 1,
//                   child: IconButton(
//                       onPressed: () async {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: ImagePickerService.selectedImage == null
//                                   ? Column(
//                                       children: [
//                                         ElevatedButton(
//                                             onPressed: () async {
//                                               await ImagePickerService
//                                                   .selectImage(
//                                                       ImagePickerService
//                                                           .camera);
//                                               setState(() {});
//                                             },
//                                             child: const Text("Camera")),
//                                         ElevatedButton(
//                                             onPressed: () async {
//                                               await ImagePickerService
//                                                   .selectImage(
//                                                       ImagePickerService
//                                                           .gallery);
//                                               setState(() {});
//                                             },
//                                             child: const Text("Gallery"))
//                                       ],
//                                     )
//                                   : const SizedBox(),
//                               content: ImagePickerService.selectedImage != null
//                                   ? Image.file(
//                                       ImagePickerService.selectedImage!)
//                                   : const SizedBox(),
//                               actions: ImagePickerService.selectedImage != null
//                                   ? [
//                                       ElevatedButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: const Text("Cancel")),
//                                       ElevatedButton(
//                                           onPressed: () async {
//                                             FireStoreService.uploadFile(
//                                                 ImagePickerService
//                                                     .selectedImage!,
//                                                 "chat");
//                                           },
//                                           child: const Text("Send"))
//                                     ]
//                                   : null,
//                             );
//                           },
//                         );
//                       },
//                       icon: const Icon(Icons.camera_alt))),
//               Expanded(
//                   flex: 10,
//                   child: TextFormField(
//                     onChanged: (v) {
//                       setState(() {});
//                     },
//                     style: AdaptiveTheme.of(context).mode ==
//                             AdaptiveThemeMode.dark
//                         ? const TextStyle(color: Colors.white, fontSize: 20)
//                         : const TextStyle(color: Colors.black, fontSize: 20),
//                     controller: context.watch<ChatProvider>().messageController,
//                     decoration: InputDecoration(
//                         hintStyle: TextStyle(color: Colors.grey.shade400),
//                         hintText: "Write a message",
//                         border: InputBorder.none),
//                   )),
//               Expanded(
//                   flex: 1,
//                   child: context
//                           .watch<ChatProvider>()
//                           .messageController
//                           .text
//                           .isEmpty
//                       ? IconButton(
//                           onPressed: () {}, icon: const Icon(Icons.mic))
//                       : CircleAvatar(
//                         child: IconButton(
//                             onPressed: () {
//                               context
//                                   .read<ChatProvider>()
//                                   .arrowDown(scrollController: scrollController);
//                               context.read<ChatProvider>().writemessage();
//                             },
//                             icon: const Icon(Icons.send_rounded),
//                             color: Colors.white,
//                           ),
//                       ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

  // StreamBuilder<QuerySnapshot<Object?>> _streamBodyBuilder(
  //     BuildContext context, Size mediaQuery) {
  //   return StreamBuilder(
  //     stream: context.read<ChatProvider>().chatStream,
  //     builder: (BuildContext context,
  //         AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: loadingWidget(),
  //         );
  //       } else if (snapshot.hasError) {
  //         return Center(
  //           child: Text(snapshot.error.toString()),
  //         );
  //       } else {
  //         List<Map<String, dynamic>> data = [];
  //         snapshot.data!.docs.map((e) {
  //           data.add(e.data() as Map<String, dynamic>);
  //         }).toList();
  //         if (data.isEmpty) {
  //           return const Center(child: Text("No messages yet"));
  //         } else {
  //           return Stack(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.only(bottom: mediaQuery.height * 0.08),
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   controller: scrollController,
  //                   itemCount: data.length,
  //                   itemBuilder: (context, index) {
  //                     return Align(
  //                         alignment: data[index]['token'] ==
  //                                 FirebaseAuth.instance.currentUser!.uid
  //                             ? Alignment.centerRight
  //                             : Alignment.centerLeft,
  //                         child: data[index]['token'] ==
  //                                 FirebaseAuth.instance.currentUser!.uid
  //                             ? Container(
  //                                 margin: const EdgeInsets.all(8),
  //                                 padding: const EdgeInsets.all(8),
  //                                 decoration: const BoxDecoration(
  //                                     color: Colors.blue,
  //                                     borderRadius: BorderRadius.only(
  //                                         topLeft: Radius.circular(20),
  //                                         bottomLeft: Radius.circular(20))),
  //                                 child: Text(
  //                                   data[index]['message'].toString(),
  //                                   style: const TextStyle(
  //                                       fontSize: 16, color: Colors.white),
  //                                 ),
  //                               )
  //                             : Container(
  //                                 margin: const EdgeInsets.all(8),
  //                                 padding: const EdgeInsets.all(8),
  //                                 decoration: const BoxDecoration(
  //                                     color: Colors.blue,
  //                                     borderRadius: BorderRadius.only(
  //                                         topRight: Radius.circular(20),
  //                                         bottomRight: Radius.circular(20))),
  //                                 child: Text(
  //                                   data[index]['message'].toString(),
  //                                   style: const TextStyle(
  //                                       fontSize: 16, color: Colors.white),
  //                                 ),
  //                               ));
  //                   },
  //                 ),
  //               ),
  //               Positioned(
  //                   bottom: 0,
  //                   right: 0,
  //                   child: Padding(
  //                     padding: EdgeInsets.only(
  //                         bottom: mediaQuery.height * 0.09,
  //                         right: mediaQuery.width * 0.01),
  //                     child: Visibility(
  //                       visible: isVisible,
  //                       child: FloatingActionButton(
  //                         onPressed: () {
  //                           context
  //                               .read<ChatProvider>()
  //                               .arrowDown(scrollController: scrollController);
  //                         },
  //                         child: const Icon(Icons.arrow_downward_rounded),
  //                       ),
  //                     ),
  //                   ))
  //             ],
  //           );
  //         }
  //       }
  //     },
  //   );
  // }

  // AppBar _appBar() {
  //   return AppBar(
  //     title: const Text("Chat App"),
  //     actions: const [
  //       // for User profile picture
  //       CircleAvatar()
  //     ],
  //   );
  // }
}

class ImageViewWidget extends StatefulWidget {
  const ImageViewWidget({super.key});

  @override
  State<ImageViewWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget> {
  @override
  void initState() {
    ImagePickerService.selectedImage = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: ImagePickerService.selectedImage == null
            ? Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await ImagePickerService.selectImage(
                            ImagePickerService.camera);
                        setState(() {});
                      },
                      child: const Text("Camera").tr()),
                  ElevatedButton(
                      onPressed: () async {
                        await ImagePickerService.selectImage(
                            ImagePickerService.gallery);
                        setState(() {});
                      },
                      child: const Text("Gallery").tr())
                ],
              )
            : const SizedBox(),
        content: ImagePickerService.selectedImage != null
            ? Image.file(ImagePickerService.selectedImage!)
            : const SizedBox(),
        actions: ImagePickerService.selectedImage != null
            ? [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel").tr()),
                ElevatedButton(
                    onPressed: () {
                      FireStoreService.uploadFile(
                              ImagePickerService.selectedImage!, "chat")
                          .then(
                        (value) async {
                          await context
                              .read<ChatProvider>()
                              .writeFileMessage()
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                      );
                    },
                    child: const Text("Send").tr())
              ]
            : null);
  }
}
