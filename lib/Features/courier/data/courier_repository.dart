import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class CourierRepository {
  CourierRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<DeliveryInfo>> getAssignedDeliveries(String courierId) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('delivery_assignments')
            .select('id,order_id,courier_id,status,orders:order_id(order_number)')
            .eq('courier_id', courierId)
            .order('assigned_at', ascending: false);
        return (response as List<dynamic>).map(_mapDelivery).toList();
      } catch (_) {}
    }
    return _fallback.deliveries.where((item) => item.courierId == courierId).toList();
  }

  Future<DeliveryInfo?> getDeliveryDetail(String deliveryId) async {
    final items = await getAssignedDeliveries('demo-courier');
    for (final item in items) {
      if (item.id == deliveryId) {
        return item;
      }
    }
    return null;
  }

  Future<void> updateDeliveryStatus(String deliveryId, String status) async {
    final client = _client;
    if (client != null) {
      try {
        await client
            .from('delivery_assignments')
            .update({'status': status})
            .eq('id', deliveryId);
        return;
      } catch (_) {}
    }
  }

  Future<String?> uploadDeliveryProof(String deliveryId, List<int> bytes) async {
    final client = _client;
    if (client != null) {
      try {
        final path = '$deliveryId/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await client
            .storage
            .from('delivery-proofs')
            .uploadBinary(path, Uint8List.fromList(bytes));
        return client.storage.from('delivery-proofs').getPublicUrl(path);
      } catch (_) {}
    }
    return null;
  }

  DeliveryInfo _mapDelivery(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    String? orderNumber;
    final order = item['orders'];
    if (order is Map<String, dynamic>) {
      orderNumber = order['order_number']?.toString();
    }
    return DeliveryInfo(
      id: item['id'].toString(),
      orderId: item['order_id'].toString(),
      courierId: item['courier_id'].toString(),
      status: (item['status'] ?? '').toString(),
      orderNumber: orderNumber,
    );
  }
}
