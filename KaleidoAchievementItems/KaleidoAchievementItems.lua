KaleidoAchievementItems = {}

local this = KaleidoAchievementItems
this.name = "KaleidoAchievementItems"
this.version = "1.5.0"
this.author = "grin3671"

-- this table contains itemsIds (string) and related achievementIds (integer)
local AddonData = {
  ---- Trophies
  ["54184"] = 838, -- Tamriel Beast Collector
  ["54185"] = 838, -- Tamriel Beast Collector
  ["54186"] = 838, -- Tamriel Beast Collector
  ["54187"] = 838, -- Tamriel Beast Collector
  ["54188"] = 838, -- Tamriel Beast Collector
  ["54189"] = 838, -- Tamriel Beast Collector
  ["54190"] = 838, -- Tamriel Beast Collector
  ["54195"] = 838, -- Tamriel Beast Collector
  ["54196"] = 838, -- Tamriel Beast Collector
  ["54197"] = 838, -- Tamriel Beast Collector
  ["54198"] = 838, -- Tamriel Beast Collector
  ["54199"] = 841, -- Undead Hoarder
  ["54200"] = 841, -- Undead Hoarder
  ["54201"] = 841, -- Undead Hoarder
  ["54202"] = 841, -- Undead Hoarder
  ["54203"] = 841, -- Undead Hoarder
  ["54204"] = 841, -- Undead Hoarder
  ["54205"] = 842, -- Chitin Accumulator
  ["54206"] = 842, -- Chitin Accumulator
  ["54207"] = 842, -- Chitin Accumulator
  ["54208"] = 842, -- Chitin Accumulator
  ["54209"] = 842, -- Chitin Accumulator
  ["54210"] = 842, -- Chitin Accumulator
  ["54211"] = 842, -- Chitin Accumulator
  ["54212"] = 842, -- Chitin Accumulator
  ["54213"] = 846, -- Dwarven Secrets Gatherer
  ["54214"] = 846, -- Dwarven Secrets Gatherer
  ["54215"] = 843, -- Nature Collector
  ["54216"] = 843, -- Nature Collector
  ["54217"] = 843, -- Nature Collector
  ["54218"] = 843, -- Nature Collector
  ["54219"] = 843, -- Nature Collector
  ["54220"] = 843, -- Nature Collector
  ["54221"] = 843, -- Nature Collector
  ["54222"] = 844, -- Monstrous Component Collector
  ["54223"] = 844, -- Monstrous Component Collector
  ["54224"] = 844, -- Monstrous Component Collector
  ["54225"] = 844, -- Monstrous Component Collector
  ["54226"] = 844, -- Monstrous Component Collector
  ["54227"] = 844, -- Monstrous Component Collector
  ["54228"] = 844, -- Monstrous Component Collector
  ["54229"] = 847, -- Atronach Element Collector
  ["54230"] = 847, -- Atronach Element Collector
  ["54231"] = 847, -- Atronach Element Collector
  ["54232"] = 847, -- Atronach Element Collector
  ["54233"] = 848, -- Oblivion Shard Gatherer
  ["54234"] = 848, -- Oblivion Shard Gatherer
  ["54235"] = 848, -- Oblivion Shard Gatherer
  ["54236"] = 848, -- Oblivion Shard Gatherer
  ["54237"] = 848, -- Oblivion Shard Gatherer
  ["54338"] = 838, -- Tamriel Beast Collector
  ---- Holidays
  -- ["147658"] = 2464, -- Festive Noise Maker (has progress, 0/10 bugged?)
  -- ["147659"] = 2465, -- Jester's Festival Joke Popper (has progress)
  -- ["153535"] = 2591, -- Bare Bones Puppet (has progress)
  ["199137"] = 3832, -- Haunted By Netches
  ["204458"] = 3827, -- Jubilee Confetti Conveyor
  ["211128"] = 4226, -- What a Hoot!
  ["212198"] = 4238, -- A Warm Winter Storm
  ---- Elsweyr
  -- ["147929"] = 2519, -- Mummified Alfiq Part (has progress)
  -- ["147930"] = 2520, -- Plague-Drenched Fabric (has progress)
  ---- Blackwood
  ["178462"] = 3917, -- Zenithar's Abbey
  ["178463"] = 3916, -- The Silent Halls
  ---- High Isle
  ["188200"] = 3918, -- Coral Haj Mota Lure
  ["188271"] = 3918, -- Coral Haj Mota Decoy
  ---- Necrom
  ["197649"] = 3723, -- Gorne
  ["198095"] = 3723, -- The Underweave
  ---- Infinite Archive
  ["203540"] = 3926, -- 50 Maligraphic Ichors / Mount
  ["203541"] = 3927, -- 25 Disgusting Spoils / Pet
  ["203542"] = 3928, -- 20 Unreliable Archive Maps / Face Marks
  ["203543"] = 3929, -- 20 Erroneous Archive Maps / Body Marks
  ---- Infinite Archive Updates
  ["206533"] = 4062, -- 20 Archival Enigmas / Face Art
  ["206534"] = 4063, -- 20 Archival Riddles / Body Art
  ---- Gold Road
  ["207814"] = 4081, -- Silorn
  ["207815"] = 4081, -- Leftwheal Trading Post
  ["207970"] = { 4055, 4056, 4149 }, -- 10/20/30 Mosaic Skill Shred
  ---- Skill Stylist
  ["214309"] = 4294, -- 10 Harvested Soul Fragments / Soul Trap
  ---- Solstice
  ["217925"] = 4446, -- 25 Phials of Tainted Blood / Eviscerate
}

function this:GetAchievementId(itemId)
    local ID = AddonData[tostring(itemId)]
    if ID == nil then return end
    if type(ID) == "table" then
      local uncomplitedIndex = 1
      for index, achievementId in ipairs(ID) do
        local _, _, _, _, completed = GetAchievementInfo(achievementId)
        if completed then
          uncomplitedIndex = index + 1
        end
      end
      return ID[uncomplitedIndex], uncomplitedIndex, #ID
    else
      return ID
    end
end


EVENT_MANAGER:RegisterForEvent(this.name, EVENT_ADD_ON_LOADED, function(event, addonName)
  if addonName == this.name then
    this:init()
  end
end)

function this:init()
  -- if (LibAddonMenu2) then
  --   self.addonMenu = self:initAddonMenu()
  -- end

  if (LibCustomMenu) then
    local function AddItem(inventorySlot, slotActions)
      local valid = ZO_Inventory_GetBagAndIndex(inventorySlot)
      if not valid then return end

      local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
      local itemId = GetItemId(bagId, slotIndex)
      local achievementId = this:GetAchievementId(itemId)
      if achievementId then
        slotActions:AddCustomSlotAction(SI_DYEING_SWATCH_VIEW_ACHIEVEMENT, function()
          SCENE_MANAGER:HideCurrentScene()
          SYSTEMS:GetObject("achievements"):ShowAchievement(achievementId)
        end , "")
      end
    end

    LibCustomMenu:RegisterContextMenu(AddItem, LibCustomMenu.CATEGORY_LATE)
  end

  -- function taken from addon MasterRecipeList with little adjustments
  local function ColorText(color, text)
    return "|c"..tostring(color)..tostring(text).."|r"
  end

  local function AddTooltipInfo(control, itemLink)
    local itemId = GetItemLinkItemId(itemLink)
    local achievementId = this:GetAchievementId(itemId)
    if achievementId then
      local name, _, _, _, completed = GetAchievementInfo(achievementId)
      local criterions = GetAchievementNumCriteria(achievementId)
      local r, g, b = ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB()

      local isList = false
      local texts = {}
      for i = 1, GetAchievementNumCriteria(achievementId) do
        local criterionDesctiprion, criterionNumCompleted, criterionNumRequired = GetAchievementCriterion(achievementId, i)
        local isCriterionComplete = criterionNumCompleted >= criterionNumRequired

        isList = criterionNumRequired == 1
        -- table.insert(texts, criterionDesctiprion .. ": " .. ColorText(isCriterionComplete and "2ADC22" or "FFFFFF", criterionNumCompleted) .. "/" .. criterionNumRequired)
        if isList then
          table.insert(texts, ColorText(isCriterionComplete and ZO_TOOLTIP_DEFAULT_COLOR:ToHex() or ZO_DISABLED_TEXT:ToHex(), criterionDesctiprion))
        else
          table.insert(texts, criterionDesctiprion .. ": " .. ColorText(isCriterionComplete and UNLOCKED_COLOR:ToHex() or ZO_WHITE:ToHex(), criterionNumCompleted) .. "/" .. criterionNumRequired)
        end
      end

      control:AddVerticalPadding(20)
      control:AddLine(GetString(SI_GROUPFINDERPLAYSTYLE8), "ZoFontWinH5", r, g, b, CENTER, MODIFY_TEXT_TYPE_NONE, CENTER, false)
      control:AddVerticalPadding(-10)
      control:AddLine(zo_strformat(name), "ZoFontHeader2", 1, 1, 1, CENTER, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_CENTER, true)
      -- control:AddLine(table.concat(texts, "\n"), "", r, g, b, CENTER, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_CENTER, true)
      control:AddLine(table.concat(texts, isList and ", " or "\n"), isList and "ZoFontWinH5" or "", r, g, b, CENTER, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_CENTER, true)
    end
  end

  -- function taken from addon MasterRecipeList with little adjustments
  local function HookItemTooltips(callback)
    ZO_PostHook(ItemTooltip, "SetBagItem", function(control, bagId, slotIndex)
      callback(control, GetItemLink(bagId, slotIndex))
    end)
    ZO_PostHook(ItemTooltip, "SetLootItem", function(control, lootId)
      callback(control, GetLootItemLink(lootId))
    end)
    ZO_PostHook(ItemTooltip, "SetAttachedMailItem", function(control, mailId, attachmentIndex)
      callback(control, GetAttachedItemLink(mailId, attachmentIndex))
    end)
    ZO_PostHook(ItemTooltip, "SetBuybackItem", function(control, slotIndex)
      callback(control, GetBuybackItemLink(slotIndex))
    end)
    ZO_PostHook(ItemTooltip, "SetTradeItem", function(control, tradeId, slotIndex)
      callback(control, GetTradeItemLink(tradeId, slotIndex))
    end)
    ZO_PostHook(ItemTooltip, "SetStoreItem", function(control, slotIndex)
      callback(control, GetStoreItemLink(slotIndex))
    end)
    ZO_PostHook(ItemTooltip, "SetQuestReward", function(control, rewardIndex)
      callback(control, GetQuestRewardItemLink(rewardIndex))
    end)
    ZO_PostHook(ItemTooltip, "SetTradingHouseItem", function(control, slotIndex)
      callback(control, GetTradingHouseSearchResultItemLink(slotIndex))
    end)
    ZO_PostHook(ItemTooltip, "SetTradingHouseListing", function(control, slotIndex)
      callback(control, GetTradingHouseListingItemLink(slotIndex))
    end)
    ZO_PostHook(PopupTooltip, "SetLink", function(control, itemLink)
      callback(control, itemLink)
    end)
  end

  HookItemTooltips(AddTooltipInfo)
end
