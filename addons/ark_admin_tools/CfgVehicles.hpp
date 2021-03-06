class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ARK_Interaction {
                displayName = "ARK";
                runOnHover = 0;
                hotkey = "";
                exceptions[] = {"isNotInside"};
                condition = "true";
                statement = "";
                icon = "\x\ark\addons\ark_main\resources\ark_star.paa";

                class ARK_Category {
                    displayName = "ARK Client Action";
                    icon = "\x\ark\addons\ark_main\resources\ark_star.paa";
                    exceptions[] = {"isNotInside"};
                    condition = "true";
                    statement = "";
                };

                class ARK_Action {
                    displayName = "ARK Client Action";
                    icon = "\x\ark\addons\ark_main\resources\ark_star.paa";
                    exceptions[] = {"isNotInside"};
                    condition = "true";
                    statement = "";
                };
                class Map_Click_Teleport : ARK_Action {
                    displayName = "Click Map Teleport";
                    exceptions[] = {};
                    icon = "\x\ark\addons\ark_main\resources\click.paa";
                    condition = "ark_mapTeleportEnabled";
                    statement = "[player] call ark_admin_tools_fnc_enableMapTeleport;";
                };
                class Ammo_Drop : ARK_Action {
                    displayName = "Request Ammo Drop";
                    exceptions[] = {};
                    icon = "\A3\ui_f\data\map\vehicleicons\iconParachute_ca.paa";
                    condition = "([player] call ark_deploy_fnc_playerIsLeader) && !(player getVariable ['ark_ts_paradropInProgress', false]) && (getNumber(missionConfigFile >> 'TownSweep' >> 'isEnabled') == 1)";
                    statement = "[player] call ark_admin_tools_fnc_ammoDrop;";
                };
                class Unflip_Vehicle : ARK_Action {
                    displayName = "Unflip Vehicle";
                    icon = "\A3\ui_f\data\Map\VehicleIcons\pictureRepair_ca.paa";
                    condition = "(!(isNull objectParent player)) && ((speed (objectParent player)) isEqualTo 0) && ([objectParent player] call ark_admin_tools_fnc_canUnflip)";
                    statement = "[] call ark_admin_tools_fnc_unFlip;";
                };

                // Host Menu
                class Host_Actions : ARK_Category {
                    displayName = "Host Menu";
                    condition = "([] call ark_admin_tools_fnc_isHost) || (isServer && hasInterface)";

                    class Safety_Off : ARK_Action {
                        displayName = "Turn Safety Off";
                        condition = "!([] call hull3_mission_fnc_hasSafetyTimerEnded)";
                        showDisabled = 1;
                        statement = "[nil, nil, nil, ['confirm']] call compile preProcessFileLineNumbers 'x\ark\addons\hull3\mission_host_safetytimer_stop.sqf';";
                        icon = "\x\ark\addons\ark_main\resources\hull_disable.paa";
                    };

                    class Enable_AI_Debug : ARK_Action {
                        displayName = "Enable AI Debug";
                        condition = "!ark_aiDebugEnabled"; 
                        statement = "[] call ark_admin_tools_fnc_enableAiDebug;";
                        icon = "\x\ark\addons\ark_main\resources\ai_enable.paa";
                    };

                    class Disable_AI_Debug : ARK_Action {
                        displayName = "Disable AI Debug";
                        condition = "ark_aiDebugEnabled"; 
                        statement = "[] call ark_admin_tools_fnc_disableAiDebug;";
                        icon = "\x\ark\addons\ark_main\resources\ai_disable.paa";
                    };

                    class Enable_Click_Teleport : ARK_Action {
                        displayName = "Enable Global Click Teleport";
                        condition = "!ark_mapTeleportEnabled"; 
                        statement = "[true] call ark_admin_tools_fnc_assignMapTeleport;";
                        icon = "\x\ark\addons\ark_main\resources\click_enable.paa";
                    };

                    class Disable_Click_Teleport : ARK_Action {
                        displayName = "Disable Global Click Teleport";
                        condition = "ark_mapTeleportEnabled"; 
                        statement = "[false] call ark_admin_tools_fnc_assignMapTeleport;";
                        icon = "\x\ark\addons\ark_main\resources\click_disable.paa";
                    };

                    class Call_Attack_Helo : ARK_Action {
                        displayName = "Call Attack Helo";
                        condition = "[] call ark_admin_tools_fnc_isAdmiralEnabled && !([] call ark_admin_tools_fnc_isTownSweep)"; 
                        statement = "[player] remoteExecCall ['ark_admin_tools_fnc_callAttackHelo',2]";
                        icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\casheli_ca.paa";
                    };

                    class Call_Armour : ARK_Action {
                        displayName = "Call Attack Armour";
                        condition = "[] call ark_admin_tools_fnc_isAdmiralEnabled && !([] call ark_admin_tools_fnc_isTownSweep)"; 
                        statement = "[player] remoteExecCall ['ark_admin_tools_fnc_callArmour',2]";
                        icon = "\A3\ui_f\data\map\vehicleicons\iconTank_ca.paa";
                    };
                };
            };
        };
    };
};