--------------------------------------------------------------------------------------------------------------------------------------
--Base code https://www.domotique-fibaro.fr/topic/14309-quickapp-remote-denon/
-- QuickApp Amplificateur Audio-Vidéo DENON AVR-X3200W
-- Commutateur binaire
-- HISTORIQUE
-- Adapté de https://www.domotique-fibaro.fr/topic/3263-telecommande-pour-marantz-sr6008-et-similaires-5008-7008-etc/?tab=comments#comment-46332
-- V3.2 (10/01/2015) Remote Marantz de SebcBien
-- HC3 Version:
-- V1.0 (14/05/2020) Remote Denon pour Home center 3 par fredokl et Maxime pour le site www.domotique-fibaro.fr
-- Utilistaion :
--      La connexion à l'amplifivateur Audio-Vidéo se fait par TELNET (port:23 par défaut)
--      Créer les variables "ip" & "port"
--      Ajouter les commandes que vous souhaitez dans la partie "RÉGLAGES UTILISATEUR"
--      Toutes les modifications se font dans la partie "RÉGLAGES UTILISATEUR"
--      À l'excepter des noms des appareils que vous utilisez chez vous
--              ==> voir QuickApp:onDataReceived(data)
--                      ==> VOS APPAREILS ICI
-- Vous pouvez le modifier et l'améliorer à votre guise.
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--                                                      PARAMÈTRES UTILISATEUR                                                      --
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
QuickApp._VERSION = "1.0" 
function QuickApp:onInit()
    __TAG = "QA_"..plugin.mainDeviceId.."Marantz"
    self:trace("DEBUT ========================================================")
    self.ip = self:getVariable("ip")
    self.port = tonumber(self:getVariable("port"))
    self:setVariable("mute", "0")
    self:setVariable("eco", "0")
    self.sock = net.TCPSocket() -- création d'une instance TCPSocket
    self.isOn = false
    self.isconnected = false
    self:connect()    
    self.pollingTime = 1000*60 -- 1min
    self:refresh()
    
end
--------------------------------------------------------------------------------------------------------------------------------------
-- ON & OFF
--------------------------------------------------------------------------------------------------------------------------------------
function QuickApp:turnOn() self:debug("Turn On") self:sendCommand("PWON") self:getinfo() end
function QuickApp:uibtnonOnReleased(event) self:turnOn() end
function QuickApp:turnOff()self:debug("Turn off") self:sendCommand("PWSTANDBY") self:getinfo() end
function QuickApp:uibtnoffOnReleased(event) self:turnOff() end
function QuickApp:turnEight()self:debug("Tyigkghkghk") self:sendCommand("MSSMART1") self:getinfo() end

--------------------------------------------------------------------------------------------------------------------------------------
-- Boutons de volume
--------------------------------------------------------------------------------------------------------------------------------------
function QuickApp:uibtnvol30OnReleased(event) self:SetVol(30) self:getinfo() end
function QuickApp:uibtnvol40OnReleased(event) self:SetVol(40) self:getinfo() end
function QuickApp:uibtnvol50OnReleased(event) self:SetVol(50) self:getinfo() end
function QuickApp:uibtnvol60OnReleased(event) self:SetVol(60) self:getinfo() end

function QuickApp:uibtnmuteOnOff(event)
    if self:getVariable("mute") == "0" then
        self:setVariable("mute","1")
        self:sendCommand("MUON") 
        self:updateProperty("value", true)       
        self:getinfo()
    elseif self:getVariable("mute") == "1" then
        self:setVariable("mute", "0")
        self:sendCommand("MUOFF")
        self:updateProperty("value", false)        
        self:getinfo()
    end
end



function QuickApp:uibtEcoOnOff(event)
    if self:getVariable("eco") == "0" then
        self:setVariable("eco","1")
        self:sendCommand("ECOON") 
        self:updateProperty("value", true)       
        self:getinfo()
    elseif self:getVariable("eco") == "1" then
        self:setVariable("eco", "0")
        self:sendCommand("ECOOFF")
        self:updateProperty("value", false)        
        self:getinfo()
    end
end
















--------------------------------------------------------------------------------------------------------------------------------------
-- Sound modes
--------------------------------------------------------------------------------------------------------------------------------------
function QuickApp:uiddOnReleased(event) self:debug("Dolby Digital") self:sendCommand("MSDOLBY DIGITAL") self:getinfo() end
function QuickApp:uidtsOnReleased(event) self:debug("DTS") self:sendCommand("MSDTS SURROUND") self:getinfo() end
function QuickApp:ui7chstOnReleased(event) self:debug("7 Canaux Stereo") self:sendCommand("MSMCH STEREO") self:getinfo() end
function QuickApp:uiatmosOnReleased(event) self:debug("MSDOLBY ATMOS") self:sendCommand("MSAURO3D") self:getinfo() end
function QuickApp:uivirtuelOnReleased(event) self:debug("MSVIRTUAL") self:sendCommand("MSVIRTUAL") self:getinfo() end
function QuickApp:uiautoOnReleased(event) self:debug("MSAUTO") self:sendCommand("MSAUTO") self:getinfo() end

--------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------
                                                    -- sound modes
function QuickApp:uimovieReleased(event) self:debug("Movie") self:sendCommand("MSMOVIE") self:getinfo() end
function QuickApp:uimusicOnReleased(event) self:debug("Music") self:sendCommand("MSMUSIC") self:getinfo() end
function QuickApp:uigameOnReleased(event) self:debug("Game") self:sendCommand("MSGAME") self:getinfo() end
function QuickApp:uidirectOnReleased(event) self:debug("Direct") self:sendCommand("MSDIRECT") self:getinfo() end
function QuickApp:uipdirectOnReleasedd(event) self:debug("P Direct") self:sendCommand("MSPURE DIRECT") self:getinfo() end

function QuickApp:uistereoOnReleased(event) self:debug("Stereo") self:sendCommand("MSSTEREO") self:getinfo() end
function QuickApp:uiauOnReleased(event) self:debug("Auto") self:sendCommand("MSAUTO") self:getinfo() end
function QuickApp:uineuralOnReleased(event) self:debug("Neural") self:sendCommand("MSNEURAL") self:getinfo() end
function QuickApp:uistandardOnReleased(event) self:debug("Standard") self:sendCommand("MSSTANDARD") self:getinfo() end


                                                    
--------------------------------------------------------------------------------------------------------------------------------------




function QuickApp:uisatOnReleased(event) self:debug("cbl/sat") self:sendCommand("SISAT/CBL") self:getinfo() end
function QuickApp:uitvOnReleased(event) self:debug("TV") self:sendCommand("SITV") self:getinfo() end
function QuickApp:uimediaOnReleased(event) self:debug("Media") self:sendCommand("SIMPLAY") self:getinfo() end
function QuickApp:uigameOnReleased(event) self:debug("Game") self:sendCommand("SIGAME") self:getinfo() end
function QuickApp:uitunerOnReleased(event) self:debug("Tuner") self:sendCommand("SITUNER") self:getinfo() end
                                        -- row 2
function QuickApp:uiradioOnReleased(event) self:debug("Radio") self:sendCommand("SIHDRADIO") self:getinfo() end
function QuickApp:uiaux1OnReleased(event) self:debug("Aux1") self:sendCommand("SIAUX1") self:getinfo() end
function QuickApp:uiaux2OnReleased(event) self:debug("Aux2") self:sendCommand("SIAUX2") self:getinfo() end
function QuickApp:uinetOnReleased(event) self:debug("Net") self:sendCommand("SINET") self:getinfo() end
function QuickApp:uibtOnReleased(event) self:debug("BT") self:sendCommand("SIBT") self:getinfo() end                                  
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--                                                 NE RIEN TOUCHER À PARTIR D'ICI                                                   --
--------------------------------------------------------------------------------------------------------------------------------------
-- VOLUME & SLIDER
--------------------------------------------------------------------------------------------------------------------------------------
function QuickApp:SetVol(value)
    if value < 10 then value = "0" ..value end
    self:sendCommand("MV" ..tostring(value))
    self:trace("Volume", value)
end

function QuickApp:uivolumeOnChanged(event)
   local value = event.values[1]
   self:SetVol(value)
   self:getinfo()
end
function QuickApp:SetVolb(value)
    if value < 10 then value = "0" ..value end
    self:sendCommand("CVSW" ..tostring(value))
    self:trace("Volume", value)
end
function QuickApp:uivolumeOnChangedb(event)
   local value = event.values[1]
   self:SetVolb(value)
   self:getinfo()
end

--------------------------------------------------------------------------------------------------------------------------------------
-- REQUÊTE HTTP
--------------------------------------------------------------------------------------------------------------------------------------
function QuickApp:getinfo()
    self:sendCommand("PW?") -- Power
    self:sendCommand("SI?")  -- source
    self:sendCommand("MS?") -- Surround modes
    self:sendCommand("MV?") -- volume
    end

function QuickApp:uigetinfo()
self:getinfo()
end

function QuickApp:sendCommand(strToSend)
local command = strToSend .."\r"
    self.sock:write(command, {
        success = function() -- fonction qui sera déclenchée lorsque les données seront correctement envoyées
            --self:trace("data sent" ..command)
        end,
        error = function(err) -- fonction qui sera déclenchée en cas d'erreur de transmission de données
            self:trace("error while sending data")
        end
    })
end
 
-- méthode pour lire les données du socket
-- puisque la méthode elle-même a été bouclée, elle ne doit pas être appelée depuis un autre emplacement que QuickApp:connect()
function QuickApp:waitForResponseFunction()
    self.sock:read({ -- lire un paquet de données depuis le socket
        success = function(data)
            self:onDataReceived(data) -- traitement des données reçues
            self:waitForResponseFunction() -- lecture en boucle des données
        end,
        error = function() -- une fonction qui sera appelée en cas d'erreur lors de la tentative de réception de données, par ex. déconnexion d'un socket
            self:trace("response error")
            self.sock:close() -- socket fermé
            fibaro.setTimeout(5000, function() self:connect() end) -- tentative de reconnexion (toutes les 5 secondes)
        end
    })
end
 
-- méthode pour ouvrir une connexion TCP.
-- si la connexion réussit, la boucle de lecture des données sera appelée QuickApp:waitForResponseFunction ()
function QuickApp:connect()
    self.sock:connect(self.ip, self.port, { -- connexion à l'appareil avec l'adresse IP et le port spécifiés
        success = function() -- la fonction sera déclenchée si la connexion est correcte
            self:trace("connected")
            self.isconnected = true
            self:waitForResponseFunction() -- lancement d'une "boucle" de lecture de données
        end,
        error = function(err) -- une fonction qui sera déclenchée en cas de connexion incorrecte, par ex. timeout
            self.sock:close() -- fermeture du socket
            self:warning("connection error")
            self:updateView("lblSource", "text", "Source: N/A")
            self:updateView("lblSur", "text", "Sound mode: N/A")
            self:updateView("lblVolStat", "text", "Volume: N/A")
            self:updateView("Slidervolume", "value", "0")
            fibaro.setTimeout(5000, function() self:connect() end) -- tentative de reconnexion (toutes les 5 secondes)
        end,
    })
end
 
-- fonction de gestion des données lues
-- normalement c'est là que les données rapportées par l'appareil seront traitées
function QuickApp:onDataReceived(data)
    --self:trace("onDataReceived", data)
    power = string.find(data, "PW.")
    volume = string.find(data, "MV%d")
    formatsonor = string.find(data, "MS.")
    source = string.find(data, "SI.")
    if power then
        if string.sub(data, 3, #data - 1) == "STANDBY" then
                self.isOn = false
                self:updateView("lblSource", "text", "Source: N/A")
                self:updateView("lblSur", "text", "Sound mode: N/A")
                self:updateView("lblVolStat", "text", "Volume: N/A")
                self:updateView("Slidervolume", "value", "0")
                self:updateProperty("value", false)
        else self.isOn = true self:updateProperty("value", true)
        end
    end
    if self.isOn then
        if volume then
            local statSliderVol = string.sub(data, 3, #data-1)
            if string.len(statSliderVol) == 3 then statSliderVol = string.sub(statSliderVol, 1, 2) end
            self:updateView("lblVolStat", "text", "Volume: " ..statSliderVol .." %")
            self:updateView("Slidervolume", "value", statSliderVol) -- updating the text for 'Slidervolume'.
        end
        if formatsonor then
        self:updateView("lblSur", "text", "Mode Surround: " ..string.sub(data, formatsonor + 2))
        self:trace("Mode Surround: " ..string.sub(data, formatsonor + 2))
        end
        if source then
        source = string.sub(data, source + 2)
            sourcetable = {
                -- VOS APPAREILS ICI -------------------------------------------
                MPLAY = "APPLE TV4",
                --SAT/CBL = "FREEBOX", --A VERIFIER SUR AMPLI ET PC
                BD = "PS4",
                TV = "TV SONY"
                -- VOS APPAREILS ICI -------------------------------------------
            }
            translatesource = sourcetable[string.sub(source, 1, #source -1)]
            if translatesource == nil then translatesource = source end
            self:updateView("lblSource", "text", "Source: " ..translatesource)
            self:trace("source: " ..translatesource)
            self:trace("FIN ========================================================")
        end
    end
end
--------------------------------------------------------------------------------------------------------------------------------------
-- REFRESH
--------------------------------------------------------------------------------------------------------------------------------------
-- fonction refresh du QA
function QuickApp:refresh()
if self.isconnected then 
self:getinfo()
end
fibaro.setTimeout(self.pollingTime, function() self:refresh() end) -- looping part
end
--------------------------------------------------------------------------------------------------------------------------------------
--                                                              FIN DU CODE                                                         --
--------------------------------------------------------------------------------------------------------------------------------------
