class PlannerActivity {
  String time;
  String activity;
  String location;

  PlannerActivity({
    required this.time,
    required this.activity,
    required this.location,
  });
}

class PlannerItineraryDay {
  int day;
  String title;
  List<PlannerActivity> activities;

  PlannerItineraryDay({
    required this.day,
    required this.title,
    required this.activities,
  });
}

class PlannerCostItem {
  String category;
  String amount;

  PlannerCostItem({
    required this.category,
    required this.amount,
  });
}

class PlannerItineraryPlan {
  String title;
  String type; // budget, balanced, premium
  String totalCost;
  String duration;
  List<String> highlights;
  List<PlannerCostItem> costBreakdown;
  List<PlannerItineraryDay> itinerary;

  PlannerItineraryPlan({
    required this.title,
    required this.type,
    required this.totalCost,
    required this.duration,
    required this.highlights,
    required this.costBreakdown,
    required this.itinerary,
  });
}
