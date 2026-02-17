local _, addon = ...

-- Localization system for QuickTravel addon
-- Provides dynamic locale management with automatic fallback functionality
addon.L = { }

-- Reference to the main localizations storage
local localizations = addon.L

-- Get current game locale with British English normalization
-- WoW treats enGB and enUS identically for most purposes
local locale = GetLocale()
if(locale == 'enGB') then
	locale = 'enUS'
end

-- Advanced metatable system for intelligent localization handling
-- Enables both dynamic locale creation and automatic string fallback
setmetatable(addon.L, {
	-- __call metamethod: Factory function for creating new locale tables
	-- Allows syntax: addon.L('frFR') to create/access French localizations
	-- @param self: table - The addon.L table (unused but required by Lua)
	-- @param newLocale: string - Target locale code (e.g., 'frFR', 'deDE', 'esES')
	-- @return table - The localization table for the specified locale
	__call = function(_, newLocale)
		local localeTable = rawget(localizations, newLocale)
		if localeTable == nil then
			localeTable = {}
			rawset(localizations, newLocale, localeTable)
		end
		return localeTable
	end,
	
	-- __index metamethod: Automatic translation lookup with intelligent fallback
	-- Searches current locale first, then enUS, then returns key as string
	-- This prevents nil access errors and aids in identifying untranslated strings
	-- @param self: table - The addon.L table (unused but required by Lua)
	-- @param key: string - The localization key to retrieve
	-- @return string - Localized text from current locale/enUS or the key itself if not found
	__index = function(_, key)
		local localeTable = rawget(localizations, locale)
		if localeTable then
			local translatedValue = rawget(localeTable, key)
			if translatedValue ~= nil then
				return translatedValue
			end
		end

		local defaultLocaleTable = rawget(localizations, 'enUS')
		if defaultLocaleTable then
			local fallbackValue = rawget(defaultLocaleTable, key)
			if fallbackValue ~= nil then
				return fallbackValue
			end
		end

		return tostring(key)
	end
})
