import 'package:cosmic/screens/planetScreen/planet_screen.dart';
import 'package:cosmic/shared/app_theme.dart';
import 'package:cosmic/shared/component/components.dart';
import 'package:cosmic/shared/models/planets_model.dart';
import 'package:flutter/material.dart';

class PlanetsScreen extends StatelessWidget {
  const PlanetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemBuilder:
            (context, index) => _buildPlanetCard(planets[index], context),
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemCount: planets.length,
      ),
    );
  }

  Widget _buildPlanetCard(PlanetModel planet, context) {
    return Container(
      margin: const EdgeInsets.all(24),
      height: 265,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme().darkBG.withOpacity(0.7),
        borderRadius: BorderRadius.circular(50),
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 3),
          right: BorderSide(color: Colors.black.withOpacity(0.4), width: 3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(
                    planet.image ?? 'assets/icons/planets/default.png',
                  ),
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
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                      ),
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
    );
  }
}
