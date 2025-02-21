# Simulation Project

## Overview
This project simulates an evolving environment where agents interact with different terrain types, resources, and each other. Agents must manage hunger, hydration, and comfort while adapting to dynamic conditions.

## Features
- **Tile-based world** with various terrain types (grass, water, mountains, etc.).
- **Resource management**, including farming, building, and gathering.
- **Agent behavior** based on survival needs, movement, and signals.
- **Dynamic events** affecting the environment and resources.
- **Multiple scenarios** for testing AI strategies, including faction-based survival.

## Agent Mechanics
- Agents have **limited vision** and can only see within a set radius.
- They can **move, gather resources, build structures, and communicate** via signals.
- **Survival depends on maintaining hunger, hydration, and comfort levels.**

## Scenarios
- **Standard**: Randomly generated or hand-placed map with no restrictions.
- **Split**: Resources and water are separated, requiring strategic movement.
- **Factions**: Multiple AI-controlled factions with unique strategies compete or cooperate.

## Pathfinding
The project implements **efficient grid-based pathfinding techniques** for agent navigation.
