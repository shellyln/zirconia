(Html5
  (head
    (meta (@ (charset "utf-8")))
    (title ::$data:reportName)
    (NormalizeCss)
    (PaperCss)
    (Font (@ (href "https://fonts.googleapis.com/css?family=Noto+Sans+JP&display=swap")))
    (style (@ (dangerouslySetInnerHTML """$concat
      @page { size: A4 }
      body { font-family: "Noto Sans JP", "Helvetica Neue", Arial, "Hiragino Kaku Gothic ProN", "Hiragino Sans", Meiryo, sans-serif; }
      div.field-container { margin: 0; padding: 0; position: absolute; }
      table.details { border: 1px solid; border-collapse: collapse; table-layout: fixed; }
      table.details tr,th,td { border: 1px solid; margin: 0; padding: 0.2rem 0; }
      table.details tr,th,td div { margin: 0; padding: 0; font-size:10.5pt }
      table.details th { padding: 0 0.4rem; text-align: justify; text-align-last: justify; }
      table.details td { padding-left: 0.4rem; }
    """))))
  (body (@(class "A4"))
    (section (@(class "sheet")(style (position "relative")))
      (h1 ::$data:fields:Name:value) )
    (section (@(class "sheet")(style (position "relative")))
      (h1 ::$data:fields:Name:value) )
    (section (@(class "sheet")(style (position "relative")))
      (h1 ::$data:fields:Name:value) )
  (script "window.print()") ))
