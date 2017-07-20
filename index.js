var sitedown = require('sitedown')

var options = {
  source: '.',            // path to source directory               default: cwd
  build: 'build',         // path to build directory                default: 'build' in cwd
  pretty: false,           // use directory indexes for pretty URLs  default: true
  layout: 'layout.html',  // path to layout                         default: none
  silent: false           // make less noise during build           default: false
}

sitedown(options, function (err) {
  if (err) return console.error(err)
  console.log('success')
})
