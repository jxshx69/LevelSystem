/*
    Level System Configuration
    Configure all level-related settings here
*/

// XP required for each level (exponential growth)
ExileClientLevelSystemXPTable = [
    0,      // Level 1
    1000,   // Level 2
    2500,   // Level 3
    5000,   // Level 4
    8000,   // Level 5
    12000,  // Level 6
    17000,  // Level 7
    23000,  // Level 8
    30000,  // Level 9
    40000,  // Level 10
    52000,  // Level 11
    66000,  // Level 12
    82000,  // Level 13
    100000, // Level 14
    120000, // Level 15
    145000, // Level 16
    175000, // Level 17
    210000, // Level 18
    250000, // Level 19
    300000  // Level 20 (Max Level)
];

// XP Rewards for actions
ExileClientLevelSystemXPRewards = [
    ["AIKill", 50],           // Killing AI
    ["PlayerKill", 200],      // Killing Player
    ["Headshot", 50],         // Bonus for headshot
    ["VehicleKill", 100],     // Destroying vehicle
    ["Survival", 10],         // Per 5 minutes alive
    ["Trading", 5],           // Per 1000 poptabs spent
    ["Crafting", 25],         // Per item crafted
    ["Healing", 15],          // Healing another player
    ["Revive", 100],          // Reviving a player
    ["MissionComplete", 500]  // Completing a mission
];

// Trader Discount per Level (in percent)
ExileClientLevelSystemTraderDiscount = [
    0,  // Level 1 - 0%
    2,  // Level 2 - 2%
    4,  // Level 3 - 4%
    6,  // Level 4 - 6%
    8,  // Level 5 - 8%
    10, // Level 6 - 10%
    12, // Level 7 - 12%
    14, // Level 8 - 14%
    16, // Level 9 - 16%
    18, // Level 10 - 18%
    20, // Level 11 - 20%
    22, // Level 12 - 22%
    24, // Level 13 - 24%
    26, // Level 14 - 26%
    28, // Level 15 - 28%
    30, // Level 16 - 30%
    32, // Level 17 - 32%
    34, // Level 18 - 34%
    36, // Level 19 - 36%
    40  // Level 20 - 40% Max Discount
];

// Speed Boost per Level (multiplier)
ExileClientLevelSystemSpeedBoost = [
    1.00, // Level 1 - Normal speed
    1.02, // Level 2
    1.04, // Level 3
    1.06, // Level 4
    1.08, // Level 5
    1.10, // Level 6
    1.12, // Level 7
    1.14, // Level 8
    1.16, // Level 9
    1.18, // Level 10
    1.20, // Level 11
    1.22, // Level 12
    1.24, // Level 13
    1.26, // Level 14
    1.28, // Level 15
    1.30, // Level 16
    1.32, // Level 17
    1.34, // Level 18
    1.36, // Level 19
    1.40  // Level 20 - 40% faster
];

// Heal Boost per Level (multiplier for heal speed)
ExileClientLevelSystemHealBoost = [
    1.00, // Level 1
    1.05, // Level 2
    1.10, // Level 3
    1.15, // Level 4
    1.20, // Level 5
    1.25, // Level 6
    1.30, // Level 7
    1.35, // Level 8
    1.40, // Level 9
    1.45, // Level 10
    1.50, // Level 11
    1.55, // Level 12
    1.60, // Level 13
    1.65, // Level 14
    1.70, // Level 15
    1.75, // Level 16
    1.80, // Level 17
    1.85, // Level 18
    1.90, // Level 19
    2.00  // Level 20 - 2x faster healing
];

// Locker (Bank) Money Limit per Level
ExileClientLevelSystemLockerLimit = [
    100000,   // Level 1 - 100k
    150000,   // Level 2 - 150k
    200000,   // Level 3 - 200k
    250000,   // Level 4 - 250k
    300000,   // Level 5 - 300k
    400000,   // Level 6 - 400k
    500000,   // Level 7 - 500k
    650000,   // Level 8 - 650k
    800000,   // Level 9 - 800k
    1000000,  // Level 10 - 1M
    1250000,  // Level 11 - 1.25M
    1500000,  // Level 12 - 1.5M
    1800000,  // Level 13 - 1.8M
    2100000,  // Level 14 - 2.1M
    2500000,  // Level 15 - 2.5M
    3000000,  // Level 16 - 3M
    3500000,  // Level 17 - 3.5M
    4000000,  // Level 18 - 4M
    5000000,  // Level 19 - 5M
    10000000  // Level 20 - 10M (Unlimited)
];

// Container Storage Limit per Level (in poptabs)
ExileClientLevelSystemContainerLimit = [
    50000,    // Level 1 - 50k
    75000,    // Level 2 - 75k
    100000,   // Level 3 - 100k
    150000,   // Level 4 - 150k
    200000,   // Level 5 - 200k
    250000,   // Level 6 - 250k
    300000,   // Level 7 - 300k
    400000,   // Level 8 - 400k
    500000,   // Level 9 - 500k
    650000,   // Level 10 - 650k
    800000,   // Level 11 - 800k
    1000000,  // Level 12 - 1M
    1250000,  // Level 13 - 1.25M
    1500000,  // Level 14 - 1.5M
    1800000,  // Level 15 - 1.8M
    2100000,  // Level 16 - 2.1M
    2500000,  // Level 17 - 2.5M
    3000000,  // Level 18 - 3M
    4000000,  // Level 19 - 4M
    5000000   // Level 20 - 5M
];

// Display Settings
ExileClientLevelSystemShowNotifications = true; // Show XP gain notifications
ExileClientLevelSystemShowLevelUp = true;       // Show level up notification
ExileClientLevelSystemShowHUD = true;           // Show level/XP in HUD

true