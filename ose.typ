#import "src/lib.typ":*
#import "src/theme.typ":*


// Workaround for the lack of an `std` scope.
#let std-bibliography = bibliography
#let std-smallcaps = smallcaps
#let std-upper = upper

// Overwrite the default `smallcaps` and `upper` functions with increased spacing between
// characters. Default tracking is 0pt.
#let smallcaps(body) = std-smallcaps(text(tracking: 0.6pt, body))
#let upper(body) = std-upper(text(tracking: 0.6pt, body))


#set text(lang:"zh")

// This function gets your whole document as its `body` and formats it as a simple
// non-fiction paper.
#let ose(
  // The title for your work.
  title: [Your Title],

  //副标题
  sub-title: none,

  // Author's name.
  author: "",

  // The paper size to use.
  paper-size: "a5",

  // Date that will be displayed on cover page.
  // The value needs to be of the 'datetime' type.
  // More info: https://typst.app/docs/reference/foundations/datetime/
  // Example: datetime(year: 2024, month: 03, day: 17)
  date: none,

  // Format in which the date will be displayed on cover page.
  // More info: https://typst.app/docs/reference/foundations/datetime/#format
  date-format: "[month repr:long] [day padding:zero], [year repr:full]",

  // An abstract for your work. Can be omitted if you don't have one.
  abstract: none,

  //封面图片
  cover-background: none,

  // The contents for the preface page. This will be displayed after the cover page. Can
  // be omitted if you don't have one.
  preface: none,

  // The result of a call to the `outline` function or `none`.
  // Set this to `none`, if you want to disable the table of contents.
  // More info: https://typst.app/docs/reference/model/outline/
  // table-of-contents: outline(),
  table-of-contents: none,

  // The result of a call to the `bibliography` function or `none`.
  // Example: bibliography("refs.bib")
  // More info: https://typst.app/docs/reference/model/bibliography/
  bibliography: none,

  // Whether to start a chapter on a new page.
  chapter-pagebreak: true,

  // Whether to display a maroon circle next to external links.
  external-link-circle: true,

  // Display an index of figures (images).
  figure-index: (
    enabled: false,
    title: "",
  ),

  // Display an index of tables
  table-index: (
    enabled: false,
    title: "",
  ),

  // Display an index of listings (code blocks).
  listing-index: (
    enabled: false,
    title: "",
  ),

  //大标题配图，可以接受none、array
  h1-img: none,

  //大标题作者，可以接受none、array
  h1-author: none,

  // The content of your work.
  body,
) = {
  // Set the document's metadata.
  set document(title: title, author: author)

  // Set the body font.
  // Default is Linux Libertine at 11pt
  set text(font: (font-content,"HYXuanSong","Noto Serif CJK SC","Libertinus Serif", "Libertinus Serif"), size: 10pt)

  // 设置强调字体。
  show emph: text.with(font: (font-emph,"STDongGuanTi","Zhuque Fangsong (technical preview)","YouYuan","Libertinus Serif", "STKaiti"))

  // Set raw text font.
  // Default is Fira Mono at 8.8pt
  show raw: set text(font: ("Iosevka", "Fira Mono","等距更紗黑體 CL"), size: 8pt)


  // Configure page size and margins.
  set page(
    paper: paper-size,
    width: 148mm,
    height: 210mm,
  )


  // Cover page.
  page(
    background: if cover-background != none {
      image(cover-background)
    },
    align(center + top, block(width: 100%,stroke: none)[
      #let v-space = v(2em, weak: true)
      #text(stroke: 1pt + luma(), 60pt,weight: "extrabold",font: font-head)[*#title*]
      #v-space
      #text(fill: luma(v), stroke: 0.3pt + luma(1), 1.5em,weight: "bold",font: font-hei)[*#sub-title*]

      #v-space
      #if author != none {
        align(right)[#text(1.6em, author)]
      }
      

      #if abstract != none {
        v(5em)
        block(width: 80%)[
          // Default leading is 0.65em.
          #par(leading: 0.78em, justify: true, linebreaks: "optimized")[
            #text(font: font-hei)[abstract]
          ]
        ]
      }

      #if date != none {
        v-space
        // Display date as MMMM DD, YYYY
        text(date.display(date-format))
      }
  ]))


  // Configure page size and margins.
  set page(
    margin: (
      bottom: 26pt, 
      top: 23.6pt,
      inside:42pt,
      outside: 24pt,
      ),
    columns: 2,
  )
  set columns(gutter: 20pt)




  // Configure paragraph properties.
  // Default leading is 0.65em.
  set par(leading: 0.7em, justify: true, linebreaks: "optimized")
  // Default spacing is 1.2em.
  set par(spacing: 1em)

  //表格
  show figure.caption: it => {
  block(
    width: 100%,
    fill: black,
    inset: 5pt,
    text(fill: white,font:font-hei, it.body),
    spacing: 0em,
  )
}

show figure.where(kind:table): it => {
  // 移除内部元素之间的间距
  grid(
    row-gutter: 0pt,
    align(left)[#it.caption],
    it.body,
  )
}


set table(
  stroke: (x, y) => (
    x: 0pt,
    y: if y==0 {
      1pt
    }
  ),
  fill: (_, y) => if calc.odd(y) { main-color },
  inset: 0.4em,
)
show table.cell.where(y: 0): set text(weight: "medium",font:font-hei)

  
  // Add vertical space after headings.

  // 标题
  let heading-img = ""
  let heading-author = ""

  show heading.where(
    level: 1
  ): it => {
    set align(center)
    set text(
      weight: "extrabold",
      fill: fill-color,
      font: font-head,
    )
    if counter(heading).get().first() != 1 {
      pagebreak(weak: true)
    }
    place(
      // dx: (page.margin.inside - page.margin.outside)/2,
      dy: - page.margin.top,
      top + center,
      float: true,
      scope: "parent",
    )[
      #grid(
          columns: (1fr),
          gutter: 0pt,
          rows: (0pt,87.7pt,-5pt),
          if type(h1-img) == array {
            let num = counter(heading).get().first()
              if num > h1-img.len() {
                image(h1-img.last(),height: 87.7pt,width: page.width + 19pt)
              } else {
                image(h1-img.at(num - 1),height: 87.7pt,width: page.width + 19pt)
              }
          } else {
            rect(
              fill:sub-color,
              width: page.width + 19pt,
              height: 87.7pt,
            )
          },

          //一级标题内容
          align()[#text(it,size: 60pt,baseline: 22pt,stroke: 1pt + luma())],
          
          rect(
            width: page.width + 19pt,
            height: 5pt, 
            fill: main-color
          ),
          

          //一级标题的作者
          if type(h1-author) == array {
            let num = counter(heading).get().first()
            if num <= h1-author.len() {
                text(size:1.5em,h1-author.at(num - 1),stroke: 0.5pt + luma())
              }
          },
      )
    ]
  }

  show heading.where(
      level: 2
    ): it => {
      set text(
        34pt, 
        weight: "extrabold",
        fill: fill-color,
        font: font-head,
        )
      it.body
      // block(
      //   fill:sub-color,
      //   width: 100%,
      //   height: auto,
      //   above: 1em,
      //   below: 0.5em,
      //   inset: 4pt
      // )[
      //   #it.body
      // ]
      v(0.5em,weak: true)
    }



  show heading.where(
      level: 3
    ): it => {
      set text(
        13pt, 
        weight: "extrabold",
        fill: fill-color,
        font: font-hei,
        )
      block(
        fill:main-color,
        width: 100%,
        height: auto,
        above: 1em,
        below: .25em,
        inset: 6pt
      )[
        #text(weight: "extrabold")[#it.body]
      ]
    }

  show heading.where(
      level: 4
    ): it => {
      set text(
        11pt,
        fill: black,
        weight: "extrabold",
        font: font-hei,
        )
      block(
        width: 100%,
        height: auto,
        above: 1.2em,
        below: .25em,
      )[
        #it.body
      ]
    }



  show heading: it => {
    set text(fill: main-color,weight: "black")
    it
    v(2%, weak: true)
  }


  //设置list

  let first-line-indent() = if type(par.first-line-indent) == dictionary {
    par.first-line-indent.amount
  } else {
    par.first-line-indent
  }

  show list: li => {
    for (i, it) in li.children.enumerate() {
      let nesting = state("list-nesting", 0)
      let indent = context h((nesting.get() + 1) * li.indent)
      let marker = context {
        let n = nesting.get()
        if type(li.marker) == array {
          li.marker.at(calc.rem-euclid(n, li.marker.len()))
        } else if type(li.marker) == content {
          li.marker
        } else {
          li.marker(n)
        }
      }
      let body = {
        nesting.update(x => x + 1)
        it.body + parbreak()
        nesting.update(x => x - 1)
      }
      let content = {
        marker
        h(li.body-indent)
        body
      }
      context pad(left: int(nesting.get() != 0) * li.indent, content)
    }
  }

  show enum: en => {
    let start = if en.start == auto {
      if en.children.first().has("number") {
        if en.reversed { en.children.first().number } else { 1 }
      } else {
        if en.reversed { en.children.len() } else { 1 }
      }
    } else {
      en.start
    }
    let number = start
    for (i, it) in en.children.enumerate() {
      number = if it.has("number") { it.number } else { number }
      if en.reversed { number = start - i }
      let parents = state("enum-parents", ())
      let indent = context h((parents.get().len() + 1) * en.indent)
      let num = if en.full {
        context numbering(en.numbering, ..parents.get(), number)
      } else {
        numbering(en.numbering, number)
      }
      let max-num = if en.full {
        context numbering(en.numbering, ..parents.get(), en.children.len())
      } else {
        numbering(en.numbering, en.children.len())
      }
      num = context box(
        width: measure(max-num).width,
        align(right, text(overhang: false, num)),
      )
      let body = {
        parents.update(arr => arr + (number,))
        it.body + parbreak()
        parents.update(arr => arr.slice(0, -1))
      }
      if not en.reversed { number += 1 }
      let content = {
        num
        h(en.body-indent)
        body
      }
      context pad(left: int(parents.get().len() != 0) * en.indent, content)
    }
  }

  set list(
    body-indent: 0.2em,
    marker: (
    text(size: 0.6em,baseline: -0.2em)[#sym.triangle.filled.r]
    // text(size: 0.6em)[\u{22B3}#v(0.1em)],
    ),
  )


  // Do not hyphenate headings.
  show heading: set text(hyphenate: false)

  // Show a small maroon circle next to external links.
  show link: it => {
    it
    // Workaround for ctheorems package so that its labels keep the default link styling.
    if external-link-circle and type(it.dest) != label  {
      sym.wj
      h(1.6pt)
      sym.wj
      super(box(height: 3.8pt, circle(radius: 1.2pt, stroke: 0.7pt + main-color)))
    }
  }

  //定制ref函数
  show ref: it => {

    let el = it.element
    let sply = it.supplement
    let page_array = counter(page).at(el.location())
    underline(
      stroke: 1.5pt + contrast-color,
      offset: 2pt,
    )[
    #link(it.target)[#if sply != auto {sply} else {el.body} #if page_array.len()>0 {"(p"; str(page_array.first())};)]
    ]
  }


  //定制underline函数
  set underline(offset:2pt)

  // Display preface as the second page.
  if preface != none {
    page(preface)
  }

  // Indent nested entires in the outline.
  set outline(indent: auto)

  // Display table of contents.
  if table-of-contents != none {
    table-of-contents
  }

  // Configure heading numbering.设置标题前缀！
  //set heading(numbering: "1.")

  //设置标题前缀！
  set heading(numbering: (..args) => {
    let nums = args.pos()
    let level = nums.len() - 1
    let label = ("章", "节", "条", "项").at(level)
    if level == 0 {
      // text(size: 0.8em,weight: "semibold")[第#nums.at(level)#label]
    } else {
      [#nums.at(level)#text(".")]
      //[第#nums.at(level)#label]
    }
  })

  // Configure page numbering and footer.
  set page(
    footer: context {

      set par(spacing: 0.25em)
      // Get current page number.
      let i = counter(page).at(here()).first()

      // Align right for even pages and left for odd.
      let is-odd = calc.odd(i)
      let aln = if is-odd { right } else { left }

      // Are we on a page that starts a chapter?
      let target = heading.where(level: 1)
      // if query(target).any(it => it.location().page() == i) {
      //   return //align(aln)[#i]
      // }

      // Find the chapter of the section we are currently in.
      let before = query(target.before(here()))
      if before.len() > 0 {
        let current = before.last()
        let gap = 1.75em
        let chapter = upper(text(size: 0.68em, current.body))
        if current.numbering != none {
            if is-odd {
              place(
                dx:25pt,
                dy:1pt+1em,
                bottom + aln,
                float: true,
                scope: "parent"
              )[
                #polygon(
                  fill: main-color,
                  (0pt,0pt),
                  (17pt,0pt),
                  (17pt,22pt),
                  (-20pt,22pt),
                )
                #move(
                  dy: -18pt,
                  dx:-0pt,
                )[
                  #block(
                    width: 3em,
                    // fill: luma(.5)
                  )[
                    #text(size: 0.8em, weight: "bold")[
                      #align(center)[#i]
                    ]
                  ]

                ]
              ]
            } else {
                place(
                  dx:-25pt,
                  dy:1pt+1em,
                  bottom + aln,
                  float: true,
                  scope: "parent"
                )[
                  #polygon(
                    fill: main-color,
                    (0pt,0pt),
                    (17pt,0pt),
                    (37pt,22pt),
                    (0pt,22pt),
                  )
                  #move(
                    dy: -18pt,
                    dx:0pt,
                  )[
                    #block(
                      width: 3em,
                      // fill: luma(0.5)
                    )[
                    #text(size: 0.8em, weight: "bold")[
                      #align(center)[#i]
                    ]
                    ]
                  ]
                ]
            }
        }
      }
    },
  )

  // Configure equation numbering.
  set math.equation(numbering: "(1)")

  // Display inline code in a small box that retains the correct baseline.
  show raw.where(block: false): box.with(
    fill: main-color.lighten(75%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Display block code with padding.
  show raw.where(block: true): block.with(
    inset: (x: 5pt),
  )

  // Break large tables across pages.
  show figure.where(kind: table): set block(breakable: true)
  // set table(
  //   // Increase the table cell's padding
  //   inset: 7pt, // default is 5pt
  //   stroke: (
  //     y: 1pt + stroke-color,
  //     // (y) => {
  //     //   if y==0 {none} else {1pt + stroke-color}
  //     // },
  //     rest: 0pt
  //     )
  // )
  // Use smallcaps for table header row.
  show table.cell.where(y: 0): smallcaps

  // Wrap `body` in curly braces so that it has its own context. This way show/set rules will only apply to body.
  {
    // Start chapters on a new page.
    show heading.where(level: 1): it => {
      if chapter-pagebreak { pagebreak(weak: true) }
      it
    }
    body
  }


  // Display bibliography.
  if bibliography != none {
    pagebreak()
    show std-bibliography: set text(0.85em)
    // Use default paragraph properties for bibliography.
    show std-bibliography: set par(leading: 0.65em, justify: false, linebreaks: auto)
    bibliography
  }

  // Display indices of figures, tables, and listings.
  let fig-t(kind) = figure.where(kind: kind)
  let has-fig(kind) = counter(fig-t(kind)).get().at(0) > 0
  if figure-index.enabled or table-index.enabled or listing-index.enabled {
    show outline: set heading(outlined: true)
    context {
      let imgs = figure-index.enabled and has-fig(image)
      let tbls = table-index.enabled and has-fig(table)
      let lsts = listing-index.enabled and has-fig(raw)
      if imgs or tbls or lsts {
        // Note that we pagebreak only once instead of each each
        // individual index. This is because for documents that only have a couple of
        // figures, starting each index on new page would result in superfluous
        // whitespace.
        pagebreak()
      }

      if imgs { outline(title: figure-index.at("title", default: "Index of Figures"), target: fig-t(image)) }
      if tbls { outline(title: table-index.at("title", default: "Index of Tables"), target: fig-t(table)) }
      if lsts { outline(title: listing-index.at("title", default: "Index of Listings"), target: fig-t(raw)) }
    }
  }



}




