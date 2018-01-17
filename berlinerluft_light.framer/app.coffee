
{TextLayer, convertTextLayers} = require 'TextLayer'

# Import file "Framer Light Janos (Page 1)"
figma = Framer.Importer.load("imported/Framer%20Light%20Janos%20(Page%201)@2x", scale: 1)
convertTextLayers(figma, true)


# Set-up FlowComponent
flow = new FlowComponent
flow.showNext(figma.Übersichtsscreen_Grafik_komplett)

figma.skale_s.opacity = 0
hidden = [figma.Group_10,figma.Group_15,figma.Group_13,figma.Group_12,figma.Group_11]
for x, i in hidden
		hidden[i].visible = false


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
	parent: figma.Übersichtsscreen_Grafik_komplett

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





clusterdimension = 175
scrolling = false
scroll.onScrollStart ->
	scrolling = true
scroll.onScrollEnd ->
	scrolling = false

partball = (parentLayer, partcount) ->
	htmlLayer = new Layer(
		x: 0
		y: 0
		backgroundColor: "transparent"
		width: clusterdimension
		height: clusterdimension)
	htmlLayer.html = '<canvas></canvas>'
	htmlLayer.parent = parentLayer
	t = new TextLayer
		text: partcount
		color: 'white'
		y: 111
		fontFamily: 'Texta'
		fontWeight: '900'
		fontSize: '30'
		paddingLeft: 3
	t.parent = parentLayer
	
	scene = undefined
	camera = undefined
	renderer = undefined
	# Used in initParticles()
	particleGroup = undefined
	clock = undefined
	
	init = ->
		scene = new (THREE.Scene)
		camera = new (THREE.PerspectiveCamera)(15, 1, 0.1, 1000)
		camera.lookAt scene.position
		renderer = new (THREE.WebGLRenderer)(
			canvas: htmlLayer._elementHTML.childNodes[0]
			antialias: true)
		renderer.setSize htmlLayer.width, htmlLayer.height
		clock = new (THREE.Clock)
		camera.position.z = 5
		
	
	initParticles = ->
		particleGroup = new (SPE.Group)(texture: value: THREE.ImageUtils.loadTexture('./img/smokeparticle.png'))
		# Spherical velocity distributions.
		emitter = new (SPE.Emitter)(
			type: 2
			maxAge: value: 1
			position:
				value: new (THREE.Vector3)(-50 + 50, 0, 0)
				#radius: partcount/100
				radius: 5
				spread: undefined
			velocity:
				value: new (THREE.Vector3)(3, 3, 3)
				#value: new (THREE.Vector3)(1, 1, 1)
				distribution: SPE.distributions.SPHERE
			size: value: 0.5
			particleCount: partcount*1)
		particleGroup.addEmitter emitter
		scene.add particleGroup.mesh
		###
		geometry = new (THREE.CubeGeometry)(1, 1, 1)
		material = new (THREE.MeshBasicMaterial)(color: 0xffffff)
		cube = new (THREE.Mesh)(geometry, material)
		scene.add cube
		###
		return
	
	animate = ->
		requestAnimationFrame animate
		if scrolling == false and (scroll.scrollY - parentLayer.y) > -250
			now = Date.now() * 0.001
			camera.position.x = Math.sin(now) * 75
			camera.position.z = Math.cos(now) * 75
			camera.lookAt scene.position
			render clock.getDelta()
		return
	
	render = (dt) ->
		particleGroup.tick dt
		renderer.render scene, camera
		return
	
	init()
	initParticles()
	setTimeout animate, 0

values = [
	[figma.Particulate_Matter,300]
	[figma.Radon,55]
	[figma.Carbon,4]
	[figma.Sulfur,360]
	[figma.Nitrogen,190]
]

spawnparts = (v) ->
	for x, i in v
		partball v[i][0],v[i][1]

spawnparts(values)

figma.Skale.originY = 0

cutoff = 230
scroll.onMove ->
	if -cutoff < scroll.content.y < 0
		figma.Skale.originX = 0
		scrolled = scroll.content.y/(cutoff)
		figma.Skale.scale = 1 + 0.8 * scrolled
		figma.Skale.opacity = 1 + scrolled
		figma.skale_s.opacity = 0 - 0.75 - 2*scrolled
	else if scroll.content.y > 0
		figma.Skale.originX = 0.5
		scrolled = 0.2 * scroll.content.y/(cutoff)
		figma.Skale.scale = 1 + scrolled
		
scroll.onScrollEnd ->
	if scroll.content.y > -100
		scroll.scrollToPoint(
			x: 0, y: 0
			true
			curve: Bezier.ease, time: 1
		)
	else if scroll.content.y > -200
		scroll.scrollToPoint(
			x: 0, y: cutoff
			true
			curve: Bezier.ease, time: 1
		)

scaleback = (l,s) ->
	l.animate
				properties:
					scale: s
				curve: "ease-in"
				time: 0.3



overdet = (nav, layerA, layerB, overlay) ->
	layerB.x = 0
	layerB.y = 0
	options = {time: 10.2}
	return transition = 
		layerA:
			show:
				opacity: 1
				options: options
			hide:
				opacity: 0
				options: options
		layerB:
			show:
				opacity: 1
				options: options
			hide:
				opacity: 0
				options: options



gotodetail = (layer) ->
	screen = switch 
				when layer.name=="Nitrogen" then null
				when layer.name=="Carbon" then null
				when layer.name=="Sulfur" then null
				when layer.name=="Radon" then figma.radon
				when layer.name=="Particulate_Matter" then null
				else null
			if screen
				scaleback(layer,6,screen)
				layer.onAnimationEnd ->
					#print "I'm finished"
					flow.transition(screen, overdet)
					layer.scale = 1
			else
				scaleback(layer,1)


for x, i in values
	values[i][0].pinchable.enabled = true
	values[i][0].pinchable.threshold = 10
	values[i][0].pinchable.centerOrigin = false
	values[i][0].pinchable.minScale = 1
	values[i][0].pinchable.scaleFactor = 0.3
	values[i][0].pinchable.rotate = false
	values[i][0].onPinchEnd (event, layer) ->
		if layer.scale > 1.6
			gotodetail(layer)
		else
			scaleback(layer,1)
	values[i][0].onClick (event, layer) ->
		if layer.scale==1 or layer.scale>1.6
			gotodetail(layer)










# Radon detailansicht
figma.overview.onClick (event, layer) ->
	flow.showPrevious(overdet)