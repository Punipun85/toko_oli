import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class VehicleRepository {
  VehicleRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<VehicleInfo>> getMyVehicles(String userId) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('vehicle_profiles')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        return (response as List<dynamic>).map(_mapVehicle).toList();
      } catch (_) {}
    }
    return _fallback.vehicles.where((item) => item.userId == userId).toList();
  }

  Future<void> createVehicle(VehicleInfo vehicle) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('vehicle_profiles').insert({
          'user_id': vehicle.userId,
          'name': vehicle.name,
          'vehicle_type': vehicle.vehicleType,
          'brand': vehicle.brand,
          'model': vehicle.model,
          'engine_type': vehicle.engineType,
        });
        return;
      } catch (_) {}
    }
    _fallback.vehicles.add(vehicle);
  }

  Future<void> updateVehicle(VehicleInfo vehicle) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('vehicle_profiles').update({
          'name': vehicle.name,
          'vehicle_type': vehicle.vehicleType,
          'brand': vehicle.brand,
          'model': vehicle.model,
          'engine_type': vehicle.engineType,
        }).eq('id', vehicle.id);
        return;
      } catch (_) {}
    }
  }

  Future<void> deleteVehicle(String id) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('vehicle_profiles').delete().eq('id', id);
        return;
      } catch (_) {}
    }
    _fallback.vehicles.removeWhere((item) => item.id == id);
  }

  VehicleInfo _mapVehicle(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return VehicleInfo(
      id: item['id'].toString(),
      userId: item['user_id'].toString(),
      name: (item['name'] ?? '').toString(),
      vehicleType: (item['vehicle_type'] ?? '').toString(),
      brand: item['brand']?.toString(),
      model: item['model']?.toString(),
      engineType: item['engine_type']?.toString(),
    );
  }
}
