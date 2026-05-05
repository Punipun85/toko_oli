import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class AddressRepository {
  AddressRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<AddressInfo>> getMyAddresses(String userId) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('addresses')
            .select()
            .eq('user_id', userId)
            .order('is_default', ascending: false);
        return (response as List<dynamic>).map(_mapAddress).toList();
      } catch (_) {}
    }
    return _fallback.addresses.where((item) => item.userId == userId).toList();
  }

  Future<void> createAddress(AddressInfo address) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('addresses').insert({
          'user_id': address.userId,
          'label': address.label,
          'recipient_name': address.recipientName,
          'phone': address.phone,
          'address_line1': address.addressLine1,
          'city': address.city,
          'province': address.province,
          'postal_code': address.postalCode,
          'is_default': address.isDefault,
        });
        return;
      } catch (_) {}
    }
    _fallback.addresses.add(address);
  }

  Future<void> updateAddress(AddressInfo address) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('addresses').update({
          'label': address.label,
          'recipient_name': address.recipientName,
          'phone': address.phone,
          'address_line1': address.addressLine1,
          'city': address.city,
          'province': address.province,
          'postal_code': address.postalCode,
          'is_default': address.isDefault,
        }).eq('id', address.id);
        return;
      } catch (_) {}
    }
  }

  Future<void> deleteAddress(String addressId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('addresses').delete().eq('id', addressId);
        return;
      } catch (_) {}
    }
    _fallback.addresses.removeWhere((item) => item.id == addressId);
  }

  Future<void> setDefaultAddress(String userId, String addressId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('addresses').update({'is_default': false}).eq('user_id', userId);
        await client.from('addresses').update({'is_default': true}).eq('id', addressId);
        return;
      } catch (_) {}
    }
    for (var i = 0; i < _fallback.addresses.length; i++) {
      final address = _fallback.addresses[i];
      if (address.userId == userId) {
        _fallback.addresses[i] = AddressInfo(
          id: address.id,
          userId: address.userId,
          label: address.label,
          recipientName: address.recipientName,
          phone: address.phone,
          addressLine1: address.addressLine1,
          city: address.city,
          province: address.province,
          postalCode: address.postalCode,
          isDefault: address.id == addressId,
        );
      }
    }
  }

  AddressInfo _mapAddress(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return AddressInfo(
      id: item['id'].toString(),
      userId: item['user_id'].toString(),
      label: (item['label'] ?? '').toString(),
      recipientName: (item['recipient_name'] ?? '').toString(),
      phone: (item['phone'] ?? '').toString(),
      addressLine1: (item['address_line1'] ?? '').toString(),
      city: (item['city'] ?? '').toString(),
      province: (item['province'] ?? '').toString(),
      postalCode: (item['postal_code'] ?? '').toString(),
      isDefault: item['is_default'] == true,
    );
  }
}
