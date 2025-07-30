import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/cubit.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/shared/widgets/news_widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NewsCubit.get(context);
        var list = cubit.searchData;
        
        return Scaffold(
          appBar: AppBar(
            title: Text("Search"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  style: TextStyle(color: Colors.deepOrange),
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    // print(value);
                    if(cubit.isSearch) 
                      cubit.getSearch(value); 
                  
                  },
                  decoration: InputDecoration(
                    labelText: "Search",
                    labelStyle: TextStyle(color: Colors.deepOrange),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.search, color: Colors.deepOrange),
                    suffixIcon: IconButton(
                      onPressed: (){
                        cubit.toggleSearch();
                      },
                      icon: Icon(cubit.isSearch ? Icons.lock_open : Icons.lock, color: Colors.deepOrange), 
                      color: Colors.deepOrange),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){
                    if (searchController.text.isNotEmpty)
                    cubit.getSearch(searchController.text);    
                  }, 
                  child: Text("Search", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 20),
                if (list.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          NewsWidget(model: list[index]),
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      itemCount: list.length,
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "No results found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
