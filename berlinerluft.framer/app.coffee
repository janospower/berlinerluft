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
gesternval = 120
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

GLTFLayer = require 'GLTFLayer'

l = new GLTFLayer
	parent: figma.Wertegruppe
	width: 200
	height: 200
	x: 20
	y: 50
	model: './Duck.glb'
	backgroundColor: "transparent"

figma.Ellipse_2.visible = false

###
three = new Layer();
three.html = "<canvas></canvas>"
renderer = new THREE.WebGLRenderer({canvas: three._elementHTML.childNodes[0]});
###

clusterdimension = 175
figma.Ellipse.visible = false

htmlLayer = new Layer(
  x: 220
  y: 5
  backgroundColor: "transparent"
  width: clusterdimension
  height: clusterdimension)
htmlLayer.html = '<canvas></canvas>'
htmlLayer.parent = figma.Wertegruppe



htmlLayer.states.animationOptions = curve: 'spring(500,12,0)'
# On a click, go to the next state

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
      radius: 5
      spread: if 2 == 1 then new (THREE.Vector3)(3, 3, 3) else undefined
    velocity:
      value: new (THREE.Vector3)(3, 3, 3)
      distribution: SPE.distributions.SPHERE
    size: value: 0.7
    particleCount: 350)
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


