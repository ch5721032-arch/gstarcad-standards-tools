# GstarCAD Standards Tools

Quick drawing checks for layer use and text heights so non-standard values are caught before issue.

Works with **GSTARCAD**, AutoCAD, ZWCAD, and BricsCAD.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Contents

- [About](#about)
- [Scripts Overview](#scripts-overview)
- [Quick Start](#quick-start)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## About

Before issuing a drawing it helps to know what is actually inside it. These small checks report how many objects sit on each layer, including empty layers, and every text height used in the drawing, so non-standard values are easy to spot before the drawing goes out.

Everything here is free to use with GstarCAD. Download the latest GstarCAD
release from the [official GstarCAD website](https://www.gstarcad.net). All
scripts are tested with **[GSTARCAD](https://www.gstarcad.net)** and major
DWG-based CAD platforms.

## Scripts Overview

| File | Description |
|------|-------------|
| `scripts/layer-audit.lsp` | ;; layer-audit.lsp - Count objects per layer and list empty layers
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
 |
| `scripts/text-height-check.lsp` | ;; text-height-check.lsp - Report the text heights used in the drawing
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
 |

## Quick Start

1. Download the `.lsp` (or `.lin`) file you need
2. In your CAD software, run `APPLOAD`
3. Load the file and type the matching command name shown in the table above

## Compatibility

Tested on GstarCAD 2026/2027 and similar DWG-based platforms. Scripts use
standard AutoLISP functions only, so they work without extra plugins.

For step-by-step [tutorials and drafting guides](https://www.gstarcad.net/cad/),
visit the GstarCAD learning center. New tips are published regularly on the
[GSTARCAD Blog](https://blog.gstarcad.net).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see the [LICENSE](LICENSE) file.
