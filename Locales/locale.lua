local _, addon = ...

-- Initialize localization table
addon.L = { }

-- Store reference to localizations table
local localizations = addon.L

-- Get current game locale and normalize British English to American English
local locale = GetLocale()
if(locale == 'enGB') then
	locale = 'enUS'
end

-- Metatable for localization system
-- Provides dynamic locale table creation and fallback functionality
setmetatable(addon.L, {
	-- __call metamethod: Creates a new locale table when called as a function
	-- Usage: addon.L('frFR') returns the French localization table
	-- @param newLocale: string - The locale code (e.g., 'frFR', 'deDE', 'esES')
	-- @return table - The localization table for the specified locale
	__call = function(_, newLocale)
		localizations[newLocale] = {}
		return localizations[newLocale]
	end,
	
	-- __index metamethod: Provides automatic fallback for missing translations
	-- When a key is accessed, it first checks the current locale table
	-- If not found, returns the key itself as a string (for debugging purposes)
	-- @param key: string - The localization key to look up
	-- @return string - The localized text or the key itself if not found
	__index = function(_, key)
		local localeTable = localizations[locale]
		return localeTable and localeTable[key] or tostring(key)
	end
})