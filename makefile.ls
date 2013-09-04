#!/usr/bin/env lsc

{ simple-make, all, x, hooks, plugins} = require 'wmake'

my-files = [
    { name: "js/render.ls", type: \ls }
    { name: "js/entry.ls", type: \ls }
]

pre-vendor-files = [
    "./assets/components/jquery/jquery.js"
    "./assets/components/angular/angular.js"
    "./assets/components/bootstrap/js/transition.js"
    "./assets/components/bootstrap/js/alert.js"
    "./assets/components/bootstrap/js/modal.js"
    "./assets/components/bootstrap/js/dropdown.js"
    "./assets/components/bootstrap/js/scrollspy.js"
    "./assets/components/bootstrap/js/tab.js"
    "./assets/components/bootstrap/js/tooltip.js"
    "./assets/components/bootstrap/js/popover.js"
    "./assets/components/bootstrap/js/button.js"
    "./assets/components/bootstrap/js/collapse.js"
    "./assets/components/bootstrap/js/carousel.js"
    "./assets/components/moment/moment.js"
    "./assets/components/showdown/src/showdown.js"
    "./assets/components/showdown/src/extensions/table.js"
    "./assets/components/highlightjs/highlight.pack.js"
    "./assets/js/highlight.js/highlight.pack.js" 
    "./assets/components/underscore.string/lib/underscore.string.js"
    "./assets/js/baseline.js"
]

 
vendor-files      = [ { name: s, type: \js } for s in pre-vendor-files ]

css-files         = [ { name: "./assets/components/grid-ui/gridpak.less", type: \less } ]

img-files         = [ ] 

project-name      = "cleanslate"
remote-site-path  = "./#project-name"
    
plugins.copy-extension \md, (path-system) -> 
  "#{path-system.client-dir}/markdown"

hooks.add-hook '_deploy', null, (path-system) ->
    x "cp ./webserver/htaccess #{path-system.client-dir}/.htaccess"

# hooks.add-hook 'post-deploy', null, (path-system) ->
    # x "./tools/deploy.coffee -s ./deploy/static -c #{__dirname} -w #{remote-site-path} deploy -v "
    



files = 
        client-js:  my-files
        vendor-js:  vendor-files, 
        client-css: css-files, 
        client-img: img-files,
        
        client-html: [ { name: "./assets/views/index.jade", type: \jade, +root, +serve} ]
        
        other: [ { name: "./docs/README.md",   type: \md } ]
        
        trigger-files: [ "./assets/components/bootstrap/less",
                         "./assets/views/default.jade"
                         "./assets/css/final-touches.less" ]
                         
        options: { +minify-js, +minify-css , +with-gzip, +optimize-img}
                     
simple-make( files )





