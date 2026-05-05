import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class OilRecommendationRepository {
  OilRecommendationRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<OilRecommendationInfo>> getRecommendationByVehicle(
    String vehicleType, {
    String? brand,
    String? model,
  }) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('oil_recommendations')
            .select()
            .eq('vehicle_type', vehicleType)
            .eq('is_active', true)
            .order('priority', ascending: false);
        return (response as List<dynamic>).map(_mapItem).toList();
      } catch (_) {}
    }
    return _fallback.recommendations
        .where((item) => item.vehicleType == vehicleType)
        .toList();
  }

  Future<List<OilRecommendationInfo>> adminGetRecommendations() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('oil_recommendations')
            .select()
            .order('priority', ascending: false);
        return (response as List<dynamic>).map(_mapItem).toList();
      } catch (_) {}
    }
    return List<OilRecommendationInfo>.from(_fallback.recommendations);
  }

  Future<void> adminCreateRecommendation(OilRecommendationInfo item) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('oil_recommendations').insert({
          'vehicle_type': item.vehicleType,
          'engine_type': item.engineType,
          'vehicle_brand': item.vehicleBrand,
          'vehicle_model': item.vehicleModel,
          'product_id': item.productId,
          'notes': item.notes,
          'is_active': true,
        });
        return;
      } catch (_) {}
    }
  }

  Future<void> adminUpdateRecommendation(OilRecommendationInfo item) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('oil_recommendations').update({
          'vehicle_type': item.vehicleType,
          'engine_type': item.engineType,
          'vehicle_brand': item.vehicleBrand,
          'vehicle_model': item.vehicleModel,
          'product_id': item.productId,
          'notes': item.notes,
        }).eq('id', item.id);
        return;
      } catch (_) {}
    }
  }

  Future<void> adminDeleteRecommendation(String id) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('oil_recommendations').delete().eq('id', id);
        return;
      } catch (_) {}
    }
  }

  OilRecommendationInfo _mapItem(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return OilRecommendationInfo(
      id: item['id'].toString(),
      vehicleType: (item['vehicle_type'] ?? '').toString(),
      productId: item['product_id'].toString(),
      notes: (item['notes'] ?? '').toString(),
      engineType: item['engine_type']?.toString(),
      vehicleBrand: item['vehicle_brand']?.toString(),
      vehicleModel: item['vehicle_model']?.toString(),
    );
  }
}
