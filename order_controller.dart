import 'dart:io';
import 'package:get/get.dart';
import '../../model/order.dart';
import '../../model/top_selling.dart';
import '../services/api_order_services.dart';


class OrderController extends GetxController {
  var orderList = <Order>[].obs;
  var topSellingList = <TopSelling>[].obs;
  var isLoading = false.obs;


  Future<int> fetchOrderCount() async {
    try {
      final result = await ApiOrderServices.orderCount();

      if (result["count"] != null) {
        int count = result["count"];
        return count;
      } else {
        return 0;
      }
    } catch (e, stack) {
      return 0;
    }
  }

  Future<void> fetchAllOrders() async {
  try {
    print('🚀 [Controller] Fetching all orders...');
    isLoading(true);

    final result = await ApiOrderServices.getAllOrders();
    print('📬 [Controller] Raw result: $result');

    if (result.containsKey("error")) {
      print('⚠️ [Controller] Error from API: ${result["error"]}');
      orderList.clear();
      return;
    }

    // Your API returns {"orders": [...]}, so access directly:
    final data = result["orders"];
    print('📊 [Controller] Extracted orders: $data');

    if (data is List && data.isNotEmpty) {
      print('✅ [Controller] Parsed ${data.length} orders');
      orderList.assignAll(
        data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } else {
      print('⚠️ [Controller] No orders found, clearing list');
      orderList.clear();
    }
  } catch (e, stack) {
    print('💥 [Controller] Error fetching orders: $e');
    print(stack);
  } finally {
    isLoading(false);
    print('🏁 [Controller] Fetch complete, isLoading=false');
  }
}

Future<void> fetchTopSellingOrder() async {
  try {
    print('🚀 [Controller] Fetching top-selling orders...');
    isLoading(true);

    final result = await ApiOrderServices.getTopSelling();
    print('📬 [Controller] Raw result: $result');

    if (result.containsKey("error")) {
      print('⚠️ [Controller] Error from API: ${result["error"]}');
      topSellingList.clear();
      return;
    }

    // API returns {"orders": [...]}, not {"top_selling": [...]}
    final data = result["orders"];
    print('📊 [Controller] Extracted top-selling orders: $data');

    if (data is List && data.isNotEmpty) {
      print('✅ [Controller] Parsed ${data.length} top-selling items');
      topSellingList.assignAll(
        data.map((e) => TopSelling.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } else {
      print('⚠️ [Controller] No top-selling data, clearing list');
      topSellingList.clear();
    }
  } catch (e, stack) {
    print('💥 [Controller] Error fetching top-selling orders: $e');
    print(stack);
  } finally {
    isLoading(false);
    print('🏁 [Controller] Top-selling fetch complete, isLoading=false');
  }
}

}


