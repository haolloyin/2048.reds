Red/System []

#include %color.reds

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

draw-ascii: func [][
    LINE(1)
    print [FG_BLUE BOLD_ON "  222222222222222         000000000            444444444       888888888      " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2:::::::::::::::22     00:::::::::00         4::::::::4     88:::::::::88    " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2::::::222222:::::2  00:::::::::::::00      4:::::::::4   88:::::::::::::88  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2222222     2:::::2 0:::::::000:::::::0    4::::44::::4  8::::::88888::::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "             2:::::2 0::::::0   0::::::0   4::::4 4::::4  8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "             2:::::2 0:::::0     0:::::0  4::::4  4::::4  8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "          2222::::2  0:::::0     0:::::0 4::::4   4::::4   8:::::88888:::::8  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "     22222::::::22   0:::::0 000 0:::::04::::444444::::444  8:::::::::::::8   " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "   22::::::::222     0:::::0 000 0:::::04::::::::::::::::4 8:::::88888:::::8  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON "  2:::::22222        0:::::0     0:::::04444444444:::::4448:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2:::::2             0:::::0     0:::::0          4::::4  8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2:::::2             0::::::0   0::::::0          4::::4  8:::::8     8:::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2:::::2       2222220:::::::000:::::::0          4::::4  8::::::88888::::::8 " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2::::::2222222:::::2 00:::::::::::::00         44::::::44 88:::::::::::::88  " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 2::::::::::::::::::2   00:::::::::00           4::::::::4   88:::::::::88    " RESET FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD_ON " 22222222222222222222     000000000             4444444444     888888888      " RESET FG_DEFAULT] LINE(1)
    print [FG_GREEN        "        From: http://patorjk.com/software/taag/#p=display&f=Doh&t=2048        " RESET FG_DEFAULT] LINE(2)
]

draw-ascii

