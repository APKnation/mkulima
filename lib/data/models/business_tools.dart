class AiChatMessage {
  const AiChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.attachedImage,
    this.suggestedActions,
    this.isLoading = false,
  });

  final String id;
  final String text;
  final bool isUser;
  final String timestamp;
  final String? attachedImage;
  final List<String>? suggestedActions;
  final bool isLoading;
}

class AgriReceipt {
  const AgriReceipt({
    required this.id,
    required this.receiptNumber,
    required this.customerName,
    required this.customerPhone,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalAmount,
    required this.paymentMethod, // 'M-Pesa', 'Tigo Pesa', 'Airtel Money', 'Taslimu'
    required this.date,
    required this.status, // 'Imelipwa', 'Deni'
  });

  final String id;
  final String receiptNumber;
  final String customerName;
  final String customerPhone;
  final String productName;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalAmount;
  final String paymentMethod;
  final String date;
  final String status;
}

class PriceWatchAlert {
  const PriceWatchAlert({
    required this.id,
    required this.cropName,
    required this.market,
    required this.targetPrice,
    required this.condition, // 'inapozidi', 'inapopungua'
    required this.currentPrice,
    required this.active,
  });

  final String id;
  final String cropName;
  final String market;
  final double targetPrice;
  final String condition;
  final double currentPrice;
  final bool active;
}

class LogisticsTransporter {
  const LogisticsTransporter({
    required this.id,
    required this.name,
    required this.vehicleType, // 'Fuso (Tani 7-10)', 'Canter (Tani 3-4)', 'Pickup / Kirikuu', 'Bodaboda / Guta'
    required this.phone,
    required this.baseRegion,
    required this.routes,
    required this.rateDescription,
    required this.rating,
    required this.verified,
  });

  final String id;
  final String name;
  final String vehicleType;
  final String phone;
  final String baseRegion;
  final List<String> routes;
  final String rateDescription;
  final double rating;
  final bool verified;
}

class AgriWarehouse {
  const AgriWarehouse({
    required this.id,
    required this.name,
    required this.type, // 'Ghala la Nafaka (Silage/Dry)', 'Hifadhi ya Baridi (Cold Storage)'
    required this.region,
    required this.district,
    required this.phone,
    required this.capacityBags,
    required this.pricePerBagPerMonth,
    required this.features,
    required this.verified,
  });

  final String id;
  final String name;
  final String type;
  final String region;
  final String district;
  final String phone;
  final int capacityBags;
  final double pricePerBagPerMonth;
  final List<String> features;
  final bool verified;
}
