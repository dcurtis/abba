Controller = require('controller')
moment     = require('moment')

class Graph extends Controller
  constructor: ->
    super

  render: (variants) ->
    @$el.empty()

    margin = {top: 30, right: 20, bottom: 30, left: 30}
    width  = @$el.width() - margin.left - margin.right
    height = 300 - margin.top - margin.bottom

    x = d3.time.scale()
        .range([0, width])

    y = d3.scale.linear()
        .range([height, 0])

    xAxis = d3.svg.axis()
        .scale(x)
        .tickSize(1)
        .tickPadding(12)
        .ticks(d3.time.days, 1)
        .orient('bottom')

    yAxis = d3.svg.axis()
        .scale(y)
        .ticks(5)
        .orient('left')

    line = d3.svg.line()
        .x((d) -> x(new Date(d.time)))
        .y((d) -> y(d.rate))

    area = d3.svg.area()
        .x((d) -> x(new Date(d.time)))
        .y0(height)
        .y1((d) -> y(d.rate))

    svg = d3.select(@$el[0]).append('svg')
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
        .append('g')
        .attr('transform', "translate(#{margin.left},#{margin.top})")

    x.domain([
      d3.min(variants, (c) -> d3.min(c.values, (v) -> new Date(v.time))),
      d3.max(variants, (c) -> d3.max(c.values, (v) -> new Date(v.time)))
    ])

    y.domain([
      d3.min(variants, (c) -> d3.min(c.values, (v) -> v.rate)),
      d3.max(variants, (c) -> d3.max(c.values, (v) -> v.rate))
    ])

    svg.append('g')
       .attr('class', 'x axis')
       .attr('transform', 'translate(0,' + height + ')')
       .call(xAxis)

    svg.append('g')
        .attr('class', 'y axis')
        .call(yAxis)

    svgVariant = svg.selectAll('.variants')
        .data(variants)
        .enter().append('g')
        .attr('class', (d, i) -> "variants variant-#{i}")

    # TODO - select first variant
    # rules = svg.selectAll('g.rule')
    #   .data([variants.a])
    # .enter().append('g')
    #   .attr('class', 'rule')
    #
    # rules.append('text')
    #   .attr('class', 'label')
    #   .attr('y', 400)
    #   .attr('x', (d, i) -> x(i))
    #   .attr('dy', '.35em')
    #   .attr('text-anchor', 'middle')
    #   .text((d) -> moment(d.time).format('MMMM Do').toUpperCase())

    svgVariant.append('path')
        .attr('class', 'line')
        .attr('d', (d) -> line(d.values))

    svgVariant.append('path')
        .attr('class', 'area')
        .attr('d', (d) -> area(d.values))

    svgVariant.selectAll('circle')
        .data((d) -> d.values)
        .enter()
        .append('circle')
        .attr('class', (d, i) -> "circle circle-#{i}")
        .attr('cx', (d, i) -> x(new Date(d.time)))
        .attr('cy', (d, i) -> y(d.rate))
        .attr('r', 4)

  showToolTip: (e) =>


  hideToolTip: (e) =>


module.exports = Graph