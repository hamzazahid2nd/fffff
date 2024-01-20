import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/filterstate_provider.dart';

class CustomBottomSheet2 extends StatefulWidget {
  String title;
  List<String> list;
  bool fullSize;

  CustomBottomSheet2(this.title, this.list, this.fullSize);

  @override
  State<CustomBottomSheet2> createState() => _CustomBottomSheet2State();
}

class _CustomBottomSheet2State extends State<CustomBottomSheet2> {
  List<String> displayList = [];
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

  void addItemInList() {}

  @override
  Widget build(BuildContext context) {
    final filterStateProvider = Provider.of<FilterState>(context, listen: true);
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
                                setState(() {
                                  if (filterStateProvider.selectedSkills
                                      .contains(displayList[index])) {
                                    filterStateProvider.selectedSkills
                                        .remove(displayList[index]);
                                  } else {
                                    filterStateProvider.selectedSkills
                                        .add(displayList[index]);
                                  }
                                });
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
                      setState(() {
                        filterStateProvider.selectedSkills
                            .add(displayList[index]);
                      });
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
