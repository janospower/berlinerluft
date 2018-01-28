# Import file "Framer Light Janos (Page 1)"
figma = Framer.Importer.load("imported/Framer%20Light%20Janos%20(Page%201)@2x", scale: 1)

Framer.Extras.Preloader.enable()
{TextLayer, convertTextLayers} = require 'TextLayer'

convertTextLayers(figma, true)
Framer.Device.deviceType = "apple-iphone-8-gold"

figma.Particulate_Matter.backgroundColor = 'transparent'



figma.criticalbg.opacity = 0
figma.criticalbg_2.opacity = 0
figma.BG_2.opacity = 0
figma.BG.opacity = 0
figma.Übersichtsscreen_Grafik_komplett.backgroundColor = 'transparent'
figma.radon.backgroundColor = 'transparent'

# Set-up FlowComponent
flow = new FlowComponent
#flow.showNext(figma.Übersichtsscreen_Grafik_komplett)
flow.showNext(figma.radon)
#flow.header = figma.Locations
#figma.Übersichtsscreen_Grafik_komplett.opacity = 0.5

bag = new BackgroundLayer
	#backgroundColor: "red"
	image: "images/bg.png"
	parent: flow


values = [
	[figma.Particulate_Matter,300]
	[figma.Radon,55]
	[figma.Carbon,4]
	[figma.Sulfur,360]
	[figma.Nitrogen,190]
]

total = 190

figma.skale_s.opacity = 0
hidden = [figma.Group_10_2,figma.Group_15,figma.Group_13,figma.Group_12,figma.Group_11]
for xx, i in hidden
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
			antialias: true
			alpha: true)
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




if total > 250
	figma.criticalbg.animate
		opacity: 1
else
	figma.criticalbg.animate
		opacity: 0

spawnparts = (v) ->
	for xx, i in v
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

scaleback = (l,s,t) ->
	l.animate
				properties:
					scale: s
				curve: "ease-in"
				time: t



overdet = (nav, layerA, layerB, overlay) ->
	layerB.x = 0
	layerB.y = 0
	options = {time: 0.3}
	return transition =
		layerA:
			show:
				opacity: 1
				scale: 1
				options: options
			hide:
				opacity: 0
				scale: 1.5
				options: options
		layerB:
			show:
				opacity: 1
				scale: 1
				options: options
			hide:
				opacity: 0
				scale: 0.5
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
				scaleback(layer,6,0.1)
				layer.onAnimationEnd ->
					#print "I'm finished"
					flow.transition(screen, overdet)
					layer.scale = 1
			else
				scaleback(layer,1,0.3)


for xx, i in values
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
			scaleback(layer,1,0.3)
	values[i][0].onClick (event, layer) ->
		if layer.scale==1 or layer.scale>1.6
			unless scroll.isMoving
				gotodetail(layer)

figma.radon.pinchable.enabled = true
figma.radon.pinchable.threshold = 10
figma.radon.pinchable.centerOrigin = false
figma.radon.pinchable.minScale = 0.8
figma.radon.pinchable.maxScale = 1
figma.radon.pinchable.scaleFactor = 1
figma.radon.pinchable.rotate = false
figma.radon.onPinchEnd (event, layer) ->
	if layer.scale < 0.9
		flow.showPrevious()
	else
		scaleback(layer,1,0.3)

#button = true
#scroll.onMove (event, layer) ->
#	button = false



# Radon detailansicht
figma.info_2.opacity = 0
figma.over.onClick (event, layer) ->
	flow.showPrevious()

figma.Grafik_Skala.onClick (event, layer) ->
	flow.transition(figma.Einstellungen, closex)

figma.info.onClick (event, layer) ->
	figma.info_2.animate
		opacity: 1
	figma.detail.animate
		opacity: 0
figma.Group_7.onClick (event, layer) ->
	figma.info_2.animate
		opacity: 0
	figma.detail.animate
		opacity: 1
		
figma.plot.opacity = 0
figma.plotdet.opacity = 1



w = 375
h = figma.Group_29.height-30

d3Layer = new Layer(
	x: 0
	y: 258
	backgroundColor: "transparent"
	width: w
	height: h)
d3Layer.html = '<div id="d3"></div>'
d3Layer.parent = figma.radon


# Set the dimensions of the canvas / graph
margin = 
  top: 0
  right: 0
  bottom: 0
  left: 0
width = w - (margin.left) - (margin.right)
height = h - (margin.top) - (margin.bottom)


# Adds the svg canvas
d3.select(document.getElementById('d3')).append('svg').attr('id', 'd3svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

svg = d3.select('svg')
defs = svg.append("defs")
grad = defs.append("linearGradient").attr("id", "MyGradient").attr('x1','0%').attr('y1','0%').attr('x2','0%').attr('y2','100%')
stop1 = grad.append("stop").attr('offset','0').attr('stop-color','white').attr('stop-opacity','0.5')
stop2 = grad.append("stop").attr('offset','100').attr('stop-color','white').attr('stop-opacity','0')

zoomed = ->
  if d3.event.sourceEvent and d3.event.sourceEvent.type == 'brush'
    return
  # ignore zoom-by-brush
  t = d3.event.transform
  # console.log(et)
  xd3.domain t.rescaleX(x2).domain()
  focus.select('.area1').attr 'd', area
  focus.select('.line').attr 'd', valuelineInterpol
  focus.select('.line1').attr 'd', valueline
  focus.select('.axis--x').call xAxis
  context.select('.brush').call brush.move, xd3.range().map(t.invertX, t)
  return


margin = 
  top: 20
  right: 20
  bottom: 110
  left: 0
margin2 = 
  top: 430
  right: 20
  bottom: 30
  left: 40
height2 = +svg.attr('height') - (margin2.top) - (margin2.bottom)
parseDate = d3.timeParse('%Y-%m-%d %H:%M:%S')
xd3 = d3.scaleTime().range([
  0
  width
])

yd3 = d3.scaleLinear().range([
  height
  0
])

xAxis = d3.axisBottom(xd3).ticks(3)
yAxis = d3.axisLeft(yd3)

#figma.overview.bringToFront()
figma.detail.bringToFront()

# Extra
x2 = d3.scaleTime().range([
  0
  width
])
y2 = d3.scaleLinear().range([
  height2
  0
])
xAxis2 = d3.axisBottom(x2)
brush = d3.brushX().extent([
  [
    0
    0
  ]
  [
    width
    height2
  ]
]).on('brush end', brushed)

area2 = d3.area().curve(d3.curveMonotoneX).x((d) ->
  x2 d.date
).y0(height2).y1((d) ->
  y2 d.price
)



zoom = d3.zoom().scaleExtent([
  1
  Infinity
]).translateExtent([
  [
    0
    0
  ]
  [
    width
    height
  ]
]).extent([
  [
    0
    0
  ]
  [
    width
    height
  ]
]).on('zoom', zoomed)

area = d3.area().curve(d3.curveMonotoneX).x((d) ->
  xd3 d.date
).y0(height).y1((d) ->
  yd3 d.price
)

valueline = d3.line().curve(d3.curveLinear).x((d) ->
  xd3 d.date
).y((d) ->
  yd3 d.price
)
valuelineInterpol = d3.line().curve(d3.curveMonotoneX).x((d) ->
  xd3 d.date
).y((d) ->
  yd3 d.price
)


brushed = ->
  if d3.event.sourceEvent and d3.event.sourceEvent.type == 'zoom'
    return
  # ignore brush-by-zoom
  s = d3.event.selection or x2.range()
  xd3.domain s.map(x2.invert, x2)
  focus.select('.area').attr 'd', area
  focus.select('.axis--x').call xAxis
  svg.select('.zoom').call zoom.transform, d3.zoomIdentity.scale(width / (s[1] - (s[0]))).translate(-s[0], 0)
  return


type = (d) ->
  d.date = parseDate(d.date)
  d.price = +d.price
  d

svg.append('defs').append('clipPath').attr('id', 'clip').append('rect').attr('width', width).attr 'height', height
focus = svg.append('g').attr('class', 'focus').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
context = svg.append('g').attr('class', 'context').attr('transform', 'translate(' + margin2.left + ',' + margin2.top + ')')
d3.csv 'sp500.csv', type, (error, data) ->
  if error
    throw error
  xd3.domain d3.extent(data, (d) ->
    d.date
  )
  yd3.domain [
    0
    d3.max(data, (d) ->
      d.price
    )
  ]
  x2.domain xd3.domain()
  y2.domain yd3.domain()
  focus.append('path').datum(data).attr('class', 'area1').attr 'd', area
  focus.append('path').datum(data).attr('class', 'line1').attr 'd', valueline
  focus.append('path').datum(data).attr('class', 'line').attr 'd', valuelineInterpol
  focus.append('g').attr('class', 'axis axis--x').attr('transform', 'translate(0,' + height + ')').call xAxis
  #focus.append('g').attr('class', 'axis axis--y').call yAxis
  svg.append('rect').attr('class', 'zoom').attr('width', width).attr('height', height).attr('transform', 'translate(' + margin.left + ',' + margin.top + ')').call zoom
  return


d3Layer.onClick (event, layer) ->
	print 'yay'













#Philine:
#kritischer index?
critical = true

#hier alle ebenen, die versteckt werden sollen, insbesondere hintergründe und top bars aller screens
hidden = [
	figma.UI_Bars___Status_Bars___White___Base_16
	figma.UI_Bars___Status_Bars___White___Base
	figma.UI_Bars___Status_Bars___White___Base_2
	]

for xx,i in hidden
	if hidden[i]
		hidden[i].visible = false

#hier alle artboards die transparenten hintergrund haben sollen
screens = [
	figma.Einstellungen
	figma.Profil
	figma.Sensoreinstellungen
	figma.Sensoreinstellungen_plus
	figma.Sensor_hinzufügen
	figma.Notif_Alarme
	figma.Grenzwerte
	figma.Profil_voll
	figma.Profil_Eingabe_sex
	figma.Profil_Eingabe_name
	figma.Profil_mit_name
	figma.Profil_Eingabe_age
	figma.Profil_mit_name_2
	figma.Loading
	figma.ort_hinzufügen
	]

back = new BackgroundLayer
	#backgroundColor: 'red'
	image: 'images/bgred.png'
	parent: flow

backblue = new BackgroundLayer
	#backgroundColor: 'red'
	image: 'images/bgblue.png'
	parent: flow
	opacity: 0


for xx,i in screens
	screens[i].image = 'images/bgred.png'



animationSpeed = 0.4
#Transitions
#Xschließen
closex = (nav, layerA, layerB, overlay) ->
	#layerB.x = 0
	#layerB.y = 0
	#options = {time: 1}
	return transition =
		layerA:
			show:
				opacity: 1
				options: 
					time: animationSpeed
					curve: Bezier.ease
			hide:
				opacity: 0
				options:
					time: animationSpeed
					curve: Bezier.ease
		layerB:
			show:
				opacity: 1
				x: 0
				y: 0
				options: 
					time: animationSpeed
					curve: Bezier.ease
					delay: animationSpeed
			hide:
				opacity: 0
				options: 
					time: animationSpeed
					curve: Bezier.ease

#transition einfache screens
screenchange = (nav, layerA, layerB, overlay) ->
	#layerB.x = 0
	#layerB.y = 0
	#options = {curve: Bezier.ease}
	return transition =
		layerA:
			show:
				opacity: 1
				options: 
					time: 0.3
					curve: Bezier.ease
			hide:
				opacity: 0
				options: 
					time: 0.3
					curve: Bezier.ease
		layerB:
			show:
				opacity: 1
				x: 0
				y: 0
				options: 
					time: 0.3
					curve: Bezier.ease
			hide:
				opacity: 0
				x: 0
				y: 0
				options: 
					time: 0.3
					curve: Bezier.ease
					
#transition mit delay für keyboard
keybtransition = (nav, layerA, layerB, overlay) ->
	#layerB.x = 0
	#layerB.y = 0
	#options = {curve: Bezier.ease}
	return transition =
		layerA:
			show:
				opacity: 1
				options: 
					time: 0.5
					curve: Bezier.ease
					delay: 1.3
			hide:
				opacity: 0
				options: 
					time: 0.5
					
		layerB:
			show:
				opacity: 1
				options: 
					time: 0.5
					curve: Bezier.ease
					delay: 1.3
			hide:
				opacity: 0
				options: 
					time: 0.5
					curve: Bezier.ease
					
#transition mit delay für female/male button
sexbutton = (nav, layerA, layerB, overlay) ->
	#layerB.x = 0
	#layerB.y = 0
	#options = {curve: Bezier.ease}
	return transition =
		layerA:
			show:
				opacity: 1
				options: 
					time: animationSpeed
					curve: Bezier.ease
					delay: animationSpeed*2
			hide:
				opacity: 0
				options: 
					time: 1
					delay: animationSpeed
					curve: Bezier.ease
					
		layerB:
			show:
				opacity: 1
				options: 
					time: animationSpeed
					curve: Bezier.ease
					delay: 2
			hide:
				opacity: 0
				options: 
					time: animationSpeed
					delay: animationSpeed
					curve: Bezier.ease
#loading icon
loadingtrans = (nav, layerA, layerB, overlay) ->
	#layerB.x = 0
	#layerB.y = 0
	#options = {curve: Bezier.ease}
	return transition =
		layerA:
			show:
				opacity: 1
				options: 
					time: animationSpeed
					curve: Bezier.ease
					delay: 5
			hide:
				opacity: 0
				options: 
					time: animationSpeed
					delay: animationSpeed
					curve: Bezier.ease
					
		layerB:
			show:
				opacity: 1
				options: 
					time: animationSpeed
					curve: Bezier.ease
					delay: 5
			hide:
				opacity: 0
				options: 
					time: animationSpeed
					delay: animationSpeed
					curve: Bezier.ease														
#Animationen
#Einstellungen on Top
#für Sensoreinstellungen
anim = new Animation figma.SensorLinie,
	y: 49
	options:
		time: animationSpeed
		curve: Bezier.ease
#Linie on Top
linie = new Animation figma.Topline_2,
	y: 33
	options:
		time: animationSpeed
		curve: Bezier.ease
		
#für Profil
animp = new Animation figma.ProfilLinie,
	y: 49
	options:
		time: animationSpeed
		curve: Bezier.ease
#Linie on Top
liniep = new Animation figma.Topline,
	y: 33
	options:
		time: animationSpeed
		
#für Threshold
animt = new Animation figma.ThreshLinie,
	y: 49
	options:
		time: 0.6
		curve: Bezier.ease
#Linie on Top
liniet = new Animation figma.Topline_3,
	y: 33
	options:
		time: animationSpeed

#für Alarme
animn = new Animation figma.Notif,
	y: 49
	options:
		time: 0.6
		curve: Bezier.ease

								
#settings verschwinden
fadeoutp = new Animation figma.ProfilLinie,
	opacity: 0
	options:
		time: animationSpeed/2
		curve: Bezier.easeOut
fadeoutt = new Animation figma.ThreshLinie,
	opacity: 0
	options:
		time: animationSpeed/2
		curve: Bezier.easeOut
fadeoutn = new Animation figma.Notif,
	opacity: 0
	options:
		time: animationSpeed/2
		curve: Bezier.easeOut
fadeouts = new Animation figma.SensorLinie,
	opacity: 0
	options:
		time: animationSpeed/2
		curve: Bezier.easeOut
fadeoutub = new Animation figma.Übersbutton,
	opacity: 0
	options:
		time: animationSpeed/2
		curve: Bezier.easeOut
		
#fadeout aller screens
Verschwinden = (d) ->
	d.animate
		opacity: 0
		options:
			time: 0.4
			curve: Bezier.easeOut
				
#berlina animation
Berlina = figma.Berlina
BerlinaA = Berlina.animate
		opacity: 0
		options:
			time: animationSpeed*2
			curve: Bezier.ease
BerlinaB = BerlinaA.reverse()

#alter 32 animation
alteroff = figma.alter_32.animate
	opacity: 0
	options: 
		time: animationSpeed*2
		curve: Bezier.ease
alterin = alteroff.reverse()
alteroff.start()	
				
#Kreuzgrößen states
figma.Kreuz_7.states = 
	Xklein: 
		scale: 0.5
	Xbig:
		scale: 0.8
figma.Kreuz.states = 
	Xklein: 
		scale: 0.5
	Xbig:
		scale: 0.8		
figma.Kreuz_2.states = 
	Xklein: 
		scale: 0.5
	Xbig:
		scale: 0.8		
figma.Kreuz_3.states = 
	Xklein: 
		scale: 0.5
	Xbig:
		scale: 0.8		
figma.Kreuz_7.animate("Xbig")

#Kreuz auf Originalgröße
KreuzOS = (b) ->
	b.animate
		scale: 1
		options: 
			time: 1
			curve: Spring (damping: 0.2)

#Keyboard Namenseingabe states
figma.Keyboard_Dark_Email.states =
	keyin:
		y: 0
	options: 
		time: animationSpeed*1.5
		curve: Bezier.ease
	keyoff:
		y: 220
	options: 
		time: animationSpeed*1.2
		curve: Bezier.ease
#Keyboard Alterseingabe states
figma.Keyb_nummern.states =
	keyin:
		y: 451
	options: 
		time: animationSpeed*1.5
		curve: Bezier.ease
	keyoff:
		y: 700
	options: 
		time: animationSpeed*1.2
		curve: Bezier.ease

#anim female/male auswahl
ausgewählt = (f) ->
	f.animate
		opacity: 1
		scale: 1.05
		options:
			time: 0.2
			curve: Bezier.easeOut
abgewählt = (h) ->
	h.animate
		opacity:0.6
		scale: 1
		options:
			time: 0.2
			curve: Bezier.easeOut

#states für Grenzwerte
figma.GW_offen.states =
	GWinvisible:
		visible: false
	GWvisible:
		visible: true
		
figma.GW_zu.states =
	GWzuinvisible:
		visible: false
	GWzuvisible:
		visible: true

#thresholds states bearbeiten oder nicht bearbeiten Modus
figma.ND_Gruppe.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.ND_offen.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.CM_Gruppe.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.CM_offen.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.SD_Gruppe.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.SD_offen_2.states =
	invisible:
		visible: false
	visible:
		visible: true	
figma.Radon_Gruppe.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.Radon_offen.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.PM_Gruppe.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.PM_offen.states =
	invisible:
		visible: false
	visible:
		visible: true	
figma.Ozon_Gruppe.states =
	invisible:
		visible: false
	visible:
		visible: true
figma.Ozon_offen.states =
	invisible:
		visible: false
	visible:
		visible: true
									
#navigation
#von Einstellungen
#zum Profil
figma.ProfilLinie.onClick (event, layer) ->
	animp.start()
	fadeouts.start()
	fadeoutn.start()
	fadeoutt.start()
	fadeoutub.start()
	liniep.start()
	
	Utils.delay animationSpeed, ->
		flow.showNext(figma.Profil, animate: false)
		animp.reset()
		fadeouts.reset()
		fadeoutn.reset()
		fadeoutt.reset()
		fadeoutub.reset()
		liniep.reset()	
		KreuzOS(figma.Kreuz)
		
figma.Keyboard_Dark_Email.animate("keyoff")
figma.Keyb_nummern.animate("keyoff")
		
#von leer zu namen eingabe
figma.Group_15_4.onClick (event, layer) ->
	flow.showNext(figma.Profil_Eingabe_name, animate: false)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
#von mit namen zur namens eingabe
figma.Berlina_2.onClick (event, layer) ->
	flow.showNext(figma.Profil_Eingabe_name, animate: false)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
#von mit name und alter zur Namenseingabe
figma.Group_10_7.onClick (event, layer) ->
	flow.showNext(figma.Profil_Eingabe_name, animate: false)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
#von voll zur Namenseingabe	
figma.Group_12_8.onClick (event, layer) ->
	flow.showNext(figma.Profil_Eingabe_name, animate: false)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
		
#keyboard to name
figma.Keyboard_Dark_Email.onClick (event, layer) ->
	BerlinaB.start()

#done zu profil mit name
figma.Group_10_6.onClick ->
	figma.Keyboard_Dark_Email.animate("keyoff")
	Utils.delay animationSpeed*1.5, ->
		flow.showNext(figma.Profil_mit_name,animate: false)
		KreuzOS(figma.Kreuz_2)
#cancel zu leer
figma.Group_11_3.onClick ->
	figma.Keyboard_Dark_Email.animate("keyoff")
	Utils.delay animationSpeed*1.5, ->
		flow.showNext(figma.Profil,animate: false)
		KreuzOS(figma.Kreuz)
			
#zur Alterseingabe
#zu alterseingabe von ohne namen
figma.Group_12_3.onClick ->
	flow.showNext(figma.Profil_Eingabe_age, animate: false)
	flow.on Events.TransitionEnd, ->
		figma.Keyb_nummern.animate("keyin")
		alteroff.start()
#zu alterseingabe von mit namen
figma.Group_13_3.onClick (event, layer)->
	flow.showNext(figma.Profil_Eingabe_age, animate: false)
	flow.on Events.TransitionEnd, ->
		figma.Keyb_nummern.animate("keyin")
		alteroff.start()
#zu alterseingabe von mit name und alter
figma.alter_32_2.onClick (event, layer)->
	flow.showNext(figma.Profil_Eingabe_age, animate: false)
	flow.on Events.TransitionEnd, ->
		alteroff.start()
#zu alterseingabe von voll
figma.Group_11_9.onClick (event, layer)->
	flow.showNext(figma.Profil_Eingabe_age, animate: false)
	flow.on Events.TransitionEnd, ->
		alteroff.start()
				
figma.Keyb_nummern.onClick ->
	alterin.start()

#done
figma.Group_10_8.onTapStart ->
	figma.Keyb_nummern.animate("keyoff")
	Utils.delay animationSpeed*1.5, ->
		flow.showNext(figma.Profil_mit_name_2,animate: false)
		KreuzOS(figma.Kreuz_3)
#cancel
figma.Group_11_6.onTapStart ->
	figma.Keyb_nummern.animate("keyoff")
	Utils.delay animationSpeed*1.5, ->
		flow.showNext(figma.Profil_mit_name,animate: false)
		KreuzOS(figma.Kreuz_2)
	
#genderbutton
#default
abgewählt(figma.malebutton)
abgewählt(figma.malebutton_2)
abgewählt(figma.malebutton_3)
abgewählt(figma.femalebutton)
abgewählt(figma.femalebutton_2)
abgewählt(figma.femalebutton_3)
#auf leer
#female
figma.femalebutton.onClick ->
	ausgewählt(figma.femalebutton)
	abgewählt(figma.malebutton)
#male
figma.malebutton.onClick ->
	ausgewählt(figma.malebutton)
	abgewählt(figma.femalebutton)
	
#auf nur name
#female
figma.femalebutton_2.onClick ->
	ausgewählt(figma.femalebutton_2)
	abgewählt(figma.malebutton_2)
#male
figma.malebutton_2.onClick ->
	ausgewählt(figma.malebutton_2)
	abgewählt(figma.femalebutton_2)

#auf name undalter
#female
figma.femalebutton_3.onClick ->
	ausgewählt(figma.femalebutton_3)
	abgewählt(figma.malebutton_3)
#male
figma.malebutton_3.onClick ->
	ausgewählt(figma.malebutton_3)
	abgewählt(figma.femalebutton_3)
	
#zumSensor
figma.SensorLinie.onClick (event, layer) ->
	anim.start()
	fadeoutp.start()
	fadeoutn.start()
	fadeoutt.start()
	fadeoutub.start()
	linie.start()
	
	Utils.delay animationSpeed, ->		
		flow.showNext(figma.Sensoreinstellungen, animate: false)
		figma.Group_19_2_2.animate("off")
		figma.Group_19_3_2.animate("off")
		figma.Group_19_3.animate("off")
		figma.Group_19_1.animate("off")
		flow.on Events.TransitionEnd, ->
			anim.reset()
			fadeoutp.reset()
			fadeoutn.reset()
			fadeoutt.reset()
			fadeoutub.reset()
			linie.reset()
		KreuzOS(figma.Kreuz_7)
		
#connect
connecting = [
	figma.Group_16_6
	figma.Group_17_2
	figma.Group_18_1
	figma.Group_18_5
	figma.Group_19_3_2
	figma.Group_19_2_2
	figma.Group_19_1
	figma.Group_19_3
]
for xx,i in connecting
	connecting[i].states = 
		on: 
			#width: 50
			opacity: 1
			options: 
				curve: Bezier.ease
				time: 0.2	 
		off:
			#width: 0
			opacity: 0
			options: 
				curve: Bezier.ease
				time: 0.2
#von connect zu connected
figma.Group_16_6.onClick ->
	figma.Group_19_3_2.animate("on")
	figma.Group_16_6.animate("off")
figma.Group_17_2.onClick ->
	figma.Group_19_2_2.animate("on")
	figma.Group_17_2.animate("off")
figma.Group_18_5.onClick ->
	figma.Group_19_1.animate("on")
	figma.Group_18_5.animate("off")
figma.Group_18_1.onClick ->
	figma.Group_19_3.animate("on")
	figma.Group_18_1.animate("off")
#von connected zu connect					
figma.Group_16_6.onClick ->
	figma.Group_19_3_2.animate("off")
	figma.Group_16_6.animate("on")
figma.Group_17_2.onClick ->
	figma.Group_19_2_2.animate("off")
	figma.Group_17_2.animate("on")
figma.Group_18_5.onClick ->
	figma.Group_19_1.animate("off")
	figma.Group_18_5.animate("on")
figma.Group_18_1.onClick ->
	figma.Group_19_3.animate("off")
	figma.Group_18_1.animate("on")
					
#states loading icon		
figma.Loading.states=
	visible:
		visible:true
		options:
			time: 2
			curve: Bezier.ease
	invisible:
		visible:false
		options:
			time: 2
			curve: Bezier.ease
#animation loading icon
Kreisa_1 = null
Kreisa_2 = null
Kreisa_3 = null
Kreisa_4 = null
Kreisr_1 = null
Kreisr_2 = null
Kreisr_3 = null
Kreisr_4 = null
kreise = [
	[Kreisa_1,Kreisr_1,figma.Kreis]
	[Kreisa_2,Kreisr_2,figma.Kreis_2]
	[Kreisa_3,Kreisr_3,figma.Kreis_3]
	[Kreisa_4,Kreisr_4,figma.Kreis_4]
]	
for xx,i in kreise
	kreise[i][0] = new Animation kreise[i][2],
	scale:1.5
	options: 
		time: 1.3
		curve: Bezier.ease
		delay: i*0.3			
#sensor suchen
figma.Group_10_12.onClick ->
	flow.showNext(figma.Loading, animate: false)
	flow.on Events.TransitionEnd, ->
		for xx,i in kreise
			kreise[i][1] = kreise[i][0].reverse()
			kreise[i][1].on Events.AnimationEnd, kreise[i][0].start
			kreise[i][0].on Events.AnimationEnd, kreise[i][1].start
			kreise[i][0].start()
		
		Utils.delay 3, ->
			flow.showNext(figma.Sensor_hinzufügen,animate:false)

#cancel sensor hinzufügen
figma.Group_12_12.onClick ->
	flow.showNext(figma.Sensoreinstellungen,animate:false)
	
#sensor hinzufügen
figma.Group_13_11.onClick ->
	flow.showNext(figma.Sensoreinstellungen_plus,animate:false)
	
#zu Threshold
figma.ThreshLinie.onClick (event, layer) ->
	animt.start()
	fadeoutp.start()
	fadeouts.start()
	fadeoutn.start()
	fadeoutub.start()
	liniet.start()
	
	Utils.delay 0.5, ->
		flow.showNext(figma.Grenzwerte, animate: false)
		flow.on Events.TransitionEnd, ->
			animt.reset()
			fadeouts.reset()
			fadeoutn.reset()
			fadeoutp.reset()
			fadeoutub.reset()
			liniet.reset()
		KreuzOS(figma.Kreuz_6)
		#figma.GW_offen.animate("GWvisible")
		figma.GW_zu.animate("GWzuinvisible")
		figma.PM_offen.animate("invisible")
		figma.Radon_offen.animate("invisible")
		figma.Ozon_offen.animate("invisible")
		figma.SD_offen_2.animate("invisible")
		figma.CM_offen.animate("invisible")
		figma.ND_offen.animate("invisible")
					
#Threshold states
customdraggable = (l) ->
	l.draggable = true
	l.draggable.speedY = 0
	# Disable overdrag
	l.draggable.overdrag = false
	
	# Disable bounce
	l.draggable.bounce = false
	
	# Disable momentum
	l.draggable.momentum = false
	l.draggable.constraints = {
		x: 15-20
		y: 0
		width: 345+20
		height: 93
	}

customdraggable(figma.reglerPM)
customdraggable(figma.reglerND)
customdraggable(figma.reglerCM)
customdraggable(figma.reglerSD)
customdraggable(figma.reglerRadon)
customdraggable(figma.reglerOzon)

#PM Skale
pm = new TextLayer
	text: Math.round(figma.reglerPM.x*0.827 + 5)	
	color: 'white'
	y: 0
	x: 238
	fontSize: '18'
	paddingLeft: 0
pm.parent = figma.PM_offen
figma.reglerPM.onMove ->
	pm.text = Math.round(figma.reglerPM.x*0.827 + 5)
	#pm.text = figma.reglerPM.x

oz = new TextLayer
	text: Math.round(figma.reglerOzon.x*1.159 + 5)	
	color: 'white'
	y: 0
	x: 238
	fontSize: '18'
	paddingLeft: 0
oz.parent = figma.Ozon_offen
figma.reglerOzon.onMove ->
	oz.text = Math.round(figma.reglerOzon.x*1.159 + 5)
	#pm.text = figma.reglerPM.x
	
rd = new TextLayer
	text: Math.round(figma.reglerRadon.x*0.629 + 5)	
	color: 'white'
	y: 0
	x: 230
	fontSize: '18'
	paddingLeft: 0
rd.parent = figma.Radon_offen
figma.reglerRadon.onMove ->
	rd.text = Math.round(figma.reglerRadon.x*0.629 + 5)
	#pm.text = figma.reglerPM.x

sd = new TextLayer
	text: Math.round(figma.reglerSD.x*2.285 + 5)	
	color: 'white'
	y: 0
	x: 238
	fontSize: '18'
	paddingLeft: 0
sd.parent = figma.SD_offen_2
figma.reglerSD.onMove ->
	sd.text = Math.round(figma.reglerSD.x*2.285 + 5)
	#pm.text = figma.reglerPM.x

cm = new TextLayer
	text: Math.round(figma.reglerCM.x*0.033 + 5)	
	color: 'white'
	y: 0
	x: 240
	fontSize: '18'
	paddingLeft: 0
cm.parent = figma.CM_offen
figma.reglerCM.onMove ->
	cm.text = Math.round(figma.reglerCM.x*0.033 + 5)
	#pm.text = figma.reglerPM.x

nd = new TextLayer
	text: Math.round(figma.reglerND.x*1.291 + 5)	
	color: 'white'
	y: 0
	x: 240
	fontSize: '18'
	paddingLeft: 0
nd.parent = figma.ND_offen
figma.reglerND.onMove ->
	nd.text = Math.round(figma.reglerND.x*1.291 + 5)
	#pm.text = figma.reglerPM.x
								
scroll_1 = ScrollComponent.wrap(figma.scrollgruppe)
scroll_1.scrollHorizontal = false
scroll_1.mouseWheelEnabled = true	

#figma.GW_offen.parent=scroll.content

#click zum bearbeiten des grenzwertes
figma.NDU.onClick ->
	figma.ND_Gruppe.stateCycle("invisible", "visible")
	figma.ND_offen.stateCycle("visible", "invisible")
figma.CMU.onClick ->
	figma.CM_Gruppe.stateCycle("invisible", "visible")
	figma.CM_offen.stateCycle("visible", "invisible")
figma.SDU.onClick ->
	figma.SD_Gruppe.stateCycle("invisible", "visible")
	figma.SD_offen_2.stateCycle("visible", "invisible")
figma.RU.onClick ->
	figma.Radon_Gruppe.stateCycle("invisible", "visible")
	figma.Radon_offen.stateCycle("visible", "invisible")
figma.PMU.onClick ->
	figma.PM_Gruppe.stateCycle("invisible", "visible")
	figma.PM_offen.stateCycle("visible", "invisible")
figma.OU.onClick ->
	figma.Ozon_Gruppe.stateCycle("invisible", "visible")
	figma.Ozon_offen.stateCycle("visible", "invisible")
	
#zu Alarme
figma.Notif.onClick (event, layer) ->
	animn.start()
	fadeoutp.start()
	fadeouts.start()
	fadeoutt.start()
	fadeoutub.start()

	Utils.delay 0.5, ->
		flow.showNext(figma.Notif_Alarme, animate: false)
		flow.on Events.TransitionEnd, ->
			animn.reset()
			fadeouts.reset()
			fadeoutt.reset()
			fadeoutp.reset()
			fadeoutub.reset()			
		KreuzOS(figma.Kreuz_9)				

scroll2 = ScrollComponent.wrap(figma.Alarmgruppe)
scroll2.scrollHorizontal = false
scroll2.mouseWheelEnabled = true	

#figma.Alarmgruppe=scroll.content
#inset unten ?
scroll2.contentInset=
	bottom: 100

	
#Kswitch states
knobs = [
	figma.knob_8
	figma.knob_7
	figma.knob_6
	figma.knob_5
	figma.knob_4
	figma.knob_3
	figma.knob_2
	figma.knob
]
for xx,i in knobs
	knobs[i].states = 
		on: 
			x: 21
			options: 
				curve: Bezier.ease
				time: 0.2	 
		off:
			x: 1
			options: 
				curve: Bezier.ease
				time: 0.2

fillb = [
	figma.fillb_8
	figma.fillb_7
	figma.fillb_6
	figma.fillb_5
	figma.fillb_4
	figma.fillb_3
	figma.fillb_2
	figma.fillb
]
for xx,i in fillb
	fillb[i].states = 
		on: 
			#width: 50
			opacity: 1
			options: 
				curve: Bezier.ease
				time: 0.2	 
		off:
			#width: 0
			opacity: 0
			options: 
				curve: Bezier.ease
				time: 0.2

#switch on off	
figma.Slide.onClick ->
	figma.knob_8.stateCycle("off", "on")
	figma.fillb_8.stateCycle("off", "on")
figma.SlideND.onClick ->
	figma.knob_7.stateCycle("off", "on")
	figma.fillb_7.stateCycle("off", "on")
figma.SlideRV.onClick ->
	figma.knob_6.stateCycle("off", "on")
	figma.fillb_6.stateCycle("off", "on")
figma.SlideAI.onClick ->
	figma.knob_5.stateCycle("off", "on")
	figma.fillb_5.stateCycle("off", "on")
figma.SlideR.onClick ->
	figma.knob_4.stateCycle("off", "on")
	figma.fillb_4.stateCycle("off", "on")
figma.SlideCM.onClick ->
	figma.knob_3.stateCycle("off", "on")
	figma.fillb_3.stateCycle("off", "on")
figma.SlideO.onClick ->
	figma.knob_2.stateCycle("off", "on")
	figma.fillb_2.stateCycle("off", "on")
figma.SlideSD.onClick ->
	figma.knob.stateCycle("off", "on")
	figma.fillb.stateCycle("off", "on")	


#ort hinzufügen
		
#Kreuz Spring anim
Kreuzsprung = (a) ->
	a.onTouchStart ->
		a.animate
			scale: 0.6
			options:
				time: 0.4 
				curve: Bezier.ease
		
Kreuzsprung(figma.Kreuz)
Kreuzsprung(figma.Kreuz_2)
Kreuzsprung(figma.Kreuz_3)
Kreuzsprung(figma.Kreuz_4)
Kreuzsprung(figma.Kreuz_5)
Kreuzsprung(figma.Kreuz_6)
Kreuzsprung(figma.Kreuz_7)
Kreuzsprung(figma.Kreuz_8)
Kreuzsprung(figma.Kreuz_9)
Kreuzsprung(figma.Kreuz_10)
Kreuzsprung(figma.Kreuz_11)
#Kreuzsprung(figma.Kreuz_12)
		
#Kreuz schließen zum Screen Einstellungen	
figma.Kreuz.onClick (event, layer) ->
	#Verschwinden(figma.Profil)
	#Utils.delay 0.4, ->
	animp.reset()
	flow.showNext(figma.Einstellungen, animate: false)	
	figma.Einstellungen.bringToFront()
figma.Kreuz_2.onClick (event, layer) ->
	#flow.showPrevious()
	animp.reset()
	flow.showNext(figma.Einstellungen, animate: false)
	figma.Einstellungen.bringToFront()
figma.Kreuz_3.onClick (event, layer) ->
	#flow.showPrevious()
	animp.reset()
	flow.showNext(figma.Einstellungen, animate: false)
	figma.Einstellungen.bringToFront()
	#flow.showPrevious()
figma.Kreuz_5.onClick (event, layer) ->
	#flow.showPrevious()
	flow.showNext(figma.Einstellungen, animate: false)
	figma.Einstellungen.bringToFront()
figma.Kreuz_6.onClick (event, layer) ->
	#flow.showPrevious()
	animt.reset()
	flow.showNext(figma.Einstellungen, animate: false)
	#flow.showPrevious()
	figma.Einstellungen.bringToFront()
figma.Kreuz_7.onClick (event, layer) ->
	#flow.showPrevious()
	anim.reset()
	flow.showNext(figma.Einstellungen, animate: false)
	#flow.showPrevious()
	figma.Einstellungen.bringToFront()
figma.Kreuz_8.onClick (event, layer) ->
	#flow.showPrevious()
	flow.showNext(figma.Einstellungen, animate: false)
	#flow.showPrevious()
	figma.Einstellungen.bringToFront()
figma.Kreuz_9.onClick (event, layer) ->
	#flow.showPrevious()
	animn.reset()
	flow.showNext(figma.Einstellungen, animate: false)
	#flow.showPrevious()
	figma.Einstellungen.bringToFront()
figma.Kreuz_10.onClick (event, layer) ->
	#flow.showPrevious()
	flow.showNext(figma.Einstellungen, animate: false)
	#flow.showPrevious()
	figma.Einstellungen.bringToFront()
figma.Kreuz_11.onClick (event, layer) ->
	#flow.showPrevious()
	flow.showNext(figma.Einstellungen, animate: false)
	#flow.showPrevious()	
	figma.Einstellungen.bringToFront()
#figma.Kreuz_12.onClick (event, layer) ->
	#flow.showPrevious()
	#flow.showNext(figma.Einstellungen,closex)	

figma.Übersbutton.onClick ->
	flow.transition(figma.Übersichtsscreen_Grafik_komplett, closex)
	#document.location = "http://127.0.0.1:8000/1a4fe2/berlinerluft_light.framer/"
	#window.open("http://127.0.0.1:8000/1a4fe2/berlinerluft_light.framer/","_self")

