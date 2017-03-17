Assets = {} --It is necessary to define any Assets, before the function AddMinimapAndTurf() will be called (or use table.insert after call).

PrefabFiles = {} --It is necessary to define any Prefabs, before the function AddMinimapAndTurf() will be called (or use table.insert after call).
--Prefabs for an automatic generated turfs will be defined by tileadder.

----------------------------------------
--Start of tile adder. Copy this code to your modmain.lua for use.
modimport 'tileadder.lua'
AddMinimapAndTurf() --PostInit for minimap and terraformer
--End of tile adder
----------------------------------------
