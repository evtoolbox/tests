-------------------------------------------------------------------------------
--                                                                           --
-- Copyright 2018 EligoVision. Interactive Technologies                      --
--                                                                           --
-- Permission is hereby granted, free of charge, to any person obtaining a   --
-- copy of this software and associated documentation files                  --
-- (the "Software"), to deal in the Software without restriction, including  --
-- without limitation the rights to use, copy, modify, merge, publish,       --
-- distribute, sublicense, and/or sell copies of the Software, and to permit --
-- persons to whom the Software is furnished to do so, subject to the        --
-- following conditions:                                                     --
--                                                                           --
-- The above copyright notice and this permission notice shall be included   --
-- in all copies or substantial portions of the Software.                    --
--                                                                           --
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS   --
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF                --
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.    --
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY      --
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,      --
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE         --
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                    --
--                                                                           --
-------------------------------------------------------------------------------

-- Timer time vs real time test

-- EV Toolbox 3.2.0-beta7

local scene			= reactorController:getReactorByName("Scene")
local time			= reactorController:getReactorByName("time")
local pendingTimer	= reactorController:getReactorByName("pendingTimer")
local counter		= reactorController:getReactorByName("tick")

local startTime		= 0
local period		= 0
local timerTime		= 0
local systemTime	= 0

function setText(v1, v2)
	time.text.value = string.format("%1.4f | %1.4f", v1, v2)
	-- loginfo(time.text.value)
end

scene:subscribeEvent("onClick", function()
	startTime	= pendingTimer._startTime -- Private API!
	period		= pendingTimer.period
	timerTime	= 0
	systemTime	= 0

	setText(timerTime, systemTime)
end)

pendingTimer:subscribeEvent("onAlarm", function()
	timerTime	= timerTime + period
	systemTime	= pendingTimer.timer:getTime() - startTime

	setText(timerTime, systemTime)
end)
