window.THREE = require './three.min'
require './GLTFLoader'

class GLTFLayer extends Layer
  constructor: (options) ->
    console.log(options)
    super(options)
    @time = 0
    @renderer = new THREE.WebGLRenderer
      antialias: true
      devicePixelRatio: window.devicePixelRatio
    @_element.appendChild(@renderer.domElement)
    @renderer.domElement.style.width = '100%'
    @renderer.domElement.style.height = '100%'
    
    @scene = new THREE.Scene
    
    @camera = new THREE.PerspectiveCamera(45, @width / @height, 1, 100)
    @camera.position.z = -4
    @camera.position.y = 2
    @camera.lookAt(new THREE.Vector3(0, 1, 0))
    light = new THREE.PointLight({color: 0xfcfcfc})
    light.position.set(1, 2, -3)
    @scene.add(light)
    @renderer.render(@scene, @camera)
    Framer.Loop.on('update', @animate)
    
    # You can create your own primitive objects using anything that ThreeJS supports
    @mesh = new THREE.Mesh(
      new THREE.BoxBufferGeometry(.3, .3, .3),
      new THREE.MeshPhongMaterial({color: 'white'})
    )
    @mesh.position.set(1.4, 1, 0)
    @scene.add(@mesh)
    @sphere = new THREE.Mesh(
      new THREE.SphereBufferGeometry(.3, 16, 16),
      new THREE.MeshPhongMaterial({color: 'white'})
    )
    @sphere.position.set(-1.4, 1, 0)
    @scene.add(@sphere)
    
    
    # Camera rotation
    # We use a ScrollComponent to get the overscroll easing and snapping for free
    # as well as better interaction with the parent (vertical) scroller
    # It stays invisible and captures touch events, and we listen to it to pipe
    # values into our scene
    # We are parenting the camera to this empty so that we can rotate the empty
    # and have the camera orbit around this object, while always pointing at
    # the object, rather than having to do complicated math to make an orbit
    @cameraSpinner = new THREE.Object3D
    @scene.add(@cameraSpinner)
    @cameraSpinner.add(@camera)
    @horizontalScroller = new ScrollComponent
      parent: @
      width: @width
      height: @height
      directionLock: true
    @horizontalScroller.content.backgroundColor = 'transparent'
    @horizontalScroller.content.draggable.vertical = false
    @horizontalScroller.content.on "change:x", (d) =>
      @cameraSpinner.rotation.y = -2 * Math.PI * d / this.width
    
    # Load up a 3d model and stick it in the scene
    new THREE.GLTFLoader().load options.model, (m) =>
      @scene.add(m.scene)
      m.scene.position.x = -0.2
      
    
  animate: () =>
    @time += 0.02
    @mesh.rotation.y += 0.05
    @mesh.rotation.x += 0.07
    scale = Math.sin(@time) * 0.25 + 0.4
    @sphere.scale.set(scale, scale, scale)
    @renderer.render(@scene, @camera)
    
module.exports = GLTFLayer
