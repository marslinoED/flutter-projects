import 'package:cosmic/screens/planetScreen/planet_screen.dart';
import 'package:cosmic/shared/app_theme.dart';
import 'package:cosmic/shared/component/components.dart';
import 'package:cosmic/shared/models/planets_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    PlanetModel planet = (planets..shuffle()).first;

    return Column(
      children: [
        SizedBox(
          height: 60, // Define a fixed height for the horizontal list
          child: ListView.separated(
            scrollDirection: Axis.horizontal, // Set to horizontal scrolling
            itemBuilder: (context, index) => _buildPlanetCard(planets[index], context),
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: planets.length,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(24),
          height: 265,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme().darkBG.withOpacity(0.7),
            borderRadius: BorderRadius.circular(50),
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.4),
                width: 3,
              ),
              right: BorderSide(color: Colors.black.withOpacity(0.4), width: 3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Random planet for you:", style: AppTheme().bodyMedium),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage(planet.image ?? 'assets/icons/planets/default.png'),
                      height: 80,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            planet.name ?? "name",
                            style: AppTheme().bodyMedium.copyWith(
                                  color: AppTheme().darkAccent,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            planet.description ?? "description",
                            style: AppTheme().bodySmall,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          TextButton(
                            onPressed: () {
                              navigateToBack(context, PlanetScreen(planet: planet));
                            },
                            child: Text(
                              'Read more',
                              style: AppTheme().bodyMedium.copyWith(
                                    color: AppTheme().darkAccent,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(24),
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme().darkBG.withOpacity(0.7),
            borderRadius: BorderRadius.circular(50),
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.4),
                width: 3,
              ),
              right: BorderSide(color: Colors.black.withOpacity(0.4), width: 3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Solar System:", style: AppTheme().bodyMedium),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    'The Solar System[c] is the gravitationally bound system of the Sun and the objects that orbit it. It formed 4.6 billion years ago from the gravitational collapse of a giant interstellar molecular cloud. The vast majority (99.86%) of the system\'s mass is in the Sun, with most of the remaining mass contained in the planet Jupiter. The four inner system planets—Mercury, Venus, Earth and Mars—are terrestrial planets, being composed primarily of rock and metal. The four giant planets of the outer system are substantially larger and more massive than the terrestrials. ',
                    style: AppTheme().bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanetCard(PlanetModel planet, context) {
    return InkWell(
      onTap: () {
        navigateToBack(context, PlanetScreen(planet: planet));
      },
      child: Container(
        height: 60,
        width: 140,
        decoration: BoxDecoration(
          color: AppTheme().darkBG.withOpacity(0.7),
          borderRadius: BorderRadius.circular(50),
          border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 3),
            right: BorderSide(color: Colors.black.withOpacity(0.4), width: 3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(planet.image ?? 'assets/icons/planets/default.png'),
              height: 30,
            ),
            const SizedBox(width: 8),
            Text(planet.name ?? "name", style: AppTheme().bodyMedium),
          ],
        ),
      ),
    );
  }
}