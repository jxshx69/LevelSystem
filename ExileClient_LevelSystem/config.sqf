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
    ["AIKill", 50],
    ["PlayerKill", 200],
    ["Headshot", 50],
    ["VehicleKill", 100],
    ["Survival", 10],
    ["Trading", 5],
    ["Crafting", 25],
    ["Healing", 15],
    ["Revive", 100],
    ["MissionComplete", 500]
];

// Trader Discount per Level (in percent)
ExileClientLevelSystemTraderDiscount = [
    0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,40
];

// Speed Boost per Level (multiplier)
ExileClientLevelSystemSpeedBoost = [
    1.00,1.02,1.04,1.06,1.08,1.10,1.12,1.14,1.16,1.18,1.20,1.22,1.24,1.26,1.28,1.30,1.32,1.34,1.36,1.40
];

// Heal Boost per Level (multiplier)
ExileClientLevelSystemHealBoost = [
    1.00,1.05,1.10,1.15,1.20,1.25,1.30,1.35,1.40,1.45,1.50,1.55,1.60,1.65,1.70,1.75,1.80,1.85,1.90,2.00
];

// Locker Limit per Level
ExileClientLevelSystemLockerLimit = [
    100000,150000,200000,250000,300000,400000,500000,650000,800000,1000000,1250000,1500000,1800000,2100000,2500000,3000000,3500000,4000000,5000000,10000000
];

// Container Limit per Level
ExileClientLevelSystemContainerLimit = [
    50000,75000,100000,150000,200000,250000,300000,400000,500000,650000,800000,1000000,1250000,1500000,1800000,2100000,2500000,3000000,4000000,5000000
];

// Display Settings
ExileClientLevelSystemShowNotifications = true;
ExileClientLevelSystemShowLevelUp = true;
ExileClientLevelSystemShowHUD = true;

// Admin UIDs
ExileClientLevelSystemAdminUIDs = [
    "76561198219914629"
];

// ⚠️ NUR EINMAL TRUE AM ENDE! ⚠️
true