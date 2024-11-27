# AssignmentData.dart
### The data sets:
  #### int numOfAssignment;
    just assignment indentifying number
  #### double currentRatio;
    current assignment's ratio of total assignment ratio
  #### double latePenalty;
    if do not allow late submit, then this will be 0.0. if it allow but late restriction is final score's 50%, then latepenalty is 0.5
  #### int isAlter;
    if such assignment is alter assignment (midterm exam or final exam). it operate like bool value, only for identifying
    0 = not a alter, 1 = midterm, 2 = final
  #### DateTime deadline;
    assignment deadline
  #### DateTime recDeadline;
    calculated recommended deadline by considering expectedPeriod or another schedules
  #### double expectedPeriod;
    Estimated time to complete the task
  #### double importance;
    calculated by currentRatio, assignmentRatio, latePenalty
  #### int priority;
    calculated by subjectImportance, assignmentImportance, recDeadlineImportance

### functions
#### calculateImportance()
    using variable : 
        assignmentRatio from SubjectData.dart
        currentRatio from AssignmentData.dart
        latePenalty from AssignmentData.dart
        isAlter from AssignmentData.dart

    assignmentImportance = 
    assignmentRatio * currentRatio + (1.0 - latePenalty)

    but if isAlter == 1  || is Alter == 2
    assignmentImportance = midtermRatio or finalRatio * 10;

    expected importance range is (1.5 ~ 4.0)

#### calculateRecdeadline()
    using variable :
        recDeadline from AssignmentData.dart
        expectedPeriod from AssignmentDate.dart
        scheduleDate from CalenderData.dart
    
    basically recDeadline = deadline (define at variable definition)

    if recDeadline == scheduleDate
        recDeadline - 1 day (n days schedule is seperated by n * 1 day schedules)
    
    if (redDeadline - expectedPeriod) < scheduleDate
        recDeadline = scheduleDate
        (if assignment's expected period is 3 days, Deadline is day n, but you have a long schedule at day n-1, recdeadline sets to n-1)



# AssignmentImportance.dart
    base function to calculate recDeadline and assignmentImportance
    it matches assignment - subject to calulate assignmentImportance

    and call calcImportance, calcRecdealine function


# CalenderDate.dart
### The data sets :
  #### String scheduleName;
  #### DateTime scheduleDate;


# SubjectData.dart
### The data sets :
  #### double midtermRatio;
    midterm exam's ratio of total subject's ratio
  #### double finalRatio;
    final exam's ratio of total subject's ratio
  #### double assignmentRatio;
    assignment's ratio of total subject's ratio
  #### double attendanceRatio;
    atendance's ratio of total subject's ratio

  upper 4 ratio's sum must be 1.0!!
  #### int creditHours;
    1, 2, or 3. just put credit hours of subject
  #### bool isMajor;
    major of not a major subject
    after calculation, this bool matches to (major : 1.0, not major : 0.8)
  #### int preferenceLevel;
    user's preference. the range is 1 ~ 5
    after calculation, this int matches to (1 : 0.8, 2 : 0.85, 3 : 0.9, 4 : 0.95, 5 : 1.0)
  #### double importance;
    calculate by creditHours, isMajor, assignmentRatio, preferenceLevel

### functions
#### calculationImportance()
    using variable :
        creditHours
        isMajor
        assignmentRatio
        preferenceLevel from SubjectData.dart
    
    subjectImportance = 
    creditHours / maxCreditHours * matched isMajor + matched preferenceLevel + assignmentRatio * 4.0

    maxCreditHours maybe 3
    
    matched Table : 
    isMajor true : double 1.0
    isMajor false : double 0.8

    preferenceLevel 1 : double 0.8
    preferenceLevel 2 : double 0.85 
    preferenceLevel 3 : double 0.9 
    preferenceLevel 4 : double 0.95 
    preferenceLevel 5 : double 1.0

    expected importance range is 1.5 ~ 4.0


# SubjectImportance.dart
    same as SubjectData.calculationImportance()


# FinalPriority.dart
### calcDeadlineImportance()
    The base importance is 2.5
    if the left day (assignment's deadline - current date) is less than 3 day,
    it is scaled suddenly

    Importance += Importance * (1 - (left days / 3)) * 3.0;

    if it left more than 3 day, its importance increase linearly

    if (baseImportance < 2.5) {
      baseImportance = 2.5;
    }
    This code means The minimum importance value is fixed at 2.5, and prevent negative importance.

    The expected range is 2.5 ~ 8.0

### calcPriority()
    The final assignment's priority will be
    subject Importance + assignmentImportance + deadline Importance

    expected range is 4.0 ~ 16.0
    
    Summary :
        subject importance range : 1.5 ~ 4.0
        assignment importance range : 1.5 ~ 4.0
        deadline Importance range : 2.5 ~ 8.0

        but the deadline reminder operate independently!


# TaskQueue.dart
#### addTask()
    push the task to queue
    and sort by priority's decreasing order

#### getNextTask()
    if print current queue, go to next