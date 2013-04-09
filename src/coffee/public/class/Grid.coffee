define [
    'jquery'
], ->
    class Grid
        # Set the default values for the grid.
        constructor: (@canvas, @button, @fontSize, @columns, @columnWidth,
        @gutterWidth, @paddingWidth) ->
            @ctx = @canvas.getContext '2d'
            @gridHeight = 500
            @columnWidth = @columnWidth * @fontSize
            @gutterWidth = @gutterWidth * @fontSize
            @paddingWidth = @paddingWidth * @fontSize

        # Get the total width of the grid.
        draw: ->
            lastPoint = 0
            i = 0

            @ctx.fillStyle = 'rgba(100, 100, 225, 0.25)'

            while i < @columns
                startPoint = @paddingWidth + (@columnWidth * i) + (@gutterWidth * i)
                @ctx.fillRect startPoint, 0, @columnWidth, @gridHeight
                i += 1

        # Generate the download link.
        generateDownloadLink: ->
            @button
                .css(display: 'block')
                .attr(href: @canvas.toDataURL('image/png'), download: 'layout.png')

        # Resize the canvas according to the given values.
        resizeCanvas: ->
            width = (@columns * @columnWidth) +
                (@paddingWidth * 2) +
                (@gutterWidth * (@columns - 1))

            $(@canvas)
                .attr(width: width, height: @gridHeight)
                .css(opacity: 1)