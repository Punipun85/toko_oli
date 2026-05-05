import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/features/cart/domain/cart_item.dart';
import 'package:toko_oli/features/product/presentation/data/product_repository.dart';

class OrderRepository {
  OrderRepository({required ProductRepository productRepository, SupabaseClient? client})
      : _client = client,
        _productRepository = productRepository,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final ProductRepository _productRepository;
  final AppFallbackStore _fallback;

  Future<OrderInfo> createOrder({
    required String userId,
    required List<CartItem> items,
    String? addressId,
  }) async {
    final total = items.fold<double>(
      0,
      (sum, item) => sum + item.subtotal.toDouble(),
    );

    final client = _client;
    if (client != null) {
      try {
        final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
        final order = await client
            .from('orders')
            .insert({
              'user_id': userId,
              'address_id': addressId,
              'order_number': orderNumber,
              'order_status': 'pending',
              'payment_status': 'unpaid',
              'delivery_status': 'pending',
              'subtotal': total,
              'grand_total': total,
            })
            .select()
            .single();

        for (final item in items) {
          final variantId = await _resolveVariantId(item.product.id);
          if (variantId == null) {
            throw Exception('Variant produk belum tersedia untuk ${item.product.name}.');
          }
          await client.from('order_items').insert({
            'order_id': order['id'],
            'product_id': item.product.id,
            'variant_id': variantId,
            'product_name': item.product.name,
            'variant_name': item.product.volume,
            'quantity': item.quantity,
            'unit_price': item.product.priceValue,
            'total_price': item.subtotal,
          });
        }

        return _mapOrder(order);
      } catch (_) {}
    }

    final order = OrderInfo(
      id: 'fallback-order-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      orderNumber: 'OFFLINE-${_fallback.orders.length + 1}',
      orderStatus: 'pending',
      paymentStatus: 'unpaid',
      deliveryStatus: 'pending',
      grandTotal: total,
      createdAt: DateTime.now(),
    );
    _fallback.orders.add(order);
    return order;
  }

  Future<List<OrderInfo>> getMyOrders(String userId) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('orders')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        return (response as List<dynamic>).map(_mapOrder).toList();
      } catch (_) {}
    }
    return _fallback.orders.where((item) => item.userId == userId).toList();
  }

  Future<OrderInfo?> getOrderDetail(String orderId) async {
    final client = _client;
    if (client != null) {
      try {
        final response =
            await client.from('orders').select().eq('id', orderId).maybeSingle();
        if (response != null) {
          return _mapOrder(response);
        }
      } catch (_) {}
    }

    for (final order in _fallback.orders) {
      if (order.id == orderId) {
        return order;
      }
    }
    return null;
  }

  Future<List<String>> getOrderTimeline(String orderId) async {
    final order = await getOrderDetail(orderId);
    if (order == null) {
      return const [];
    }
    return [
      'Order dibuat',
      'Status pesanan: ${order.orderStatus}',
      'Status pembayaran: ${order.paymentStatus}',
      'Status pengiriman: ${order.deliveryStatus}',
    ];
  }

  Future<void> cancelOrder(String orderId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('orders').update({'order_status': 'cancelled'}).eq('id', orderId);
        return;
      } catch (_) {}
    }
  }

  Future<List<OrderInfo>> adminGetOrders() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('orders')
            .select()
            .order('created_at', ascending: false);
        return (response as List<dynamic>).map(_mapOrder).toList();
      } catch (_) {}
    }
    return List<OrderInfo>.from(_fallback.orders);
  }

  Future<OrderInfo?> adminGetOrderDetail(String orderId) => getOrderDetail(orderId);

  Future<void> adminUpdateOrderStatus(String orderId, String orderStatus) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('orders').update({'order_status': orderStatus}).eq('id', orderId);
        return;
      } catch (_) {}
    }
  }

  Future<void> adminUpdateTrackingNumber(String orderId, String trackingNumber) async {
    final client = _client;
    if (client != null) {
      try {
        await client
            .from('orders')
            .update({'tracking_number': trackingNumber})
            .eq('id', orderId);
        return;
      } catch (_) {}
    }
  }

  Future<void> adminAssignCourier(String orderId, String courierId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('delivery_assignments').insert({
          'order_id': orderId,
          'courier_id': courierId,
          'status': 'assigned',
        });
        await client
            .from('orders')
            .update({'delivery_status': 'assigned'})
            .eq('id', orderId);
        return;
      } catch (_) {}
    }
  }

  Future<String?> _resolveVariantId(String productId) async {
    final variants = await _productRepository.getProductVariants(productId);
    if (variants.isEmpty) {
      return null;
    }
    return variants.first.id;
  }

  OrderInfo _mapOrder(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return OrderInfo(
      id: item['id'].toString(),
      userId: item['user_id'].toString(),
      orderNumber: (item['order_number'] ?? '').toString(),
      orderStatus: (item['order_status'] ?? '').toString(),
      paymentStatus: (item['payment_status'] ?? '').toString(),
      deliveryStatus: (item['delivery_status'] ?? '').toString(),
      grandTotal: (item['grand_total'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse((item['created_at'] ?? '').toString()) ??
          DateTime.now(),
      trackingNumber: item['tracking_number']?.toString(),
    );
  }
}
