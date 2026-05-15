import '../models/planner_models.dart';

PlannerItineraryPlan getMockItineraryPlan(String type, bool isGroupTrip, String duration, String destination) {
  if (type == 'budget') {
    return PlannerItineraryPlan(
      title: 'Budget-Friendly Plan',
      type: 'budget',
      totalCost: isGroupTrip ? '₱4,500/person' : '₱4,500',
      duration: duration,
      highlights: [
        'Affordable accommodations with great reviews',
        'Local transportation and tricycle rides',
        'Street food and local restaurant dining',
        'Free or low-cost attractions and beaches',
      ],
      costBreakdown: [
        PlannerCostItem(category: 'Accommodation', amount: '₱1,500'),
        PlannerCostItem(category: 'Food & Dining', amount: '₱1,200'),
        PlannerCostItem(category: 'Transportation', amount: '₱800'),
        PlannerCostItem(category: 'Activities', amount: '₱700'),
      ],
      itinerary: [
        PlannerItineraryDay(
          day: 1,
          title: 'Arrival & Exploration',
          activities: [
            PlannerActivity(time: '09:00 AM', activity: 'Arrive and check-in', location: 'Budget hostel'),
            PlannerActivity(time: '11:00 AM', activity: 'Local market tour', location: 'Downtown market'),
          ],
        ),
        PlannerItineraryDay(
          day: 2,
          title: 'Adventure Day',
          activities: [
            PlannerActivity(time: '08:00 AM', activity: 'Hiking or nature walk', location: 'Local trail'),
            PlannerActivity(time: '12:00 PM', activity: 'Packed lunch picnic', location: 'Scenic viewpoint'),
          ],
        ),
      ],
    );
  } else if (type == 'premium') {
    return PlannerItineraryPlan(
      title: 'Premium Adventure',
      type: 'premium',
      totalCost: isGroupTrip ? '₱15,000/person' : '₱15,000',
      duration: duration,
      highlights: [
        'Luxury resort or boutique hotel stay',
        'Private transportation and transfers',
        'Fine dining and exclusive experiences',
        'Premium activities and guided tours',
      ],
      costBreakdown: [
        PlannerCostItem(category: 'Accommodation', amount: '₱6,500'),
        PlannerCostItem(category: 'Food & Dining', amount: '₱3,500'),
        PlannerCostItem(category: 'Transportation', amount: '₱2,000'),
        PlannerCostItem(category: 'Activities', amount: '₱2,500'),
      ],
      itinerary: [
        PlannerItineraryDay(
          day: 1,
          title: 'Luxury Arrival',
          activities: [
            PlannerActivity(time: '10:00 AM', activity: 'Resort check-in', location: '5-star resort'),
            PlannerActivity(time: '12:00 PM', activity: 'Gourmet lunch', location: 'Resort fine dining'),
          ],
        ),
      ],
    );
  } else {
    // Balanced
    return PlannerItineraryPlan(
      title: 'Balanced Experience',
      type: 'balanced',
      totalCost: isGroupTrip ? '₱8,500/person' : '₱8,500',
      duration: duration,
      highlights: [
        'Comfortable mid-range accommodations',
        'Mix of local and tourist transportation',
        'Variety of dining experiences',
        'Popular attractions and hidden gems',
      ],
      costBreakdown: [
        PlannerCostItem(category: 'Accommodation', amount: '₱3,000'),
        PlannerCostItem(category: 'Food & Dining', amount: '₱2,500'),
        PlannerCostItem(category: 'Transportation', amount: '₱1,500'),
        PlannerCostItem(category: 'Activities', amount: '₱1,200'),
      ],
      itinerary: [
        PlannerItineraryDay(
          day: 1,
          title: 'Welcome & Beach Time',
          activities: [
            PlannerActivity(time: '09:00 AM', activity: 'Hotel check-in', location: '3-star hotel'),
            PlannerActivity(time: '11:00 AM', activity: 'Welcome lunch', location: 'Hotel restaurant'),
          ],
        ),
      ],
    );
  }
}
