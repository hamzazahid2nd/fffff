import 'package:flutter/material.dart';

class CenteredBtnWithIcon extends StatelessWidget {
  String title;
  Function function;
  Color color;


  CenteredBtnWithIcon( this.title, this.function,this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
                SizedBox(width : 20),
                Icon(Icons.logout,color: color,),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
