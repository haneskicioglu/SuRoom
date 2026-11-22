
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
    {
      'id': 'FASS 1076',
      'building': 'Faculty of Arts & Social Sciences',
      'floor': 1,
      'type': 'Large Classroom',
      'capacity': 72,
      'attributes': ['POWER', 'CIRCULAR', 'ETHERNET'],
      'available': {
        'type': 'RESERVED',
        'until': '17:00',
        'event': {
          'type': 'Exam',
          'name': 'CS305 Midterm Exam',
          'occupier': 'Hüsnü Yenigün'
        }
      },
    },
    {
      'id': 'UC G030',
      'building': 'University Center',
      'floor': 0,
      'type': 'Cinema Room',
      'capacity': 72,
      'attributes': ['NO_WINDOWS'],
      'available': {
        'type': 'RESERVED',
        'until': '20:00',
        'event': {
          'type': 'Club Event',
          'name': 'Movie Night',
          'occupier': 'Arda Dikbaş',
          'club': 'Pandora Sci-Fi & Fantasy Club (BKFK)'
        }
      },
    }
  ];
}