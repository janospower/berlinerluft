# Import file "Berliner Luft Framer Sync (Page 1)"
figma = Framer.Importer.load("imported/Berliner%20Luft%20Framer%20Sync%20(Page%201)@2x", scale: 1)

# Set-up FlowComponent
flow = new FlowComponent
flow.showNext(figma.Übersichtsscreen_Grafik_komplett)

# Background for Cover
bg = new Layer
	backgroundColor: "transparent"

scroll = ScrollComponent.wrap(figma.content)
scroll.scrollHorizontal = false
scroll.mouseWheelEnabled = true

originX = figma.Locations.x
originY = figma.Locations.y

figma.Locations.draggable.enabled = true
figma.Locations.draggable.speedY = 0
figma.Locations.draggable.constraints = {
	x: -280
	y: 0
	width: 860
	height: 80
}

startx = 0
deltx = 0
originX = figma.Locations.x

figma.Locations.on Events.DragStart, ->
	startx = event.x
	deltx = startx

figma.Locations.on Events.DragMove, ->
	deltx = startx - event.x
	##Numbers.html = figma.Locations.x

figma.Locations.on Events.DragEnd, ->
  if figma.Locations.x < (originX - 100)
    figma.Locations.animate
      properties:
        x: -285
      curve: "ease"
      time: 0.3
  else if figma.Locations.x > (originX + 100)
    figma.Locations.animate
      properties:
        x: 110
      curve: "ease"
      time: 0.3
  else
    figma.Locations.animate
      properties:
        x: originX
      curve: "ease"
      time: 0.3

###
Numbers = new Layer
Numbers.html = figma.Locations.x
###

figma.Group.onClick (event, layer) ->
	figma.Locations.animate
		properties:
			x: 110
		curve: "ease"
		time: 0.3

figma.Group_2_10.onClick (event, layer) ->
	figma.Locations.animate
		properties:
			x: -285
		curve: "ease"
		time: 0.3
