import 'dart:convert';
import 'package:admincoffee/view/ipaddress/ip.dart';
import 'package:http/http.dart' as http;

class ApiOrderServices {
  static const String baseUrl = BASE_URL;

  static Future<Map<String, dynamic>> orderCount() async {
    final url = Uri.parse('$baseUrl/order/ordercount/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch product count: ${response.statusCode} ${response.body}');
    }
  }

   static Future<Map<String, dynamic>> getAllOrders() async {
    final url = Uri.parse('$baseUrl/order/getorders/');
    print('[LOG] Fetching all orders from $url');

    try {
      final response = await http.get(url);
      print('[LOG] Response status: ${response.statusCode}');
      print('[LOG] Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('[LOG] Successfully fetched ${data.length} orders');
        return {"orders": data};
      } else {
        print('[ERROR] Failed to load orders: ${response.body}');
        return {"error": "Failed to load orders: ${response.body}"};
      }
    } catch (e, stack) {
      print('[EXCEPTION] getAllOrders error: $e');
      print('[STACK TRACE] $stack');
      return {"error": e.toString()};
    }
  }

  static Future<List<dynamic>> getStatusOrders(String status) async {
    final url = Uri.parse('$baseUrl/getstatusorders/$status');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        'Failed to fetch status orders: ${response.statusCode} ${response.body}',
      );
    }
  }

  static Future<Map<String, dynamic>> deleteOrder(String id) async {
    final url = Uri.parse('$baseUrl/order/deleteorder/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to delete coffee: ${response.statusCode} ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getTopSelling() async {
    final url = Uri.parse('$baseUrl/order/topselling/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return {"orders": data};
      } else {
        return {"error": "Failed to load orders: ${response.body}"};
      }
    } catch (e, stack) {
      return {"error": e.toString()};
    }
  }

}