import 'package:augmntx/provider/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterTextDropDown extends StatefulWidget {
  FilterProvider provider;
  String hint;
  List<String> listofitems;
  double width;


  FilterTextDropDown(this.provider, this.hint, this.listofitems, this.width);

  @override
  State<FilterTextDropDown> createState() => _FilterTextDropDownState();
}

class _FilterTextDropDownState extends State<FilterTextDropDown> {
  @override
  Widget build(BuildContext context) {
    final dropDownModel = widget.provider;
    String? selectedItem = null;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: DropdownButton(
            itemHeight:50,
            underline: Container(
              color: Colors.transparent,
            ),
            items: widget.listofitems.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Container(
                    width: widget.width,
                    child: Text(option,style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,)),
              );
            }).toList(),
            hint:
                Text(dropDownModel.selectedItem == '' ? widget.hint : dropDownModel.selectedItem, style: Theme.of(context).textTheme.bodySmall,),
            onChanged: (String? value) {
              dropDownModel.setSelectedItem(value!);
              setState(() {

              });
            },
          ),
        ),
      ),
    );
  }
}
