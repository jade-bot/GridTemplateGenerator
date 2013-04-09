require.config
    paths:
        'jquery': '/lib/jquery/jquery.min'

    shim:
        'jquery':
            exports: 'jquery'

define [
    'jquery'
    'class/Grid'
], ($, Grid) ->

    # Add initial focus to total columns box.
    $('#js-grid-font-size').trigger 'focus'

    # Add listener to form submition.
    $('#js-grid-options').on 'submit', (event) ->
        event.preventDefault()
        canvas = $('#js-grid-target')[0]
        downloadButton = $ '#js-grid-download-image'
        gridFontSize = $('#js-grid-font-size').val()
        gridColumns = $('#js-grid-columns').val()
        gridColumnWidth = $('#js-grid-column-width').val()
        gridGutterWidth = $('#js-grid-gutter-width').val()
        gridPaddingWidth = $('#js-grid-padding').val()

        grid = new Grid canvas, downloadButton, gridFontSize, gridColumns, gridColumnWidth,
        gridGutterWidth, gridPaddingWidth

        grid.resizeCanvas()
        grid.draw()
        grid.generateDownloadLink()