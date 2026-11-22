
class MockRooms {
  static const List<Map<String, dynamic>> rooms = [
    {
      'id': 'FENS G035',
      'building': 'Faculty of Engineering',
      'type': 'Classroom',
      'floor': 0,
      'capacity': 80,
      'attributes': ['POWER', 'ETHERNET', 'SEATS', 'BLACKBOARD'],
      'available': {
        'type': 'AVAILABLE',
        'until': '16:00',
      },
    },
    {
      'id': 'FMAN L014',
      'building': 'Faculty of Management',
      'floor': -1,
      'type': 'Lecture hall',
      'capacity': 90,
      'attributes': ['POWER', 'ETHERNET', 'CIRCULAR', 'NO_WINDOWS'],
      'available': {
        'type': 'CLAIMED',
        'until': null,
      },
    },
    {
      'id': 'FENS 1033',
      'building': 'Faculty of Engineering',
      'floor': 1,
      'type': 'Lab',
      'capacity': 60,
      'attributes': ['POWER', 'SEATS', 'LOCKED'],
      'available': {
        'type': 'RESERVED',
        'until': '16:00',
        'event': {
          'type': 'Class',
          'name': 'EE 321L',
          'instructors': ['Ayhan Bozkurt']
        }
      },
    },
  ];
}