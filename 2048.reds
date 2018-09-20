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
        time: "time" [
            t   [integer!]
            return: [integer!]
        ]
        srand: "srand" [
            seed    [integer!]
            return: [integer!]
        ]
        rand: "rand" [
            return: [integer!]
        ]
        log10: "log10" [
            x   [float!]
            return: [float!]
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
            ; see https://docs.microsoft.com/zh-cn/cpp/c-runtime-library/reference/getch-getwch
            getch: "_getch" [
                return: [integer!]
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
            getchar: "getchar" [
                return: [integer!]
            ]
        ]
    ]

    getch: func [
        return: [integer!]
        /local c
    ][
        c: getchar
        c
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

srand time NULL

rand-int: func [
    max [integer!]
    return: [integer!]
][
    rand // (max + 1)
]

log2: func [
    x [integer!]
    return: [integer!]
    /local 
        f [float!]
][
    f: (log10 as-float x) / (log10 as-float 2)
    as-integer f
]

clear-screen: func [][
    shell "clear"
]

draw-menu: does [
    LINE(1)
    print [FG_LIGHT_MAGENTA "------------------------------------------------------------" lf]
    print [FG_LIGHT_MAGENTA "    W => Up" lf]
    print [FG_LIGHT_MAGENTA "    A => Left" lf]
    print [FG_LIGHT_MAGENTA "    S => Down" lf]
    print [FG_LIGHT_MAGENTA "    D => Right" lf]
    print [FG_LIGHT_MAGENTA "    Q => Quit Game" lf]
    print [FG_LIGHT_MAGENTA "------------------------------------------------------------" lf RESET FG_DEFAULT]
]

draw-ascii: func [][
    LINE(1)
    print [FG_BLUE BOLD "  /$$$$$$   /$$$$$$  /$$   /$$  /$$$$$$    "              RESET FG_RED "                           /$$          " FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " /$$__  $$ /$$$_  $$| $$  | $$ /$$__  $$   "              RESET FG_RED "                          | $$          " FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "|__/  \ $$| $$$$\ $$| $$  | $$| $$  \ $$   "              RESET FG_RED "  /$$$$$$   /$$$$$$   /$$$$$$$  /$$$$$$$" FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "  /$$$$$$/| $$ $$ $$| $$$$$$$$|  $$$$$$/   "              RESET FG_RED " /$$__  $$ /$$__  $$ /$$__  $$ /$$_____/" FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " /$$____/ | $$\ $$$$|_____  $$ >$$__  $$   "              RESET FG_RED "| $$  \__/| $$$$$$$$| $$  | $$|  $$$$$$ " FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "| $$      | $$ \ $$$      | $$| $$  \ $$   "              RESET FG_RED "| $$      | $$_____/| $$  | $$ \____  $$" FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "| $$$$$$$$|  $$$$$$/      | $$|  $$$$$$/"    RESET "/$$"  RESET FG_RED "| $$      |  $$$$$$$|  $$$$$$$ /$$$$$$$/" FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "|________/ \______/       |__/ \______/"     RESET "|__/" RESET FG_RED "|__/       \_______/ \_______/|_______/ " FG_DEFAULT] LINE(2)
    print [FG_CYAN BOLD "   http://patorjk.com/software/taag/#p=display&f=Big%20Money-ne&t=2048.reds                        " FG_DEFAULT] LINE(1)
    print [FG_GREEN BOLD "          Inspired by https://github.com/plibither8/2048.cpp" RESET FG_DEFAULT] LINE(1)
    print [FG_RED        "          Writen in Red/System (https://github.com/red/red)"  RESET FG_DEFAULT] LINE(1)
]


;---------------------- game ---------------------- 
tile!: alias struct! [
    value   [integer!]
    color   [color!]
    blocked [logic!]
]

game: context [
    _x: 4
    _y: 4
    _total: 0
    _board: declare tile!
    _colors: [
        FG_LIGHT_RED
        FG_LIGHT_BLUE
        FG_LIGHT_YELLOW
        FG_LIGHT_GREEN
        FG_LIGHT_MAGENTA
        FG_LIGHT_CYAN
        FG_LIGHT_GRAY

        FG_RED
        FG_BLUE
        FG_YELLOW
        FG_GREEN
        FG_MAGENTA
        FG_CYAN
        FG_GRAY
    ]

    init-board: func [
        x [integer!]
        y [integer!]
        /local i tile
    ][
        _x: x
        _y: y
        _total: x * y
        _board: as tile! allocate (_total * size? tile!)

        i: 0
        while [i < _total][
            tile: _board + i
            tile/value: 0
            tile/color: C_RESET
            tile/blocked: no
            i: i + 1
        ]
    ]

    debug-print-board: func [
        "打印棋盘每个各自的值"
        /local i tile
    ][
        i: 0
        print "board >> "
        while [i < _total][
            tile: _board + i
            if tile/value <> 0 [
                printf ["%d:%d, " i tile/value]
            ]
            i: i + 1
        ]
        print lf
    ]

    get-tile-color: func [
        tile    [tile!]
        return: [c-string!]
        /local log index
    ][
        log: log2 tile/value
        ; +1 是因为 Red/System 的字面量数组 /0 是数组长度
        index: either log < 12 [log][10 + 1]
        ;print ["i:" index]
        as-c-string _colors/index
    ]

    draw-board: func [
        /local x y i tile
    ][
        clear-screen
        draw-ascii
        draw-menu

        print lf
        y: 0
        while [y < _y][
            print "  +" 

            ; top border
            x: 0
            while [x < _x][
                print "------+"
                x: x + 1
            ]

            print lf
            print "  |"

            ; tiles grid with value
            x: 1
            while [x <= _x][
                i: y * 4 + x - 1
                tile: _board + i

                either tile/value <> 0 [
                    printf ["%s%s%5d%s%s |" (get-tile-color tile) BOLD tile/value RESET FG_DEFAULT]
                ][
                    print "      |"
                ]
                x: x + 1
            ]

            print lf
            y: y + 1
        ]

        ; bottom border
        x: 0
        print "  +"
        while [x < _x][
            print "------+"
            x: x + 1
        ]
        LINE(2)
    ]

    is-game-over?: func [
        return: [logic!]
        /local i tile
    ][
        i: 0
        while [i < _total][
            tile: _board + i
            if tile/value = 0 [return false]
            i: i + 1
        ]
        true
    ]

    find-empty-tile: func [
        return: [integer!]
        /local i tile
    ][
        until [
            i: rand-int _total
            tile: _board + i
            tile/value = 0
        ]
        i
    ]

    random-tile-value: func [
        "can only be 2 or 4 or 8"
        return: [integer!]
        /local v
    ][
        until [
            v: rand-int 8
            any [
                v = 2
                v = 4
                v = 8
            ]
        ]
        v
    ]

    fill-tile: func [
        "fill a tile with a given value"
        index   [integer!]
        value   [integer!]
        return: [integer!]
        /local tile
    ][
        tile: _board + index
        tile/value: either value = -1 [random-tile-value][value]
        tile/value
    ]

    add-tiles: func [
        "find n random tiles, each fills with a random value"
        n [integer!]
        return: [integer!]
        /local i index value
    ][
        i: 0
        while [i < n][
            index: find-empty-tile
            if index = -1 [return -1]

            value: fill-tile index -1
            ;print-line ["  fill board/" index " with " value]
            i: i + 1
        ]
        0
    ]

    move-tile: func [
        curr [tile!]
        next [tile!]
    ][
        if curr/value = next/value [
            curr/value: curr/value * 2
            next/value: 0
        ]
    ]

    handle-tile-values: func [
        "add value with two closest tiles with same value, or move next no zero tile to next one"
        curr    [integer!]
        next    [integer!]
        j       [integer!]
        /local  k h nn
            c   [tile!]
            n   [tile!]
            n1  [tile!]
    ][
        k: 1
        until [
            c: _board + curr    ; current tile
            n1: _board + next   ; next tile
            ;printf ["curr:%d, next:%d ==> " curr next]
            if c/value > 0 [    ; current tile is no empty, need to find next no empty one
                nn: next
                h: 4 - k
                while [h > 0][
                    n: _board + nn
                    ;printf [" %d:%d, " nn n/value]
                    if n/value > 0 [   ; next on empty one
                        either c/value = n/value [
                            ; same value as current tile, double current's value and reset the next to zero
                            ;printf ["%d:%d -> %d:%d^/" nn n/value curr c/value]
                            c/value: c/value * 2
                            n/value: 0
                        ][
                            if next <> nn [
                                ; different value with current tile, and is not the cloesest next one, then move it
                                ;printf ["%d:%d >> %d:%d^/" nn n/value next n1/value]
                                n1/value: n/value ; move to next closest empty tile
                                n/value: 0
                            ]
                        ]
                        break
                    ]
                    nn: nn + j
                    h: h - 1
                ]
            ]
            ;print lf
            curr: next
            next: next + j
            k: k + 1
            k > 3
        ]
    ]

    compact-empty-tiles: func [
        "make sure no empty tile between two filled tiles"
        curr    [integer!]
        next    [integer!]
        j       [integer!]
        /local  k h nn
            c   [tile!]
            n   [tile!]
    ][
        k: 1
        until [
            c: _board + curr    ; current tile
            if c/value = 0 [    ; current tile is empty, find next no empty one
                nn: next
                h: 4 - k
                while [h > 0][
                    n: _board + nn
                    if n/value <> 0 [   ; first no empty tile
                        c/value: n/value
                        n/value: 0
                        break
                    ]
                    nn: nn + j
                    h: h - 1
                ]
            ]
            curr: next
            next: next + j
            k: k + 1
            k > 3
        ]
    ]

    add-tiles-for-test: does [
        ; just for test: Left
        game/fill-tile 0 2
        game/fill-tile 2 2

        game/fill-tile 5 4
        game/fill-tile 7 4

        game/fill-tile 8 8
        game/fill-tile 11 8 

        game/fill-tile 12 2
        game/fill-tile 15 4
    ]

    comment {
            --Board index
        0   1   2   3
        4   5   6   7
        8   9   10  11
        12  13  14  15
            --Up
        curr: 0 4 8    1 5 9    2 6  10   3 7  11
        next: 4 8 12   5 9 13   6 10 14   7 11 15
            --Down
        curr: 12 8 4   13 9 5   14 10 6   15 11 7
        next: 8  4 0   9  5 1   10 6  2   11 7  3
            --Left
        curr: 0 1 2   4 5 6   8 9  10   12 13 14
        next: 1 2 3   5 6 7   9 10 11   13 14 15
            --Right
        curr: 3 2 1   7 6 5   11 10 9   15 14 13
        next: 2 1 0   6 5 4   10 9  8   14 13 12
    }

    move-line: func [
        curr    [integer!]
        next    [integer!]
        j       [integer!]
    ][
        handle-tile-values curr next j
        compact-empty-tiles curr next j
    ]

    start: func [
        /local c times curr next update?
    ][
        forever [
            c: getch    ; no echo, read only 1 char every time
            times: 0
            update?: true

            switch c [
                #"w" [  ; Up
                    while [times < 4][
                        curr: times
                        next: curr + 4
                        move-line curr next 4
                        times: times + 1
                    ]
                ]
                #"s" [  ; Down
                    while [times < 4][
                        curr: 12 + times
                        next: curr - 4
                        move-line curr next -4
                        times: times + 1
                    ]
                ]
                #"a" [  ; Left
                    while [times < 4][
                        curr: times * 4
                        next: curr + 1
                        move-line curr next 1
                        times: times + 1
                    ]
                ]
                #"d" [  ; Right
                    while [times < 4][
                        curr: 3 + (times * 4)
                        next: curr - 1
                        move-line curr next -1
                        times: times + 1
                    ]
                ]
                #"q" [
                    print-line [lf "Bye~" lf]
                    update?: false
                    break
                ]
                default [
                    update?: false
                ]
            ]

            if update? [
                if is-game-over? [
                    print-line ["Game Over! Bye ~" lf]
                    break
                ]
                game/add-tiles 1
                draw-board
            ]
        ]
    ]
]

;---------------------- 2048  ---------------------- 

start-game: does [
    #if OS <> 'Windows [
        ; https://www.ibm.com/support/knowledgecenter/zh/ssw_aix_72/com.ibm.aix.cmds5/stty.htm#stty__row-d3e57314
        shell "stty -echo -icanon" ; 不回显，禁用规范输入
    ]

    game/init-board 4 4
    game/add-tiles 3
    ;game/add-tiles-for-test     ;-- test
    game/draw-board
    ;game/debug-print-board
    game/start

    #if OS <> 'Windows [
        shell "stty echo icanon" ; 恢复
    ]
]

start-game

