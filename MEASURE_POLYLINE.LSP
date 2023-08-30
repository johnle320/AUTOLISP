;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------
;MEASURE LENGTH OF EACH SEGMENT OF POLYLINES
;MEASUREMENTS ARE PUT IN A SEPARATE LAYER CALLED "03-LABEL_PLINE_SEG_LEN"
;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------
(vl-load-com)
(defun c:CAL_PLEN_MEAS ( / js htx AcDoc Space nw_style n obj ename pr dist_start dist_end pt_start pt_end seg_len alpha nw_obj)
  (princ "\nSelect polylines.")
  (while
    (null
      (setq js
        (ssget
          '(
            (0 . "*POLYLINE")
            (-4 . "<NOT")
              (-4 . "&") (70 . 112)
            (-4 . "NOT>")
          )
        )
      )
    )
    (princ "\nSelect is empty, or isn't POLYLINE!")
  )
  (initget 6)
  (setq htx (getdist (getvar "VIEWCTR") (strcat "\nSpecify height text <" (rtos (getvar "TEXTSIZE")) ">: ")))
  (if htx (setvar "TEXTSIZE" htx))
  (setq
    AcDoc (vla-get-ActiveDocument (vlax-get-acad-object))
    Space
    (if (= 1 (getvar "CVPORT"))
      (vla-get-PaperSpace AcDoc)
      (vla-get-ModelSpace AcDoc)
    )
  )
  (cond
    ((null (tblsearch "LAYER" "03-LABEL_PLINE_SEG_LEN"))
      (vlax-put (vla-add (vla-get-layers AcDoc) "03-LABEL_PLINE_SEG_LEN") 'color 96)
    )
  )
  (cond
    ((null (tblsearch "STYLE" "Romand-Label"))
      (setq nw_style (vla-add (vla-get-textstyles AcDoc) "Romand-Label"))
      (mapcar
        '(lambda (pr val)
          (vlax-put nw_style pr val)
        )
        (list 'FontFile 'Height 'ObliqueAngle 'Width 'TextGenerationFlag)
        (list "romand.shx" 0.0 (/ (* 15.0 pi) 180) 1.0 0.0)
      )
    )
  )
  (repeat (setq n (sslength js))
    (setq
      obj (ssname js (setq n (1- n)))
      ename (vlax-ename->vla-object obj)
      pr -1
    )
    (repeat (fix (vlax-curve-getEndParam ename))
      (setq
        dist_start (vlax-curve-GetDistAtParam ename (setq pr (1+ pr)))
        dist_end (vlax-curve-GetDistAtParam ename (1+ pr))
        pt_start (vlax-curve-GetPointAtParam ename pr)
        pt_end (vlax-curve-GetPointAtParam ename (1+ pr))
        seg_len (- dist_end dist_start)
        alpha (angle (trans pt_start 0 1) (trans pt_end 0 1))
      )
      (if (and (> alpha (* pi 0.5)) (< alpha (* pi 1.5))) (setq alpha (+ alpha pi)))
      (setq nw_obj
        (vla-addMtext Space
          (vlax-3d-point (setq pt (polar (vlax-curve-GetPointAtParam ename (+ 0.5 pr)) (+ alpha (* pi 0.5)) (getvar "TEXTSIZE"))))
          0.0
          (rtos seg_len (getvar "LUNITS") 0)
        )
      )
      (mapcar
        '(lambda (pr val)
          (vlax-put nw_obj pr val)
        )
        (list 'AttachmentPoint 'Height 'DrawingDirection 'InsertionPoint 'StyleName 'Layer 'Rotation)
        (list 8 (getvar "TEXTSIZE") 5 pt "Romand-Label" "03-LABEL_PLINE_SEG_LEN" alpha)
      )
    )
  )
  (prin1)
)
