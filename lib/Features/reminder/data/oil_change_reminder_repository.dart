import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class OilChangeReminderRepository {
  OilChangeReminderRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<OilChangeReminderInfo>> getMyReminders(String userId) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('oil_change_reminders')
            .select()
            .eq('user_id', userId)
            .order('next_change_date');
        return (response as List<dynamic>).map(_mapReminder).toList();
      } catch (_) {}
    }
    return _fallback.reminders.where((item) => item.userId == userId).toList();
  }

  Future<void> createReminder(OilChangeReminderInfo reminder) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('oil_change_reminders').insert({
          'user_id': reminder.userId,
          'vehicle_profile_id': reminder.vehicleProfileId,
          'next_change_date': reminder.nextChangeDate?.toIso8601String(),
          'next_change_odometer_km': reminder.nextChangeOdometerKm,
        });
        return;
      } catch (_) {}
    }
    _fallback.reminders.add(reminder);
  }

  Future<void> updateReminder(OilChangeReminderInfo reminder) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('oil_change_reminders').update({
          'next_change_date': reminder.nextChangeDate?.toIso8601String(),
          'next_change_odometer_km': reminder.nextChangeOdometerKm,
        }).eq('id', reminder.id);
        return;
      } catch (_) {}
    }
  }

  Future<void> deleteReminder(String id) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('oil_change_reminders').delete().eq('id', id);
        return;
      } catch (_) {}
    }
    _fallback.reminders.removeWhere((item) => item.id == id);
  }

  Future<Map<String, int>> adminGetReminderSummary() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client.from('oil_change_reminders').select('id,is_active');
        final list = response as List<dynamic>;
        return {
          'total': list.length,
          'active': list.where((item) => item['is_active'] == true).length,
        };
      } catch (_) {}
    }
    return {
      'total': _fallback.reminders.length,
      'active': _fallback.reminders.length,
    };
  }

  OilChangeReminderInfo _mapReminder(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return OilChangeReminderInfo(
      id: item['id'].toString(),
      userId: item['user_id'].toString(),
      vehicleProfileId: item['vehicle_profile_id'].toString(),
      nextChangeDate: item['next_change_date'] == null
          ? null
          : DateTime.tryParse(item['next_change_date'].toString()),
      nextChangeOdometerKm:
          (item['next_change_odometer_km'] as num?)?.toInt(),
    );
  }
}
