Red/System []

#include %color.reds

#import [
	LIBC-file cdecl [
        shell: "system" [
            cmd [c-string!]
            return: [integer!]
        ]
        fgets: "fgets" [
            str         [byte-ptr!]
            count       [integer!]
            stream      [byte-ptr!]
            return:     [byte-ptr!]
        ]
        rand: "rand" [
            return: [integer!]
        ]
    ]
]

#either OS = 'Windows [
    #import [
        LIBC-file cdecl [
            fdopen: "_fdopen" [
                fd      [integer!]
                mode    [byte-ptr!]
                return: [byte-ptr!]
            ]
        ]
    ]
][
    #import [
        LIBC-file cdecl [
            fdopen: "fdopen" [
                fd      [integer!]
                mode    [byte-ptr!]
                return: [byte-ptr!]
            ]
        ]
    ]
]

std-in: fdopen 0 as byte-ptr! "r"
std-err: fdopen 2 as byte-ptr! "w"

;---------------------- utils ---------------------- 
newlf: func [
    n   [integer!]
    /local  i
][
    i: 0
    while [i < n][
        print lf
        i: i + 1
    ]
]

#define LINE(n) [newlf n]

randint: func [
    n   [integer!]
    return: [integer!]
][
    rand // n
]

clear-screen: func [][
    shell "clear"
]

draw-ascii: func [][
    LINE(1)
    print [FG_BLUE BOLD "  222222222222222          000000000             444444444        888888888      " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 2:::::::::::::::22      00:::::::::00          4::::::::4      88:::::::::88    " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 2::::::222222:::::2   00:::::::::::::00       4:::::::::4    88:::::::::::::88  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 2222222     2:::::2  0:::::::000:::::::0     4::::44::::4   8::::::88888::::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "             2:::::2  0::::::0   0::::::0    4::::4 4::::4   8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "             2:::::2  0:::::0     0:::::0   4::::4  4::::4   8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "          2222::::2   0:::::0     0:::::0  4::::4   4::::4    8:::::88888:::::8  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "     22222::::::22    0:::::0 000 0:::::0 4::::444444::::444   8:::::::::::::8   " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "   22::::::::222      0:::::0 000 0:::::0 4::::::::::::::::4  8:::::88888:::::8  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "  2:::::22222         0:::::0     0:::::0 4444444444:::::444 8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 2:::::2              0:::::0     0:::::0           4::::4   8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 2:::::2              0::::::0   0::::::0           4::::4   8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 2:::::2       222222 0:::::::000:::::::0           4::::4   8::::::88888::::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 2::::::2222222:::::2  00:::::::::::::00          44::::::44  88:::::::::::::88  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 2::::::::::::::::::2    00:::::::::00            4::::::::4    88:::::::::88    " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " 22222222222222222222      000000000              4444444444      888888888      " RESET FG_DEFAULT] LINE(1)
    print [FG_GREEN     "        From: http://patorjk.com/software/taag/#p=display&f=Doh&t=2048           " RESET FG_DEFAULT] LINE(2)
]

tile!: alias struct! [
    value   [integer!]
    color   [color!]
    blocked [logic!]
]


game: context [
    _x: 4
    _y: 4
    board-array: declare tile!

    init-board: func [
        x [integer!]
        y [integer!]
        /local 
            i       [integer!]
            total   [integer!]
            tile    [tile! value]
            b       [tile!]

    ][
        _x: x
        _y: y
        total: x * y
        board-array: as tile! allocate (total * size? tile!)

        i: 0
        while [i < total][
            tile: declare tile!
            tile/value: 0
            tile/color: C_RESET
            tile/blocked: no

            b: board-array + i
            b: tile
            i: i + 1
        ]
    ]

    draw-board: func [
        /local x y
    ][
        clear-screen
        draw-ascii

        y: 0
        while [y < _y][
            print "  +" 

            x: 0
            while [x < _x][
                print "-----+"
                x: x + 1
            ]

            print lf
            print "  |"

            x: 1
            while [x <= _x][
                print "     |"
                x: x + 1
            ]

            print lf
            y: y + 1
        ]

        x: 0
        print "  +"
        while [x < _x][
            print "-----+"
            x: x + 1
        ]

        LINE(2)
    ]
]

start-game: func [
    
][
    game/init-board 4 4
    game/draw-board
]

show-menu: func [
    /local
        cin [byte-ptr!]
][
    clear-screen
    draw-ascii

    print [BOLD "  Welcome to " FG_BLUE "2048!" FG_DEFAULT RESET] LINE(2)
    print ["          1. Play a New Game"] LINE(1)
    print ["          2. View Highscores and Statistics"] LINE(2)
    print ["  Enter Choice: "]

    cin: as byte-ptr! system/stack/allocate 2
    if null? fgets cin 2 std-in [
        start-game
    ]

    switch cin/1 [
        #"1" [
            print ["1. Play a New Game^/"]
            start-game
        ]
        #"2" [
            print ["2. View Highscores and Statistics^/^/"]
        ]
        default [
            start-game
        ]
    ]
    
]



show-menu


