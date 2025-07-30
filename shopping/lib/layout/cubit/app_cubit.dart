import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/layout/cubit/app_states.dart';
import 'package:shopping/screens/categories/categories.dart';
import 'package:shopping/screens/favorites/favorites.dart';
import 'package:shopping/screens/login/login_screen.dart';
import 'package:shopping/screens/products/products.dart';
import 'package:shopping/screens/settings/settings.dart';
import 'package:shopping/shared/components/components.dart';
import 'package:shopping/shared/constraints/constants.dart';
import 'package:shopping/shared/models/category_model.dart';
import 'package:shopping/shared/models/favorites_model.dart';
import 'package:shopping/shared/models/home_model.dart';
import 'package:shopping/shared/models/login_model.dart';
import 'package:shopping/shared/models/screens_model.dart';
import 'package:shopping/shared/network/end_points.dart';
import 'package:shopping/shared/network/local/cash_helper.dart';
import 'package:shopping/shared/network/remote/dio_helper.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Screens> bottomScreens = [
    Screens(
      title: 'Products',
      icon: Icon(Icons.home),
      screen: ProductsScreen(),
    ),
    Screens(
      title: 'Categories',
      icon: Icon(Icons.category),
      screen: CategoriesScreen(),
    ),
    Screens(
      title: 'Favourites',
      icon: Icon(Icons.favorite),
      screen: FavoritesScreen(),
    ),
    Screens(
      title: 'Settings',
      icon: Icon(Icons.settings),
      screen: SettingsScreen(),
    ),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  HomeModel? homeModel;
  void getHomeData() {
    emit(AppLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token ?? '',
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      print("---------Data Loaded---------");
      emit(AppSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorHomeDataState());
    });
  }

  CategoryModel? categoryModel;
  void getCategoryData() {
    emit(AppLoadingCategoryDataState());

    DioHelper.getData(
      url: CATEGORIES,
    ).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);

      print("---------Categories Loaded---------");
      emit(AppSuccessCategoryDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorCategoryDataState());
    });
  }


  FavoritesModel? favoritesModel;
  void getFavoritesData() {
    emit(AppLoadingFavoritesDataState());

    DioHelper.getData(
      url: FAVORITES,
      token: token ?? '',
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      print("---------Favorites Loaded---------");
      emit(AppSuccessFavoritesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorFavoritesDataState());
    });
  }

  void changeFavourites(int productId) {
    bool productElement = false;
    homeModel!.data.products.forEach((element) {
      if (element.id == productId) {
        element.inFavorites = !element.inFavorites;
        productElement = element.inFavorites;
      }
    });
      emit(AppChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token ?? '',
    ).then((value) {
      if(!value.data['status']){
        homeModel!.data.products.forEach((element) {
          if (element.id == productId) {
            element.inFavorites = !element.inFavorites;
          }
        });
        emit(AppUnSuccessChangeFavoritesState(value.data['message']));
        print(value.data['message']);
      }
      else{
        emit(AppSuccessChangeFavoritesState(productElement));
        getFavoritesData();
      }
    }).catchError((error) {
        homeModel!.data.products.forEach((element) {
          if (element.id == productId) {
            element.inFavorites = !element.inFavorites;
          }
        });
      print(error.toString());
      emit(AppErrorChangeFavoritesState());
    });
  }


  LoginModel? userModel;
  void getUserData() {
    emit(AppLoadingUserDataState());
    token = CacheHelper.getData(key: 'token');
    print(token);
    DioHelper.getData(
      url: PROFILE,
      token: token ?? '',
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(value.data);
      print("---------User Loaded---------");
      emit(AppSuccessUserDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorUserDataState());
    });
  }

  void logout(context) {
    token = null;
    CacheHelper.removeData(key: 'token');
    navigateTo(context, LoginScreen());
    emit(AppLogoutState());
  }



  loadData() {
    getHomeData();
    getCategoryData();
    getFavoritesData();
    getUserData();
  }


  void updateUserData({
    required String name,
    required String email,
    required String phone, 
  }) {
    emit(AppLoadingUpdateUserState());
    token = CacheHelper.getData(key: 'token');
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token ?? '',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
      },
    ).then((value) {
      if (value.data['status']) {
        userModel = LoginModel.fromJson(value.data);
        emit(AppSuccessUpdateUserState(userModel!));
      } else {
        emit(AppUnSuccessUpdateUserState(value.data['message']));
      }
      print(value.data);
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorUpdateUserState());
    });
  }
}
