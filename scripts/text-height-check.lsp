;; text-height-check.lsp - Report the text heights used in the drawing
;; Command: TEXTHCHECK
(defun c:TEXTHCHECK ( / ss i en ed h item alist )
  (setq ss (ssget "_X" '((0 . "TEXT,MTEXT"))))
  (if ss
    (progn
      (setq i 0 alist nil)
      (repeat (sslength ss)
        (setq en (ssname ss i)
              ed (entget en)
              h (cdr (assoc (if (= (cdr (assoc 0 ed)) "MTEXT") 43 40) ed)))
        (if (and h (numberp h))
          (progn
            (setq item (assoc h alist))
            (if item
              (setq alist (subst (cons h (1+ (cdr item))) item alist))
              (setq alist (cons (cons h 1) alist))
            )
          )
        )
        (setq i (1+ i))
      )
      (foreach item alist
        (princ (strcat "\nHeight " (rtos (car item) 2 2)
                       ": " (itoa (cdr item)) " objects"))
      )
    )
    (princ "\nNo text found.")
  )
  (princ)
)
