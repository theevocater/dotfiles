tell application "System Events"
	set darkm to get dark mode of appearance preferences
end tell
tell application "Terminal"
	if darkm then
		set default settings to settings set "Solarized Dark"
	else
		set default settings to settings set "Solarized Light"
	end if
	set wlist to every window
	repeat with w in wlist
		-- For some reason, there is always a blank window in the list so we ignore it here to not error out
		if name of w is not "" then
			set tlist to every tab of w
			repeat with t in tlist
				if darkm then
					set current settings of t to (first settings set whose name is "Solarized Dark")
				else
					set current settings of t to (first settings set whose name is "Solarized Light")
				end if
			end repeat
		end if
	end repeat
end tell
