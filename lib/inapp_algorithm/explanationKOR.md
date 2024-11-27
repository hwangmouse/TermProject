# AssignmentData.dart
### 데이터 세트:
  #### int numOfAssignment;
    과제를 식별하는 번호입니다.
  #### double currentRatio;
    현재 과제의 총 과제 비율에서의 비율입니다.
  #### double latePenalty;
    지각 제출을 허용하지 않는 경우 0.0입니다. 지각 제출을 허용하지만 최종 점수의 50%로 제한하는 경우 latePenalty는 0.5입니다.
  #### int isAlter;
    대체 과제(중간고사 또는 기말고사)인지 여부를 나타냅니다. 불리언 값처럼 작동하며, 식별을 위한 용도입니다.
    0 = 대체 아님, 1 = 중간고사, 2 = 기말고사
  #### DateTime deadline;
    과제 마감일입니다.
  #### DateTime recDeadline;
    예상 소요 기간이나 다른 일정을 고려하여 계산된 권장 마감일입니다.
  #### double expectedPeriod;
    과제를 완료하는 데 걸리는 예상 시간입니다.
  #### double importance;
    currentRatio, assignmentRatio, latePenalty를 사용하여 계산된 중요도입니다.
  #### int priority;
    subjectImportance, assignmentImportance, recDeadlineImportance를 사용하여 계산된 우선순위입니다.

### 함수들
#### calculateImportance()
    사용하는 변수: 
        SubjectData.dart의 assignmentRatio
        AssignmentData.dart의 currentRatio, latePenalty, isAlter

    assignmentImportance = 
    assignmentRatio * currentRatio + (1.0 - latePenalty)

    단, isAlter가 1 또는 2인 경우:
    assignmentImportance = midtermRatio 또는 finalRatio * 10;

    예상 중요도 범위는 (1.5 ~ 4.0)입니다.

#### calculateRecdeadline()
    사용하는 변수:
        AssignmentData.dart의 recDeadline
        AssignmentData.dart의 expectedPeriod
        CalenderData.dart의 scheduleDate
    
    기본적으로 recDeadline = deadline (변수 정의 시 설정)

    if recDeadline == scheduleDate
        recDeadline - 1일 (n일 일정은 n * 1일 일정으로 나뉩니다)
    
    if (recDeadline - expectedPeriod) < scheduleDate
        recDeadline = scheduleDate
        (과제의 예상 기간이 3일이고 마감일이 n일일 때, n-1일에 긴 일정이 있는 경우 recDeadline은 n-1로 설정됩니다)

# AssignmentImportance.dart
    기본적으로 recDeadline과 assignmentImportance를 계산하는 함수
    과제와 과목을 매칭하여 assignmentImportance를 계산합니다.

    calcImportance와 calcRecdeadline 함수를 호출합니다.

# CalenderDate.dart
### 데이터 세트:
  #### String scheduleName;
  #### DateTime scheduleDate;

# SubjectData.dart
### 데이터 세트:
  #### double midtermRatio;
    중간고사의 과목 전체 비율에서의 비율입니다.
  #### double finalRatio;
    기말고사의 과목 전체 비율에서의 비율입니다.
  #### double assignmentRatio;
    과제의 과목 전체 비율에서의 비율입니다.
  #### double attendanceRatio;
    출석의 과목 전체 비율에서의 비율입니다.

  위 4가지 비율의 합은 반드시 1.0이어야 합니다.
  #### int creditHours;
    과목의 학점을 설정합니다 (1, 2, 또는 3).
  #### bool isMajor;
    전공 여부를 나타냅니다.  
    계산 후 이 값은 (전공: 1.0, 비전공: 0.8)로 매칭됩니다.
  #### int preferenceLevel;
    사용자의 선호도를 나타내며, 범위는 1 ~ 5입니다.  
    계산 후 이 값은 (1: 0.8, 2: 0.85, 3: 0.9, 4: 0.95, 5: 1.0)로 매칭됩니다.
  #### double importance;
    creditHours, isMajor, assignmentRatio, preferenceLevel을 사용하여 계산됩니다.

### 함수
#### calculationImportance()
    사용하는 변수:
        SubjectData.dart의 creditHours, isMajor, assignmentRatio, preferenceLevel
    
    subjectImportance = 
    creditHours / maxCreditHours * 매칭된 isMajor + 매칭된 preferenceLevel + assignmentRatio * 4.0

    maxCreditHours는 3일 수 있습니다.
    
    매칭 테이블:
    isMajor가 true인 경우: double 1.0
    isMajor가 false인 경우: double 0.8

    preferenceLevel 1 : double 0.8
    preferenceLevel 2 : double 0.85
    preferenceLevel 3 : double 0.9
    preferenceLevel 4 : double 0.95
    preferenceLevel 5 : double 1.0

    예상 중요도 범위는 1.5 ~ 4.0입니다.

# SubjectImportance.dart
    SubjectData.calculationImportance()와 동일합니다.

# FinalPriority.dart
### calcDeadlineImportance()
    기본 중요도는 2.5입니다.
    과제의 마감일 - 현재 날짜가 3일 미만일 경우, 급격히 증가합니다.

    Importance += Importance * (1 - (남은 일 / 3)) * 3.0;

    3일 이상 남은 경우 중요도가 선형적으로 증가합니다.

    if (baseImportance < 2.5) {
      baseImportance = 2.5;
    }
    이 코드는 최소 중요도 값을 2.5로 고정하여 음수 중요도를 방지합니다.

    예상 중요도 범위는 2.5 ~ 8.0입니다.

    + 0-1 knapsack
    0-1 냅색 알고리즘이 과제를 선택하는 기준은 다음과 같습니다:

    데드라인 제한 내에서 가능한 과제만 고려됨: 각 과제의 expectedPeriod(예상 소요 시간)가 주어진 deadlineLimit(데드라인까지 남은 시간) 이내에 있어야 합니다.

    우선순위의 합을 최대화: 가능한 조합 중에서 priority(우선순위)의 합이 가장 큰 조합이 선택됩니다.

    선택된 과제는 우선순위가 +10 됩니다.

### calcPriority()
    최종 과제 우선순위는
    subject Importance + assignmentImportance + deadline Importance로 계산됩니다.

    예상 범위는 4.0 ~ 16.0입니다.
    
    요약:
        subject importance 범위 : 1.5 ~ 4.0
        assignment importance 범위 : 1.5 ~ 4.0
        deadline Importance 범위 : 2.5 ~ 8.0

        그러나 deadline 리마인더는 독립적으로 작동합니다!

# TaskQueue.dart
#### addTask()
    작업을 큐에 추가하고 우선순위가 높은 순서로 정렬합니다.

#### getNextTask()
    현재 큐를 출력한 후 다음 작업으로 이동합니다.
