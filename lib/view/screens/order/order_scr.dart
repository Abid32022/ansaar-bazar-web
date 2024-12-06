import 'package:flutter/material.dart';
class OrderScr extends StatefulWidget {
  // const OrderScr({super.key});

  @override
  State<OrderScr> createState() => _OrderScrState();
}

class _OrderScrState extends State<OrderScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YEs",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
      ),
       body: Container(
         child: Column(
           children: [

           ],
         ),
       ),
    );
  }
}
