class CropBudgetTemplate {
  const CropBudgetTemplate({
    required this.id,
    required this.cropName,
    required this.category,
    required this.seedCostPerAcre,
    required this.fertilizerCostPerAcre,
    required this.pesticideCostPerAcre,
    required this.laborCostPerAcre,
    required this.expectedYieldBagsPerAcre,
    required this.yieldUnit,
    required this.defaultMarketPricePerUnit,
    required this.durationMonths,
    required this.aiAdvice,
  });

  final String id;
  final String cropName;
  final String category;
  final double seedCostPerAcre;
  final double fertilizerCostPerAcre;
  final double pesticideCostPerAcre;
  final double laborCostPerAcre;
  final double expectedYieldBagsPerAcre;
  final String yieldUnit;
  final double defaultMarketPricePerUnit;
  final int durationMonths;
  final String aiAdvice;

  double get totalCostPerAcre =>
      seedCostPerAcre +
      fertilizerCostPerAcre +
      pesticideCostPerAcre +
      laborCostPerAcre;
}

class CropPestDisease {
  const CropPestDisease({
    required this.id,
    required this.name,
    required this.crop,
    required this.type, // 'Ugonjwa' au 'Mwadudu'
    required this.severity, // 'Hatari kubwa', 'Kawaida', 'Wastani'
    required this.symptoms,
    required this.solutionChemical,
    required this.solutionOrganic,
    required this.preventionTip,
    required this.imageAsset,
  });

  final String id;
  final String name;
  final String crop;
  final String type;
  final String severity;
  final List<String> symptoms;
  final String solutionChemical;
  final String solutionOrganic;
  final String preventionTip;
  final String imageAsset;
}

class AgroDealer {
  const AgroDealer({
    required this.id,
    required this.name,
    required this.type, // 'Muuzaji Pembejeo' au 'Afisa Ugani'
    required this.region,
    required this.district,
    required this.phone,
    required this.location,
    required this.specialties,
    required this.verified,
  });

  final String id;
  final String name;
  final String type;
  final String region;
  final String district;
  final String phone;
  final String location;
  final List<String> specialties;
  final bool verified;
}

class FarmCalendarTask {
  const FarmCalendarTask({
    required this.id,
    required this.title,
    required this.crop,
    required this.dayOffset, // siku baada ya kupanda
    required this.description,
    required this.category, // 'Kupanda', 'Mbolea', 'Dawa', 'Palizi', 'Mavuno'
    this.completed = false,
  });

  final String id;
  final String title;
  final String crop;
  final int dayOffset;
  final String description;
  final String category;
  final bool completed;
}
