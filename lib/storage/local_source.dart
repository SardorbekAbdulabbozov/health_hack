import 'package:get_storage/get_storage.dart';
import 'package:health_hack/utils/constants.dart';

class LocalSource {
  LocalSource._();

  static LocalSource? _instance;

  factory LocalSource() => _instance ?? LocalSource._();

  final _localSource = GetStorage();

  static LocalSource getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      return LocalSource._();
    }
  }

  Future <void> setProfile(String ssn) async {
    await _localSource.write(Constants.profile, ssn);
  }

  String getSSN() {
    return _localSource.read<String>(Constants.profile)??'';
  }

  bool hasProfile() {
    return (_localSource.read<String>(Constants.profile)??'').isNotEmpty;
  }

  Future<void> logout() async {
    await _localSource.remove(Constants.profile);
  }
}
