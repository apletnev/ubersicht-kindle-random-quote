command: 'cat ~/My\ Clippings.txt | awk -f kindle-clippings.widget/parser.awk'

refreshFrequency: 300000

style: """
  background: rgba(#fff, 0.0) no-repeat 50% 20px
  color: #141f33
  font-family: Helvetica Neue
  left: 10%
  line-height: 1.5
  padding-left: 10px
  padding-right: 10px
  width: 80%
  height: 60%
  top: 20%

  .author
    height: 60px
    width: 100%

  .clipping
    height: 100%
    width: 100%

"""
render: (output) -> """
<div class='test'></div>
  <div>
  <canvas class="author"></canvas>
  <canvas class="clipping"></canvas>
  </div>
"""

setSize: ->
  author = $(".author")[0]
  authorContext = author.getContext("2d")

  clipping = $(".clipping")[0]
  clippingContext = clipping.getContext("2d")

  if window.devicePixelRatio
    #set correct size for HDF monitor
    #author
    authorWidth = author.clientWidth
    authorHeight = author.clientHeight
    $(author).attr('width', authorWidth * window.devicePixelRatio)
    $(author).attr('height', authorHeight * window.devicePixelRatio)
    $(author).css('width', authorWidth)
    $(author).css('height', authorHeight)
    authorContext.scale(window.devicePixelRatio, window.devicePixelRatio)

    #clipping
    clippingWidth = clipping.clientWidth
    clippingHeight = clipping.clientHeight
    $(clipping).attr('width', clippingWidth * window.devicePixelRatio)
    $(clipping).attr('height', clippingHeight * window.devicePixelRatio)
    $(clipping).css('width', clippingWidth)
    $(clipping).css('height', clippingHeight)
    clippingContext.scale(window.devicePixelRatio, window.devicePixelRatio)


setAuthor: (text) ->
  author = $(".author")[0]
  authorContext = author.getContext("2d")
  authorContext.clearRect(0, 0, author.width, author.height)
  this.wrapText(authorContext, text, 0, 25, author.clientWidth, 25)

setClipping: (text) ->
  clipping = $(".clipping")[0]
  clippingContext = clipping.getContext("2d")
  clippingContext.clearRect(0, 0, clipping.width, clipping.height)
  this.wrapText(clippingContext, text, 5, 25, clipping.clientWidth, 30)

createGradient: (context, y, lineHeight) ->
  gradient = context.createLinearGradient(0, y - lineHeight, 0, y)
  gradient.addColorStop("0", "#DDDDDD")
  gradient.addColorStop("0.5", "#FFFFFF")
  gradient.addColorStop("1.0", "#DDDDDD")
  context.fillStyle = gradient
  #context.textAlign = "center"
  context.textBaseline = 'middle';


wrapText: (context, text, x, y, maxWidth, lineHeight) ->
  words = text.split(' ')
  n = 0
  line = ''
  self = this
  context.font = 'bold 20pt avenir next'
  for word in words
    do (word) ->
      testLine = line + word + ' '
      metrics = context.measureText(testLine);

      if metrics.width > (maxWidth - x) && n > 0
        self.createGradient(context, y, lineHeight)
        context.fillText(line, x, y)
        line = word + ' '
        y += lineHeight
      else
        line = testLine
    n++
    this.createGradient(context, y, lineHeight)
    context.fillText(line, x, y)

update: (output, domEl) ->
  res = output.split('\r\n');

  if res.length == 0
    this.setClipping(res)
  else
    this.setSize()
    this.setAuthor(res[0].toUpperCase())
    this.setClipping(res[2].toUpperCase())
