class PlanetModel {
  final String? name;
  final String? description;
  final String? image;
  final double? mass;
  final double? gravity;
  final double? day;
  final double? velocity;
  final double? temperature;
  final double? distanceToSun;
  final bool? isFavorite;

  PlanetModel({
    required this.name,
    required this.description,
    required this.image,
    required this.mass,
    required this.gravity,
    required this.day,
    required this.velocity,
    required this.temperature,
    required this.distanceToSun,
    required this.isFavorite,
  });

  factory PlanetModel.fromJson(Map<String, dynamic> json) {
    return PlanetModel(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      mass: json['mass'],
      gravity: json['gravity'],
      day: json['day'],
      velocity: json['velocity'],
      temperature: json['temperature'],
      distanceToSun: json['distanceToSun'],
      isFavorite: json['isFavorite'],
    );
  }
}

List<PlanetModel> planets = [
  PlanetModel.fromJson({
    "name": "Mercury",
    "description":
        "Mercury is the smallest planet in our solar system and the closest to the Sun. It has a thin atmosphere and experiences extreme temperature fluctuations. A day on Mercury lasts longer than its year. Due to its proximity to the Sun, it is difficult to observe. The planet has a heavily cratered surface similar to the Moon.",
    "image": "assets/icons/planets/mercury.png",
    "mass": 0.330,
    "gravity": 3.7,
    "day": 4222.6,
    "velocity": 47.4,
    "temperature": 167.0,
    "distanceToSun": 57.9,
    "isFavorite": false,
  }),
  PlanetModel.fromJson({
    "name": "Venus",
    "description":
        "Venus is the second planet from the Sun and is often called Earth's twin due to its similar size. It has a thick, toxic atmosphere that traps heat, making it the hottest planet. Venus rotates in the opposite direction of most planets. Its surface is covered in volcanic plains and mountains. The planet experiences a runaway greenhouse effect.",
    "image": "assets/icons/planets/venus.png",
    "mass": 4.87,
    "gravity": 8.9,
    "day": 2802.0,
    "velocity": 35.0,
    "temperature": 464.0,
    "distanceToSun": 108.2,
    "isFavorite": false,
  }),
  PlanetModel.fromJson({
    "name": "Earth",
    "description":
        "Earth is the third planet from the Sun and the only known place in the universe to support life. It has a diverse climate, vast oceans, and a protective atmosphere. Earth's magnetic field shields it from harmful solar radiation. The planet has active plate tectonics that shape its landscape. It is home to millions of species, including humans.",
    "image": "assets/icons/planets/earth.png",
    "mass": 5.97,
    "gravity": 9.8,
    "day": 24.0,
    "velocity": 29.8,
    "temperature": 15.0,
    "distanceToSun": 149.6,
    "isFavorite": true,
  }),
  PlanetModel.fromJson({
    "name": "Mars",
    "description":
        "Mars, also known as the Red Planet, is the fourth planet from the Sun. Its reddish appearance comes from iron oxide on its surface. It has the largest volcano in the solar system, Olympus Mons. Mars has polar ice caps made of water and carbon dioxide. Scientists believe Mars once had liquid water, raising the possibility of past life.",
    "image": "assets/icons/planets/mars.png",
    "mass": 0.642,
    "gravity": 3.7,
    "day": 24.6,
    "velocity": 24.1,
    "temperature": -65.0,
    "distanceToSun": 227.9,
    "isFavorite": false,
  }),
  PlanetModel.fromJson({
    "name": "Jupiter",
    "description":
        "Jupiter is the largest planet in the solar system and is primarily made of gas. It has a Great Red Spot, a massive storm that has lasted for centuries. Jupiter has at least 79 known moons, including the four largest: Io, Europa, Ganymede, and Callisto. Its strong magnetic field is the most powerful of any planet. The planet's swirling clouds and bands create a striking appearance.",
    "image": "assets/icons/planets/jupiter.png",
    "mass": 1898.0,
    "gravity": 24.8,
    "day": 9.9,
    "velocity": 13.1,
    "temperature": -110.0,
    "distanceToSun": 778.5,
    "isFavorite": false,
  }),
  PlanetModel.fromJson({
    "name": "Saturn",
    "description":
        "Saturn is the sixth planet from the Sun and is well known for its extensive ring system. The rings are made of countless ice and rock particles. Saturn has over 80 moons, including Titan, which has a thick atmosphere. It is a gas giant composed mainly of hydrogen and helium. The planet has strong winds and storms in its atmosphere.",
    "image": "assets/icons/planets/saturn.png",
    "mass": 568.0,
    "gravity": 10.4,
    "day": 10.7,
    "velocity": 9.7,
    "temperature": -140.0,
    "distanceToSun": 1434.0,
    "isFavorite": false,
  }),
  PlanetModel.fromJson({
    "name": "Uranus",
    "description":
        "Uranus is an ice giant that rotates on its side, a unique feature among planets. Its atmosphere contains methane, giving it a pale blue color. Uranus has faint rings and at least 27 moons. The planet's extreme axial tilt causes its seasons to last for decades. It was the first planet discovered using a telescope in modern times.",
    "image": "assets/icons/planets/uranus.png",
    "mass": 86.8,
    "gravity": 8.7,
    "day": 17.2,
    "velocity": 6.8,
    "temperature": -195.0,
    "distanceToSun": 2871.0,
    "isFavorite": false,
  }),
  PlanetModel.fromJson({
    "name": "Neptune",
    "description":
        "Neptune is the eighth and farthest planet from the Sun. It has the strongest winds in the solar system, reaching supersonic speeds. Neptune's deep blue color comes from methane in its atmosphere. The planet has 14 known moons, including Triton, which orbits in the opposite direction of Neptune's rotation.",
    "image": "assets/icons/planets/neptune.png",
    "mass": 102.0,
    "gravity": 11.0,
    "day": 16.1,
    "velocity": 5.4,
    "temperature": -200.0,
    "distanceToSun": 4495.0,
    "isFavorite": false,
  }),
];
