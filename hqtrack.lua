_addon.name = "hqtrack"
_addon.author = "Darkdoom/Uwu"
_addon.version = "0.1"
_addon.command = "hq"

packets = require 'packets'
texts   = require 'texts'
require('default_settings')
settings = (defaults)
text_box = texts.new(settings.player)

Break = 0
NQ = 0
HQ = 0
Break_Per = 0
NQ_Per = 0
HQ_Per = 0
Total = 0


function round(num, numDecimalPlaces)
  
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))

end  

windower.register_event('addon command', function(...)
    
    local args = {...}
    
    if #args == 1 and args[1]:lower() == "reset" then
      
      Break = 0
      NQ = 0
      HQ =  0
      Break_Per = 0
      NQ_Per = 0
      HQ_Per = 0
      Total = 0
      
      new_text = "Total/%\n" .. "Break: " .. Break .. " | " .. round(Break_Per, 0) .. "% \nNQ:     " .. NQ .. " | " .. round(NQ_Per, 0) .. "% \nHQ:     " .. HQ ..         " | " .. round(HQ_Per, 0) .. "% \nTotal:  " .. Total
      
      text_box:text(new_text)
      text_box:update()
      
    end

end)
      


windower.register_event('incoming chunk', function(id, data)
    
    if id == 0x030 then
      
      local craft_result = packets.parse('incoming', data)
      
      if craft_result['Param'] == 1 then
        
        Break = Break + 1
        Total = Total + 1
        
      elseif craft_result['Param'] == 0 then
        
        NQ    = NQ + 1
        Total = Total +1
        
      elseif craft_result['Param'] == 2 then
        
        HQ    = HQ + 1
        Total = Total +1
        
      end
      
      Break_Per = Break / Total * 100
      NQ_Per    = NQ / Total * 100
      HQ_Per    = HQ / Total * 100
      
      new_text = "Total/%\n" .. "Break: " .. Break .. " | " .. round(Break_Per, 0) .. "% \nNQ:     " .. NQ .. " | " .. round(NQ_Per, 0) .. "% \nHQ:     " .. HQ .. " | " .. round(HQ_Per, 0) .. "% \nTotal:  " .. Total
      
      if new_text ~= nil then
        
        text_box:text(new_text)
        text_box:visible(true)
        
      end
      
    end
    
  end)

