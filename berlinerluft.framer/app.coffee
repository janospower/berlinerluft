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

