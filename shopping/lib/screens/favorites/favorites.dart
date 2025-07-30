import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/layout/cubit/app_cubit.dart';
import 'package:shopping/layout/cubit/app_states.dart';
import 'package:shopping/shared/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        // Ensure favoritesModel is not null before accessing data
        if (state is AppChangeFavoritesState || state is AppLoadingFavoritesDataState) {
          return Center(child: CircularProgressIndicator());
        }
        else if (cubit.favoritesModel?.data!.data.length == 0 || cubit.favoritesModel == null) {
          return Center(child: Text('No favorites yet', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)));
        }
        else{  
        return ListView.separated(
          itemBuilder: (context, index) => buildListProduct(
              cubit.favoritesModel!.data?.data[index].product, cubit, context),
          separatorBuilder: (context, index) => Divider(color: Colors.grey),
          itemCount: cubit.favoritesModel!.data!.data.length,
        );
        }
      },
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
                if (product.discount != 0)
                  Container(
                    width: 150, // Match image width
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            'DISCOUNT \n${product.discount}%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 8.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 40),
                        Container(
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            'SAVE \n${(product.oldPrice - product.price).toInt()}LE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 8.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      if (product.discount != 0)
                        Text(
                          '${product.oldPrice}LE',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
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
