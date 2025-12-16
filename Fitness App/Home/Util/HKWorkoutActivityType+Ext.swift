//
//  HKWorkoutActivityType+Ext.swift
//  Fitness App
//
//  Created by Rahil Gandhi on 2025-12-10.
//

import HealthKit
import SwiftUI
import SwiftASN1


extension HKWorkoutActivityType {

    /*
     Simple mapping of available workout types to a human readable name.
     */
    var name: String {
        switch self {
        case .americanFootball:             return "American Football"
        case .archery:                      return "Archery"
        case .australianFootball:           return "Australian Football"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Basketball"
        case .bowling:                      return "Bowling"
        case .boxing:                       return "Boxing"
        case .climbing:                     return "Climbing"
        case .crossTraining:                return "Cross Training"
        case .curling:                      return "Curling"
        case .cycling:                      return "Cycling"
        case .dance:                        return "Dance"
        case .danceInspiredTraining:        return "Dance Inspired Training"
        case .elliptical:                   return "Elliptical"
        case .equestrianSports:             return "Equestrian Sports"
        case .fencing:                      return "Fencing"
        case .fishing:                      return "Fishing"
        case .functionalStrengthTraining:   return "Functional Strength Training"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gymnastics"
        case .handball:                     return "Handball"
        case .hiking:                       return "Hiking"
        case .hockey:                       return "Hockey"
        case .hunting:                      return "Hunting"
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Martial Arts"
        case .mindAndBody:                  return "Mind and Body"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports:                 return "Paddle Sports"
        case .play:                         return "Play"
        case .preparationAndRecovery:       return "Preparation and Recovery"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Running"
        case .sailing:                      return "Sailing"
        case .skatingSports:                return "Skating Sports"
        case .snowSports:                   return "Snow Sports"
        case .soccer:                       return "Soccer"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Stair Climbing"
        case .surfingSports:                return "Surfing Sports"
        case .swimming:                     return "Swimming"
        case .tableTennis:                  return "Table Tennis"
        case .tennis:                       return "Tennis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Traditional Strength Training"
        case .volleyball:                   return "Volleyball"
        case .walking:                      return "Walking"
        case .waterFitness:                 return "Water Fitness"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Water Sports"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"

        // iOS 10
        case .barre:                        return "Barre"
        case .coreTraining:                 return "Core Training"
        case .crossCountrySkiing:           return "Cross Country Skiing"
        case .downhillSkiing:               return "Downhill Skiing"
        case .flexibility:                  return "Flexibility"
        case .highIntensityIntervalTraining:    return "High Intensity Interval Training"
        case .jumpRope:                     return "Jump Rope"
        case .kickboxing:                   return "Kickboxing"
        case .pilates:                      return "Pilates"
        case .snowboarding:                 return "Snowboarding"
        case .stairs:                       return "Stairs"
        case .stepTraining:                 return "Step Training"
        case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
        case .wheelchairRunPace:            return "Wheelchair Run Pace"

        // iOS 11
        case .taiChi:                       return "Tai Chi"
        case .mixedCardio:                  return "Mixed Cardio"
        case .handCycling:                  return "Hand Cycling"

        // iOS 13
        case .discSports:                   return "Disc Sports"
        case .fitnessGaming:                return "Fitness Gaming"

        // Catch-all
        default:                            return "Other"
        }
    }
    
    var image: String {
        let symbolName: String

        switch self {

        // Sports
        case .americanFootball:   symbolName = "sportscourt"
        case .archery:            symbolName = "Archery"
        case .baseball:           symbolName = "figure.baseball"
        case .basketball:         symbolName = "figure.basketball"
        case .soccer:             symbolName = "figure.soccer"
        case .rugby:              symbolName = "sportscourt"
        case .lacrosse:           symbolName = "sportscourt"
        case .hockey:             symbolName = "sportscourt"
        case .volleyball:         symbolName = "figure.volleyball"
        case .tennis:             symbolName = "figure.tennis"
        case .tableTennis:        symbolName = "sportscourt"
        case .golf:               symbolName = "figure.golf"
        case .bowling:            symbolName = "figure.bowling"
        case .boxing:             symbolName = "figure.boxing"
        case .wrestling:          symbolName = "figure.wrestling"
        case .martialArts:        symbolName = "figure.martial.arts"
        case .handball:           symbolName = "sportscourt"
        case .squash:             symbolName = "sportscourt"
        case .racquetball:        symbolName = "sportscourt"
        case .discSports:         symbolName = "sportscourt"

        // Cardio / movement
        case .running:            symbolName = "figure.run"
        case .walking:            symbolName = "figure.walk"
        case .hiking:             symbolName = "figure.hiking"
        case .cycling:            symbolName = "figure.outdoor.cycle"
        case .handCycling:        symbolName = "figure.hand.cycling"
        case .rowing:             symbolName = "figure.rower"
        case .elliptical:         symbolName = "figure.elliptical"
        case .stairClimbing,
             .stairs:             symbolName = "figure.stairs"
        case .jumpRope:           symbolName = "figure.jumprope"

        // Water
        case .swimming:           symbolName = "figure.pool.swim"
        case .waterPolo:          symbolName = "sportscourt"
        case .waterSports,
             .sailing:            symbolName = "drop.wave"
        case .waterFitness:       symbolName = "figure.water.fitness"
        case .surfingSports:      symbolName = "wave.3.right"

        // Fitness / training
        case .traditionalStrengthTraining,
             .functionalStrengthTraining:
                                    symbolName = "dumbbell"
        case .crossTraining,
             .mixedMetabolicCardioTraining,
             .mixedCardio:
                                    symbolName = "figure.highintensity.intervaltraining"
        case .highIntensityIntervalTraining:
                                    symbolName = "figure.highintensity.intervaltraining"
        case .coreTraining:       symbolName = "figure.core.training"
        case .flexibility:        symbolName = "figure.flexibility"
        case .pilates:            symbolName = "figure.pilates"
        case .yoga:               symbolName = "figure.yoga"
        case .barre:              symbolName = "figure.barre"
        case .taiChi:             symbolName = "figure.taichi"
        case .mindAndBody:        symbolName = "figure.mind.and.body"
        case .preparationAndRecovery:
                                    symbolName = "heart.text.square"

        // Winter / outdoor
        case .snowSports,
             .snowboarding,
             .crossCountrySkiing,
             .downhillSkiing:
                                    symbolName = "snowflake"
        case .skatingSports:      symbolName = "figure.skating"

        // Misc
        case .dance,
             .danceInspiredTraining:
                                    symbolName = "music.note.list"
        case .play:               symbolName = "gamecontroller"
        case .fitnessGaming:      symbolName = "gamecontroller.fill"
        case .hunting,
             .fishing:            symbolName = "scope"
        case .equestrianSports:   symbolName = "figure.equestrian"

        // Accessibility
        case .wheelchairWalkPace: symbolName = "figure.roll"
        case .wheelchairRunPace:  symbolName = "figure.roll.runningpace"

        // Fallback
        default:                  symbolName = "figure.walk"
        }

        return symbolName
    }
    

    var color: Color {
        let defaultColor = Color.black
        switch self {
        case .americanFootball,
             .rugby,
             .lacrosse,
             .hockey,
             .handball,
             .squash,
             .racquetball,
             .discSports:
            return Color.brown

        case .baseball,
             .softball:
            return Color.red

        case .basketball:
            return Color.orange

        case .soccer:
            return Color.green

        case .tennis,
             .tableTennis:
            return Color.yellow
            

        case .volleyball:
            return Color.pink

        case .golf:
            return Color.mint

        case .boxing,
             .wrestling,
             .martialArts:
            return Color.red

        case .running,
             .walking,
             .hiking:
            return Color.blue

        case .cycling,
             .handCycling:
            return Color.teal

        case .rowing,
             .elliptical,
             .stairClimbing,
             .stairs:
            return Color.indigo

        case .jumpRope:
            return Color.purple

        case .swimming,
             .waterPolo,
             .waterFitness:
            return Color.cyan

        case .surfingSports,
             .waterSports,
             .sailing:
            return Color.blue.opacity(0.8)

        case .traditionalStrengthTraining,
             .functionalStrengthTraining:
            return Color.gray

        case .crossTraining,
             .mixedMetabolicCardioTraining,
             .mixedCardio,
             .highIntensityIntervalTraining:
            return Color.red.opacity(0.8)

        case .coreTraining:
            return Color.purple

        case .flexibility:
            return Color.green.opacity(0.7)

        case .pilates,
             .yoga,
             .taiChi,
             .mindAndBody:
            return Color.indigo.opacity(0.8)

        case .barre:
            return Color.pink.opacity(0.8)

        case .preparationAndRecovery:
            return Color.green

        case .snowSports,
             .snowboarding,
             .crossCountrySkiing,
             .downhillSkiing,
             .skatingSports:
            return Color.cyan.opacity(0.8)

        case .dance,
             .danceInspiredTraining:
            return Color.purple.opacity(0.8)

        case .play,
             .fitnessGaming:
            return Color.orange.opacity(0.9)

        case .hunting,
             .fishing:
            return Color.brown.opacity(0.8)

        case .equestrianSports:
            return Color.brown

        case .wheelchairWalkPace,
             .wheelchairRunPace:
            return Color.blue.opacity(0.7)

        default:
            return Color.gray
        }
    }



}

