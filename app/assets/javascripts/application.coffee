#= require jquery
#= require jquery-ujs
#= require tether
#= require bootstrap
# require turbolinks
#= require angular
#= require angular-inview
#= require angular-animate
#= require angular-resource
#= require angular-flash-alert
#= require angular-ui-bootstrap
#= require angular-ui-bootstrap-tpls
# require angular-cancel-on-navigate # Including angularCancelOnNavigateModule.js instead because the package has issues.
#= require imperavi-redactor
#= require imperavi-redactor/redactor-plugins/filemanager
#= require imperavi-redactor/redactor-plugins/fontsize
#= require imperavi-redactor/redactor-plugins/limiter
#= require imperavi-redactor/redactor-plugins/textexpander
#= require imperavi-redactor/redactor-plugins/counter
#= require imperavi-redactor/redactor-plugins/fontcolor
#= require imperavi-redactor/redactor-plugins/fullscreen
#= require imperavi-redactor/redactor-plugins/table
#= require imperavi-redactor/redactor-plugins/video
#= require imperavi-redactor/redactor-plugins/definedlinks
#= require imperavi-redactor/redactor-plugins/fontfamily
#= require imperavi-redactor/redactor-plugins/imagemanager
#= require imperavi-redactor/redactor-plugins/textdirection
#= require angular-redactor
#= require moment
#= require chosen
#= require ngclipboard
#= require clipboard
#= require nprogress
#= require main
#= require_tree .

NProgress.configure
  showSpinner: true,
  ease: 'ease',
  speed: 100,
  minimum: 0.08

# Turbolinks.enableTransitionCache() # Causes momenary jump while new page loads.
#Turbolinks.ProgressBar.disable() if Turbolinks.ProgressBar
$(document).on 'ajaxStart page:fetch', -> NProgress.start()
$(document).on 'submit', 'form', -> NProgress.start()
$(document).on 'ajaxStop page:change', -> NProgress.done()
$(document).on 'page:receive', -> NProgress.set(0.7)
$(document).on 'page:restore', -> NProgress.remove()
  
$(document).on 'page:change', ->
  if !!(fieldset = $('fieldset:has(.field_with_errors)'))
    fieldset.addClass('has-danger') 
  if !!(any = $('.field_with_errors'))
    any.addClass('has-danger') 
  if !!(input = $('.field_with_errors > input'))
    input.addClass('form-control-danger') 
  if !!(label = $('.field_with_errors > label'))
    label.addClass('control-danger') 
  $('.redactor').redactor({
    "plugins": ['filemanager', 'fontsize', 'limiter', 'textexpander', 'counter',
      'fontcolor', 'fullscreen', 'table', 'video', 'definedlinks', 'fontfamily',
      'imagemanager', 'textdirection']
  })
