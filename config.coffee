# ============================================ #
# Config file for Zephyros OS X Window Manager #
# ============================================ #

baseKeyMods = ["cmd", "ctrl"]

# Enable these to assist with testing
# bind "R", ["cmd", "ctrl"], -> reloadConfig()
# bind "T", ["cmd", "ctrl"], ->
#   log "This is a test"

# maximize window
bind "F", baseKeyMods, ->
  win = api.focusedWindow()
  win.setFrame win.screen().frameWithoutDockOrMenu()

# maximize window on main screen (good for finding lost windows)
bind "M", baseKeyMods, ->
  api.focusedWindow().setFrame api.mainScreen().frameWithoutDockOrMenu()

# center on screen
bind "C", baseKeyMods, ->
  win = api.focusedWindow()
  sRect = win.screen().frameWithoutDockOrMenu()
  wRect = win.frame()
  wRect.origin.x = sRect.origin.x + (sRect.size.width - wRect.size.width) / 2
  wRect.origin.y = sRect.origin.y + (sRect.size.height - wRect.size.height) / 2
  win.setFrame wRect

# =========== CMD + ALT === Scale by 1/2 ============================

bind "left", baseKeyMods, ->
  win = api.focusedWindow()
  sRect = win.screen().frameWithoutDockOrMenu()
  wRect = win.frame()
  return lft 1/2 if wRect.origin.x != sRect.origin.x
  setWin { w: 1/2 }, wRect

bind "up", baseKeyMods, ->
  win = api.focusedWindow()
  sRect = win.screen().frameWithoutDockOrMenu()
  wRect = win.frame()
  return top 1/2 if wRect.origin.y != sRect.origin.y
  setWin { h: 1/2 }, wRect

bind "right", baseKeyMods, ->
  sRect = getScr()
  wRect = getWin().frame()
  sRgt = sRect.origin.x + sRect.size.width
  wRgt = wRect.origin.x + wRect.size.width
  return rgt 1/2 if Math.abs(wRgt - sRgt) > 5 # fuzzy logic for right edge
  setWin { w: 1/2, x: 1/2 }, wRect

bind "down", baseKeyMods, ->
  sRect = getScr()
  wRect = getWin().frame()
  sBot = sRect.origin.y + sRect.size.height
  wBot = wRect.origin.y + wRect.size.height
  return bot 1/2 if Math.abs(wBot - sBot) > 20 # fuzzy logic of bottom edge
  setWin { h: 1/2, y: 1/2 }, wRect

# =========== CMD + ALT + SHFT ======= Drag ========================
dragKeyMods = baseKeyMods.concat "shift"
bind "left" , dragKeyMods, -> setWin { x:-1 }, getWin().frame()
bind "right", dragKeyMods, -> setWin { x: 1 }, getWin().frame()
bind "up"   , dragKeyMods, -> setWin { y:-1 }, getWin().frame()
bind "down" , dragKeyMods, -> setWin { y: 1 }, getWin().frame()

# =========== CMD + ALT + CTRL =======Throw to other screen ============
throwKeyMods = baseKeyMods.concat "alt"
bind "left", throwKeyMods, ->
  win = api.focusedWindow()
  win.setFrame win.screen().previousScreen().frameWithoutDockOrMenu()

bind "right", throwKeyMods, ->
  win = api.focusedWindow()
  win.setFrame win.screen().nextScreen().frameWithoutDockOrMenu()

# =============== Support Functions ===================

top = (h) -> setWin { h: h }
bot = (h) -> setWin { h: h, y: 1-h }
lft = (w) -> setWin { w: w }
rgt = (w) -> setWin { w: w, x: 1-w }
topLft = (w, h) -> setWin { w: w, h: h }
botLft = (w, h) -> setWin { w: w, h: h, y: 1-h }
topRgt = (w, h) -> setWin { w: w, h: h, x: 1-w }
botRgt = (w, h) -> setWin { w: w, h: h, x: 1-w, y: 1-h }

# Returns a Window object of current focued window
getWin = () -> api.focusedWindow()

# Returns a Rect(origin, size) of current screen
getScr = () -> getWin().screen().frameWithoutDockOrMenu()

# Sets the current window size/loc based on mult(w,h,x,y);  all optional attr
# An optional reference rectangle may be passed; defaults to the screen
setWin = (mult, r) ->
  win = api.focusedWindow()
  r ||= win.screen().frameWithoutDockOrMenu()

  # Change the position by a muliple of the 'prior' size
  # (multiplier may be fractional, positive or negative)
  r.origin.x += Math.floor(r.size.width  * mult.x) if mult.x
  r.origin.y += Math.floor(r.size.height * mult.y) if mult.y

  # Change the size by a multiplier
  r.size.width  = Math.floor(r.size.width  * mult.w) if mult.w
  r.size.height = Math.floor(r.size.height * mult.h) if mult.h

  win.setFrame r
