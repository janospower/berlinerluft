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
	flow.showPrevious(overdet)

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
	]

for x,i in screens
	screens[i].backgroundColor = 'transparent'

back = new BackgroundLayer
	#backgroundColor: 'red'
	image: 'images/bgred.png'
	parent: flow

backblue = new BackgroundLayer
	#backgroundColor: 'red'
	image: 'images/bgblue.png'
	parent: flow
	opacity: 0

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


#Transitions
#Xschließen
closex = (nav, layerA, layerB, overlay) ->
	layerB.x = 0
	layerB.y = 0
	#options = {time: 1}
	return transition =
		layerA:
			show:
				opacity: 1
				options: 
					time: 1
					curve: Bezier.ease
			hide:
				opacity: 0
				options:
					time: 1
					curve: Bezier.ease
		layerB:
			show:
				opacity: 1
				options: 
					time: 1
					curve: Bezier.ease
					delay: 1
			hide:
				opacity: 0
				options: 
					time: 1
					curve: Bezier.ease

#transition einfache screens
screenchange = (nav, layerA, layerB, overlay) ->
	layerB.x = 0
	layerB.y = 0
	#options = {curve: Bezier.ease}
	return transition =
		layerA:
			show:
				opacity: 1
				options: 
					time: 1
					curve: Bezier.ease
			hide:
				opacity: 0
				options: 
					time: 1
					curve: Bezier.ease
		layerB:
			show:
				opacity: 1
				options: 
					time: 1
					curve: Bezier.ease
			hide:
				opacity: 0
				options: 
					time: 1
					curve: Bezier.ease
					
#transition mit delay für keyboard
keybtransition = (nav, layerA, layerB, overlay) ->
	layerB.x = 0
	layerB.y = 0
	#options = {curve: Bezier.ease}
	return transition =
		layerA:
			show:
				opacity: 1
				options: 
					time: 1
					curve: Bezier.ease
					delay: 1.3
			hide:
				opacity: 0
				options: 
					time: 1
					
		layerB:
			show:
				opacity: 1
				options: 
					time: 1
					curve: Bezier.ease
					delay: 1.3
			hide:
				opacity: 0
				options: 
					time: 1
					curve: Bezier.ease
					
									
#Animationen
#Einstellungen on Top
#für Sensoreinstellungen
anim = new Animation figma.SensorLinie,
	y: 49
	options:
		time: 1
		curve: Bezier.ease
#Linie on Top
linie = new Animation figma.Topline_2,
	y: 33
	options:
		time: 1
		curve: Bezier.ease
		
#für Profil
animp = new Animation figma.ProfilLinie,
	y: 49
	options:
		time: 1
		curve: Bezier.ease
#Linie on Top
liniep = new Animation figma.Topline,
	y: 33
	options:
		time: 1
		
#für Threshold
animt = new Animation figma.ThreshLinie,
	y: 49
	options:
		time: 1
		curve: Bezier.ease
#Linie on Top
liniet = new Animation figma.Topline_3,
	y: 33
	options:
		time: 1	

#für Alarme
animn = new Animation figma.Notif,
	y: 49
	options:
		time: 1
		curve: Bezier.ease

								
#settings verschwinden
fadeoutp = new Animation figma.ProfilLinie,
	opacity: 0
	options:
		time: 0.5
		curve: Bezier.easeOut
fadeoutt = new Animation figma.ThreshLinie,
	opacity: 0
	options:
		time: 0.5
		curve: Bezier.easeOut
fadeoutn = new Animation figma.Notif,
	opacity: 0
	options:
		time: 0.5
		curve: Bezier.easeOut
fadeouts = new Animation figma.SensorLinie,
	opacity: 0
	options:
		time: 0.5
		curve: Bezier.easeOut
fadeoutub = new Animation figma.Übersbutton,
	opacity: 0
	options:
		time: 0.5
		curve: Bezier.easeOut

#berlina animation
Berlina = figma.Berlina
BerlinaA = Berlina.animate
		opacity: 0
		options:
			time: 1.7
			curve: Bezier.ease
BerlinaB = BerlinaA.reverse()

#alter 32 animation
alteroff = figma.alter_32.animate
	opacity: 0
	options: 
		time: 2
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
			time: 1
			curve: Spring (damping: 0.2)
					
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
			figma.Profil.visible=true
			figma.Sensoreinstellungen.visible=false
			
		KreuzOS(figma.Kreuz)


#Keyboard Namenseingabe states
figma.Keyboard_Dark_Email.states =
	keyin:
		y: 0
	options: 
		time:1.5
		curve: Bezier.ease
	keyoff:
		y: 220
	options: 
		time:1.2
		curve: Bezier.ease
#Keyboard Alterseingabe states
figma.Keyb_nummern.states =
	keyin:
		y: 451
	options: 
		time:1.5
		curve: Bezier.ease
	keyoff:
		y: 700
	options: 
		time:1.2
		curve: Bezier.ease
		
figma.Keyboard_Dark_Email.animate("keyoff")
figma.Keyb_nummern.animate("keyoff")

#zu namen eingabe
figma.Group_15_4.onClick (event, layer) ->
	flow.transition(figma.Profil_Eingabe_name,screenchange)
	flow.on Events.TransitionEnd, ->
		figma.Keyboard_Dark_Email.animate("keyin")
		BerlinaA.start()
	
#keyboard to name
figma.Keyboard_Dark_Email.onClick (event, layer) ->
	BerlinaB.start()

#done
figma.Group_10_6.onClick ->
	figma.Keyboard_Dark_Email.animate("keyoff")
	flow.transition(figma.Profil_mit_name,keybtransition)	
#cancel
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
	
#von Profil leer zu eingabe sex
figma.Group_11_3.onClick ->
	femaleout.start()
	maleout.start()
	flow.transition(figma.Profil_Eingabe_sex,screenchange)
#von Profil name zu eingabe sex
figma.Group_12_5.onClick ->
	femaleout.start()
	maleout.start()
	flow.transition(figma.Profil_Eingabe_sex,screenchange)
#auf profil mit name und alter zu sex eingabe
figma.Group_12_6.onClick ->
	femaleout.start()
	maleout.start()
	flow.transition(figma.Profil_Eingabe_sex,screenchange)

#von eingabe sex
#female
figma.Group_10_9.onClick ->
	femalein.start()
	maleout.start()
	flow.transition(figma.Profil_voll,keybtransition)
#anim female auswahl
femalein=figma.Group_10_9.animate
	opacity: 1
femaleout=figma.Group_10_9.animate
	opacity:0.6
#male
figma.Group_11_8.onClick ->
	malein.start()
	femaleout.start()
	flow.transition(figma.Profil_voll,keybtransition)
#anim male auswahl
malein=figma.Group_11_8.animate
	opacity: 1
maleout=figma.Group_11_8.animate
	opacity: 0.6
#cancel
figma.Kreuz_4.onClick ->
	flow.transition(figma.Profil_mit_name_2,keybtransition)
	
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
			figma.Profil.visible=false
			figma.Sensoreinstellungen.visible=true
		KreuzOS(figma.Kreuz_7)
	
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
			
		KreuzOS(figma.Kreuz_6)
		figma.GW_offen.animate("GWinvisible")
		figma.GW_zu.animate("GWzuvisible")
		
			
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
				
scroll2 = ScrollComponent.wrap(figma.GW_offen)
scroll2.scrollHorizontal = false
scroll2.mouseWheelEnabled = true	


#figma.GW_offen.parent=scroll.content

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
				
		KreuzOS(figma.Kreuz_9)				

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
Kreuzsprung(figma.Kreuz_12)
		
#Kreuz schließen zum Screen Einstellungen	
figma.Kreuz.onClick (event, layer) ->
	#Kreuzsprung(figma.Kreuz)
	flow.transition(figma.Einstellungen,closex)	
figma.Kreuz_2.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
figma.Kreuz_3.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
figma.Kreuz_5.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
figma.Kreuz_6.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
figma.Kreuz_7.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
figma.Kreuz_8.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
figma.Kreuz_9.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
figma.Kreuz_10.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)
figma.Kreuz_11.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)	
figma.Kreuz_12.onClick (event, layer) ->
	#flow.showPrevious()
	flow.transition(figma.Einstellungen,closex)	

figma.Übersbutton.onClick ->
	flow.transition(figma.Übersichtsscreen_Grafik_komplett, closex)
	#document.location = "http://127.0.0.1:8000/1a4fe2/berlinerluft_light.framer/"
	#window.open("http://127.0.0.1:8000/1a4fe2/berlinerluft_light.framer/","_self")

