import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.isMale, required this.height, required this.weight, required this.age});
  final bool isMale;
  final int height;
  final int weight;
  final int age;

  double get alpha => isMale ? (1 + 0.1 * (age / 10)) : (1 - 0.05 * (age / 10));
  double get bmi => double.parse(((weight / ((height / 100) * (height / 100))) * alpha).toStringAsFixed(2));
  String get bmiCategories => bmi >= 25 ? "Overweight" : bmi >= 18.5 ? "Normal" : "Underweight";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 47, 61),
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 74, 165, 240)), // Custom icon
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
      title: Text("BMI Result",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 74, 165, 240)),),
      centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Result for:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: const Color.fromARGB(255, 74, 165, 240)),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Gender: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: const Color.fromARGB(255, 74, 165, 240)),),
                Text("${isMale ? "Male" : "Female"}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.white),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Height: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: const Color.fromARGB(255, 74, 165, 240)),),
                Text("${height.round()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.white),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Weight: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: const Color.fromARGB(255, 74, 165, 240)),),
                Text("$weight", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.white),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Age: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: const Color.fromARGB(255, 74, 165, 240)),),
                Text("$age", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.white),),
              ],
            ),
            
            SizedBox(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your BMI is: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: const Color.fromARGB(255, 74, 165, 240)),),
                Text("$bmi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.white),),
              ],
            ),
            
            Text("Your BMI Categories is:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: const Color.fromARGB(255, 74, 165, 240)),),
            Text(bmiCategories, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45, color: Colors.white),),
            
            

            SizedBox(height: 70),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold), // Common style
                  children: [
                    TextSpan(
                      text: "Note: ", 
                      style: TextStyle(color: Color.fromARGB(255, 74, 165, 240)), // Blue color
                    ),
                    TextSpan(
                      text: "BMI does not differentiate between muscle and fat, so a very muscular person might be classified as overweight even if they have low body fat.",
                      style: TextStyle(color: Colors.white), // White color
                    ),
                  ],
                ),
              ),
            ),


            ],
        ),
      ),

    );
  }
}