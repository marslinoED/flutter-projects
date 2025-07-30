import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ramadan/database/database.dart';

class SeriesWidget extends StatefulWidget {
  const SeriesWidget({super.key, required this.series, required this.onDelete});

  final Map series;
  final Function(int) onDelete; 

  @override
  State<SeriesWidget> createState() => _SeriesWidgetState();
}

class _SeriesWidgetState extends State<SeriesWidget> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.series['currentindex'];
  }

  Future<void> _increment() async {
    await incrementIndex(id: widget.series['id']);
    setState(() {
      currentIndex += 1;
    });
  }

  Future<void> _decrement() async {
    if (currentIndex > 0) {
      await decrementIndex(id: widget.series['id']);
      setState(() {
        currentIndex -= 1;
      });
    }
  }

  Future<void> _deleteSeries() async {
    await deleteData(id: widget.series['id']);
    widget.onDelete(widget.series['id']); 
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.series['id'].toString()), 
      direction: DismissDirection.horizontal,
      onDismissed: (direction) => _deleteSeries(), 
      background: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 40),
        ),
      ),
      secondaryBackground: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 200,
                    height: 200,
                    child: widget.series['image'].startsWith('Assets/')
                        ? Image.asset(
                            widget.series['image'],
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(widget.series['image']),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.series['title'],
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _increment,
                          child: const Text('+', style: TextStyle(fontSize: 40)),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          currentIndex.toString(),
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _decrement,
                          child: const Text('-', style: TextStyle(fontSize: 40)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}