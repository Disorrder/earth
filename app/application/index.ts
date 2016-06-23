class EarthController {
    public scene = new THREE.Scene();
    public camera = new THREE.PerspectiveCamera(45, this.windowRatio, 0.1, 1000);
    public renderer = new THREE.WebGLRenderer();
    public axes = new THREE.AxisHelper( 20 );

    constructor() {
        this.initScene();
        this.addPlanet();
        this.renderScene();
    }

    private get windowRatio() {
        return window.innerWidth / window.innerHeight;
    }

    initScene() {
    	this.renderer.setClearColor(0xEEEEEE, 1);
    	this.renderer.setSize(window.innerWidth, window.innerHeight);
    	this.scene.add(this.axes);
        this.camera.position.set(15, 10, 10);
        $("#screen").append(this.renderer.domElement);
    }

    renderScene() {
        requestAnimationFrame(() => this.renderScene());
        this.renderer.render(this.scene, this.camera);
        this.Update();
    }

    public planet;
    addPlanet() {
        var sphereGeometry = new THREE.SphereGeometry(4,20,20);
    	var sphereMaterial = new THREE.MeshBasicMaterial(
    		{color: 0x7777ff, wireframe: true}
        );
    	this.planet = new THREE.Mesh(sphereGeometry,sphereMaterial);
    	this.scene.add(this.planet);
        this.camera.lookAt(this.planet.position);
    }

    Update() {
        this.planet.rotation.y += 0.005;
    }
}

new EarthController();
