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
        ; https://www.ibm.com/support/knowledgecenter/zh/ssw_aix_72/com.ibm.aix.cmds5/stty.htm#stty__row-d3e57314
        shell "stty -echo -icanon" ; 不回显，禁用规范输入
        c: getchar
        shell "stty echo icanon" ; 恢复
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
    x   [integer!]
    return: [integer!]
][
    ;as-integer ( (log10 as-float x) / (log10 as-float 2) )
    as-integer ceil ( (log10 as-float x) / (log10 as-float 2) )
]

clear-screen: func [][
    shell "clear"
]

draw-ascii: func [][
    LINE(1)
    print [FG_BLUE BOLD "  /$$$$$$   /$$$$$$  /$$   /$$  /$$$$$$    " RESET FG_RED "                           /$$          " FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " /$$__  $$ /$$$_  $$| $$  | $$ /$$__  $$   " RESET FG_RED "                          | $$          " FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "|__/  \ $$| $$$$\ $$| $$  | $$| $$  \ $$   " RESET FG_RED "  /$$$$$$   /$$$$$$   /$$$$$$$  /$$$$$$$" FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "  /$$$$$$/| $$ $$ $$| $$$$$$$$|  $$$$$$/   " RESET FG_RED " /$$__  $$ /$$__  $$ /$$__  $$ /$$_____/" FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD " /$$____/ | $$\ $$$$|_____  $$ >$$__  $$   " RESET FG_RED "| $$  \__/| $$$$$$$$| $$  | $$|  $$$$$$ " FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "| $$      | $$ \ $$$      | $$| $$  \ $$   " RESET FG_RED "| $$      | $$_____/| $$  | $$ \____  $$" FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "| $$$$$$$$|  $$$$$$/      | $$|  $$$$$$/" RESET "/$$" RESET FG_RED "| $$      |  $$$$$$$|  $$$$$$$ /$$$$$$$/" FG_DEFAULT] LINE(1)
    print [FG_BLUE BOLD "|________/ \______/       |__/ \______/"  RESET "|__/" RESET FG_RED "|__/       \_______/ \_______/|_______/ " FG_DEFAULT] LINE(2)
    print [FG_BLUE BOLD "   http://patorjk.com/software/taag/#p=display&f=Big%20Money-ne&t=2048.reds                        " FG_DEFAULT] LINE(1)
    print [FG_GREEN BOLD "          Inspired by https://github.com/plibither8/2048.cpp" FG_DEFAULT] LINE(1)
    print [FG_RED        "          Writen in Red/System (https://github.com/red/red)"  FG_DEFAULT] LINE(1)
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

        print lf
        y: 0
        while [y < _y][
            print "  +" 

            ; 顶部边框
            x: 0
            while [x < _x][
                print "------+"
                x: x + 1
            ]

            print lf
            print "  |"

            ; 中间填充数字
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

        ; 底部边框
        x: 0
        print "  +"
        while [x < _x][
            print "------+"
            x: x + 1
        ]
        LINE(2)
    ]

    game-over?: func [
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
        "随机找一个空白块"
        return: [integer!]
        /local i tile
    ][
        if game-over? [return -1]
    
        until [
            i: rand-int _total
            tile: _board + i
            tile/value = 0
        ]
        i
    ]

    random-tile-value: func [
        "获取一个空白块的初始值，只能是 2 4 8 之一"
        return: [integer!]
        /local v
    ][
        until [
            v: rand-int 8
            all [
                v <> 0
                v <> 6
                v % 2 <> 1
            ]
        ]
        v
    ]

    fill-tile: func [
        "对指定下标的空白块增加一个值"
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
        "随机找 n 个空白块，并填上随机值"
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
        "处理每一行/列的值"
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
            c: _board + curr    ; 当前块
            n1: _board + next   ; 下一块
            ;printf ["curr:%d, next:%d ==> " curr next]
            if c/value > 0 [    ; 当前块非空，往后找到第一个非空白块
                nn: next
                h: 4 - k
                while [h > 0][
                    n: _board + nn
                    ;printf [" %d:%d, " nn n/value]
                    if n/value > 0 [   ; 后面第一个不为空的块
                        either c/value = n/value [
                            ; 与当前块相同，合并
                            ;printf ["%d:%d -> %d:%d^/" nn n/value curr c/value]
                            c/value: c/value * 2
                            n/value: 0
                        ][
                            if next <> nn [
                                ; 与当前块不同，且 n 与 n1 不同，否则否则会被设为 0
                                ;printf ["%d:%d >> %d:%d^/" nn n/value next n1/value]
                                n1/value: n/value ; 挪到当前的下一个空白块
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
        "压缩空白块"
        curr    [integer!]
        next    [integer!]
        j       [integer!]
        /local  k h nn
            c   [tile!]
            n   [tile!]
    ][
        k: 1
        until [
            c: _board + curr    ; 当前块
            if c/value = 0 [    ; 当前为空，往后找到第一个不为空的填进来
                nn: next
                h: 4 - k
                while [h > 0][
                    n: _board + nn
                    if n/value <> 0 [   ; 后面第一个不为空的块
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
        ; 用于测试
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
        0  1  2  3
        4  5  6  7
        8  9  10 11
        12 13 14 15
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
        i       [integer!]
        j       [integer!]
    ][
        ; 处理每一行/列的值
        handle-tile-values curr next j
        ; 压缩掉空白块
        compact-empty-tiles curr next j
    ]

    start: func [
        /local c times curr next update?
    ][
        forever [
            c: getch    ; 无回显、缓冲读取一个字符
            times: 0
            update?: true

            switch c [
                #"w" [  ; Up
                    ; 每次要处理 4 行/列
                    while [times < 4][
                        curr: times
                        next: curr + 4
                        move-line curr next 1 4
                        times: times + 1
                    ]
                ]
                #"s" [  ; Down
                    while [times < 4][
                        curr: 12 + times
                        next: curr - 4
                        move-line curr next 1 -4
                        times: times + 1
                    ]
                ]
                #"a" [  ; Left
                    while [times < 4][
                        curr: times * 4
                        next: curr + 1
                        move-line curr next 4 1
                        times: times + 1
                    ]
                ]
                #"d" [  ; Right
                    while [times < 4][
                        curr: 3 + (times * 4)
                        next: curr - 1
                        move-line curr next 4 -1
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
                ; 随机新增一个块，重画棋盘（最好不要在刚移动过的块来新增）
                game/add-tiles 1
                draw-board
                ;debug-print-board
            ]
        ]
    ]
]

;---------------------- 2048  ---------------------- 

start-game: does [
    game/init-board 4 4
    game/add-tiles 3
    ;game/add-tiles-for-test     ;-- test
    game/draw-board
    ;game/debug-print-board
    game/start
]

show-menu: func [
    /local
        cin [byte-ptr!]
][
    clear-screen
    ;draw-ascii

    print [BOLD "  Welcome to " FG_BLUE "2048!" FG_DEFAULT RESET] LINE(2)
    print ["          1. Play a New Game"] LINE(1)
    print ["          2. View Highscores and Statistics"] LINE(2)
    print ["  Enter Choice: "]

    cin: as byte-ptr! system/stack/allocate 2

    print lf
    start-game
    exit

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


