// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    _Subscription(
      id: json['id'] as String,
      name: json['name'] as String,
      amountPaise: (json['amountPaise'] as num).toInt(),
      currency: json['currency'] as String? ?? 'INR',
      billingCycle: $enumDecode(_$BillingCycleEnumMap, json['billingCycle']),
      nextBillingDate: DateTime.parse(json['nextBillingDate'] as String),
      categoryId: json['categoryId'] as String,
      reminderDaysBefore: (json['reminderDaysBefore'] as num?)?.toInt() ?? 2,
      colorHex: json['colorHex'] as String,
      notes: json['notes'] as String?,
      isPaused: json['isPaused'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$SubscriptionToJson(_Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amountPaise': instance.amountPaise,
      'currency': instance.currency,
      'billingCycle': _$BillingCycleEnumMap[instance.billingCycle]!,
      'nextBillingDate': instance.nextBillingDate.toIso8601String(),
      'categoryId': instance.categoryId,
      'reminderDaysBefore': instance.reminderDaysBefore,
      'colorHex': instance.colorHex,
      'notes': instance.notes,
      'isPaused': instance.isPaused,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

const _$BillingCycleEnumMap = {
  BillingCycle.weekly: 'weekly',
  BillingCycle.monthly: 'monthly',
  BillingCycle.quarterly: 'quarterly',
  BillingCycle.yearly: 'yearly',
};
