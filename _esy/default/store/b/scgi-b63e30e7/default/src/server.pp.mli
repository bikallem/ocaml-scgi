Caml1999N023����            .src/server.mli����  �  Y  )  ������1ocaml.ppx.context��&_none_A@ �A����������)tool_name���.migrate_driver@@����,include_dirs����"[]@@����)load_path!����
%@%@����,open_modules*����.@.@����+for_package3����$None8@8@����%debug=����%falseB@B@����+use_threadsG����
K@K@����-use_vmthreadsP����T@T@����'cookiesY����B]@]@@@]@@]@]���A�    �+server_name��.src/server.mliBW\�BWg@@@@A�����&string��
BWj�BWp@@��BWj�BWp@@���)ocaml.doc��xA@ ��yA@ �A�������1 The SCGI server @��A@@� A@V@@@��"A@@�#A@V@@@��%BWW�&BWp@@��(BWW�)BWp@���A�    �)inet_addr��2Drw�3Dr @@@@@A�����&string��;Dr C�<Dr I@@��>Dr C�?Dr I@@@��ADrr�BDr I@@��DDrr�EDr I@���A�    �$port��NF K P�OF K T@@@@A�����#int��WF K W�XF K Z@@��ZF K W�[F K Z@@@��]F K K�^F K Z@@��`F K K�aF K Z@���A�    �/socket_filename��jH \ a�kH \ p@@@@A�����&string��sH \ s�tH \ y@@��vH \ s�wH \ y@@@��yH \ \�zH \ y@@��|H \ \�}H \ y@���Р,handler_inet���J { ��J { �@���,read_timeout����%float���K � ���K � �@@���K � ���K � �@@���2processing_timeout����%float���L � ���L � �@@���L � ���L � �@@���-write_timeout����%float���M ���M �@@���M ���M �@@���3write_error_handler��@����#exn���N2M��N2P@@���N2M��N2P@@�����#Lwt!t���N2Y��N2^@�����$unit���N2T��N2X@@���N2T��N2X@@@���N2T��N2^@@���N2M��N2^@@���"fd�����(Lwt_unix*file_descr���O`i��O`|@@���O`i��O`|@@���+buffer_size����#int���P}���P}�@@���P}�� P}�@@���'backlog����#int��Q���Q��@@��Q���Q��@@���(no_close����$bool��R���R��@@��R���R��@@��@����)inet_addr��'S���(S��@@��*S���+S��@@��@����$port��4T���5T��@@��7T���8T��@@��@��@�����'Request!t��EU���FU��@@��HU���IU��@@�����#Lwt!t��RU���SU��@������(Response!t��]U���^U��@@��`U���aU��@@@��cU���dU��@@��fU���gU��@@�����#Lwt!t��pV�
�qV�@������&Lwt_io&server��{V���|V�	@@��~V���V�	@@@���V����V�@@���U����V�@@���T����V�@@���S����V�@@���R����V�@@���Q����V�@@���P}���V�@@���O`e��V�@@���N27��V�@@���M ���V�@@���L � ���V�@@���K � ���V�@@@������A@ ��A@ �A�������	8 Launch an SCGI server listening on an Internet socket. @���W��WM@@@���W��WM@@@���J { {��V�@���J { {��V�@���Р,handler_sock���YOS��YO_@���,read_timeout����%float���Zbu��Zbz@@���Zbu��Zbz@@���2processing_timeout����%float���[����[��@@���[����[��@@���-write_timeout����%float���\����\��@@���\����\��@@���3write_error_handler��@����#exn�� ]!�]$@@��]!�]$@@�����#Lwt!t��]-�]2@�����$unit��](�],@@��](�],@@@��](�]2@@��]!� ]2@@���"fd�����(Lwt_unix*file_descr��-^4=�.^4P@@��0^4=�1^4P@@���+buffer_size����#int��<_Qc�=_Qf@@��?_Qc�@_Qf@@���'backlog����#int��K`gu�L`gx@@��N`gu�O`gx@@���(no_close����$bool��Zay��[ay�@@��]ay��^ay�@@��@����/socket_filename��gb���hb��@@��jb���kb��@@��@��@�����'Request!t��xc���yc��@@��{c���|c��@@�����#Lwt!t���c����c��@������(Response!t���c����c��@@���c����c��@@@���c����c��@@���c����c��@@�����#Lwt!t���d����d��@������&Lwt_io&server���d����d��@@���d����d��@@@���d����d��@@���c����d��@@���b����d��@@���ay~��d��@@���`gl��d��@@���_QV��d��@@���^49��d��@@���]��d��@@���\����d��@@���[����d��@@���Zbg��d��@@@���Ű�<A@ ��=A@ �A�������
  # Launch an SCGI server listening on a Unix-domain socket. You may want to
    block the SIGPIPE signal with
    [Sys.set_signal Sys.sigpipe Sys.Signal_ignore] in order to avoid process
    termination with exit code 141 (on Linux at least) when a client closes its
    connection too early. @���e����i�@@@���e����i�@@@���YOO��d��@���YOO��d��@@