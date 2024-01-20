import 'package:flutter/material.dart';

class SortTitle extends StatelessWidget {
  bool isSelected;
  Function function;
  String title;
  String desc;
  IconData icon;


  SortTitle(this.isSelected, this.function, this.title, this.desc, this.icon);

  @override
  Widget build(BuildContext context) {
    Color ColorUnselected = Colors.grey.shade600;
    Color Colorselected = Color.fromRGBO(82, 113, 255, 1);

    return GestureDetector(
      onTap: (){
        function();
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? Colorselected : Colors.transparent,
            border: Border.all(color: isSelected ? Colorselected  : ColorUnselected),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,style: TextStyle(color: isSelected ? Colors.white  : ColorUnselected ),),
                    Text(desc,style: TextStyle(color: isSelected ? Colors.white : ColorUnselected,fontSize: 10),),
                  ],
                ),
                SizedBox(width: 20,),
                Icon(icon, color: isSelected ? Colors.white : ColorUnselected,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
