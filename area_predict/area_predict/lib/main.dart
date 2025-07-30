import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Area Price Prediction'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _areaController = TextEditingController();
  double? _predictedPrice;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _predictPrice() async {
    setState(() {
      _isLoading = true;
      _predictedPrice = null;
      _errorMessage = null;
    });

    try {
      final area = double.tryParse(_areaController.text);
      if (area == null || area <= 0) {
        throw Exception('Please enter a valid positive number for area');
      }

      final apiService = ApiService();
      final predictedPrice = await apiService.predictPrice(area);

      setState(() {
        _predictedPrice = predictedPrice;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Enter Area (in sq. ft.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _predictPrice,
                child: const Text('Predict Price'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Predicted Price:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                )
              else
                Text(
                  _predictedPrice != null
                      ? '£ ${_predictedPrice!.toStringAsFixed(2)}'
                      : '£ 0.00',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}