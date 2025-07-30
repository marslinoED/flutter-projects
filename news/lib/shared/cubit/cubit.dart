import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/shared/models/navigation_bar_model.dart';
import 'package:news/shared/network/local/cache_helper.dart';
import 'package:news/shared/network/remote/dio_helper.dart';
import 'package:news/widgets/business_screen.dart';
import 'package:news/widgets/science_screen.dart';
import 'package:news/widgets/settings_screen.dart';
import 'package:news/widgets/sports_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : isDark = CacheHelper.getBoolean(key: 'isDark'),
        isEn = CacheHelper.getBoolean(key: 'isEn'),
        currentIndex = CacheHelper.getInt(key: 'currentIndex'),
        super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  List<dynamic> businessData = [];
  List<dynamic> sportsData = [];
  List<dynamic> scienceData = [];
  List<dynamic> searchData = [];
  String searchController = '';
  bool isSearch = false;
  bool isSettings = false;
  bool isDark = true;
  int currentIndex = 0;
  bool isEn = true;

  List<NavigatorBarModel> screens = [
    NavigatorBarModel(screen: BusinessScreen(), label: 'Business'),
    NavigatorBarModel(screen: SportsScreen(), label: 'Sports'),
    NavigatorBarModel(screen: ScienceScreen(), label: 'Science'),
    NavigatorBarModel(screen: SettingsScreen(), label: 'Science'),
  ];

  void initializeSharedPreferences() {
    isDark = CacheHelper.getBoolean(key: 'isDark');
    isEn = CacheHelper.getBoolean(key: 'isEn');
  }
  void changeBottomNav(int index) {
    isSettings = false;
    currentIndex = index;
    CacheHelper.putInt(key: 'currentIndex', value: index);
    if(index == 0 && businessData.isEmpty) getData('business');
    else if(index == 1 && sportsData.isEmpty) getData('sports');
    else if(index == 2 && scienceData.isEmpty) getData('science');

    emit(NewsBottomNavigationState());
  }
  void isSettingsScreen() {
    isSettings = !isSettings;
    emit(NewsSettingState());
  }

  void getData(String category) {
    emit(NewsLoadingState());
    // https://newsapi.org/v2/everything?q=business&language=ar&apiKey=1df840c874354a3f98c3cb1df431ddcf
    DioHelper.getData(
      url: 'v2/everything', 
      query: {
        'q': category,
        'language': isEn ? 'en' : 'ar',
        // 'apiKey': '1df840c874354a3f98c3cb1df431ddcf', // old key
        'apiKey' : '30cb3ee50a794405912d2c0a004379cc',
      }
      ).then((value) {
        if(category == 'business') businessData = value.data['articles'];
        else if(category == 'sports') sportsData = value.data['articles'];
        else if(category == 'science') scienceData = value.data['articles'];

        emit(NewsGetDataSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetDataErrorState(error.toString()));
      });
    
  }
  void getSearch(String searchWord) {
    emit(NewsLoadingState());
    searchController = searchWord;
    // https://newsapi.org/v2/everything?q=any&from=2025-01-20&sortBy=publishedAt&apiKey=1df840c874354a3f98c3cb1df431ddcf
    
    DioHelper.getData(
      url: 'v2/everything', 
      query: {
        'q': '$searchWord',
        'from' : '2025-01-20',
        'sortBy' : 'publishedAt',
        // 'apiKey': '1df840c874354a3f98c3cb1df431ddcf', // old key
        'apiKey' : '30cb3ee50a794405912d2c0a004379cc',
      }
      ).then((value) {
        emit(NewsGetSearchDataSuccessState());
        searchData = value.data['articles'];
        // print(searchData);
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSearchDataErrorState(error.toString()));
      });
    
  }

  
  void toggleColorMode() {
    isDark = !isDark;
    CacheHelper.putBoolean(key: 'isDark', value: isDark);
    emit(NewsToggleColorModeState());
  }

  void toggleSearch() {
    isSearch = !isSearch;
    emit(NewsToggleSearchState());
  }

  void toggleLanguage(String newLang) {
    isEn = newLang == 'en';
    businessData = [];
    sportsData = [];
    scienceData = [];
    CacheHelper.putBoolean(key: 'isEn', value: isEn);
    emit(NewsChangeLanguageState());
    changeBottomNav(currentIndex);
  }

    Future<void> launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $url";
    }
  }

}