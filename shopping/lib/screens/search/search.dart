import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/screens/search/cubit/search_cubit.dart';
import 'package:shopping/screens/search/cubit/search_states.dart';
import 'package:shopping/shared/app_theme.dart';
import 'package:shopping/shared/components/components.dart';


class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('Search'),
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    buildDeafultTextField(searchController, 'Search', Icons.search, false, context, state, cubit),
                    SizedBox(
                      height: 10.0,
                    ),
                    buildDefaultButton(() {
                      if (formKey.currentState!.validate()) {
                        cubit.search(searchController.text);
                      }
                    },
                    'Search',
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    
                    if (state is SearchLoadingState) Center(child: CircularProgressIndicator()),
                    
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildListProduct(
                            SearchCubit.get(context).model?.data.data[index],
                            cubit,
                            context,
                          ),
                          separatorBuilder: (context, index) => Divider(color: Colors.grey,),
                          itemCount:
                              SearchCubit.get(context).model!.data.data.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildListProduct(product, cubit, context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(
                      product.image ?? 'https://example.com/default_image.png'),
                  width: 150,
                  height: 150,
                  // fit: BoxFit.cover,
                ),
                
              ],
            ),
            Expanded(
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.name}',
                    maxLines: 4,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        '${product.price}LE',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AppTheme().primaryColor,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Spacer(),
                      SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: IconButton(
                          onPressed: () {
                            cubit.changeFavourites(product.id);
                          },
                          padding: EdgeInsets.all(0),
                          icon: CircleAvatar(
                            backgroundColor: AppTheme().primaryColor,
                            radius: 20.0,
                            child: Transform.translate(
                              offset: Offset(0, 0.5),
                              child: Icon(Icons.favorite,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: IconButton(
                          onPressed: () {
                            print("object");
                          },
                          padding: EdgeInsets.all(0),
                          icon: CircleAvatar(
                            backgroundColor: Colors.grey[500],
                            radius: 25.0,
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}