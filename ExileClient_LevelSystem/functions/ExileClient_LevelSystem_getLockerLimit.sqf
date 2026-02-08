/**
 * ExileClient_LevelSystem_getLockerLimit
 * Returns locker limit based on player level
 */

private ["_level", "_limit"];
_level = call ExileClient_LevelSystem_getLevel;

// Level-based locker limits
_limit = switch (true) do 
{
    case (_level >= 20): { 10000000 }; // 10 Million
    case (_level >= 18): { 8000000 };  // 8 Million
    case (_level >= 16): { 6000000 };  // 6 Million
    case (_level >= 14): { 4000000 };  // 4 Million
    case (_level >= 12): { 3000000 };  // 3 Million
    case (_level >= 10): { 2000000 };  // 2 Million
    case (_level >= 8):  { 1500000 };  // 1.5 Million
    case (_level >= 6):  { 1000000 };  // 1 Million (Config Base)
    case (_level >= 4):  { 500000 };   // 500k
    case (_level >= 2):  { 250000 };   // 250k
    default { 100000 };                 // 100k (Level 1)
};

_limit