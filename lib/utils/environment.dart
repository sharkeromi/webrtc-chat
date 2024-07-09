import 'package:startup_boilerplate/utils/constants/imports.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env';
    }
    return '.env.dev';
  }

  static String get apiUrl {
    return dotenv.get('Api_Url');
  }

  static String get baseUrl {
    return dotenv.get('Base_Url');
  }

  static String get imageBaseUrl {
    return dotenv.get('Image_Base_Url');
  }

}