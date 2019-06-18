(lang dune 1.10)

(name scgi)

(using fmt 1.1)

(generate_opam_files true)

(source
 (github bikallem/ocaml-scgi))

(license BSD-3-Clause)

(authors "Mike Wells <https://github.com/mwells>"
  "Martin Jambon <https://github.com/mjambon>"
  "Bikal Lem <https://github.com/bikallem>")

(maintainers "Bikal Lem <https://github.com/bikallem>")

(homepage "https://github.com/bikallem/ocaml-scgi")

(bug_reports "https://github.com/bikallem/ocaml-scgi/issues")

(package
 (name scgi)
 (synopsis
   "Simple Common Gateway Interface (SCGI) protocol support for interface with HTTP servers")
 (tags
  ("scgi" "web application framework"))
 (depends
  (dune
   (and
    :build
    (>= 1.10)))
  (ocaml
   (>= 4.07.1))
  (lwt
   (>= 4.2.1))
  (lwt_ppx
   (>= 1.2.2))
  (uri
   (>= 2.2.1))
  (tyxml
   (>= 4.3.0))))
