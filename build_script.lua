--this should be in main as main.lua, then when exporting, replace main.lua with main_game.lua
cd '/source/puzzlegame/'

cp('scripts', '/ram/cart/scripts')
cp('includes', '/ram/cart/includes')
cp('main.lua', '/ram/cart/main_game.lua')

cd '/ram/cart/'

include 'main_game.lua'
