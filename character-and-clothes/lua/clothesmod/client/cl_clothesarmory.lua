surface.CreateFont("ClothesModTitle1", {
    font = "Walking in the Street", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 100,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

local blur = Material("pp/blurscreen")
local DermaPanel
local infos

local function fthis(str) -- creates a folder for player data, like clothes, etc. names it accordingly, f stands for folder in fthis, also fuck... because Cats & VirtualRaptor got annoyed at this
    str = tostring(str)
    str = str:lower()
    str = str:Trim()
    str = string.Replace(str, "/", "_")

    return str
end

local function DrawBlur(p, a, d)
    local x, y = p:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)

    for i = 1, d do
        blur:SetFloat("$blur", (i / d) * a)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

local param = Material("materials/clothesmod/003-note.png")
local head = Material("materials/clothesmod/002-people-1.png")
local eyes = Material("materials/clothesmod/007-medical.png")
local top = Material("materials/clothesmod/006-game.png")
local pant = Material("materials/clothesmod/001-fashion.png")
local male = Material("materials/clothesmod/male.png")
local female = Material("materials/clothesmod/female.png")
local modelPanel
local OpenCharacterPage

local function DrawBlurRect(x, y, w, h, amount, heavyness)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(blur)

    for i = 1, heavyness do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        render.SetScissorRect(x, y, x + w, y + h, true)
        surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(), ScrH())
        render.SetScissorRect(0, 0, 0, 0, false)
    end
end

local OpenPantPage = function(Panel, entity) -- Choose your pants
    local DPanel = vgui.Create("DPanel", Panel)
    local w, h = Panel:GetSize()
    DPanel:SetSize(w, h)
    DPanel:SetPos(0, 0)

    DPanel.Paint = function()
        draw.SimpleText(CLOTHESMOD.Config.Sentences[14][CLOTHESMOD.Config.Lang], "Bariol25", w / 2, 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    local PantList = vgui.Create("DScrollPanel", Panel) -- Cats
    PantList:SetSize(w - 20, h - 100)
    PantList:SetPos(10, 80)

    PantList.Paint = function()
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    local sbar = PantList:GetVBar()

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 0))
    end

    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    end

    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
    end

    local list = CLOTHESMOD.PlayerBottoms[LocalPlayer():SteamID64()] or {}
    local nb = 0
    local line = -1

    for pant, tables in pairs(list) do
        local nbl = math.fmod(nb, 3)

        if nbl == 0 then
            line = line + 1
            nb = 0
        end

        local DPanel3 = vgui.Create("DPanel", PantList) -- Cats
        DPanel3:SetSize(40 + 45, 40 + 45)
        DPanel3:SetPos(5 + 90 * nb, 5 + 95 * line)
        DPanel3:SetText("")
        DPanel3.Paint = function(p, w, h) end
        local DmodelPanel = vgui.Create("DModelPanel", DPanel3)
        DmodelPanel:SetSize(85, 85)
        DmodelPanel:SetPos(0, 0)

        function DmodelPanel:LayoutEntity(Entity)
            return
        end

        DmodelPanel:SetModel(infos.model)
        local startpos = DmodelPanel.Entity:GetBonePosition(DmodelPanel.Entity:LookupBone("ValveBiped.Bip01_R_Calf") or 0) + Vector(0, 5, 0)
        DmodelPanel:SetLookAt(startpos)
        DmodelPanel:SetCamPos(startpos - Vector(-30, -0, 0))
        DmodelPanel.Entity:SetEyeTarget(startpos - Vector(-30, -0, 0))
        --
        local datas

        if infos.sex == 1 then
            datas = CLOTHESMOD.Male.ListDefaultPM[infos.model]
        else
            datas = CLOTHESMOD.Female.ListDefaultPM[infos.model]
        end

        local tindex = datas.bodygroupsbottom[tables.bodygroup].pant

        local bodygroups = {datas.bodygroupsbottom[tables.bodygroup].group,}

        local ent = DmodelPanel.Entity

        for k, v in pairs(bodygroups) do
            ent:SetBodygroup(v[1], v[2])
        end

        local pants = pant

        for k, v in pairs(tindex) do
            ent:SetSubMaterial(v, pants)
        end

        local DButton3 = vgui.Create("DButton", DPanel3) -- Cats
        DButton3:SetSize(40 + 45, 40 + 45)
        DButton3:SetPos(0, 0)
        DButton3:SetText("")

        DButton3.Paint = function(p, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
            local m = 0

            if infos.panttexture.basetexture == pants then
                m = 1
            end

            draw.RoundedBox(0, 0, 0, w, 2, Color(255, 225, 255, 255 * m))
            draw.RoundedBox(0, 0, h - 2, w, 2, Color(255, 255, 255, 255 * m))
            draw.RoundedBox(0, 0, 0, 2, h, Color(255, 255, 255, 255 * m))
            draw.RoundedBox(0, w - 2, 0, 2, h, Color(255, 255, 255, 255 * m))
        end

        DButton3.DoClick = function(pnl)
            infos.bodygroups.pant = tables.bodygroup
            infos.panttexture.basetexture = pants
            modelPanel.Actualize()
        end

        if CLOTHESMOD.Config.CanRemoveClothesInWardrobe then
            local DButton4 = vgui.Create("DButton", DPanel3) -- X's to delete -- Cats
            DButton4:SetSize(20, 20)
            DButton4:SetPos(40 + 45 - 25, 40 + 45 - 25)
            DButton4:SetText("")

            DButton4.Paint = function(p, w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(150, 0, 0, 255))
                draw.SimpleText("X", "Bariol17", w / 2, h / 2 - 1, Color(255, 255, 255, 255), 1, 1)
            end

            DButton4.DoClick = function(pnl)
                net.Start("ClothesMod:RemoveCloth")
                net.WriteEntity(entity)
                -- category ( 1 = top, 2 = bottom )
                net.WriteInt(2, 32)
                -- texture id/texture
                net.WriteString(pants)
                net.WriteBool(false)
                net.SendToServer()

                timer.Simple(0.1, function()
                    DermaPanel:Close()
                    CM_OpenArmory(entity, true)
                end)
            end
        end

        nb = nb + 1
    end

    return DPanel
end

local OpenTopMenu = function(Panel, entity)
    local DPanel = vgui.Create("DPanel", Panel) -- Cats
    local w, h = Panel:GetSize()
    DPanel:SetSize(w, h)
    DPanel:SetPos(0, 0)

    DPanel.Paint = function()
        draw.SimpleText(CLOTHESMOD.Config.Sentences[7][CLOTHESMOD.Config.Lang], "Bariol25", w / 2, 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    local PantList = vgui.Create("DScrollPanel", Panel) -- Cats
    PantList:SetSize(w - 20, h - 100)
    PantList:SetPos(10, 80)

    PantList.Paint = function()
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    local sbar = PantList:GetVBar()

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 0))
    end

    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    end

    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
    end

    local list = CLOTHESMOD.PlayerTops[LocalPlayer():SteamID64()] or {}
    local nb = 0
    local line = -1

    for iscustom, newlist in pairs(list) do
        for tee, tables in pairs(newlist) do
            local nbl = math.fmod(nb, 3)

            if nbl == 0 then
                line = line + 1
                nb = 0
            end

            local DPanel3 = vgui.Create("DButton", PantList)
            DPanel3:SetSize(40 + 45, 40 + 45)
            DPanel3:SetPos(5 + 90 * nb, 5 + 95 * line)
            DPanel3:SetText("")
            DPanel3.Paint = function(p, w, h) end
            local DmodelPanel = vgui.Create("DModelPanel", DPanel3)
            DmodelPanel:SetSize(85, 85)
            DmodelPanel:SetPos(0, 0)

            function DmodelPanel:LayoutEntity(Entity)
                return
            end

            DmodelPanel:SetModel(infos.model)
            local startpos = DmodelPanel.Entity:GetBonePosition(DmodelPanel.Entity:LookupBone("ValveBiped.Bip01_Spine2") or 0)
            DmodelPanel:SetLookAt(startpos)
            DmodelPanel:SetCamPos(startpos - Vector(-25, 0, 0))
            DmodelPanel.Entity:SetEyeTarget(startpos - Vector(-25, 0, 0))
            --
            local data
            local datas

            if infos.sex == 1 then
                data = CLOTHESMOD.Male
            else
                data = CLOTHESMOD.Female
            end

            local datas = data.ListDefaultPM[infos.model]
            local tindex
            local bodygroups
            local tbdg
            local bodygroupname

            if tables.id and CLOTHESMOD.Textures and data.EditableTop[CLOTHESMOD.Textures[tables.id].baseTexture] then
                tbdg = data.EditableTop[CLOTHESMOD.Textures[tables.id].baseTexture]
                -- if true then return end
                tindex = datas.bodygroupstop[tbdg.bodygroup].tee

                bodygroups = {datas.bodygroupstop[tbdg.bodygroup].group,}

                bodygroupname = tbdg.bodygroup
            else
                local t = datas.bodygroupstop[tables.bodygroup]
                tindex = t.tee

                bodygroups = {datas.bodygroupstop[tables.bodygroup].group,}

                bodygroupname = tables.bodygroup
            end

            local ent = DmodelPanel.Entity

            for k, v in pairs(bodygroups) do
                ent:SetBodygroup(v[1], v[2])
            end

            local tops = tee

            for k, v in pairs(tindex) do
                if iscustom == "customs" then
                    ent:SetSubMaterial(v, "!CM_" .. tables.id)
                else
                    ent:SetSubMaterial(v, tops)
                end
            end

            local DButton3 = vgui.Create("DButton", DPanel3)
            DButton3:SetSize(40 + 45, 40 + 45)
            DButton3:SetPos(0, 0)
            DButton3:SetText("")

            DButton3.Paint = function(p, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
                local m = 0

                if tables.id then
                    if tables.id == infos.teetexture.id and infos.teetexture.basetexture == "!CM_" .. tables.id then
                        m = 1
                    end
                elseif infos.teetexture.basetexture == tops then
                    m = 1
                end

                draw.RoundedBox(0, 0, 0, w, 2, Color(255, 255, 255, 255 * m))
                draw.RoundedBox(0, 0, h - 2, w, 2, Color(255, 255, 255, 255 * m))
                draw.RoundedBox(0, 0, 0, 2, h, Color(255, 255, 255, 255 * m))
                draw.RoundedBox(0, w - 2, 0, 2, h, Color(255, 255, 255, 255 * m))
            end

            DButton3.DoClick = function(pnl)
                infos.bodygroups.top = bodygroupname

                if iscustom == "customs" then
                    infos.teetexture.basetexture = "!CM_" .. tables.id
                    infos.teetexture.id = tables.id
                    infos.teetexture.hasCustomThings = true
                else
                    infos.teetexture.basetexture = tops
                    infos.teetexture.hasCustomThings = false
                end

                modelPanel.Actualize()
            end

            if CLOTHESMOD.Config.CanRemoveClothesInWardrobe then
                local DButton4 = vgui.Create("DButton", DPanel3)
                DButton4:SetSize(20, 20)
                DButton4:SetPos(40 + 45 - 25, 40 + 45 - 25)
                DButton4:SetText("")

                DButton4.Paint = function(p, w, h)
                    draw.RoundedBox(5, 0, 0, w, h, Color(150, 0, 0, 255))
                    draw.SimpleText("X", "Bariol17", w / 2, h / 2 - 1, Color(255, 255, 255, 255), 1, 1)
                end

                DButton4.DoClick = function(pnl)
                    net.Start("ClothesMod:RemoveCloth")
                    net.WriteEntity(entity)
                    -- category ( 1 = top, 2 = bottom )
                    net.WriteInt(1, 32)
                    -- texture id/texture
                    net.WriteString(tables.id or tops)

                    if iscustom == "customs" then
                        net.WriteBool(true)
                    else
                        net.WriteBool(false)
                    end

                    net.SendToServer()

                    timer.Simple(0.1, function()
                        DermaPanel:Close()
                        CM_OpenArmory(entity, true)
                    end)
                end
            end

            nb = nb + 1
        end
    end

    return DPanel
end

OpenCharacterPage = function(Frame, sizex, sizey, ent, removeAlphaEffect)
    local DPanel = vgui.Create("DPanel", Frame)

    if not removeAlphaEffect then
        DPanel:SetPos(0, 50)
        DPanel:SetSize(sizex, sizey)
        local removeTime = -1
        local startTime = CurTime()
        DPanel:SetAlpha(0)
        DPanel:MoveTo(0, 0, 1, 0, -1, function() end)
    else
        DPanel:SetPos(0, 0)
        DPanel:SetSize(sizex, sizey)
    end

    local sizeym = sizey * 0.9
    local sizexm = sizeym * 0.7

    DPanel.Paint = function(pnl, w, h)
        local perc = 1

        if removeTime and removeTime ~= -1 then
            perc = (1 - math.Clamp(CurTime() - removeTime, 0, 1)) / 2
        elseif removeTime then
            perc = math.Clamp(CurTime() - startTime, 0, 1)
        else
            perc = 1
        end

        DPanel:SetAlpha(255 * perc)
    end

    local panelx, panely = 310, 392
    local DButton = vgui.Create("DButton", DPanel) -- Change Button -- Cats
    DButton:SetSize(panelx / 2 - 2.5, 30)
    DButton:SetPos(ScrW() / 2 - panelx / 2, sizey - 50)
    DButton:SetText("")

    DButton.Paint = function(pnl, w, h)
        local perc = 1

        if removeTime and removeTime ~= -1 then
            perc = (1 - math.Clamp(CurTime() - removeTime, 0, 1)) / 2
        end

        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        draw.RoundedBox(0, 0, 0, w, 2, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, h - 2, w, 2, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, 0, 2, h, Color(255, 255, 255, 255))
        draw.RoundedBox(0, w - 2, 0, 2, h, Color(255, 255, 255, 255))
        draw.SimpleText(CLOTHESMOD.Config.Sentences[15][CLOTHESMOD.Config.Lang], "Bariol25", (panelx / 2 - 2.5) / 2, 30 / 2 - 1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    DButton.DoClick = function(pnl)
        net.Start("ClothesMod:ChangeClothes")

        if infos.teetexture.hasCustomThings then
            net.WriteString(infos.teetexture.id)
        else
            net.WriteString(infos.teetexture.basetexture or "")
        end

        net.WriteString(infos.panttexture.basetexture or "")
        net.WriteBool(infos.teetexture.hasCustomThings)
        net.WriteEntity(ent)
        net.SendToServer()
        DermaPanel:Close()
    end

    local DButton2 = vgui.Create("DButton", DPanel) -- Close Button -- Cats
    DButton2:SetSize(panelx / 2 - 2.5, 30)
    DButton2:SetPos(ScrW() / 2 - panelx / 2 + panelx / 2 + 2.5, sizey - 50)
    DButton2:SetText("")

    DButton2.Paint = function(pnl, w, h)
        local perc = 1

        if removeTime and removeTime ~= -1 then
            perc = (1 - math.Clamp(CurTime() - removeTime, 0, 1)) / 2
        end

        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        draw.RoundedBox(0, 0, 0, w, 2, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, h - 2, w, 2, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, 0, 2, h, Color(255, 255, 255, 255))
        draw.RoundedBox(0, w - 2, 0, 2, h, Color(255, 255, 255, 255))
        draw.SimpleText(CLOTHESMOD.Config.Sentences[19][CLOTHESMOD.Config.Lang], "Bariol25", (panelx / 2 - 2.5) / 2, 30 / 2 - 1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    DButton2.DoClick = function(pnl)
        DermaPanel:Close()
    end

    modelPanel = vgui.Create("DModelPanel", DPanel)
    modelPanel:SetSize(sizexm, sizeym)
    modelPanel:SetPos(ScrW() / 2 - sizexm / 2, 0)

    function modelPanel:LayoutEntity(Entity)
        return
    end

    modelPanel:SetModel(infos.model)
    local startpos = modelPanel.Entity:GetBonePosition(modelPanel.Entity:LookupBone("ValveBiped.Bip01_Pelvis") or 0)
    modelPanel.LastChangePos = CurTime()
    modelPanel.pos = startpos
    modelPanel.el = Vector(-40, -10, -0)
    modelPanel.isChanged = false
    modelPanel.oldPos = modelPanel.pos
    modelPanel.oldel = modelPanel.el

    modelPanel.Actualize = function()
        local datas

        if infos.sex == 1 then
            datas = CLOTHESMOD.Male.ListDefaultPM[infos.model]
        else
            datas = CLOTHESMOD.Female.ListDefaultPM[infos.model]
        end

        modelPanel:SetModel(infos.model)
        local tindex = datas.bodygroupstop[infos.bodygroups.top].tee
        local pindex = datas.bodygroupsbottom[infos.bodygroups.pant].pant
        local eindex = datas.eyes

        local bodygroups = {datas.bodygroupstop[infos.bodygroups.top].group, datas.bodygroupsbottom[infos.bodygroups.pant].group}

        local skin = infos.skin
        local ent = modelPanel.Entity
        local pcolor = infos.playerColor
        local tops = infos.teetexture.basetexture
        local pants = infos.panttexture.basetexture
        ent:SetSkin(skin)

        for k, v in pairs(bodygroups) do
            ent:SetBodygroup(v[1], v[2])
        end

        for k, v in pairs(tindex) do
            ent:SetSubMaterial(v, tops)
        end

        for k, v in pairs(pindex) do
            ent:SetSubMaterial(v, pants)
        end

        ent.GetPlayerColor = function() return pcolor end

        for k, v in pairs(infos.eyestexture) do
            local matr = v["r"]
            local matl = v["l"]
            local indexr = eindex["r"]
            local indexl = eindex["l"]
            ent:SetSubMaterial(indexr, matr)
            ent:SetSubMaterial(indexl, matl)
        end

        modelPanel.Entity:SetEyeTarget(modelPanel.pos - modelPanel.el)
    end

    modelPanel:Actualize()

    modelPanel.Think = function(pnl)
        if CurTime() - modelPanel.LastChangePos > 1 then return end

        if modelPanel.isChanged then
            modelPanel.oldPos = modelPanel.pos
            modelPanel.oldel = modelPanel.el
            modelPanel.pos = modelPanel.npos
            modelPanel.el = modelPanel.nel
            modelPanel.isChanged = false
        end

        local frac = CurTime() - modelPanel.LastChangePos
        modelPanel:SetLookAt(LerpVector(frac, modelPanel.oldPos, modelPanel.pos))
        modelPanel:SetCamPos(LerpVector(frac, modelPanel.oldPos - modelPanel.oldel, modelPanel.pos - modelPanel.el))
        modelPanel.Entity:SetEyeTarget(LerpVector(frac, modelPanel.oldPos - modelPanel.oldel, modelPanel.pos - modelPanel.el))
    end

    local pnOpen = 1
    ---
    -- local DPanelMenu = vgui.Create( "DPanel", DPanel ) -- Left List of Clothes (Scrapped) -- Cats
    -- DPanelMenu:SetPos( 50, ( sizey - panely ) / 2 )
    -- DPanelMenu:SetSize( panelx, 40 )
    -- DPanelMenu.Paint = function(pnl, w, h)
    -- 	local we = 2
    -- 	draw.RoundedBox(0,0,0,w,h, Color(0, 0, 0,200))
    -- 	draw.RoundedBox(0,0,0,w,we,Color(255,255,255,255))
    -- 	draw.RoundedBox(0,0,h-we,w,we,Color(255,255,255,255))
    -- 	draw.RoundedBox(0,0,0,we,h,Color(255,255,255,255))
    -- 	draw.RoundedBox(0,w-we,0,we,h,Color(255,255,255,255))
    -- 	-- draw.SimpleText( CLOTHESMOD.Config.Sentences[16][CLOTHESMOD.Config.Lang], "Bariol25", w/2, h/2 ,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    -- end
    ---
    local ShirtButton = vgui.Create("DButton", DPanel) -- Shirt -- Cats
    ShirtButton.IsSelected = true
    ShirtButton:SetPos(50, (sizey - panely) / 2)
    ShirtButton:SetSize(panelx / 2, 40)
    ShirtButton:SetText("")

    ShirtButton.Paint = function(pnl, w, h)
        local color = not pnl.IsSelected and Color(255, 255, 255, 255) or Color(100, 255, 255, 255)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, 2, color)
        draw.RoundedBox(0, 0, h - 2, w, 2, color)
        draw.RoundedBox(0, 0, 0, 2, h, color)
        draw.RoundedBox(0, w - 2, 0, 2, h, color)
        draw.SimpleText(CLOTHESMOD.Config.Sentences[70][CLOTHESMOD.Config.Lang], "Bariol25", (panelx / 2) / 2, 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    ---
    local PantButton = vgui.Create("DButton", DPanel) -- Pants -- Cats
    PantButton.IsSelected = false
    PantButton:SetPos(50 + (panelx / 2), (sizey - panely) / 2)
    PantButton:SetSize(panelx / 2, 40)
    PantButton:SetText("")

    PantButton.Paint = function(pnl, w, h)
        local color = not pnl.IsSelected and Color(255, 255, 255, 255) or Color(100, 255, 255, 255)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, 2, color)
        draw.RoundedBox(0, 0, h - 2, w, 2, color)
        draw.RoundedBox(0, 0, 0, 2, h, color)
        draw.RoundedBox(0, w - 2, 0, 2, h, color)
        draw.SimpleText(CLOTHESMOD.Config.Sentences[71][CLOTHESMOD.Config.Lang], "Bariol25", (panelx / 2) / 2, 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    ---
    local ShirtsPage = vgui.Create("DPanel", DPanel) -- Cats
    ShirtsPage:SetPos(50, (sizey - panely) / 2 + 38)
    ShirtsPage:SetSize(panelx, panely)

    ShirtsPage.Paint = function(pnl, w, h)
        local we = 2
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, h - we, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, 0, we, h, Color(255, 255, 255, 255))
        draw.RoundedBox(0, w - we, 0, we, h, Color(255, 255, 255, 255))
    end

    OpenTopMenu(ShirtsPage, ent)
    local DPanelMenu2 = vgui.Create("DPanel", DPanel) -- Outfits -- Cats
    DPanelMenu2:SetPos(ScrW() - 50 - panelx, (sizey - panely) / 2)
    DPanelMenu2:SetSize(panelx, 40)

    DPanelMenu2.Paint = function(pnl, w, h)
        local we = 2
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, h - we, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, 0, we, h, Color(255, 255, 255, 255))
        draw.RoundedBox(0, w - we, 0, we, h, Color(255, 255, 255, 255))
        draw.SimpleText(CLOTHESMOD.Config.Sentences[72][CLOTHESMOD.Config.Lang], "Bariol25", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- save shirt + pant
    -- the list of outfits
    local test = vgui.Create("DScrollPanel", DPanel)
    test:SetSize(panelx, panely)
    test:SetPos(ScrW() - 50 - panelx, (sizey - panely) / 2 + 38)

    test.Paint = function(pnl, w, h)
        local we = 2
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, we, Color(255, 255, 255))
        draw.RoundedBox(0, 0, h - we, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, 0, we, h, Color(255, 255, 255, 255))
        draw.RoundedBox(0, w - we, 0, we, h, Color(255, 255, 255, 255))
    end

    local sbar = test:GetVBar()
    sbar:DockPadding(0, 0, 0, 0)

    function sbar:Paint(w, h) 
    end

    function sbar.btnUp:Paint(w, h)
    end

    function sbar.btnDown:Paint(w, h)
    end

    function sbar.btnGrip:Paint(w, h)
        local we = 2
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, we, Color(255, 255, 255))
        draw.RoundedBox(0, 0, h - we, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, 0, we, h, Color(255, 255, 255, 255))
        draw.RoundedBox(0, w - we, 0, we, h, Color(255, 255, 255, 255))
    end

    -- testing making buttons
    local function AddOutfitButton(fName, fID) -- Cats
        local tb = test:Add("DButton")
        tb:Dock(TOP)
        tb:SetText("")
        tb.Name = fName
        tb.OutfitID = fID
        tb:DockMargin(10, 0, 10, 10)
        tb:SetTall(50)

        tb.Paint = function(s, w, h)
            local we = 2
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
            draw.RoundedBox(0, 0, 0, w, we, Color(255, 255, 255))
            draw.RoundedBox(0, 0, h - we, w, we, Color(255, 255, 255, 255))
            draw.RoundedBox(0, 0, 0, we, h, Color(255, 255, 255, 255))
            draw.RoundedBox(0, w - we, 0, we, h, Color(255, 255, 255, 255))
            draw.SimpleText(tb.Name or "", "Bariol25", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function tb:DoClick()
            local d = self.Outfitdata
            if not d then return end
            infos.teetexture.hasCustomThings = d["isShirtCustom"]
            infos.teetexture.id = d["shirtID"]
            infos.teetexture.basetexture = d["shirtID"] or ""
            infos.panttexture.basetexture = d["pantID"] or ""
            modelPanel.Actualize()
        end

        local delete = tb:Add("DButton")
        delete:Dock(RIGHT)
        delete:SetWide(tb:GetTall())
        delete:SetText("")

        delete.Paint = function(pnl, w, h)
            local we = 2
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
            draw.RoundedBox(0, 0, 0, w, we, Color(223, 67, 67, 245))
            draw.RoundedBox(0, 0, h - we, w, we, Color(223, 67, 67, 245))
            draw.RoundedBox(0, 0, 0, we, h, Color(223, 67, 67, 245))
            draw.RoundedBox(0, w - we, 0, we, h, Color(223, 67, 67, 245))
            draw.SimpleText("X", "Bariol25", w / 2, h / 2, Color(223, 67, 67, 245), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        function delete:DoClick()
            file.Delete("customoutfits/" .. tb.OutfitID)
            tb:Remove()
        end

        return tb
    end

    local function BuildOutfits()
        test:Clear()
        local fetchedOutfits, _ = file.Find("customoutfits/*", "DATA")

        if istable(fetchedOutfits) and #fetchedOutfits > 0 then
            for i = 1, #fetchedOutfits do
                local tempButton = AddOutfitButton("Outfit " .. i, fetchedOutfits[i])
                tempButton.Outfitdata = util.JSONToTable(file.Read("customoutfits/" .. fetchedOutfits[i], "DATA"))
            end
        end
    end

    local SaveButton = vgui.Create("DButton", DPanel) -- Save -- Cats
    SaveButton:SetText("")
    local sb_x, sb_y = panelx / 2 + (panelx * .1), 30
    SaveButton:SetSize(sb_x, sb_y)
    local cockx, cocky, cockw, cockh = DPanelMenu2:GetBounds()
    SaveButton:SetPos(cockx + (cockw * .5) - (sb_x * .5), cocky + panely + cockh + 5)

    SaveButton.DoClick = function()
        local outfit = {
            isShirtCustom = infos.teetexture.hasCustomThings,
            shirtID = infos.teetexture.hasCustomThings and infos.teetexture.id or (infos.teetexture.basetexture or ""),
            pantID = infos.panttexture.basetexture or "",
        }

        if not file.IsDir("customoutfits", "DATA") then
            file.CreateDir("customoutfits")
        end

        local fname = fthis(outfit.isShirtCustom) .. fthis(outfit.shirtID) .. fthis(outfit.pantID) .. ".txt"
        file.Write("customoutfits/" .. fname, util.TableToJSON(outfit, true))
        BuildOutfits()
    end

    SaveButton.Paint = function(pnl, w, h)
        local we = 2
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, h - we, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, 0, we, h, Color(255, 255, 255, 255))
        draw.RoundedBox(0, w - we, 0, we, h, Color(255, 255, 255, 255))
        draw.SimpleText(CLOTHESMOD.Config.Sentences[73][CLOTHESMOD.Config.Lang], "Bariol25", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    BuildOutfits()
    local PantsPage = vgui.Create("DPanel", DPanel) -- Cats
    PantsPage:SetPos(50, (sizey - panely) / 2 + 38)
    PantsPage:SetSize(panelx, panely)

    PantsPage.Paint = function(pnl, w, h)
        local we = 2
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(0, 0, 0, w, we, Color(255, 255, 255))
        draw.RoundedBox(0, 0, h - we, w, we, Color(255, 255, 255, 255))
        draw.RoundedBox(0, 0, 0, we, h, Color(255, 255, 255, 255))
        draw.RoundedBox(0, w - we, 0, we, h, Color(255, 255, 255, 255))
    end

    OpenPantPage(PantsPage, ent)
    PantsPage:SetVisible(false)

    ShirtButton.DoClick = function(pnl)
        ShirtButton.IsSelected = true
        PantButton.IsSelected = false
        PantsPage:SetVisible(false)
        ShirtsPage:SetVisible(true)
    end

    PantButton.DoClick = function(pnl) -- Cats
        PantButton.IsSelected = true
        ShirtButton.IsSelected = false
        PantsPage:SetVisible(true)
        ShirtsPage:SetVisible(false)
    end
end

function CM_OpenArmory(ent, removeAlphaEffect)
    local sizex, sizey = ScrW(), ScrH()
    DermaPanel = vgui.Create("DFrame")
    DermaPanel:SetPos((ScrW() - sizex) / 2, (ScrH() - sizey) / 2)
    DermaPanel:SetSize(sizex, sizey)
    DermaPanel:SetTitle("")
    DermaPanel:SetDraggable(false)
    DermaPanel:ShowCloseButton(false)
    DermaPanel:MakePopup()

    DermaPanel.Paint = function(pnl, w, h)
        DrawBlurRect(0, 0, sizex, sizey * 0.15, 6, 10)
        DrawBlurRect(0, ScrH() - sizey * 0.15, sizex, sizey * 0.15, 6, 10)
        DrawBlur(pnl, 8, 16)
        draw.RoundedBox(0, 0, 0, sizex, sizey * 0.15, Color(0, 0, 0, 245))
        draw.RoundedBox(0, 0, ScrH() - sizey * 0.15, sizex, sizey * 0.15, Color(0, 0, 0, 245))
        DrawBlur(pnl, 8, 16)
        draw.RoundedBox(0, 0, 0, sizex, sizey * 0.15, Color(0, 0, 0, 245))
        draw.RoundedBox(0, 0, ScrH() - sizey * 0.15, sizex, sizey * 0.15, Color(0, 0, 0, 245))
    end

    local DPanel = vgui.Create("DPanel", DermaPanel)
    DPanel:SetPos(0, sizey * 0.15)
    DPanel:SetSize(sizex, sizey * 0.7)
    DPanel.Paint = function() end
    infos = table.Copy(LocalPlayer():CM_GetInfos())
    OpenCharacterPage(DPanel, sizex, sizey * 0.7, ent, removeAlphaEffect)
end