import 'package:get_it/get_it.dart';
import 'package:shopping/data/database_service/product_database_service.dart';
import 'package:shopping/logic/management_service/product_management_service.dart';
class Locator{
  static void setup() {
    // Management Services
    GetIt.instance.registerLazySingleton(() => ProductManagementService());

    //database Services
    GetIt.instance.registerLazySingleton(() => ProductDatabaseService());
    
  }


  // Management Service
  static ProductManagementService get productManagementService =>
      GetIt.I<ProductManagementService>();

  // Database Service
   static ProductDatabaseService get productDatabaseService =>
      GetIt.I<ProductDatabaseService>();
}