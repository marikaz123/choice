� 0�!<s�e�ð��N�z ���.�>MwC� .�Nt�� =��u&��Y�$P���	�!X��!<u� �� =��t�O�3�L�!��.�>Mu�4������.�>Mu���	��.�>Mu���� ���� 뾾X�� ���� �.�Nu�L���<�t�<ar<zw$ߪ���L.�>T.�Nu�[��<�t��,���O�]?��$�.�Nu
<ar<zw$߹z �L��t.�O�z +�.�SþK�j ����.�O���=��u�P���	�!X.�V�t!������Q��� �H��Y� s���=��u��.�S�Q��!
�u���Yô�!<u� Y���g�Y��P��
�t���X�3��� �<w�� F�< t<	t<u�� .�M� �< t�<	t�<u� .�M</t*.�Nt	.�M� .�N��� =��u�.�M�{�<?u.�M�n <nu.�N�<su	.�N�{�<cu$.�Nu.�N�L�r =��t�[�.�M�+<tt.�M�.�Nu.�N�i =��t�.�.�M�<"t<t</t<"t"����NON� �.�>Tì<"t<t	���.�>Tø��ùz �<:uF�<t<	t< t	r��������NÀ<:uF�.�O�<,uPF�<0rJ<9wF�� t��	t��t��0r2��9r
�+,0.�VNÀ< t
�<	t�<u-00����������.�Vø���   
  �  CHOICE v1.2 * (c)1994 by 'marikaz'
Waits for the user to choose one of a set of choices.

  CHOICE [/C[:]choices] [/N] [/S] [/T[:]c,nn] [text]

 /C[:]choices Specifies allowable keys. Default is yn.
/N           Do not display choices and ? at end of prompt string.
/S           Make the choices case sensitive.
/T[:]c,nn    Default choice to c after nn seconds.
text         Prompt string to display.

ERRORLEVEL is set to offset of key user presses in choices.
 Invalid switch on command line. Expected form:
 CHOICE: Required MS-DOS version 2.0 or higher.
 CHOICE: Incorrect timeout syntax. Expected form: T[:]c,nn
 CHOICE: Only one prompt string allowed. Expected form:
 CHOICE: Timeout default not in specified (or default) choices.
 yn