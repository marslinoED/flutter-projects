import 'package:cosmic/shared/app_theme.dart';
import 'package:cosmic/shared/component/components.dart';
import 'package:cosmic/shared/models/planets_model.dart';
import 'package:flutter/material.dart';

class PlanetScreen extends StatelessWidget {
  const PlanetScreen({super.key, required this.planet});

  final PlanetModel planet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildBody(context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(24),
            height: 150,
            child: Row(
              children: [
                circularButton(
                  Icon(Icons.arrow_back),
                  Colors.black,
                  () {
                    Navigator.pop(context);
                  },
                  backgroundColor: AppTheme().darkBG.withOpacity(0.7),
                ),
                Spacer(),
                circularButton(
                  Icon(Icons.person),
                  Colors.black,
                  () {},
                  backgroundColor: AppTheme().darkBG.withOpacity(0.7),
                ),
              ],
            ),
          ),
          Spacer(),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    height: 700,
                    decoration: BoxDecoration(
                      color: AppTheme().darkBG.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        top: BorderSide(
                          color: Colors.black.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 80),
                        Text(planet.name!, style: AppTheme().bodyExtraLarge),
                        SizedBox(height: 24),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildProb(
                                  Image(
                                    image: AssetImage(
                                      'assets/icons/properties/mass.png',
                                    ),
                                  ),
                                  'Mass\n(1024kg)',
                                  planet.mass!,
                                ),
                                _buildProb(
                                  Image(
                                    image: AssetImage(
                                      'assets/icons/properties/gravity.png',
                                    ),
                                  ),
                                  'Gravity\n(m/s2)',
                                  planet.gravity!,
                                ),
                                _buildProb(
                                  Image(
                                    image: AssetImage(
                                      'assets/icons/properties/day.png',
                                    ),
                                  ),
                                  'Day\n(hours)',
                                  planet.day!,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildProb(
                                  Image(
                                    image: AssetImage(
                                      'assets/icons/properties/velocity.png',
                                    ),
                                  ),
                                  'Esc. Velocity\n(km/s)',
                                  planet.velocity!,
                                ),
                                _buildProb(
                                  Image(
                                    image: AssetImage(
                                      'assets/icons/properties/temp.png',
                                    ),
                                  ),
                                  'Mean\nTemp (C)',
                                  planet.temperature!,
                                ),
                                _buildProb(
                                  Image(
                                    image: AssetImage(
                                      'assets/icons/properties/distance.png',
                                    ),
                                  ),
                                  'Distance from\nSun (106 km)',
                                  planet.distanceToSun!,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(planet.description!, style: AppTheme().bodyMedium.copyWith(fontWeight: FontWeight.normal), textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Image(image: AssetImage(planet.image!)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProb(icon, String stringUnit, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 20),
        Text(
          stringUnit,
          style: AppTheme().bodyMedium.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 20),
        Text(
          value.toString(),
          style: AppTheme().bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ],
    );
  }
}
