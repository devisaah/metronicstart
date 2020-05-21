// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("local-time").start()

window.Rails = Rails

import '../../assets/javascripts/metronic/plugins.bundle'
import '../../assets/javascripts/metronic/prismjs.bundle'
import '../../assets/javascripts/metronic/scripts.bundle'
import '../../assets/javascripts/modal.bundle'
import '../../assets/javascripts/custom'

$(document).on("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
})
