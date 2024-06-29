
#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>
#include <vip_core>

public Plugin myinfo =
{
	name = "[VIP] No Fall Damage",
	author = "R1KO (skype: vova.andrienko1), optimized by -R3d RuSh.",
	version = "1.0.1"
};

static const char g_sFeature[] = "NoFallDamage";

public VIP_OnVIPLoaded()
{
	VIP_RegisterFeature(g_sFeature, BOOL);
}

public OnPluginStart()
{
	for (new i = 1; i <= MaxClients; ++i)
	{
		if (IsClientInGame(i)) OnClientPutInServer(i);
	}
	if (VIP_IsVIPLoaded())
	{
		VIP_OnVIPLoaded();
	}
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action:OnTakeDamage(iClient, &iAttacker, &inflictor, &Float:fDamage, &damagetype)
{
	if (damagetype & DMG_FALL && VIP_IsClientVIP(iClient) && VIP_IsClientFeatureUse(iClient, g_sFeature))
	{
		char sMapName[64];
		GetCurrentMap(sMapName, sizeof(sMapName));
		
		if (StrEqual(sMapName, "de_vertigo", false))
		{
			float fPos[3];
			GetClientAbsOrigin(iClient, fPos);

			const float vertigoFallThreshold = -500.0;

			if (fPos[2] < vertigoFallThreshold)
			{
				return Plugin_Continue;
			}
		}

		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public OnPluginEnd() 
{
	if (CanTestFeatures() && GetFeatureStatus(FeatureType_Native, "VIP_UnregisterFeature") == FeatureStatus_Available)
	{
		VIP_UnregisterFeature(g_sFeature);
	}
}