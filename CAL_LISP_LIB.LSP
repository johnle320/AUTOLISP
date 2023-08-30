;version 1.1
;DATE: 08-30-2023

;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------
; SET UP ALL LTSCALE AND ANNOTATION COMMANDS
;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------
(defun c:CAL_ALLLAY_LTSCALE_SETUP()
    (setvar 'ctab "MODEL"); set current tab to be the model tab. From here this function starts to run
    (alert "The following setting will be applied for model space AND ALL layouts (paper space):\n MSLTSCALE: 1\n PSLTSCALE: 1\n LTSCALE: 1\n CELTSCALE: 1\n ANNOAUTOSCALE: 1\n")
    (command  "MSLTSCALE" 1)
    (command  "LTSCALE" 1)
    (command  "CELTSCALE" 1)
    (command  "ANNOAUTOSCALE" 1)
    (foreach lay (layoutlist)
        (command "_LAYOUT" "_Set" lay "PSLTSCALE" temp)
        (command "_pspace") ;switch to paper space. layout will be regenerated here --> slow
        (command "ANNOALLVISIBLE" 1)
    );end foreach
    (command "REGENALL")
    (princ)
    (alert "linescale setup is done!")
);end function (c:PS0)





