import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ramadan/database/database.dart';
import 'package:ramadan/image_picker_camer_and_gallery.dart';
import 'package:ramadan/series_widget.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final TextEditingController taskTitleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _addButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Ramadan App',
        style: TextStyle(fontSize: 30),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: seriesList.length,
      itemBuilder: (context, index) {
        Map series = seriesList[index];
        return SeriesWidget(
          series: series,
          onDelete: (int id) {
            setState(() {
              seriesList.removeWhere((element) => element['id'] == id);
            });
          },
        );
      },
    );
  }

  Widget _addButton() {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      onPressed: () {
        _selectedImage = null; // Reset when opening
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter modalSetState) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 8.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: taskTitleController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Series Name',
                              labelStyle: TextStyle(fontSize: 20),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Series name cannot be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final pickedImage = await pickImageFromGallery();
                                  if (pickedImage != null) {
                                    modalSetState(() {
                                      _selectedImage = pickedImage;
                                    });
                                  }
                                },
                                child: Text(_selectedImage != null ? 'Change Image' : 'Pick Image'),
                              ),
                              if (_selectedImage != null)
                                ElevatedButton(
                                  onPressed: () {
                                    modalSetState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  child: const Text('Remove Image'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 250,
                              width: 350,
                              child: _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'Assets/temp.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                insertToDatabase(
                                  title: taskTitleController.text.trim(),
                                  currentindex: 0,
                                  image: _selectedImage?.path,
                                ).then((_) {
                                  setState(() {
                                    taskTitleController.clear();
                                    _selectedImage = null;
                                  });
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: const Text('Add Series'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}