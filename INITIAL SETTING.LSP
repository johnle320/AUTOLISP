; SET UP ALL LTSCALE AND ANNOTATION COMMANDS
(defun c:CAL_LTSCALE_SETUP()
    (command  "MSLTSCALE" 1)
    (command  "LTSCALE" 1)
    (command  "CELTSCALE" 1)
    (command  "ANNOAUTOSCALE" 0)
    (foreach lay (layoutlist)
        (command "_LAYOUT" "_Set" lay "PSLTSCALE" 1)
        (command "_pspace") ;switch to paper space
        (command "ANNOALLVISIBLE" 1)
    );end foreach
    ;(command "REGENALL")
    (princ)
);endPS0 (c:PS0)

