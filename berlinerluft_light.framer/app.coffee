Framer.Extras.Preloader.enable()
{TextLayer, convertTextLayers} = require 'TextLayer'

# Import file "Framer Light Janos (Page 1)"
figma = Framer.Importer.load("imported/Framer%20Light%20Janos%20(Page%201)@2x", scale: 1)
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
flow.showNext(figma.Übersichtsscreen_Grafik_komplett)
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


#button = true
#scroll.onMove (event, layer) ->
#	button = false



# Radon detailansicht
figma.info_2.opacity = 0
figma.overview.onClick (event, layer) ->
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
		
figma.plot.opacity = 0.4




w = figma.plot.width
h = figma.plot.height

d3Layer = new Layer(
	x: 0
	y: figma.plot.y
	backgroundColor: "transparent"
	width: w
	height: h)
d3Layer.html = '<div id="d3"></div>'
d3Layer.parent = figma.radon


# Set the dimensions of the canvas / graph
margin = 
  top: 30
  right: 20
  bottom: 30
  left: 50
width = w - (margin.left) - (margin.right)
height = h - (margin.top) - (margin.bottom)
# Parse the date / time
parseDate = d3.time.format('%d-%b-%y').parse
# Set the ranges
xd3 = d3.time.scale().range([
  0
  width
])
yd3 = d3.scale.linear().range([
  height
  0
])
# Define the axes
xAxis = d3.svg.axis().scale(xd3).orient('bottom').ticks(2)
yAxis = d3.svg.axis().scale(yd3).orient('right').ticks(3)
# Define the line
valueline = d3.svg.line().x((d) ->
  xd3 d.date
).y((d) ->
  yd3 d.close
)
# Adds the svg canvas
svg = d3.select(document.getElementById('d3')).append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
# Get the data
d3.csv 'data.csv', (error, data) ->
  data.forEach (d) ->
    d.date = parseDate(d.date)
    d.close = +d.close
    return
  # Scale the range of the data
  
  xd3.domain d3.extent(data, (d) ->
    d.date
  )
  yd3.domain [
    0
    d3.max(data, (d) ->
      d.close
    )
  ]
  
  # Add the valueline path.
  svg.append('path').attr('class', 'line').attr 'd', valueline(data)
  # Add the X Axis
  svg.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + height + ')').call xAxis
  # Add the Y Axis
  svg.append('g').attr('class', 'y axis').call yAxis
  return
















#Philine:
#kritischer index?
critical = true

#hier alle ebenen, die versteckt werden sollen, insbesondere hintergründe und top bars aller screens
hidden = [
	figma.UI_Bars___Status_Bars___White___Base_16
	figma.UI_Bars___Status_Bars___White___Base
	figma.UI_Bars___Status_Bars___White___Base_2
	]

for x,i in hidden
	if hidden[i]
		hidden[i].visible = false

#hier alle artboards die transparenten hintergrund haben sollen
screens = [
	figma.Einstellungen
	figma.Profil
	figma.Sensoreinstellungen
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
###
unless critical
	backblue.animate
		opacity: 1
		options:
			time: 1
			curve: Bezier.ease
	back.animate
		opacity: 0
		options:
			time: 1
			curve: Bezier.ease
	bag.animate
		opacity: 0
		options:
			time: 1
			curve: Bezier.ease
###

for x,i in screens
	screens[i].image = 'images/bgred.png'



animationSpeed = 0.2
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
			hide:
				opacity: 0
				x: 0
				y: 0
				options: 
					time: animationSpeed
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
					time: animationSpeed
					curve: Bezier.ease
					delay: 1.3
			hide:
				opacity: 0
				options: 
					time: animationSpeed
					
		layerB:
			show:
				opacity: 1
				options: 
					time: animationSpeed
					curve: Bezier.ease
					delay: animationSpeed+0.3
			hide:
				opacity: 0
				options: 
					time: animationSpeed
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
		time: animationSpeed
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
		time: animationSpeed
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
		
figma.Kreuz_7.animate("Xbig")

#Kreuz auf Originalgröße
KreuzOS = (b) ->
	b.animate
		scale: 1
		options: 
			time: animationSpeed
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

#anim female auswahl
femalein=figma.Group_10_9.animate
	opacity: 1
	scale: 1.05
	options:
		time: animationSpeed*0.3
		curve: Bezier.easeOut
femaleout=figma.Group_10_9.animate
	opacity:0.6
	scale: 1
	options:
		time: animationSpeed*0.3
		curve: Bezier.easeOut
#anim male auswahl
malein=figma.Group_11_8.animate
	opacity: 1
	scale: 1.05
	options:
		time: animationSpeed*0.3
		curve: Bezier.easeOut
maleout=figma.Group_11_8.animate
	opacity: 0.6 
	scale: 1
	options:
		time: animationSpeed*0.3
		curve: Bezier.ease
							
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
	
	figma.ProfilLinie.onAnimationEnd (event, layer) ->
		flow.transition(figma.Profil,screenchange)
		flow.on Events.TransitionEnd, ->
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
	flow.transition(figma.Profil_Eingabe_name,screenchange)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
#von mit namen zur namens eingabe
figma.Berlina_2.onClick (event, layer) ->
	flow.transition(figma.Profil_Eingabe_name,screenchange)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
#von mit name und alter zur Namenseingabe
figma.Group_10_7.onClick (event, layer) ->
	flow.transition(figma.Profil_Eingabe_name,screenchange)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
#von voll zur Namenseingabe	
figma.Group_12_8.onClick (event, layer) ->
	flow.transition(figma.Profil_Eingabe_name,screenchange)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
		
#keyboard to name
figma.Keyboard_Dark_Email.onClick (event, layer) ->
	BerlinaB.start()

#done zu profil mit name
figma.Group_10_6.onClick ->
	figma.Keyboard_Dark_Email.animate("keyoff")
	flow.transition(figma.Profil_mit_name,keybtransition)	
#cancel zu leer
figma.Group_11_4.onClick ->
	figma.Keyboard_Dark_Email.animate("keyoff")
	flow.transition(figma.Profil,keybtransition)
	
#zur Alterseingabe
#print figma.Keyb_nummern.y
#zu alterseingabe von ohne namen
figma.Group_12_3.onClick ->
	flow.transition(figma.Profil_Eingabe_age,screenchange)
	flow.on Events.TransitionEnd, ->
		figma.Keyb_nummern.animate("keyin")
		alteroff.start()
#zu alterseingabe von mit namen
figma.Group_13_3.onClick (event, layer)->
	flow.transition(figma.Profil_Eingabe_age,screenchange)
	flow.on Events.TransitionEnd, ->
		figma.Keyb_nummern.animate("keyin")
		alteroff.start()
#zu alterseingabe von mit name und alter
figma.alter_32_2.onClick (event, layer)->
	flow.transition(figma.Profil_Eingabe_age,screenchange)
	flow.on Events.TransitionEnd, ->
		alteroff.start()
#zu alterseingabe von voll
figma.Group_11_9.onClick (event, layer)->
	flow.transition(figma.Profil_Eingabe_age,screenchange)
	flow.on Events.TransitionEnd, ->
		alteroff.start()
				
figma.Keyb_nummern.onClick ->
	alterin.start()

#done
figma.Group_10_8.onClick ->
	figma.Keyb_nummern.animate("keyoff")
	flow.transition(figma.Profil_mit_name_2,keybtransition)
#cancel
figma.Group_11_7.onClick ->
	figma.Keyb_nummern.animate("keyoff")
	flow.transition(figma.Profil_mit_name,keybtransition)
	
#zu eingabe sex	
#von Profil leer zu eingabe sex
figma.Group_11_3.onClick ->
	femaleout.start()
	maleout.start()
	KreuzOS(figma.Kreuz_4)
	flow.transition(figma.Profil_Eingabe_sex,screenchange)
#von Profil name zu eingabe sex
figma.Group_12_5.onClick ->
	femaleout.start()
	maleout.start()
	KreuzOS(figma.Kreuz_4)
	flow.transition(figma.Profil_Eingabe_sex,screenchange)
#von profil mit name und alter zu sex eingabe
figma.Group_12_6.onClick ->
	femaleout.start()
	maleout.start()
	KreuzOS(figma.Kreuz_4)
	flow.transition(figma.Profil_Eingabe_sex,screenchange)
#von profil voll zu eingabe sex
figma.Group_10_10.onClick ->
	femaleout.start()
	maleout.start()
	KreuzOS(figma.Kreuz_4)
	flow.transition(figma.Profil_Eingabe_sex,screenchange)
	
#von eingabe sex
#female
figma.Group_10_9.onClick ->
	femalein.start()
	maleout.start()
	flow.transition(figma.Profil_voll,sexbutton)
#male
figma.Group_11_8.onClick ->
	malein.start()
	femaleout.start()
	flow.transition(figma.Profil_voll,sexbutton)
#cancel
figma.Kreuz_4.onClick ->
	flow.transition(figma.Profil_mit_name_2,screenchange)

	
#zumSensor
figma.SensorLinie.onClick (event, layer) ->
	anim.start()
	fadeoutp.start()
	fadeoutn.start()
	fadeoutt.start()
	fadeoutub.start()
	linie.start()
	
	figma.SensorLinie.onAnimationEnd (event, layer) ->
		
		flow.transition(figma.Sensoreinstellungen,screenchange)
		flow.on Events.TransitionEnd, ->
			anim.reset()
			fadeoutp.reset()
			fadeoutn.reset()
			fadeoutt.reset()
			fadeoutub.reset()
			linie.reset()
		KreuzOS(figma.Kreuz_7)
		
		
			
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
Kreisa_1 = new Animation figma.Kreis,
	scale:1.5
	options: 
		time: 0.6
		curve: Bezier.ease
		#delay:0.2
		repeat: 2
Kreisa_2 = new Animation figma.Kreis_2,
	scale:1.5
	options: 
		time: 1.2
		curve: Bezier.ease
		#delay: 0.4
		repeat: 2
Kreisa_3 = new Animation figma.Kreis_3,
	scale:1.5
	options: 
		time: 1.8
		curve: Bezier.ease
		#delay: 0.6
		repeat: 2
Kreisa_4 = new Animation figma.Kreis_4,
	scale:1.5
	options: 
		time: 2.4
		curve: Bezier.ease
		#delay: 0.8
		repeat: 2
						
#sensor suchen
figma.Group_10_12.onClick ->
	flow.transition(figma.Loading,screenchange)
	flow.on Events.TransitionEnd, ->
		Kreisa_1.start()
		Kreisa_2.start()
		Kreisa_3.start()
		Kreisa_4.start()
		figma.Kreis_4.onAnimationEnd ->
			flow.transition(figma.Sensor_hinzufügen,keybtransition)
			flow.on Events.TransitionEnd, ->
				Kreisa_1.reset()
				Kreisa_2.reset()
				Kreisa_3.reset()
				Kreisa_4.reset()
#zu Threshold
figma.ThreshLinie.onClick (event, layer) ->
	animt.start()
	fadeoutp.start()
	fadeouts.start()
	fadeoutn.start()
	fadeoutub.start()
	liniet.start()
	
	figma.ThreshLinie.onAnimationEnd (event, layer) ->
		flow.transition(figma.Grenzwerte,screenchange)
		flow.on Events.TransitionEnd, ->
			animt.reset()
			fadeouts.reset()
			fadeoutn.reset()
			fadeoutp.reset()
			fadeoutub.reset()
			liniet.reset()
			figma.Profil.visible=false
			figma.Grenzwerte.visible=true
			figma.ND_offen.visible = false
			figma.CM_offen.visible = false
			figma.SD_offen_2.visible = false
			figma.Radon_offen.visible = false
			figma.PM_offen.visible = false
			figma.Ozon_offen.visible = false
		KreuzOS(figma.Kreuz_6)
		figma.GW_offen.animate("GWvisible")
		figma.GW_zu.animate("GWzuinvisible")
					
#Threshold states

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
								
scroll_1 = ScrollComponent.wrap(figma.GW_offen)
scroll_1.scrollHorizontal = false
scroll_1.mouseWheelEnabled = true	

#figma.GW_offen.parent=scroll.content

#click zum bearbeiten des grenzwertes
figma.ND_Gruppe.onClick ->
	figma.ND_Gruppe.stateCycle("invisible", "visible")
	figma.ND_offen.stateCycle("visible", "invisible")
figma.CM_Gruppe.onClick ->
	figma.CM_Gruppe.stateCycle("invisible", "visible")
	figma.CM_offen.stateCycle("visible", "invisible")
figma.SD_Gruppe.onClick ->
	figma.SD_Gruppe.stateCycle("invisible", "visible")
	figma.SD_offen_2.stateCycle("visible", "invisible")
figma.Radon_Gruppe.onClick ->
	figma.Radon_Gruppe.stateCycle("invisible", "visible")
	figma.Radon_offen.stateCycle("visible", "invisible")
figma.PM_Gruppe.onClick ->
	figma.PM_Gruppe.stateCycle("invisible", "visible")
	figma.PM_offen.stateCycle("visible", "invisible")
figma.Ozon_Gruppe.onClick ->
	figma.Ozon_Gruppe.stateCycle("invisible", "visible")
	figma.Ozon_offen.stateCycle("visible", "invisible")
	
#zu Alarme
figma.Notif.onClick (event, layer) ->
	animn.start()
	fadeoutp.start()
	fadeouts.start()
	fadeoutt.start()
	fadeoutub.start()

	figma.Notif.onAnimationEnd (event, layer) ->
		flow.transition(figma.Notif_Alarme,screenchange)
		flow.on Events.TransitionEnd, ->
			animn.reset()
			fadeouts.reset()
			fadeoutt.reset()
			fadeoutp.reset()
			fadeoutub.reset()
			figma.Profil.visible=false
			figma.Grenzwerte.visible=false
			figma.Notif_Alarme.visible=true				
		KreuzOS(figma.Kreuz_9)				

scroll2 = ScrollComponent.wrap(figma.Alarmgruppe)
scroll2.scrollHorizontal = false
scroll2.mouseWheelEnabled = true	

#figma.Alarmgruppe=scroll.content
#inset unten ?
scroll2.contentInset=
	bottom: 100


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
	
#Kswitch states
figma.knob_8.states = 
	on: 
		x: 21
		options: 
			curve: Bezier.ease
			time: 0.5
	off:
		x: 1
		options: 
			curve: Bezier.ease
			time: 0.5
figma.knob_7.states = 
	on: 
		x: 21
		options: 
			curve: Bezier.ease
			time: 0.5	 
	off:
		x: 1
		options: 
			curve: Bezier.ease
			time: 0.5
figma.knob_6.states = 
	on: 
		x: 21
		options: 
			curve: Bezier.ease
			time: 0.5	 
	off:
		x: 1
		options: 
			curve: Bezier.ease
			time: 0.5
figma.knob_5.states = 
	on: 
		x: 21
		options: 
			curve: Bezier.ease
			time: 0.5	 
	off:
		x: 1
		options: 
			curve: Bezier.ease
			time: 0.5
figma.knob_4.states = 
	on: 
		x: 21
		options: 
			curve: Bezier.ease
			time: 0.5	 
	off:
		x: 1
		options: 
			curve: Bezier.ease
			time: 0.5
figma.knob_3.states = 
	on: 
		x: 21
		options: 
			curve: Bezier.ease
			time: 0.5	 
	off:
		x: 1
		options: 
			curve: Bezier.ease
			time: 0.5
figma.knob_2.states = 
	on: 
		x: 21
		options: 
			curve: Bezier.ease
			time: 0.5	 
	off:
		x: 1
		options: 
			curve: Bezier.ease
			time: 0.5
figma.knob.states = 
	on: 
		x: 21
		options: 
			curve: Bezier.ease
			time: 0.5	 
	off:
		x: 1
		options: 
			curve: Bezier.ease
			time: 0.5
			
figma.fillb.states = 
	on: 
		opacity: 100
		options:
			time:0.5
			curve: Bezier.ease	
	off:
		opacity: 0
		options:
			time:0.5
			curve: Bezier.ease	
figma.fillb_2.states = 
	on: 
		opacity: 100
	off:
		opacity: 0
figma.fillb_3.states = 
	on: 
		opacity: 100
	off:
		opacity: 0
figma.fillb_4.states = 
	on: 
		opacity: 100
	off:
		opacity: 0
figma.fillb_5.states = 
	on: 
		opacity: 100
	off:
		opacity: 0
figma.fillb_6.states = 
	on: 
		opacity: 100
	off:
		opacity: 0
figma.fillb_7.states = 
	on: 
		opacity: 100
	off:
		opacity: 0
figma.fillb_8.states = 
	on: 
		opacity: 100
		options: 
			#delay: 0.3
			time: 1
			curve: Bezier.ease
	off:
		opacity: 0
		options: 
			#delay: 0.3
			time: 1
			curve: Bezier.ease
			
		
#Kreuz Spring anim
Kreuzsprung = (a) ->
	a.onTouchStart ->
		a.animate
			scale: 0.6
			options:
				time: 1 
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
	#Kreuzsprung(figma.Kreuz)
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()	
figma.Kreuz_2.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()
figma.Kreuz_3.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()
figma.Kreuz_5.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()
figma.Kreuz_6.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()
figma.Kreuz_7.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()
figma.Kreuz_8.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()
figma.Kreuz_9.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()
figma.Kreuz_10.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()
figma.Kreuz_11.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
	#flow.showPrevious()	
#figma.Kreuz_12.onClick (event, layer) ->
	#flow.showPrevious()
	#flow.transition(figma.Einstellungen,closex)	

figma.Übersbutton.onClick ->
	flow.transition(figma.Übersichtsscreen_Grafik_komplett, closex)
	#document.location = "http://127.0.0.1:8000/1a4fe2/berlinerluft_light.framer/"
	#window.open("http://127.0.0.1:8000/1a4fe2/berlinerluft_light.framer/","_self")

