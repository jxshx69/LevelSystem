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
    300000,  // Level 20 (Max Level)
	350000,   // Level 21
	400000	// Level 22
];

// XP Rewards for actions
ExileClientLevelSystemXPRewards = [
    ["AIKill", 50],
    ["PlayerKill", 200],
    ["Headshot", 50],
    ["VehicleKill", 100],
    ["Survival", 10],
    ["Trading", 1],
    ["Crafting", 25],
    ["Healing", 15],
    ["Revive", 100],
    ["MissionComplete", 500],
    ["ZombieKill", 10],           // Standard Zombie
    ["ZombieKillSlow", 5],        // Slow Zombie (Walker)
    ["ZombieKillMedium", 10],     // Medium Zombie (Runner)
    ["ZombieKillFast", 15],       // Fast Zombie (Sprinter)
    ["ZombieKillCrawler", 8],     // Crawler Zombie
    ["ZombieKillSpider", 12],     // Spider Zombie
    ["ZombieKillBoss", 100],      // Boss Zombie (Demon)
    ["ZombieKillSpecial", 50]     // Special Zombies
];

// Trader Discount per Level (in percent)
ExileClientLevelSystemTraderDiscount = [
    0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,40
];

// ========================================
// SPEED BOOST TABLE
// ========================================
ExileClientLevelSystemSpeedBoost = [
    1.0,   // Level 1  - Normal speed
    1.02,  // Level 2  - +2%
    1.04,  // Level 3  - +4%
    1.06,  // Level 4  - +6%
    1.08,  // Level 5  - +8%
    1.1,   // Level 6  - +10%
    1.12,  // Level 7  - +12%
    1.14,  // Level 8  - +14%
    1.16,  // Level 9  - +16%
    1.18,  // Level 10 - +18%
    1.2,   // Level 11 - +20%
    1.22,  // Level 12 - +22%
    1.24,  // Level 13 - +24%
    1.26,  // Level 14 - +26%
    1.28,  // Level 15 - +28%
    1.3,   // Level 16 - +30%
    1.32,  // Level 17 - +32%
    1.34,  // Level 18 - +34%
    1.36,  // Level 19 - +36%
    1.4    // Level 20 - +40%
];

// Heal Boost per Level (multiplier)
ExileClientLevelSystemHealBoost = [
    1.00,1.05,1.10,1.15,1.20,1.25,1.30,1.35,1.40,1.45,1.50,1.55,1.60,1.65,1.70,1.75,1.80,1.85,1.90,2.00
];

// Locker Limit per Level
ExileClientLevelSystemLockerLimit = [
    500000,1000000,1500000,2000000,2500000,3000000,3500000,4000000,4500000,5000000,5500000,6000000,6500000,7000000,7500000,8000000,8500000,9000000,10000000,15000000
];

// Container Limit per Level
ExileClientLevelSystemContainerLimit = [
    50000,75000,100000,150000,200000,250000,300000,400000,500000,650000,800000,1000000,1250000,1500000,1800000,2100000,2500000,3000000,4000000,5000000
];

// Display Settings
ExileClientLevelSystemShowNotifications = true;
ExileClientLevelSystemShowLevelUp = true;
ExileClientLevelSystemShowHUD = true;

true