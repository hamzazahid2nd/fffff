  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  import '../provider/filterstate_provider.dart';

  class CustomBottomSheet extends StatefulWidget {
    String title;
    List<String> list;
    bool fullSize;

    CustomBottomSheet(this.title, this.list, this.fullSize);

    @override
    State<CustomBottomSheet> createState() => _CustomBottomSheetState();
  }

  class _CustomBottomSheetState extends State<CustomBottomSheet> {
    List<String> displayList = [];
    List<String> selectedList = [];
    TextEditingController searchController = TextEditingController();

    @override
    void initState() {
      super.initState();
      displayList = List.from(widget.list);
      searchController.addListener(() {
        filterList(searchController.text);
      });
    }

    void filterList(String query) {
      setState(() {
        displayList = widget.list
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    void updateListInProvider(List<String> providerList, List<String> displayList, int index){

      print('updateListInProvider method called');
        setState(() {
          if (providerList.contains(displayList[index])) {
            providerList.remove(displayList[index]);
            print('removed ${displayList[index]} in list');

          } else {
            providerList.add(displayList[index]);
            print('added ${displayList[index]} in list');
          }
          Provider.of<FilterState>(context, listen: false).updateSkills(providerList);
        });

    }

    @override
    Widget build(BuildContext context) {
      final filterStateProvider = Provider.of<FilterState>(context);
      return widget.fullSize
          ? Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 21),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.close)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        child: TextField(
                          controller: searchController,
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                            filled: true, // Enable background color
                            fillColor: Colors.grey[
                                200], // Choose your desired background color
                            border: InputBorder.none, // Remove the border

                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            hintText: 'Search for ${widget.title}',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: displayList.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                    child: textWid(
                                        displayList[index],
                                        filterStateProvider.selectedSkills
                                            .contains(displayList[index]), () {
                                      updateListInProvider(filterStateProvider.selectedSkills, displayList,index);
                                })),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: TextField(
                    controller: searchController,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                      filled: true, // Enable background color
                      fillColor: Colors
                          .grey[200], // Choose your desired background color
                      border: InputBorder.none, // Remove the border

                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      hintText: 'Search for ${widget.title}',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      return textWid(
                          displayList[index],
                          filterStateProvider.selectedSkills
                              .contains(displayList[index]), () {
                            print('checkbox clicked');
                        updateListInProvider(filterStateProvider.selectedSkills, displayList,index);
                      });
                    },
                  ),
                ),
              ],
            );
    }
  }

  class textWid extends StatefulWidget {
    String text;
    bool isChecked;
    Function function;

    textWid(this.text, this.isChecked, this.function);

    @override
    State<textWid> createState() => _textWidState();
  }

  class _textWidState extends State<textWid> {
    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          Checkbox(
              activeColor: Color.fromRGBO(82, 113, 255, 1),
              checkColor: Color.fromRGBO(82, 113, 255, 1),
              side: BorderSide(color: Color.fromRGBO(82, 113, 255, 1), width: 1.0),
              value: widget.isChecked,
              onChanged: (value) {
                widget.function();
                setState(() {
                  value!;
                });
              }),
          Row(
            children: [
              Text(
                widget.text,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
              Text('(31)'),
            ],
          ),
        ],
      );
    }
  }
