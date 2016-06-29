class Resource {
    public url: string;
    public type: string;
    public data;
    public inprogress;
    private loader;

    constructor(typed: string) { // typed url is Type[:url],
        [this.type, this.url] = typed.split(':');
        this.loader = new THREE[`${this.type}Loader`]();
    }

    public setUrl(url: string) {
        this.url = url;
        return this;
    }

    public fetch() {
        if (this.inprogress) return this.inprogress;

        var deferred = Q.defer();
        this.inprogress = deferred.promise;

        this.loader.load(
            this.url,
            (data) => {
                this.data = data;
                deferred.resolve(this);
            },
            (xhr) => {
                this.inprogress.progress = xhr;
                console.info(`Loading ${this.url}: ${xhr.loaded} from ${xhr.total} complete.`);
                deferred.notify(xhr);
            },
            (xhr) => {
                deferred.reject(new Error(`Texture ${this.url} load failed.`));
            }
        );

        return this.inprogress.finally(() => {
            this.inprogress = null;
        });
    }

    public purge() {
        this.inprogress = null;
        this.loader = null;
        this.data = null;
        return this;
    }
}

class ResourceLoader {
    public cache = true;
    public cached = [];

    public getSync(typed: string) {
        var [type, url] = typed.split(':');
        var cached = _.find(this.cached, {url});
        if (cached) return cached;
        return new Resource(typed);
    }

    public get(typed: string) {
        var res = this.getSync(typed);
        return res.data ? Q.when(res) : res.fetch();
    }

    public getAll(list: string[]) {
        list = list.map((item) => this.get(item));
        return Q.all(list);
    }
}

var resourceLoader = new ResourceLoader();
