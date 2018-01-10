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

originX = figma.Locations.x

pluspos = -235
fhpos = 130

figma.Locations.on Events.DragEnd, ->
  if figma.Locations.x < (originX - 100)
    figma.Locations.animate
      properties:
        x: pluspos
        y: 20
      curve: "ease"
      time: 0.3
  else if figma.Locations.x > (originX + 100)
    figma.Locations.animate
      properties:
        x: fhpos
        y: 20
      curve: "ease"
      time: 0.3
  else
    figma.Locations.animate
      properties:
        x: originX
        y: 20
      curve: "ease"
      time: 0.3

###
Numbers = new Layer
Numbers.html = figma.Locations.x
###

figma.Group.onClick (event, layer) ->
	figma.Locations.animate
		properties:
			x: fhpos
			y: 20
		curve: "ease"
		time: 0.3

figma.plus.onClick (event, layer) ->
	figma.Locations.animate
		properties:
			x: pluspos
			y: 20
		curve: "ease"
		time: 0.3

###
heuterot = 0

skalaclip = new Layer
	width: 220
	height: 220
	rotation: heuterot
	originY: 0
#	borderRadius: "50%"
#	backgroundColor: "transparent"
	x: 38
	y: 116+107

# mask.style['-webkit-mask-image'] = '-webkit-radial-gradient(circle, white, black)'

figma.Heute.parent = skalaclip
figma.Heute.x = -0
figma.Heute.y = -107
figma.Heute.rotation = -heuterot


skalaclip.clip = true
###
gesternval = 100
heuteval = 100

figma.Gestern.style.webkitClipPath = "polygon(50% 50%, 0% "+gesternval+"%, 1% 100%, 100% 100%)"

figma.Heute.style.webkitClipPath = "polygon(50% 50%, 0% "+heuteval+"%, 1% 100%, 100% 100%)"

inv = new Layer
	backgroundColor: "transparent"

inv.animate 
	properties: {x: 1}
	curve: "ease"
	delay: 2
	time: 2

inv.on "change:x", ->
	gesternval = 100 - (98 * inv.x)
	figma.Gestern.style.webkitClipPath = "polygon(50% 50%, 0% "+gesternval+"%, 1% 100%, 100% 100%)"
	heuteval = 100 - (45 * inv.x)
	figma.Heute.style.webkitClipPath = "polygon(50% 50%, 0% "+heuteval+"%, 1% 100%, 100% 100%)"
#	print figma.Gestern.style.webkitClipPath
