KaleidoAchievementItems = {}

local this = KaleidoAchievementItems
this.name = "KaleidoAchievementItems"
this.version = "1.1.0"
this.author = "grin3671"

-- this table contains itemsIds (string) and related achievementIds (integer)
this.addonData = {
  ---- Elsweyr (already has progress in tooltip)
  -- ["147929"] = 2519, -- Mummified Alfiq Part
  -- ["147930"] = 2520, -- Plague-Drenched Fabric
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
}


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
      local achievementId = this.addonData[tostring(itemId)]
      if achievementId ~= nil then
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
    local achievementId = this.addonData[tostring(itemId)]
    if achievementId ~= nil then
      -- local name, description, points, icon, completed, date, time = GetAchievementInfo(achievementId)
      local name = GetAchievementInfo(achievementId)
      local criterions = GetAchievementNumCriteria(achievementId)

      control:AddVerticalPadding(10)
      control:AddLine(name, 'ZoFontHeader2', 1, 1, 1, CENTER, MODIFY_TEXT_TYPE_NONE, CENTER, false)
      
      for i=1,GetAchievementNumCriteria(achievementId) do
        local criterionDesctiprion, criterionNumCompleted, criterionNumRequired = GetAchievementCriterion(achievementId, i)
        local isCriterionComplete = criterionNumCompleted >= criterionNumRequired
        -- local progressText = zo_strformat(SI_PROMOTIONAL_EVENT_TRACKER_PROGRESS_FORMATTER, criterionNumCompleted, criterionNumRequired)
        control:AddLine(ColorText("C5C29E", criterionDesctiprion .. ": ") .. ColorText(isCriterionComplete and "2ADC22" or "FFFFFF", criterionNumCompleted) .. ColorText("C5C29E", "/" .. criterionNumRequired), 'ZoFontGame', 1, 1, 1, CENTER, MODIFY_TEXT_TYPE_NONE, CENTER, false)
      end

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
      callback(control, GetTradeItemLink(slotIndex))
    end)
    ZO_PostHook(ItemTooltip, "SetStoreItem", function(control, slotIndex)
      callback(control, GetStoreItemLink(slotIndex))
    end)
    ZO_PostHook(PopupTooltip, "SetLink", function(control, itemLink)
      callback(control, itemLink)
    end)
  end

  HookItemTooltips(AddTooltipInfo)
end
