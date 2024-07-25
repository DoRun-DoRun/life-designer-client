final List<String> templateList = [
  "전체",
  "상쾌한 아침",
  "편안한 저녁",
  "자기계발",
  "건강 관리",
  "생산성",
  "마음 안정",
];

final Map<String, List<RoutineTemplate>> templateListRoutine = {
  "상쾌한 아침": [
    RoutineTemplate(
        name: "상쾌한 아침 시작",
        description:
            "이 루틴은 상쾌한 아침을 시작하기 위해 필요한 기본적인 활동들을 포함합니다. 기지개를 켜고 물을 마시는 등 간단하지만 효과적인 활동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(name: "기지개 켜기", emoji: "🧘", durationSecond: 300),
          SubRoutineTemplate(
              name: "물 한 컵 마시기", emoji: "💧", durationSecond: 180),
          SubRoutineTemplate(
              name: "깊은 호흡하기", emoji: "🌬️", durationSecond: 300),
          SubRoutineTemplate(name: "간단한 스트레칭", emoji: "🤸", durationSecond: 600)
        ]),
    RoutineTemplate(
        name: "활기찬 아침 운동",
        description:
            "이 루틴은 간단한 아침 운동으로 몸을 깨우고 활력을 불어넣습니다. 짧은 시간 안에 할 수 있는 쉽고 효과적인 운동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "간단한 요가", emoji: "🧘‍♀️", durationSecond: 600),
          SubRoutineTemplate(
              name: "가벼운 조깅", emoji: "🏃‍♂️", durationSecond: 1200),
          SubRoutineTemplate(name: "팔 굽혀 펴기", emoji: "💪", durationSecond: 300),
          SubRoutineTemplate(name: "플랭크", emoji: "🧍", durationSecond: 300)
        ]),
    RoutineTemplate(
        name: "상쾌한 아침 명상",
        description:
            "이 루틴은 아침에 명상과 마인드풀니스 활동을 통해 정신을 맑게 하고 하루를 차분하게 시작할 수 있게 도와줍니다.",
        subRoutines: [
          SubRoutineTemplate(name: "명상하기", emoji: "🧘", durationSecond: 600),
          SubRoutineTemplate(name: "긍정적 확언", emoji: "💬", durationSecond: 300),
          SubRoutineTemplate(
              name: "감사 일기 쓰기", emoji: "📓", durationSecond: 600),
          SubRoutineTemplate(name: "마음챙김 호흡", emoji: "🌬️", durationSecond: 300)
        ]),
    RoutineTemplate(
        name: "영양 가득한 아침 식사",
        description: "이 루틴은 건강하고 영양가 있는 아침 식사를 통해 하루를 에너지로 가득 채우는 것을 목표로 합니다.",
        subRoutines: [
          SubRoutineTemplate(name: "과일 준비하기", emoji: "🍎", durationSecond: 300),
          SubRoutineTemplate(
              name: "단백질 음료 만들기", emoji: "🥤", durationSecond: 300),
          SubRoutineTemplate(
              name: "건강한 시리얼 먹기", emoji: "🥣", durationSecond: 600),
          SubRoutineTemplate(
              name: "비타민 섭취", emoji: "💊", durationSecond: 2 * 60)
        ])
  ],
  "편안한 저녁": [
    RoutineTemplate(
        name: "편안한 저녁 시작",
        description:
            "이 루틴은 저녁 시간을 편안하게 시작하기 위한 기본적인 활동들을 포함합니다. 몸과 마음을 릴렉스 시키는 간단하지만 효과적인 활동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "편안한 스트레칭", emoji: "🧘", durationSecond: 600),
          SubRoutineTemplate(
              name: "따뜻한 차 한 잔 마시기", emoji: "🍵", durationSecond: 300),
          SubRoutineTemplate(
              name: "깊은 호흡하기", emoji: "🌬️", durationSecond: 300),
          SubRoutineTemplate(
              name: "편안한 음악 듣기", emoji: "🎶", durationSecond: 600)
        ]),
    RoutineTemplate(
        name: "저녁 독서 시간",
        description:
            "이 루틴은 저녁에 독서를 통해 마음을 진정시키고 하루를 마무리하는 데 도움을 줍니다. 집중력을 높이고, 스트레스를 줄이는 데 도움이 됩니다.",
        subRoutines: [
          SubRoutineTemplate(name: "독서하기", emoji: "📚", durationSecond: 1200),
          SubRoutineTemplate(
              name: "독서 노트 작성", emoji: "📝", durationSecond: 600),
          SubRoutineTemplate(
              name: "간단한 명상", emoji: "🧘‍♂️", durationSecond: 300),
          // SubRoutineTemplate(name: "간단한 명상", emoji: "🧘‍♂️", durationSecond: 5*60})
        ]),
    RoutineTemplate(
        name: "저녁 운동",
        description:
            "이 루틴은 저녁에 할 수 있는 가벼운 운동으로 구성되어 있어, 몸을 릴렉스하고 숙면을 준비하는 데 도움을 줍니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "가벼운 요가", emoji: "🧘‍♀️", durationSecond: 1200),
          SubRoutineTemplate(
              name: "간단한 스트레칭", emoji: "🤸", durationSecond: 600),
          SubRoutineTemplate(name: "명상하기", emoji: "🧘", durationSecond: 600),
          // SubRoutineTemplate(name: "명상하기", emoji: "🧘", durationSecond: 10*60})
        ]),
    RoutineTemplate(
        name: "편안한 취침 준비",
        description:
            "이 루틴은 편안한 수면을 위해 필요한 준비 활동들로 구성되어 있습니다. 저녁 시간에 몸과 마음을 릴렉스 시키고 숙면을 유도합니다.",
        subRoutines: [
          SubRoutineTemplate(name: "따뜻한 목욕", emoji: "🛁", durationSecond: 1200),
          SubRoutineTemplate(name: "스킨케어 루틴", emoji: "🧴", durationSecond: 600),
          SubRoutineTemplate(
              name: "감사 일기 쓰기", emoji: "📓", durationSecond: 600),
          SubRoutineTemplate(name: "마음챙김 호흡", emoji: "🌬️", durationSecond: 300)
        ])
  ],
  "자기계발": [
    RoutineTemplate(
        name: "효율적인 학습 루틴",
        description: "이 루틴은 효율적인 학습을 위한 방법들을 포함하고 있어, 매일 꾸준히 공부할 수 있도록 도와줍니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "공부 계획 세우기", emoji: "📝", durationSecond: 600),
          SubRoutineTemplate(
              name: "집중 타이머 설정", emoji: "⏲️", durationSecond: 2300),
          SubRoutineTemplate(name: "짧은 휴식", emoji: "☕", durationSecond: 300),
          SubRoutineTemplate(name: "복습하기", emoji: "📚", durationSecond: 1200)
        ]),
    RoutineTemplate(
        name: "직무 능력 향상",
        description:
            "이 루틴은 직장에서 필요한 능력을 향상시키기 위해 매일 할 수 있는 간단한 활동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "아침 뉴스 읽기", emoji: "📰", durationSecond: 600),
          SubRoutineTemplate(
              name: "새로운 기술 학습", emoji: "💻", durationSecond: 1200),
          SubRoutineTemplate(
              name: "업무 목표 설정", emoji: "🎯", durationSecond: 600),
          SubRoutineTemplate(name: "데스크 정리", emoji: "🗄️", durationSecond: 600)
        ]),
    RoutineTemplate(
        name: "자기 계발 및 휴식",
        description: "이 루틴은 자기 계발과 함께 휴식을 병행하여 균형 잡힌 삶을 추구하는 활동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(name: "독서하기", emoji: "📚", durationSecond: 1200),
          SubRoutineTemplate(
              name: "새로운 취미 시도", emoji: "🎨", durationSecond: 1200),
          SubRoutineTemplate(
              name: "명상 및 마음 정리", emoji: "🧘", durationSecond: 600),
          SubRoutineTemplate(name: "일기 쓰기", emoji: "📓", durationSecond: 600)
        ])
  ],
  "건강 관리": [
    RoutineTemplate(
        name: "아침 산책",
        description:
            "이 루틴은 매일 아침에 신선한 공기를 마시며 산책을 통해 건강을 증진하는 것을 목표로 합니다. 하루를 활기차게 시작할 수 있도록 도와줍니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "간단한 스트레칭", emoji: "🤸", durationSecond: 300),
          SubRoutineTemplate(name: "산책하기", emoji: "🚶", durationSecond: 1200),
          SubRoutineTemplate(name: "수분 보충", emoji: "💧", durationSecond: 300),
          // SubRoutineTemplate(name: "수분 보충", emoji: "💧", durationSecond: 5*60})
        ]),
    RoutineTemplate(
        name: "유산소 운동",
        description:
            "이 루틴은 매일 할 수 있는 간단한 유산소 운동을 통해 심혈관 건강을 증진하고 체력을 향상시키는 것을 목표로 합니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "가벼운 스트레칭", emoji: "🧘", durationSecond: 300),
          SubRoutineTemplate(name: "줄넘기", emoji: "🤸‍♂️", durationSecond: 600),
          SubRoutineTemplate(name: "자전거 타기", emoji: "🚴", durationSecond: 1200),
          SubRoutineTemplate(name: "깊은 호흡하기", emoji: "🌬️", durationSecond: 300)
        ]),
    RoutineTemplate(
        name: "전신 운동",
        description: "이 루틴은 전신 운동을 통해 근력과 유연성을 강화하고 체력을 향상시키는 것을 목표로 합니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "전신 스트레칭", emoji: "🤸‍♀️", durationSecond: 300),
          SubRoutineTemplate(name: "팔 굽혀 펴기", emoji: "💪", durationSecond: 600),
          SubRoutineTemplate(name: "스쿼트", emoji: "🏋️‍♂️", durationSecond: 600),
          SubRoutineTemplate(name: "플랭크", emoji: "🧍", durationSecond: 300),
          SubRoutineTemplate(
              name: "쿨다운 스트레칭", emoji: "🧘‍♂️", durationSecond: 300)
        ])
  ],
  "생산성": [
    RoutineTemplate(
        name: "아침 생산성 향상",
        description: "이 루틴은 하루를 효율적으로 시작하기 위해 아침에 생산성을 높이는 활동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(name: "간단한 운동", emoji: "🏃", durationSecond: 600),
          SubRoutineTemplate(name: "계획 세우기", emoji: "📝", durationSecond: 600),
          SubRoutineTemplate(name: "명상", emoji: "🧘", durationSecond: 600),
          SubRoutineTemplate(name: "아침 식사 준비", emoji: "🍳", durationSecond: 600)
        ]),
    RoutineTemplate(
        name: "업무 집중",
        description: "이 루틴은 업무 중 집중력을 높이고 생산성을 극대화하는 활동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "할 일 목록 작성", emoji: "📝", durationSecond: 600),
          SubRoutineTemplate(
              name: "타이머 설정 후 집중", emoji: "⏲️", durationSecond: 2300),
          SubRoutineTemplate(name: "짧은 휴식", emoji: "☕", durationSecond: 300),
          SubRoutineTemplate(name: "정리 및 정돈", emoji: "🗂️", durationSecond: 600)
        ]),
    RoutineTemplate(
      name: "저녁 정리",
      description: "이 루틴은 하루를 마무리하며 다음 날을 준비하고 정리하는 활동들로 구성되어 있습니다.",
      subRoutines: [
        SubRoutineTemplate(name: "할 일 목록 점검", emoji: "📝", durationSecond: 600),
        SubRoutineTemplate(name: "데스크 정리", emoji: "🗄️", durationSecond: 600),
        SubRoutineTemplate(name: "다음 날 계획", emoji: "📅", durationSecond: 600),
        SubRoutineTemplate(name: "명상 및 마음정리", emoji: "🧘", durationSecond: 600)
      ],
    ),
  ],
  "마음 안정": [
    RoutineTemplate(
        name: "마음 안정 명상",
        description:
            "이 루틴은 하루 중 마음을 진정시키고 스트레스를 해소하는 데 도움이 되는 명상 활동으로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(
              name: "깊은 호흡 명상", emoji: "🌬️", durationSecond: 600),
          SubRoutineTemplate(
              name: "마음챙김 명상", emoji: "🧘", durationSecond: 1200),
          SubRoutineTemplate(
              name: "감사 일기 작성", emoji: "📓", durationSecond: 600),
          SubRoutineTemplate(
              name: "편안한 음악 듣기", emoji: "🎶", durationSecond: 300)
        ]),
    RoutineTemplate(
        name: "저녁 리추얼",
        description: "이 루틴은 하루를 마무리하며 마음을 안정시키고 숙면을 준비하는 활동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(name: "따뜻한 목욕", emoji: "🛁", durationSecond: 1200),
          SubRoutineTemplate(
              name: "편안한 스트레칭", emoji: "🧘", durationSecond: 600),
          SubRoutineTemplate(
              name: "차 한 잔 마시기", emoji: "🍵", durationSecond: 300),
          SubRoutineTemplate(name: "독서", emoji: "📚", durationSecond: 600)
        ]),
    RoutineTemplate(
        name: "자연 속 힐링",
        description: "이 루틴은 자연 속에서 마음을 안정시키고 재충전하는 활동들로 구성되어 있습니다.",
        subRoutines: [
          SubRoutineTemplate(name: "산책", emoji: "🚶", durationSecond: 1200),
          SubRoutineTemplate(
              name: "자연 명상", emoji: "🧘‍♂️", durationSecond: 600),
          SubRoutineTemplate(
              name: "자연 소리 듣기", emoji: "🎧", durationSecond: 600),
          SubRoutineTemplate(name: "감사 일기 작성", emoji: "📓", durationSecond: 300)
        ])
  ],
};

class RoutineTemplate {
  final String name, description;
  final List<SubRoutineTemplate> subRoutines;

  RoutineTemplate(
      {required this.description,
      required this.name,
      required this.subRoutines});
}

class SubRoutineTemplate {
  final String name;
  final String emoji;
  final int durationSecond;

  SubRoutineTemplate({
    required this.name,
    required this.emoji,
    required this.durationSecond,
  });
}
