import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/features/order/data/order_repository.dart';
import 'package:toko_oli/features/product/presentation/data/product_repository.dart';

class AdminDashboardRepository {
  AdminDashboardRepository(
    this._orderRepository,
    this._productRepository, {
    SupabaseClient? client,
  })  : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;
  final AppFallbackStore _fallback;

  Future<DashboardSummaryInfo> getDashboardSummary() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.from('admin_dashboard_summary').select().single();
        return DashboardSummaryInfo(
          todaySales: (response['today_sales'] as num?)?.toDouble() ?? 0,
          newOrders: (response['new_orders'] as num?)?.toInt() ?? 0,
          ordersToProcess: (response['orders_to_process'] as num?)?.toInt() ?? 0,
          shippedOrders: (response['shipped_orders'] as num?)?.toInt() ?? 0,
          lowStockProducts: (response['low_stock_products'] as num?)?.toInt() ?? 0,
          outOfStockProducts:
              (response['out_of_stock_products'] as num?)?.toInt() ?? 0,
          monthlyRevenue: (response['monthly_revenue'] as num?)?.toDouble() ?? 0,
          newCustomers: (response['new_customers'] as num?)?.toInt() ?? 0,
        );
      } catch (_) {}
    }
    return _fallback.dashboardSummary;
  }

  Future<List<Map<String, Object>>> getRevenueChart() async {
    final summary = await getDashboardSummary();
    return [
      {'label': 'Today', 'value': summary.todaySales},
      {'label': 'Month', 'value': summary.monthlyRevenue},
    ];
  }

  Future<List<Map<String, Object>>> getOrderStatusOverview() async {
    final orders = await _orderRepository.adminGetOrders();
    final counts = <String, int>{};
    for (final order in orders) {
      counts.update(order.orderStatus, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts.entries
        .map((entry) => {'status': entry.key, 'count': entry.value})
        .toList();
  }

  Future<List<Map<String, Object>>> getBestSellingProducts() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.from('best_selling_products').select().limit(10);
        return (response as List<dynamic>)
            .map((item) => Map<String, Object>.from(item as Map))
            .toList();
      } catch (_) {}
    }
    final products = await _productRepository.getActiveProducts();
    return products
        .take(3)
        .map((item) => {'product_name': item.name, 'units_sold': 8, 'revenue': item.priceValue * 8})
        .toList();
  }

  Future<List<OrderInfo>> getRecentOrders() async {
    final orders = await _orderRepository.adminGetOrders();
    return orders.take(5).toList();
  }

  Future<List<ProductVariantInfo>> getLowStockAlerts() =>
      _productRepository.getLowStockProducts();
}
