import 'package:get_it/get_it.dart';
import 'package:shopping/logic/management_service/product_management_service.dart';
class Locator{
  static void setup() {
    GetIt.instance.registerLazySingleton(() => ProductManagementService());
    
  }

  static ProductManagementService get productManagementService =>
      GetIt.I<ProductManagementService>();
}