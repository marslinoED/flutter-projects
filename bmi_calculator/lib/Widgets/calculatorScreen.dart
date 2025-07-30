import 'package:flutter/material.dart';
import 'resultScreen.dart';
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  static const double paddingValue = 20;

  

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool isMale = true;
  double height = 180;
  int weight = 65;
  int age = 21;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 47, 61),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text("BMI Calculator",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 74, 165, 240)),),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(flex: 4,
          child: _genderButtons(),),
        Expanded(flex: 4,
          child: _heightSlider()),
        Expanded(flex: 4,
          child: _metricsButtons()),
        Expanded(flex: 1,
          child: _calculateButton()),
        SizedBox(height: CalculatorScreen.paddingValue),
      ],
    );
  }

  Widget _genderButtons() {
    return Padding(
      padding: const EdgeInsets.all(CalculatorScreen.paddingValue),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {    
                setState(() {
                  print("Male");
                  isMale = true; 
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isMale ? Color.fromARGB(255, 28, 89, 140) : Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.male, size: 60, color: isMale ? Colors.white : Colors.black,),
                    Text("Male",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: isMale ? Colors.white : Colors.black),)
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: CalculatorScreen.paddingValue),
          
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  print("Female");
                  isMale = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isMale ? Colors.blue : Color.fromARGB(255, 28, 89, 140),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.female, size: 60, color: isMale ? Colors.black : Colors.white,),
                    Text("Female",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: isMale ? Colors.black : Colors.white),)
                  ],
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }

  Widget _heightSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CalculatorScreen.paddingValue),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Height cm",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
                      
            Text("${height.round()}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
        
            Slider(
              thumbColor: const Color.fromARGB(255, 2, 39, 69),
              activeColor: const Color.fromARGB(255, 2, 39, 69),
              value: height,
              min: 80,
              max: 250,
              onChanged: (value)
                {
                  setState(() {
                    height= value;
                  });
                  print(value.round());
                },
            )
          ],
        ),
      ),
    );
  }

  Widget _metricsButtons() {
    return Padding(
      padding: const EdgeInsets.all(CalculatorScreen.paddingValue),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Weight g",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
                  Text("${weight}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'weightPlus',
                        backgroundColor: Color.fromARGB(255, 2, 39, 69),
                        mini: true,
                        onPressed: (){
                          setState(() {
                            weight++;
                          });
                        },
                        child: Icon(Icons.add, color: Colors.white,),
                      ),
                      SizedBox(width: CalculatorScreen.paddingValue),
                      FloatingActionButton(
                        heroTag: 'weightMinus',
                        backgroundColor: Color.fromARGB(255, 2, 39, 69),
                        mini: true,
                        onPressed: (){
                          setState(() {
                            weight--;
                          });
                        },
                        child: Icon(Icons.remove, color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: CalculatorScreen.paddingValue),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Age",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
                  Text("$age",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'agePlus',
                        backgroundColor: Color.fromARGB(255, 2, 39, 69),
                        mini: true,
                        onPressed: (){
                          setState(() {
                            age++;
                          });
                        },
                        child: Icon(Icons.add, color: Colors.white,),
                      ),
                      SizedBox(width: CalculatorScreen.paddingValue),
                      FloatingActionButton(
                        heroTag: 'ageMinus',
                        backgroundColor: Color.fromARGB(255, 2, 39, 69),
                        mini: true,
                        onPressed: (){
                          setState(() {
                            age--;
                          });
                        },
                        child: Icon(Icons.remove, color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _calculateButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: CalculatorScreen.paddingValue),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: MaterialButton(
        onPressed: (){

          Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(isMale: isMale, height: height.round(), weight: weight, age: age)));

        },
        child: Text("calculate",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),)),
    ),
  );

  }
}