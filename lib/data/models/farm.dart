class FarmTask {
  const FarmTask({
    required this.id,
    required this.title,
    required this.due,
    required this.type,
    this.done = false,
  });

  final String id;
  final String title;
  final String due;

  /// `umwagiliaji`, `chanjo`, `mbolea`, `mavuno`, `uondoaji` or `uuzaji`.
  final String type;
  final bool done;

  FarmTask copyWith({bool? done}) =>
      FarmTask(id: id, title: title, due: due, type: type, done: done ?? this.done);
}

class FarmActivity {
  const FarmActivity({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.note,
  });

  final String id;
  final String title;
  final String date;
  final String type;
  final String? note;
}

class FarmExpense {
  const FarmExpense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  final String id;
  final String title;
  final String category;
  final double amount;
  final String date;
}

/// The farmer's registered farm. A single farm keeps the MVP honest and simple;
/// the model is ready for multiple plots later.
class Farm {
  const Farm({
    required this.name,
    required this.region,
    required this.ward,
    required this.sizeHa,
    required this.crops,
    required this.livestock,
    required this.goal,
    required this.monthlySales,
    required this.tasks,
    required this.activities,
    required this.expenses,
    this.registered = true,
  });

  final String name;
  final String region;
  final String ward;
  final double sizeHa;
  final List<String> crops;
  final List<String> livestock;
  final String goal;
  final double monthlySales;
  final List<FarmTask> tasks;
  final List<FarmActivity> activities;
  final List<FarmExpense> expenses;
  final bool registered;

  double get totalExpenses =>
      expenses.fold(0, (sum, expense) => sum + expense.amount);

  double get estimatedProfit => monthlySales - totalExpenses;

  Farm copyWith({
    String? name,
    String? region,
    String? ward,
    double? sizeHa,
    List<String>? crops,
    List<String>? livestock,
    String? goal,
    double? monthlySales,
    List<FarmTask>? tasks,
    List<FarmActivity>? activities,
    List<FarmExpense>? expenses,
    bool? registered,
  }) {
    return Farm(
      name: name ?? this.name,
      region: region ?? this.region,
      ward: ward ?? this.ward,
      sizeHa: sizeHa ?? this.sizeHa,
      crops: crops ?? this.crops,
      livestock: livestock ?? this.livestock,
      goal: goal ?? this.goal,
      monthlySales: monthlySales ?? this.monthlySales,
      tasks: tasks ?? this.tasks,
      activities: activities ?? this.activities,
      expenses: expenses ?? this.expenses,
      registered: registered ?? this.registered,
    );
  }
}
