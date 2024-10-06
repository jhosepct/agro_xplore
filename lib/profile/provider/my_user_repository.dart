import '../../profile/provider/firebase_provider.dart';
import '../model/user.dart';

abstract class MyUserRepositoryBase {
  Future<MyUser?> getMyUser();

  Future<void> saveMyUser(MyUser user);

  Future<void> updateMyUser(String description, List interests);
}

class MyUserRepository extends MyUserRepositoryBase {
  final provider = FirebaseProvider();

  @override
  Future<MyUser?> getMyUser() => provider.getMyUser();

  @override
  Future<void> saveMyUser(MyUser user) => provider.saveMyUser(user);

  @override
  Future<void> updateMyUser(String description, List interests) =>
      provider.updateMyUser(description, interests);
}
