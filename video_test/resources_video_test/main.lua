-- Toolbox version >= 3.3 required

EV.Logger.setCatPriority("ev_osg.EVosgAV", "DEBUG")


CFG_HISTORY_SIZE		= 8
CFG_TEST_PERIOD			= 5.0	-- seconds
CFG_VOLUME_STEP			= 0.1

local video				= reactorController:getReactorByName("video")
local btnTest			= reactorController:getReactorByName("btn_test")
local timer				= reactorController:getReactorByName("timer")

local btnVolumeUp		= reactorController:getReactorByName("btn_volume_up")
local btnVolumeDown		= reactorController:getReactorByName("btn_volume_down")

btnVolumeUp:subscribeEvent("onDown", function()
	video.volume = math.min(1.0, video.volume + CFG_VOLUME_STEP)
	loginfo("Volume =", video.volume)
end)

btnVolumeDown:subscribeEvent("onDown", function()
	video.volume = math.max(0.0, video.volume - CFG_VOLUME_STEP)
	loginfo("Volume =", video.volume)
end)


local tests = {
	{ "play" },
	{ "pause" },
	{ "rewind", "play" },
	{ "stop", "hide" },
	{ "play", "show" },
}
local currentTest = 1

timer:subscribeEvent("onAlarm", function()
	loginfo("test", currentTest, "of", #tests)
	for _, action in ipairs(tests[currentTest]) do
		loginfo("\tperform action", action)
		video[action](video)
	end
	currentTest = currentTest + 1

	if currentTest > #tests then timer:reset() end
end)

btnTest:subscribeEvent("onDown", function()
	timer:reset()
	currentTest = 1
	timer:start(CFG_TEST_PERIOD, TimerReactor.Mode.LOOP)
end)

--------------------------------------------------------------------------------

local lblLastEvent		= reactorController:getReactorByName("lbl_last_event")
local lblEventsHistory	= reactorController:getReactorByName("lbl_events_history")

lblLastEvent.text.value			= ""
lblEventsHistory.text.value		= ""

local eventsHistory = {}
local events = {
	"onPlay",
	"onPause",
	"onFinish",
	"onRewind",
	"onShowed",
	"onHidden",
}

function updateLog(eventName)
	table.insert(eventsHistory, eventName)
	if #eventsHistory > CFG_HISTORY_SIZE then
		table.remove(eventsHistory, 1)
	end

	local text = ""
	for i = #eventsHistory, 1, -1 do
		text = text .. eventsHistory[i] .. "\n"
	end

	-- lblLastEvent.text.value			= eventName
	lblEventsHistory.text.value		= text
end

for _, eventName in ipairs(events) do
	video:subscribeEvent(eventName, function()
		loginfo("Received event", eventName)
		updateLog(eventName)
	end)
end
