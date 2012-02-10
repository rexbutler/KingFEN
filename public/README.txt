KingFEN 0.01 README

KingFEN is a small web application which displays chess positions described
using the FEN standard.

FUNCIONALITY

KingFEN accepts both 'GET' and 'POST' requests at '[base]/view' with
the following parameters:

  fen_string:         The FEN string of the chess position to display
  piece_image_set:    The piece image collection to use, one of:
                        alpha (default)
                        merida
                        uscf
  comment_top:        The comment to display above the board.
  comment_bottom:     The comment to display bellow the board.
                      [TO DO:  Fix CSS after reset for Textile support.]

  piece_size:         The pixel size of each piece/square
                      The supported sizes are 20 through 64 in increments of 4 along
                      with 74, 80, 88, 96, 112, 128, 144, and 300
                      
  FUTURE SUPPORT(?):

  board_color_scheme: The name of the board color scheme to use, one of:
                        brown (default)
                        aqua

  white_sqr_color:    A hex code for the background color of a white square.
                      * Overrides board_color_scheme
  black_sqr_color:    A hex code for the background color of a white square.
                      * Overrides board_color_scheme
                      

Also:
* There is an about/test page at '[base]/about.html'.
* There is a HTML mockup of a FEN editor application at '[base]/edit.html'
