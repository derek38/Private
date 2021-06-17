-- Script-Analyser Rewrite (From the Ground Up (hence why its  garbage in its current state))
getgenv().Previous = "";
local request = syn.request or request or http.request
getgenv().Toggles = {
   SpyRequests = true,
   BlockRequests  = false,
   DeleteWebhooks = true, -- Kinda Toxic. Wouldn't do it if i were you.
   HttpGetSpyer = true,
   synTableSpy = true,
   new_G = true,
   clonefunctionBlock = true,
   hookfunctionBlock = true,
   IndexSpy = false,
   Instance_newSpy = false,
   readonlyChanged = true,
}
if getgenv().Executed and getgenv().Executed == true then
   error("already executed")
end
getgenv().Executed = true;

rconsoleprint([[ok]])
wait(2)
rconsoleprint("\n")

rconsoleprint("@@LIGHT_BLUE@@")
rconsoleprint([[    Documentation [

           SpyRequests -- Simple enough, it spies on syn.request.

           BlockRequests -- Blocks all HTTP requests made with syn.request and game.HttpGet (still logs attempts)
  
           DeleteWebhooks -- Automatically does a DELETE request on any webhook requests that come through.
  
           HttpGetSpyer -- Spies on game.HttpGet requests.
  
           new_G -- alerts you of all objects created in _G.
  
           clonefunctionBlock -- blocks the use of clonefunction

           hookfunctionBlock -- blocks the use of hookfunction

           IndexSpy -- spies on all indexes made. (EG: game.Players.LocalPlayer)
          
           Instance_newSpy -- spies on all Instance.new creations.
  
           readonlyChanged -- Alerts you of any changes to tables writability
   ] ]])
wait(1)
rconsoleerr("- LOADED")
local function rprint(Header, Body)
   rconsoleprint("\n")
   rconsoleprint("@@BLUE@@");
   rconsoleprint("["..Header.."]".."\n");
   rconsoleprint("@@WHITE@@");
   rconsoleprint(Body);
   rconsoleprint("\n\n");
end
local oldsyn_request;
oldsyn_request = hookfunction(request, function(tbl)
   if Toggles.SpyRequests and tbl.Method ~= "DELETE" then
       rprint("Http Spy", "A HTTP Request was sent to the following URL: "..tostring(tbl.Url) .. "\n\n Containg the following Body: "..tostring(tbl.Body))
   end
   if Toggles.DeleteWebhooks and tbl.Url:find("api/webhooks/") and tbl.Method ~= 'DELETE' then
       rprint("Webhook Deleter", "Requested webhook: "..tbl.Url)
       return request({Url = tbl.Url, Method = 'DELETE'})
   end
   if Toggles.BlockRequests then
       return;
   end
   Previous = "HttpRequest";
   return oldsyn_request(tbl);
end)
local old_httpget;
old_httpget = hookfunction(game.HttpGet, function(...)
   local args = {...};
   if Toggles.HttpGetSpyer then
       rprint("HttpGet Spy", "game.HttpGet was called with the URL: "..tostring(args[2]))
   end
   if Toggles.BlockRequests then
       return old_httpget("https://google.com/");
   end
   Previous = "HttpGet";
   return old_httpget(...)
end)
local old_instnew;
old_instnew = hookfunction(Instance.new, function(...)
    local args = {...}
   if Toggles.Instance_newSpy and checkcaller() then
       rprint("Instance.new Spy", "A new instance was created: "..tostring(args[1]))
       return old_instnew(...)
   end
   Previous="I don't remember, really."
   return old_instnew(...)
end)
local mt = getrawmetatable(game);
local oldindex = mt.__index;
setreadonly(mt,false)
mt.__index = newcclosure(function(self,key)
   if Toggles.IndexSpy and checkcaller() and Previous ~= "Index" then
       Previous = "Index";
       rprint("Index Spy", "Parents: " .. tostring(self) .. " \n Indexed: "..tostring(key) .. "\n")
   elseif Toggles.IndexSpy and checkcaller() and Previous == "Index" then
       Previous = "Index";
       rconsoleprint("Parent: "..tostring(self) .. " \n Indexed: "..tostring(key) .. "\n\n")
   end
   Previous="I don't remember, really."
   return oldindex(self,key)
end)
setmetatable(_G,{__newindex = function(k,t,v) -- thanks egg salad x2 *nuzzles rawr :3*
   if Toggles.new_G then
       rprint("New Index Spy (_G)", "A new variable was created in _G: "..tostring(t).." | Value: "..tostring(v).. " | Type: "..typeof(v))
       rawset(k,t,v)
       Previous="I don't remember, really."
   end
end})
setmetatable(getrenv()._G,{__newindex = function(k,t,v) -- thanks egg salad x2 *nuzzles rawr :3*
   if Toggles.new_G then
       rprint("New Index Spy (getrenv._G)", "A new variable was created in Roblox's _G: "..tostring(t).." | Value: "..tostring(v).. " | Type: "..tostring(typeof(v)))
       rawset(k,t,v)
       Previous="I don't remember, really."
   end
end})
setreadonly(syn,false)
setreadonly(getgenv(),false)

setmetatable(syn,{__newindex = function(k,t,v)
   if Toggles.synTableSpy then
       rprint("New Index Spy (syn)", "A new variable was created in syn: "..tostring(t).." | Value: "..tostring(v).. " | Type: "..tostring(typeof(v)));
       rawset(k,t,v)
       Previous="I don't remember, really."
   end
end})
local old_isreadonly;
old_isreadonly = hookfunction(setreadonly, function(t,b)
   if Toggles.readonlyChanged then
       rprint("isreadonly Change Spy" ,"The readability of the "..tostring(t).." Has changed. It is now "..tostring(isreadonly(t)))
   end
   Previous = "when will i stop using this"
   return old_isreadonly(t,b)
end) -- I cant fucking be bothered fucking changing this shit to support all functions (is_writeonly and whatnot fuck those)
local old_clonefunc;
old_clonefunc = hookfunction(clonefunction, function(f)
   if Toggles.clonefunctionBlock then
       rprint("Clonefunction Blocker", "a function cloning attempt was made, returning the original function.")
       return f;
   end
   Previous = "Fuckin hell"
   return old_clonefunc(f)
end)
local oldhook;
oldhook = hookfunction(hookfunction, function(f,f2)
   if Toggles.hookfunctionBlock then
       rprint("Hookfunction BLocker", "A hookfunction attempt was made. Returning hooked argument as original function.")
       return oldhook(f,f);
   end
   Previous = "Im gonna say the N word if i have to do thi shit one more time"
   return oldhook(f,f2);
end)
