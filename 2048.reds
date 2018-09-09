Red/System []

#include %color.reds

;---------------------- utils ---------------------- 
newlf: func [
    count   [integer!]
    /local  i
][
    i: 0
    while [i < count][
        print lf
        i: i + 1
    ]
]

#define LINE(n) [newlf n]

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

new-stdin: fdopen 0 as byte-ptr! "r"
new-stderr: fdopen 2 as byte-ptr! "w"

clear-screen: func [][
    shell "clear"
]

draw-ascii: func [][
    LINE(1)
    print [FG_BLUE BOLD_ON "  222222222222222          000000000             444444444        888888888      " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2:::::::::::::::22      00:::::::::00          4::::::::4      88:::::::::88    " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2::::::222222:::::2   00:::::::::::::00       4:::::::::4    88:::::::::::::88  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2222222     2:::::2  0:::::::000:::::::0     4::::44::::4   8::::::88888::::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "             2:::::2  0::::::0   0::::::0    4::::4 4::::4   8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "             2:::::2  0:::::0     0:::::0   4::::4  4::::4   8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "          2222::::2   0:::::0     0:::::0  4::::4   4::::4    8:::::88888:::::8  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "     22222::::::22    0:::::0 000 0:::::0 4::::444444::::444   8:::::::::::::8   " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "   22::::::::222      0:::::0 000 0:::::0 4::::::::::::::::4  8:::::88888:::::8  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "  2:::::22222         0:::::0     0:::::0 4444444444:::::444 8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2:::::2              0:::::0     0:::::0           4::::4   8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2:::::2              0::::::0   0::::::0           4::::4   8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2:::::2       222222 0:::::::000:::::::0           4::::4   8::::::88888::::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2::::::2222222:::::2  00:::::::::::::00          44::::::44  88:::::::::::::88  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2::::::::::::::::::2    00:::::::::00            4::::::::4    88:::::::::88    " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 22222222222222222222      000000000              4444444444      888888888      " RESET FG_DEFAULT] LINE(1)
    print [FG_GREEN        "        From: http://patorjk.com/software/taag/#p=display&f=Doh&t=2048           " RESET FG_DEFAULT] LINE(2)
]

start-game: func [
][
    print-line "TBD"
]

show-menu: func [
    /local
        cin [byte-ptr!]
][
    clear-screen
    draw-ascii

    print [bold_on "  Welcome to " FG_BLUE "2048!" FG_DEFAULT RESET] LINE(2)
    print ["          1. Play a New Game"] LINE(1)
    print ["          2. View Highscores and Statistics"] LINE(2)
    print ["  Enter Choice: "]

    cin: as byte-ptr! system/stack/allocate 2
    if null? fgets cin 2 new-stdin [
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


