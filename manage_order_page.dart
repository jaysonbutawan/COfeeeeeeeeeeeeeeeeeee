import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cards/order_card.dart';
import '../controller/auth_controller.dart';
import '../controller/order_controller.dart';

class ManageOrderScreen extends StatefulWidget {
  const ManageOrderScreen({super.key});

  @override
  State<ManageOrderScreen> createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen> {
  final OrderController controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    debugPrint("📲 ManageOrderScreen: initState called");

    final adminId = AuthController.instance.currentAdmin.value?.id;
    debugPrint("👤 Current Admin ID on init: $adminId");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (adminId != null) {
        debugPrint("🚀 Fetching orders for admin $adminId (after build)");
        controller.fetchAllOrders();
      } else {
        debugPrint("⚠️ No admin found yet — waiting for listener...");
      }
    });

    ever(AuthController.instance.currentAdmin, (admin) {
      debugPrint("🔁 Admin listener triggered: $admin");
      if (admin != null) {
        debugPrint("✅ Admin detected (${admin.id}), refetching orders...");
        controller.fetchAllOrders();
      } else {
        debugPrint("🧹 Admin is null, clearing orderList");
        controller.orderList.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🧩 ManageOrderScreen: build() called");

    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          Obx(() {
            debugPrint("👀 Obx rebuild triggered");
            debugPrint("🧮 Order list length: ${controller.orderList.length}");
            debugPrint("🔄 isLoading: ${controller.isLoading.value}");

            // 🌀 Loading state
            if (controller.isLoading.value && controller.orderList.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFD7CCC8)),
                ),
              );
            }

            // ❌ Empty list
            if (controller.orderList.isEmpty && !controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No orders found.',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),
              );
            }

            // ✅ Display orders
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final order = controller.orderList[index];
                  return CompactOrderCard(order: order);
                },
                childCount: controller.orderList.length,
              ),
            );
          }),
        ],
      ),
    );
  }

  // ----- AppBar -----
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF6D4C41),
      toolbarHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: _buildAppBarContent(),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: const Color(0xFF6D4C41),
        ),
      ),
    );
  }

  // ----- Search Bar -----
  Widget _buildAppBarContent() {
    return Column(
      children: [
        const Text(
          'Manage Orders ☕',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(25, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by name...',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(150, 255, 255, 255)),
                    prefixIcon: Icon(Icons.search,
                        color: Color.fromARGB(150, 255, 255, 255)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14, left: 5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF5D4037),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
