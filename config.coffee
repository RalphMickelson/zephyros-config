# ============================================ #
# Config file for Zephyros OS X Window Manager #
# ============================================ #

# Enable these to assist with testing
# bind "R", ["cmd", "alt"], -> reloadConfig()
# bind "T", ["cmd", "alt"], ->
#   log "This is a test"

# maximize window
bind "F", ["cmd", "alt"], ->
  win = api.focusedWindow()
  win.setFrame win.screen().frameWithoutDockOrMenu()

# maximize window on main screen (good for finding lost windows)
bind "M", ["cmd", "alt"], ->
  api.focusedWindow().setFrame api.mainScreen().frameWithoutDockOrMenu()

# center on screen
bind "C", ["cmd", "alt"], ->
  win = api.focusedWindow()
  sRect = win.screen().frameWithoutDockOrMenu()
  wRect = win.frame()
  wRect.origin.x = (sRect.size.width - wRect.size.width) / 2
  wRect.origin.y = (sRect.size.height - wRect.size.height) / 2
  win.setFrame wRect

# =========== CMD + ALT === Scale by 1/2 ============================

bind "left" , ["cmd", "alt"], ->
  win = api.focusedWindow()
  sRect = win.screen().frameWithoutDockOrMenu()
  wRect = win.frame()
  return lft 1/2 if wRect.origin.x != sRect.origin.x
  setWin { w: 1/2 }, wRect

bind "up"   , ["cmd", "alt"], ->
  win = api.focusedWindow()
  sRect = win.screen().frameWithoutDockOrMenu()
  wRect = win.frame()
  return top 1/2 if wRect.origin.y != sRect.origin.y
  setWin { h: 1/2 }, wRect

bind "right", ["cmd", "alt"], ->
  sRect = getScr()
  wRect = getWin().frame()
  sRgt = sRect.origin.x + sRect.size.width
  wRgt = wRect.origin.x + wRect.size.width
  return rgt 1/2 if Math.abs(wRgt - sRgt) > 5 # fuzzy logic for right edge
  setWin { w: 1/2, x: 1/2 }, wRect

bind "down", ["cmd", "alt"], ->
  sRect = getScr()
  wRect = getWin().frame()
  sBot = sRect.origin.y + sRect.size.height
  wBot = wRect.origin.y + wRect.size.height
  return bot 1/2 if Math.abs(wBot - sBot) > 20 # fuzzy logic of bottom edge
  setWin { h: 1/2, y: 1/2 }, wRect

# =========== CMD + ALT + SHFT ======= Drag ========================

bind "left" , ["cmd", "alt", "shift"], -> setWin { x:-1 }, getWin().frame()
bind "right", ["cmd", "alt", "shift"], -> setWin { x: 1 }, getWin().frame()
bind "up"   , ["cmd", "alt", "shift"], -> setWin { y:-1 }, getWin().frame()
bind "down" , ["cmd", "alt", "shift"], -> setWin { y: 1 }, getWin().frame()

# =========== CMD + ALT + CTRL =======Throw to other screen ============

bind "left" , ["cmd", "alt", "ctrl"], ->
  win = api.focusedWindow()
  win.setFrame win.screen().previousScreen().frameWithoutDockOrMenu()

bind "right" , ["cmd", "alt", "ctrl"], ->
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
  r.origin.x += r.size.width  * mult.x if mult.x
  r.origin.y += r.size.height * mult.y if mult.y

  # Change the size by a multiplier
  r.size.width  *= mult.w if mult.w
  r.size.height *= mult.h if mult.h

  win.setFrame r
