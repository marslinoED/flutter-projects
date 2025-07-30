import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/layout/cubit/app_cubit.dart';
import 'package:shopping/layout/cubit/app_states.dart';
import 'package:shopping/shared/components/components.dart';
import 'package:shopping/shared/models/home_model.dart';
import 'package:shopping/shared/app_theme.dart';
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppUnSuccessChangeFavoritesState) {
          errorMessage(context, state.error, false);
        }
        else if (state is AppSuccessChangeFavoritesState) {
          errorMessage(context, state.changeFavourites ? 'Added to favourites' : 'Removed from favourites', true);
        }
        else if (state is AppErrorChangeFavoritesState) {
          errorMessage(context, 'An error occurred, please try again later', false);
        }

      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return cubit.homeModel == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildProducts(cubit.homeModel, cubit);
      },
    );
  }

  Widget buildProducts(HomeModel? model, cubit) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          CarouselSlider(
            items: model?.data.banners
                .map((e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ))
                .toList(),
            options: CarouselOptions(
              height: 200.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              shrinkWrap: true,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.3,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(
                model?.data.products.length ?? 0,
                (index) => buildProductItem(model!.data.products[index], cubit),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget buildProductItem(ProductModel product, cubit) {
  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage('${product.image}'),
                width: double.infinity,
                height: 150.0,
                fit: BoxFit.scaleDown,
              ),
              if (product.discount != 0)
                Row(
                  children: [
                    Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'DISCOUNT ${product.discount}%',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'SAVE ${(product.oldPrice - product.price).toInt()}LE',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
       Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '${product.name}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              height: 1.3,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
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
                  backgroundColor: product.inFavorites ? AppTheme().primaryColor : Colors.grey[500],
                  radius: 20.0,
                  child: Transform.translate(
                    offset: Offset(0, 0.5),
                    child: Icon(
                      product.inFavorites ? Icons.favorite : Icons.favorite_border,
                      color: 
                      Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 2,),
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
        ),
      ),
      ],
    ),
  );
}

}
