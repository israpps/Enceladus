--Secrman.init()
Screen.clear(Color.new(255,255,255))

while true do
end
Font.fmLoad() 
Font.fmPrint(150, 25, 0.6, "Hello motherfucker\n")

if System.doesFileExist("System/system.lua") then
	dofile("System/system.lua");
end

Screen.clear(Color.new(255,0,0))
while true do
end