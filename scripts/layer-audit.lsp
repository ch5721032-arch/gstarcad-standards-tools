;; layer-audit.lsp - Count objects per layer and list empty layers
;; Command: LAYERAUDIT
;; Usage: APPLOAD -> LAYERAUDIT -> read the report in the command line
(defun c:LAYERAUDIT ( / tbl name ss n total )
  (setq tbl (tblnext "LAYER" T) total 0)
  (while tbl
    (setq name (cdr (assoc 2 tbl)))
    (setq ss (ssget "_X" (list (cons 8 name))))
    (setq n (if ss (sslength ss) 0))
    (setq total (+ total n))
    (if (= n 0)
      (princ (strcat "\n" name ": empty layer"))
      (princ (strcat "\n" name ": " (itoa n) " objects"))
    )
    (setq tbl (tblnext "LAYER"))
  )
  (princ (strcat "\nTotal objects checked: " (itoa total)))
  (princ)
)
