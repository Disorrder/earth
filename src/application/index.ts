const grad = Math.PI / 180;
var stats = addStats();
var gui = new dat.GUI();

function addStats() {
    var stats = new Stats();
    $('#stats').append(stats.domElement);
    return stats;
}

class SpaceController {
    public resources;
    public scene = new THREE.Scene();
    public camera = new THREE.PerspectiveCamera(45, this.windowRatio, 0.1, 1000);
    public renderer = new THREE.WebGLRenderer();
    public axes = new THREE.AxisHelper( 20 );
    public clock = new THREE.Clock();

    public earth;
    public stars;

    constructor() {
        this.initScene();
        this.addLight();
        this.addPlanet();
        this.addGui();
        this.renderScene();

        this.preload().then(() => {
            this.addStars();
        });
    }

    private get windowRatio() {
        return window.innerWidth / window.innerHeight;
    }

    get loaded() { return !!this.resources };

    preload() {
        return resourceLoader.getAll([
            'Texture:assets/images/galaxy_starfield.png'
        ]).then((res) => {
            var r = this.resources = <any>{};
            [r.stars] = res;
            return res;
        });
    }

    initScene() {
    	this.renderer.setClearColor(0xEEEEEE, 1);
    	this.renderer.setSize(window.innerWidth, window.innerHeight);
    	this.scene.add(this.axes);
        this.camera.position.set(7, 10, 7);
        $("#screen").append(this.renderer.domElement);
    }

    renderScene() {
        requestAnimationFrame(() => this.renderScene());
        stats.update();
        this.renderer.render(this.scene, this.camera);
        var dt = this.clock.getDelta();
        if (dt) this.Update(dt);
    }

    addLight() {
        this.scene.add(new THREE.AmbientLight(0x333333));

        var light = new THREE.DirectionalLight(0xffffff, 0.9);
        light.position.set(5,3,5);
        this.scene.add(light);
    }

    addPlanet() {
        this.earth = new Earth(this.scene);
        this.camera.lookAt(this.earth.position);
    }

    addStars() {
        var geometry = new THREE.SphereGeometry(96, 32, 32);
        var material = new THREE.MeshBasicMaterial({
            map: this.resources.stars.data,
            side: THREE.BackSide
        });
        this.stars = new THREE.Mesh(geometry, material);
        this.scene.add(this.stars);
    }

    Update(dt) {
        if (!this.loaded) return;
        this.earth.Update(dt);
    }

    // --- GUI ---
    addGui() {
        var folder = gui.addFolder('Space');
        folder.add(this, 'cameraX', -40, 40);
        folder.add(this, 'cameraY', -40, 40);
        folder.add(this, 'cameraZ', -40, 40);
        folder.open();
    }

    public get cameraX() { return this.camera.position.x; }
    public set cameraX(val) { this.camera.position.x = val; this.camera.lookAt(this.earth.position); }
    public get cameraY() { return this.camera.position.y; }
    public set cameraY(val) { this.camera.position.y = val; this.camera.lookAt(this.earth.position); }
    public get cameraZ() { return this.camera.position.z; }
    public set cameraZ(val) { this.camera.position.z = val; this.camera.lookAt(this.earth.position); }
}

class Earth {
    public resources;
    public planet;
    public atmosphere;
    public clouds;
    public radius = 4;
    public angularVelocity = -5;
    public cloudsAngularVelocity = 1;

    constructor(public scene) {
        this.preload().then(() => {
            this.addPlanet();
            // this.addAtmosphere();
            this.addClouds();
        });
    }

    get loaded() { return !!this.planet };
    get position() { return this.planet ? this.planet.position : this.scene.position}

    preload() {
        return resourceLoader.getAll([
            'Texture:assets/images/2_no_clouds_4k.jpg',
            'Texture:assets/images/elev_bump_4k.jpg',
            'Texture:assets/images/water_4k.png',
            'Texture:assets/images/fair_clouds_4k.png'
        ]).then((res) => {
            var r = this.resources = <any>{};
            [r.map, r.bump, r.water, r.clouds] = res;
            return res;
        });
    }

    addPlanet() {
        var geometry = new THREE.SphereGeometry(this.radius, 32, 32);
        var material = new THREE.MeshPhongMaterial({
            map: this.resources.map.data,
            bumpMap: this.resources.bump.data,
            bumpScale: 0.05,
            specularMap: this.resources.water.data
            // specular: 0xbebebe
        });
        this.planet = new THREE.Mesh(geometry, material);
        this.planet.rotation.x = -23.44 * grad;
        this.scene.add(this.planet);
    }

    addAtmosphere() {
        var geometry = new THREE.SphereGeometry(this.radius + 0.1, 32, 32);
    	var material = new THREE.MeshBasicMaterial({
            color: 0x7EC0EE,
            transparent: true,
            opacity: 0.2
        });
        this.atmosphere = new THREE.Mesh(geometry, material);
        this.planet.add(this.atmosphere);
    }

    addClouds() {
        var geometry = new THREE.SphereGeometry(this.radius + 0.1, 32, 32);
    	var material = new THREE.MeshPhongMaterial({
            map: this.resources.clouds.data,
            transparent: true
        });
        this.clouds = new THREE.Mesh(geometry, material);
        this.planet.add(this.clouds);
    }

    Update(dt) {
        if (!this.loaded) return;
        this.updatePlanet(dt);
        this.updateClouds(dt);
    }

    updatePlanet(dt) {
        var dy = this.angularVelocity * grad * dt;
        this.planet.rotation.y += dy;
    }

    updateClouds(dt) {
        var dy = this.cloudsAngularVelocity * grad * dt;
        this.clouds.rotation.y += dy;
    }
}

new SpaceController();
