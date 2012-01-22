KingFEN 0.01 README

KingFEN accepts both 'GET' and 'POST' requests at '[base]/view'.

It accepts the following parameters:
  fen_string:         The FEN string of the chess position to display
  piece_image_set:    The piece image collection to use, one of:
                        alpha (default)
                        merida
                        uscf
  comment_top:        The comment to display above the board.  Text or textile format.
  comment_bottom:     The comment to display bellow the board.  Text or textile format.                      
                          
  FUTURE SUPPORT(?):
  piece_size:         The pixel size of each piece/square [PRIORITY]

  board_color_scheme: The name of the board color scheme to use, one of:
                        brown (default)
                        aqua

  white_sqr_color:    A valid hex code for the background color of a white square.
                      * Overrides board_color_scheme
  black_sqr_color:    A valid hex code for the background color of a white square.
                      * Overrides board_color_scheme
                      
There is an 'about' page at '[base]/about.html'.

