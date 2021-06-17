--@Obfuscator
local Script = [[print('derek38')]]
local Obfuscated = ''

for Letter in Script:gmatch('.') do
    Obfuscated = Obfuscated..'\\'..Letter:byte()
end

setclipboard('loadstring("'..Obfuscated..'")()')
