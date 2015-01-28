
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end
package.path = package.path..";./src/?.lua;./src/cocos/?.lua;./src/framework/?.lua;./src/scenes/?.lua;./src/server/?.lua"
require("config")
require("pack")
require("scenes.scene").new()