#         1         2         3         4         5         6         7         8
#12345678901234567890123456789012345678901234567890123456789012345678901234567890

find = (name) ->
  log name
  for app in api.runningApps()
    log app.title()
    if app.name() == title
      log app.title()
      return app.visibleWindows()[0]

# useful for testing
bind "R", ["cmd", "alt"], -> reloadConfig()
bind "T", ["cmd", "alt"], ->
  log find('Emacs').title()

# maximize window
bind "F", ["cmd", "alt"], ->
  win = api.focusedWindow()
  win.setFrame win.screen().frameWithoutDockOrMenu()

# push to top half of screen
bind "C", ["cmd", "alt"], ->
  win = api.focusedWindow()
  sRect = win.screen().frameWithoutDockOrMenu()
  wRect = win.frame()
  wRect.origin.x = (sRect.size.width - wRect.size.width) / 2
  wRect.origin.y = (sRect.size.height - wRect.size.height) / 2
  win.setFrame wRect

# =========== CTRL+ALT === Scale by 1/2 ============================

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
  return rgt 1/2 if Math.abs(wRgt - sRgt) > 4
  setWin { w: 1/2, x: 1/2 }, wRect

bind "down", ["cmd", "alt"], ->
  sRect = getScr()
  wRect = getWin().frame()
  sBot = sRect.origin.y + sRect.size.height
  wBot = wRect.origin.y + wRect.size.height
  return bot 1/2 if Math.abs(wBot - sBot) > 20
  setWin { h: 1/2, y: 1/2 }, wRect

# =========== CTRL+ALT_SHFT ======= Drag ========================

bind "left" , ["cmd", "alt", "shift"], -> setWin { x:-1 }, getWin().frame()
bind "right", ["cmd", "alt", "shift"], -> setWin { x: 1 }, getWin().frame()
bind "up"   , ["cmd", "alt", "shift"], -> setWin { y:-1 }, getWin().frame()
bind "down" , ["cmd", "alt", "shift"], -> setWin { y: 1 }, getWin().frame()

# =========== CTRL+ALT ===============================

bind "left" , ["cmd", "alt", "ctrl"], ->
  scr = getScr()
  win = getWin().frame()
  return lft 1/2 if win.origin.x != scr.origin.x
  m = scr.size.width / win.size.width
  setWin { s: m / (m + 1) }, win

bind "up"   , ["cmd", "alt", "ctrl"], ->
  scr = getScr()
  win = getWin().frame()
  return top 1/2 if win.origin.y != scr.origin.y
  m = scr.size.height / win.size.height
  setWin { sh:  m / (m + 1) }

top = (h) -> setWin { h: h }
bot = (h) -> setWin { h: h, y: 1-h }
lft  = (w) -> setWin { w: w }
rgt  = (w) -> setWin { w: w, x: 1-w }
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
  r.origin.x += r.size.width  * mult.x if mult.x
  r.origin.y += r.size.height * mult.y if mult.y
  r.size.width  *= mult.w if mult.w
  r.size.height *= mult.h if mult.h
  win.setFrame r

# Sets the current window size/loc based on box(w,h,x,y) # all optional attr
# Param box is relative current window rect
# setWin = (box) ->
#   r = getWin().frame()
#   r.origin.x += r.size.width * box.x if box.x
#   r.origin.y += r.size.height * box.y if box.y
#   r.size.width  *= box.w if box.w
#   r.size.height *= box.h if box.h
#   getWin().setFrame r

# Ralphs App specific settings

bind "pad7", ["cmd", "alt"], -> topLft 1/4, 1/3 # left short
bind "pad4", ["cmd", "alt"], -> topLft 1/4, 2/3 # left med
bind "pad1", ["cmd", "alt"], -> topLft 1/4, 1   # left long

# mid small size
bind "pad8", ["cmd", "alt"], ->
  win = api.focusedWindow()
  frame = win.screen().frameWithoutDockOrMenu()
  frame.origin.x += frame.size.width * 1/4
  frame.size.width *= 5/12
  frame.size.height *= 1/3
  win.setFrame frame

# mid med size
bind "pad5", ["cmd", "alt"], ->
  win = api.focusedWindow()
  frame = win.screen().frameWithoutDockOrMenu()
  frame.origin.x += frame.size.width * 1/4
  frame.size.width *= 5/12
  frame.size.height *= 2/3
  win.setFrame frame

# mid long size
bind "pad2", ["cmd", "alt"], ->
  win = api.focusedWindow()
  frame = win.screen().frameWithoutDockOrMenu()
  frame.origin.x += frame.size.width * 1/4
  frame.size.width *= 5/12
  win.setFrame frame

bind "pad9", ["cmd", "alt"], -> topRgt 1/3, 1/3 # right small size
bind "pad6", ["cmd", "alt"], -> topRgt 1/3, 2/3 # right mid size
bind "pad3", ["cmd", "alt"], -> topRgt 1/3, 1   # right large size

# emacs size
bind "pad+", ["cmd", "alt"], ->
  win = api.focusedWindow()
  frame = win.screen().frameWithoutDockOrMenu()
  frame.origin.x += frame.size.width * 1/4
  frame.origin.y += frame.size.height * 1/3
  frame.size.width *= 3/4
  frame.size.height *= 2/3
  win.setFrame frame

# alt emacs size
bind "pad_enter", ["cmd", "alt"], ->
  win = api.focusedWindow()
  frame = win.screen().frameWithoutDockOrMenu()
  frame.origin.x += frame.size.width * 1/4
  frame.origin.y += frame.size.height * 2/3
  frame.size.width *= 3/4
  frame.size.height *= 1/3
  win.setFrame frame
