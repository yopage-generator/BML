# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require csrf-token.js
#= require tether
#= require nprogress
#= require nprogress-turbolinks
#= require bootstrap-sprockets
#= require turbolinks
#= require react_ujs
#= require i18n
#= require i18n/translations
#= require better-form
#= require enableWhenChanged
#= require selectize/dist/js/standalone/selectize.min.js
#= require dropzone/dist/min/dropzone.min.js
#= require dropzones
#= require leadsFilter.js
#= require sortablejs/Sortable.js
#= require sortable.js
#= require rehover.js
#= require toastr/toastr
#
#
# SimpleNavigation
#  require bootstrap_and_overrides
#  require bootstrap_navbar_split_dropdowns


$ ->
  I18n.defaultLocale = gon.i18n.defaultLocale
  I18n.locale        = gon.i18n.locale

  Bugsnag.notifyReleaseStages = ["production"]

  NProgress.configure
    showSpinner: false
    ease: 'ease'
    speed: 500

  $.ajaxSetup cache: true

  #// Move modal to body
  #// Fix Bootstrap backdrop issu with animation.css
  #$('.modal:not([data-reactid])').appendTo("body")


$(document).on 'ready page:load', ->
  $('.dropdown-toggle').dropdown()
  $('[tooltip]').tooltip container: "body"

