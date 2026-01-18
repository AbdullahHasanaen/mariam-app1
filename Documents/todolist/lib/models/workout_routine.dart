/// Workout routine model for Fitness Coach module
class WorkoutRoutine {
  final String id;
  final String name;
  final String level; // 'beginner', 'intermediate', 'advanced'
  final List<Exercise> exercises;
  final int durationMinutes;

  WorkoutRoutine({
    required this.id,
    required this.name,
    required this.level,
    required this.exercises,
    required this.durationMinutes,
  });
}

/// Exercise model within a workout routine
class Exercise {
  final String name;
  final String description;
  final int sets;
  final int reps;
  final int restSeconds;

  Exercise({
    required this.name,
    required this.description,
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });
}

/// Predefined workout routines
class WorkoutRoutines {
  static List<WorkoutRoutine> getAllRoutines() {
    return [
      // Beginner routines
      WorkoutRoutine(
        id: 'beginner_1',
        name: 'Full Body Beginner',
        level: 'beginner',
        durationMinutes: 20,
        exercises: [
          Exercise(
            name: 'Push-ups',
            description: 'Modified push-ups on knees',
            sets: 2,
            reps: 10,
            restSeconds: 30,
          ),
          Exercise(
            name: 'Bodyweight Squats',
            description: 'Basic squats with proper form',
            sets: 2,
            reps: 12,
            restSeconds: 30,
          ),
          Exercise(
            name: 'Plank',
            description: 'Hold plank position',
            sets: 2,
            reps: 1,
            restSeconds: 30,
          ),
          Exercise(
            name: 'Lunges',
            description: 'Alternating leg lunges',
            sets: 2,
            reps: 10,
            restSeconds: 30,
          ),
        ],
      ),
      WorkoutRoutine(
        id: 'beginner_2',
        name: 'Core Strength',
        level: 'beginner',
        durationMinutes: 15,
        exercises: [
          Exercise(
            name: 'Crunches',
            description: 'Basic abdominal crunches',
            sets: 3,
            reps: 15,
            restSeconds: 20,
          ),
          Exercise(
            name: 'Leg Raises',
            description: 'Lying leg raises',
            sets: 2,
            reps: 12,
            restSeconds: 30,
          ),
          Exercise(
            name: 'Plank Hold',
            description: 'Hold plank for time',
            sets: 2,
            reps: 1,
            restSeconds: 40,
          ),
        ],
      ),

      // Intermediate routines
      WorkoutRoutine(
        id: 'intermediate_1',
        name: 'Full Body Intermediate',
        level: 'intermediate',
        durationMinutes: 30,
        exercises: [
          Exercise(
            name: 'Push-ups',
            description: 'Standard push-ups',
            sets: 3,
            reps: 15,
            restSeconds: 45,
          ),
          Exercise(
            name: 'Jump Squats',
            description: 'Explosive jump squats',
            sets: 3,
            reps: 12,
            restSeconds: 45,
          ),
          Exercise(
            name: 'Plank to Push-up',
            description: 'Alternating plank to push-up position',
            sets: 3,
            reps: 10,
            restSeconds: 45,
          ),
          Exercise(
            name: 'Reverse Lunges',
            description: 'Reverse lunges with jump',
            sets: 3,
            reps: 12,
            restSeconds: 45,
          ),
          Exercise(
            name: 'Burpees',
            description: 'Full burpee movement',
            sets: 2,
            reps: 8,
            restSeconds: 60,
          ),
        ],
      ),
      WorkoutRoutine(
        id: 'intermediate_2',
        name: 'HIIT Cardio',
        level: 'intermediate',
        durationMinutes: 25,
        exercises: [
          Exercise(
            name: 'Mountain Climbers',
            description: 'Fast alternating knee drives',
            sets: 4,
            reps: 20,
            restSeconds: 30,
          ),
          Exercise(
            name: 'Jumping Jacks',
            description: 'Full jumping jacks',
            sets: 4,
            reps: 30,
            restSeconds: 30,
          ),
          Exercise(
            name: 'High Knees',
            description: 'Running in place with high knees',
            sets: 4,
            reps: 30,
            restSeconds: 30,
          ),
          Exercise(
            name: 'Burpees',
            description: 'Full burpee movement',
            sets: 3,
            reps: 10,
            restSeconds: 45,
          ),
        ],
      ),

      // Advanced routines
      WorkoutRoutine(
        id: 'advanced_1',
        name: 'Full Body Advanced',
        level: 'advanced',
        durationMinutes: 40,
        exercises: [
          Exercise(
            name: 'Diamond Push-ups',
            description: 'Close-grip diamond push-ups',
            sets: 4,
            reps: 15,
            restSeconds: 60,
          ),
          Exercise(
            name: 'Pistol Squats',
            description: 'Single-leg squats',
            sets: 3,
            reps: 8,
            restSeconds: 60,
          ),
          Exercise(
            name: 'Handstand Push-ups',
            description: 'Against wall or pike push-ups',
            sets: 3,
            reps: 8,
            restSeconds: 90,
          ),
          Exercise(
            name: 'Single-leg Deadlifts',
            description: 'Bodyweight single-leg deadlifts',
            sets: 3,
            reps: 12,
            restSeconds: 60,
          ),
          Exercise(
            name: 'Burpees with Push-up',
            description: 'Full burpee with push-up',
            sets: 4,
            reps: 12,
            restSeconds: 60,
          ),
        ],
      ),
      WorkoutRoutine(
        id: 'advanced_2',
        name: 'Core Power',
        level: 'advanced',
        durationMinutes: 35,
        exercises: [
          Exercise(
            name: 'Dragon Flags',
            description: 'Advanced core exercise',
            sets: 3,
            reps: 8,
            restSeconds: 90,
          ),
          Exercise(
            name: 'Hanging Leg Raises',
            description: 'Hanging or L-sit leg raises',
            sets: 4,
            reps: 12,
            restSeconds: 60,
          ),
          Exercise(
            name: 'Plank Variations',
            description: 'Side planks, reverse planks',
            sets: 4,
            reps: 1,
            restSeconds: 45,
          ),
          Exercise(
            name: 'Russian Twists',
            description: 'Weighted or advanced twists',
            sets: 4,
            reps: 20,
            restSeconds: 45,
          ),
        ],
      ),
    ];
  }

  static List<WorkoutRoutine> getRoutinesByLevel(String level) {
    return getAllRoutines().where((r) => r.level == level).toList();
  }
}
