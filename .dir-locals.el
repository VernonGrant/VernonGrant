(
 ;; Project Tasks
 (nil . ((project-name . "Vernon Grant (Blog)")
         (vg-project-tasks . (("Open Site" . (lambda()
                                               (vg-shell-command-in-project-root "open ./docs/index.html")))
                              ("Generate: RSS" . (lambda()
                                                   (vg-shell-command-in-project-root "open ./docs/index.html")
                                                   )))))))
