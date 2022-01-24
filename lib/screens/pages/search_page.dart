import 'package:biblio_files/services/data_model.dart';
import 'package:biblio_files/widgets/post_list_preview.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

class Searchpage extends StatelessWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //single child scroll view used to allow the keyboard to cover the screen, from https://stackoverflow.com/questions/46551268/when-the-keyboard-appears-the-flutter-widgets-resize-how-to-prevent-this by user Duncan Jones accessed 17/11/21
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 15,
              left: 18,
              right: 24,
              bottom: 10,
            ),
            child: Text(AppLocalizations.of(context)!.searchTitle, style: Constants.titleText,),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                            spreadRadius: 0.05,
                            blurRadius: 20,
                          )
                        ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          //this uses the FirestoreSearchScaffold library to search the database for books using a stream. Future development could allow for users to change search by
                          //course or condition.
                            child: FirestoreSearchScaffold(
                              firestoreCollectionName: 'posts',
                              searchBy: 'name',
                              scaffoldBody: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                        spreadRadius: 0.05,
                                        blurRadius: 20,
                                      )
                                    ]
                                ),
                              ),
                              dataListFromSnapshot: DataModel().dataListFromSnapshot,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<DataModel>? dataList = snapshot.data;
                                  if (dataList!.isEmpty) {
                                    return const Center(
                                      child: Text('No Results Returned'),
                                    );
                                  }
                                  return ListView.builder(
                                      itemCount: dataList.length,
                                      itemBuilder: (context, index) {
                                        final DataModel data = dataList[index];

                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            PostListPreview(image: data.image1, name: data.name, postID: data.postID, course: data.course, userUuid: data.userUuid,)
                                          ],
                                        );
                                      });
                                }

                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: Text('No Results Returned'),
                                    );
                                  }
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
