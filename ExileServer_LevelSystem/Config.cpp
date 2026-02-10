class CfgPatches
{
    class exile_server_levelsystem
    {
        requiredVersion = 0.1;
        requiredAddons[] = {"exile_server"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions
{
    class exile_server_levelsystem
    {
        class bootstrap
        {
            file = "ExileServer_LevelSystem\bootstrap";
            class preInit { preInit = 1; };
            class postInit { postInit = 1; };
        };
    };
};