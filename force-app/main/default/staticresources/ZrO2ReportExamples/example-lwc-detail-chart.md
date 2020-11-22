# Table and chart
## %%%($last ::$data:fields:Name:value)


%%%($last ($let table-data '(1 2 3 4 5 6 7 8 9 10)) nil)


| Left align           | Right align             | Center align                               |
|:---------------------|------------------------:|:------------------------------------------:| %%%($=for table-data """
| %%%($get $data)      | %%%($get $index)        | %%%($get $array ($get $index))             | """)
| %%%(+ ...table-data) | %%%($length table-data) | %%%($reduce table-data (-> (a b) (+ a b))) |


%%%($last ($defun get-color (i op)
    ($let p ($to-string op))
    ($let c ($list ($concat "rgba(255,  99, 132, " p ")")
                   ($concat "rgba( 54, 162, 235, " p ")")
                   ($concat "rgba(255, 206,  86, " p ")")
                   ($concat "rgba( 75, 192, 192, " p ")")
                   ($concat "rgba(153, 102, 255, " p ")")
                   ($concat "rgba(255, 159,  64, " p ")") ))
    ($get c ($mod i ($length c))) )
    nil)


%%%(Chart (@ (width 800)
             (height 400)
             (unit "px")
             (asImgTag)
             (displayDataLabel)
             (settings (#
    (type "bar")
    (data (#
        (labels ($list ...($map ($range 1 ($length table-data)) (-> (v) ($concat "#" ($to-string v))))))
        (datasets ($list (#
            (label "# of Votes")
            (data table-data)
            (backgroundColor ($map ($range 0 (- ($length table-data) 1)) (-> (i) (get-color i 0.2)) ))
            (borderColor     ($map ($range 0 (- ($length table-data) 1)) (-> (i) (get-color i 1.0)) ))
            (borderWidth 1) )))))
    (options (#
        (title (#
            (display true)
            (text "Chart.js example") ))
        (scales (#
            (yAxes ($list (# (ticks (#
                (beginAtZero true) )))))))
        (plugins (# (datalabels (#
            (color "black")
            (font (# (weight "bold")))
            (display (-> (ctx) (> ($get ctx dataset data ($get ctx dataIndex)) 5)))
            (formatter (-> (v) ($round v))) ))))))))))


%%%(Qr (@ (x 5)(y 7)(cellSize 0.8)
          (data ::$data:fields:Name:value) ))


%%%(Svg (@ (width  100)
           (height 100)
           (unit "mm") )
    (Canvas (-> (ctx) (::ctx@moveTo  10  10)
                      (::ctx@lineTo 190 190)
                      (::ctx:strokeStyle="rgba(255,128,0,0.2)")
                      (::ctx@stroke)
                      (::ctx@beginPath) )))
