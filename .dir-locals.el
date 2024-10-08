(
 ;; Project Tasks
 (nil . ((vg-project-tasks . (
                              ("Regen RSS" . (lambda()
                                               (vg-multi-term-shell-command "./gen-rss.lisp" t)
                                               ))
                              ("Open Site" . (lambda()
                                               (vg-multi-term-shell-command "open ./docs/index.html" t)
                                               )))))))
