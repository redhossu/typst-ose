#import "theme.typ": book-theme
#import "@preview/gentle-clues:1.2.0":*
#import "theme.typ":*

#let debug = false


#let z-stack(..contents) = (
  context {
    let max-width = calc.max(
      ..contents.pos().map(content => {
        measure(content).width
      }),
    )

    box(
      grid(
        align: center + horizon,
        columns: contents.pos().len() * (max-width,),
        column-gutter: -max-width,
        rows: 1,
        ..contents
      ),
    )
  }
)


// This function formats its `body` (content) into a *blockquote*.
#let blockquote(body) = {
  pad(
    left: 0.9em,
    bottom: 0.25em,
  )[
  #block(
    width: 100%,
    // fill: fill-color,
    inset: 0.25em,
    outset: (x: 0.5em ),
    stroke: (left: 2pt + sub-color),
    emph(align(left, body))
  )
  ]
}

//怪物块
#let monster(
    name:"",
    ac:"",
    hd:"",
    att:"",
    thac0:"",
    mv:"",
    na:"",
    sv:"",
    ml:"",
    al:"",
    tt:"",
    xp:"",
    disc:"",
    body,
  ) = {
  v(2em, weak: true)
  //block(breakable: false)
  [#{
  grid(
    rows:5,
    row-gutter:0.5em,
//    fill: gray,
    grid(
      columns: (auto,0.5em,0.5em,1em,auto),
      text(
        weight: "bold",
        size:1.2em,
        //fill: main-color,
      )[#align(start+horizon,[#name])],h(0.5em),

      align(start+horizon)[#rect(fill:sub-color, height: 1.2em, width: 0.5em)],h(1em),

      emph[#align(horizon,[#disc])],
    ),
    line(length: 100%, stroke: 1pt+sub-color),
    [
    #if ac!= ""{[*AC* #ac]}
    #if hd!= ""{[，*HD* #hd]}
    #if att!= ""{[，*攻击* #att]}
    #if thac0!= ""{[，*THAC0* #dmg]}
    #if mv!= ""{[，*移动* #mv]}
    #if na!= ""{[，*NA* #na]}
    #if sv!= ""{[，*豁免* #sv]}
    #if ml!= ""{[，*士气* #ml]}
    #if tt!= ""{[，*TT* #tt]}
    #if al!= ""{[，*阵营* #tt]}
    #if xp!= ""{[，*XP* #xp]}
    ],
    line(length: 100%, stroke: 1pt+sub-color),
    emph[#body],
  )
  v(1em, weak: true)
  }]
}


#let monster_property(name:"",data) = {
  if data != none {box(stroke: if debug {1pt+red})[*#name* #data]}
}

//怪物块
#let monster_ose(
    // monster_id:array(),
    monster,
    alt_name:none,
    padding: 0.75em,
  ) = {
  v(2em, weak: true)
  //block(breakable: false)
  pad(left: padding)[#{
  block(
    fill: luma(220),
    inset: 5pt,
    outset: 5pt,
    below: 1em,
    breakable:false,
  grid(
    rows:5,
    row-gutter:0.5em,
    stroke: if debug {1pt},
//    fill: gray,
    grid(
      columns: (auto,0.5em,0.5em,1em,auto),
      text(
        weight: "bold",
        size:1.2em,
        //fill: main-color,
      )[#align(start+horizon,
          [#if alt_name != none {
            alt_name
          }else{
            monster.name
          }])],
      h(0.5em),

      align(start+horizon)[#rect(fill:sub-color, height: 1.2em, width: 0.5em)],h(1em),
      align(horizon,text(size: 0.8em)[#monster.disc]),
      // emph[#align(horizon,text(size: 0.8em)[#monster.disc])],
    ),
    line(length: 100%, stroke: 1pt+sub-color),
    [
      #set text(size:0.9em)
      #set par(justify: false,linebreaks: "simple")

      #if "ac" in monster {monster_property(name:"AC",monster.ac)}
      #if "hd" in monster {monster_property(name:"HD",monster.hd)}
      #if "att" in monster {monster_property(name:"攻击",monster.att)}
      #if "thac0" in monster {monster_property(name:"THAC0",monster.thac0)}
      #if "mv" in monster {monster_property(name:"移动",monster.mv)}
      #if "na" in monster {monster_property(name:"NA",monster.na)}
      #if "sv" in monster {monster_property(name:"豁免",monster.sv)}
      #if "ml" in monster {monster_property(name:"士气",monster.ml)}
      #if "tt" in monster {monster_property(name:"奖励",monster.tt)}
      #if "al" in monster {monster_property(name:"阵营",monster.al)}
      #if "xp" in monster {monster_property(name:"XP",monster.xp)}
    ],
    if monster.ability != "" {line(length: 100%, stroke: 1pt+sub-color)},
    if monster.ability != "" {
      set text(size:0.9em)
      set list(marker: sym.arrow.r.curve)
      eval(monster.ability,mode: "markup")

    }
  ))
  v(1.8em,weak: true)
  }]
}


//怪物块 for cairn
#let monster-cairn(
  name:"",
  hp:"",
  ac:"",
  str:"",
  dex:"",
  crl:"",
  wea:"",
  spacing:1.2em,
  body
  ) = {
  block(
    spacing: spacing,
    grid(
      rows:6,
      row-gutter:.5em,
      //fill: gray,
      grid(
        columns: (0.5em,0.5em,auto),
        align(start+horizon)[#rect(fill:sub-color, height: 1.2em, width: 0.5em)],h(0.5em),
        text(
          weight: "bold",
          size:1.2em,
          //fill: main-color,
        )[#align(start+horizon,[#name])],
  //      emph[#align(horizon,[#disc])],
      ),
      line(length: 100%, stroke: 1pt+sub-color),
      [
      #if str!= ""{[*力量* #str]}#if dex!= ""{[，*敏捷* #dex]}#if crl!= ""{[，*意志* #crl]}#if hp!= ""{[，*HP* #hp]}#if ac!= ""{[，*护甲* #ac]}
      ],[
      #if wea!= ""{[#wea]} \ #v(0.5em, weak: false)
      ],

      emph[
        #set par(leading: 0.62em)
        #body
        ],
      line(length: 100%, stroke: 1pt+sub-color),
      h(.5em, weak: false),
    )
  )
}

#let dnd-note-fold = (
  top-left: polygon(
    fill: luma(0%),
    (0%, 100% - 0.75pt),
    (100%, 0%),
    (100%, 100%),
  ),
  top-right: polygon(
    fill: luma(0%),
    (0%, 0%),
    (100%, 100% - 0.75pt),
    (0%, 100%),
  ),
  bottom-left: polygon(
    fill: luma(0%),
    (0%, 0.75pt),
    (100%, 0%),
    (100%, 100%),
  ),
  bottom-right: polygon(
    fill: luma(0%),
    (0%, 0%),
    (100%, 0.75pt),
    (0%, 100%),
  ),
)

#let dnd-with-folds = body => block(
  breakable: false,
  align(left)[
    #block(
      below: 0pt,
      breakable: false,
    )[
      #box(
        width: 3mm,
        height: 1mm,
        dnd-note-fold.top-left,
      )
      #h(1fr)
      #box(
        width: 3mm,
        height: 1mm,
        dnd-note-fold.top-right,
      )
    ]
    #body
    #block(
      above: 0pt,
      breakable: false,
    )[
      #box(
        width: 3mm,
        height: 1mm,
        dnd-note-fold.bottom-left,
      )
      #h(1fr)
      #box(
        width: 3mm,
        height: 1mm,
        dnd-note-fold.bottom-right,
      )
    ]
  ],
)

#let dnd-note = (body, theme: book-theme()) => {
  set par(justify: true)

  set text(font: theme.font.aside)

  set heading(
    level: 10,
    outlined: false,
  )

  show heading: smallcaps
  show heading: set text(
    size: 14pt,
    weight: 500,
    font: theme.font.aside,
    fill: luma(0%),
  )

  place(
    auto,
    float: true,
    dnd-with-folds(
      block(
        width: 100%,
        fill: rgb(235, 214, 193),
        stroke: (
          y: (
            paint: luma(0%),
            thickness: 1.5pt,
          ),
        ),
        inset: 8pt,
        breakable: false,
        body,
      ),
    ),
  )
}

#let dnd-dialogue = (..lines, highlight: (), theme: book-theme()) => {
  set text(font: theme.font.aside)

  show <dnd-dm>: set text(fill: theme.paint.label.dm.fill)

  show <dnd-player>: set text(fill: theme.paint.label.player.fill)

  show terms: it => block(
    fill: theme.paint.dialogue.fill,
    inset: 3mm,
    it,
  )

  lines = lines.pos().map(((speaker, line)) => {
    if speaker in highlight {
      ([#text(speaker + ":") <dnd-dm>], line)
    } else {
      ([#text(speaker + ":") <dnd-player>], line)
    }
  })

  terms(..lines)
}

#let dnd-enum = (..items, cols: 2, theme: book-theme()) => {
  set text(font: theme.font.aside)

  let items = items.pos().map(item => par(item))
  let count = items.len()
  let rows = calc.div-euclid(count, cols)

  items = items
    .chunks(rows)
    .map(chunk => {
        (..chunk, colbreak())
      })
    .join()

  block(inset: (x: 1cm), columns(cols, items.join()))
}

#let dnd-terms = (..args) => {
  let t = args.pos().map(((term, desc)) => {
    (emph(term + "."), desc)
  })

  terms(..t)
}

#let rfnote(
  title:"裁判笔记",
  icon:" ",
  ..args
) = {
  pad(
    left: 0.4em
  )[
    #tip(
      accent-color: sub-color,
      title:title,
      icon:icon,
      ..args
    )
  ]
}

#let rumor(
  title:"传言！",
  icon:" ",
  ..args
) = tip(
  accent-color: sub-color,
  title:title,
  icon:icon,
  ..args
)

#let rfclue(
  padding: 0.4em,
  ..args
) = {
  pad(
    left:padding
  )[
    #clue(
      ..args
    )
  ]
}


#let rand_table(
  ..entries, 
  start: 1,              // 起始编号
  header1: none,          // 表头1
  header2: none,   // 表头2
  show_header: false,    // 是否显示表头
  columns: (auto, 1fr),  // 列宽配置
  align: (center, left), // 对齐方式
  alt-fill: false,       // 交替行填充色
) = {
  // 获取所有传入的参数
  let items = entries.pos()
  
  // 如果没有传入任何条目，返回空内容
  if items.len() == 0 { return [] }
  
  // 创建表格内容
  let rows = ()
  
  // 添加表头（如果需要）
  if show_header {
    if header1 == none {
      header1 = "d" + [#items.len()]
    }

    if header2 == none {
      header2 = "随机遭遇"
    }

    rows.push(header1)
    rows.push(header2)
  }
  
  // 为每个条目创建一行，并根据需要应用交替行填充
  for (i, item) in items.enumerate() {
    rows.push(
      [*#(start + i)*]
    )
    rows.push(
      [#item]
    )
    
  }
  
  // 创建并返回表格
  table(
    columns: columns,
    align: align,
    ..rows
  )
}


#let ose_table(
  ..entries, 
  caption: none,          // 名称
  alt-fill: false,       // 交替行填充色
) = {
  // 获取所有传入的参数
  let items = entries.pos()
  
  // 如果没有传入任何条目，返回空内容
  if items.len() == 0 { return [] }
  
  // 创建表格内容
  let rows = ()
  
  // 添加表头（如果需要）
  if caption {
    rows.push(caption)
  }
  
  // 为每个条目创建一行，并根据需要应用交替行填充
  for (i, item) in items.enumerate() {
    rows.push(
      [*#(start + i)*]
    )
    rows.push(
      [#item]
    )
  }
  
  // 创建并返回表格
  table(
    columns: columns,
    align: align,
    ..rows
  )
}


#let info(
  inset:4pt,
  ..args
) = {
  box(
    fill: main-color,
    inset:inset,
    width: 100%,
    ..args
  )
}

#let ose-data(
  ..args
) = {
  block(
    stroke: (
      top:0.6pt,
      bottom:.6pt,
    ),
    inset:(y:3pt),
    width: 100%,
    above: 0.4em,
    below: 0.6em,
    ..args
  )
}