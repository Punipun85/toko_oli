import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class PromoRepository {
  PromoRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<PromoInfo>> getActivePromos() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('promos')
            .select()
            .eq('is_active', true)
            .order('created_at', ascending: false);
        return (response as List<dynamic>).map(_mapPromo).toList();
      } catch (_) {}
    }
    return List<PromoInfo>.from(_fallback.promos.where((item) => item.isActive));
  }

  Future<PromoInfo?> validateVoucher(String code) async {
    final promos = await getActivePromos();
    for (final promo in promos) {
      if (promo.code.toLowerCase() == code.trim().toLowerCase()) {
        return promo;
      }
    }
    return null;
  }

  Future<List<PromoInfo>> adminGetPromos() => getActivePromos();

  Future<void> adminCreatePromo(PromoInfo promo) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('promos').insert({
          'code': promo.code,
          'title': promo.title,
          'promo_type': 'percentage',
          'discount_value': promo.discountValue,
          'is_active': promo.isActive,
        });
        return;
      } catch (_) {}
    }
  }

  Future<void> adminUpdatePromo(PromoInfo promo) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('promos').update({
          'code': promo.code,
          'title': promo.title,
          'discount_value': promo.discountValue,
          'is_active': promo.isActive,
        }).eq('id', promo.id);
        return;
      } catch (_) {}
    }
  }

  Future<void> adminDeletePromo(String id) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('promos').delete().eq('id', id);
        return;
      } catch (_) {}
    }
  }

  PromoInfo _mapPromo(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return PromoInfo(
      id: item['id'].toString(),
      code: (item['code'] ?? '').toString(),
      title: (item['title'] ?? '').toString(),
      discountValue: (item['discount_value'] as num?)?.toDouble() ?? 0,
      isActive: item['is_active'] == true,
    );
  }
}
