/// <refernce path="/../typings/jquery/jquery.d.ts">

function loadTexture(url) {
    if (!_.isArray(url)) url = [url];

    var promises = url.map(item => {
        var promise;
        return promise = new Promise((resolve, reject) => {
            new THREE.TextureLoader().load(
                item,
                (texture) => { resolve(texture) },
                (xhr) => { promise.progress = xhr; console.log('prog', item, `${xhr.loaded} from ${xhr.total}`, 'total:', all.getProgress()); },
                (xhr) => { reject(new Error(`Texture ${item} load failed.`)) }
            )
        });
    });

    console.log(promises);
    var all = Promise.all(promises);
    all.getProgress = () => {
        var loaded = promises.map(item => item.progress.loaded);
        var total = promises.map(item => item.progress.total);
        return {
            loaded: _.sumBy(promises, 'progress.loaded'),
            total: _.sumBy(promises, 'progress.total')
        }
    };
    return all;
}
