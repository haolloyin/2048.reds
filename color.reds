Red/System []

#enum color! [
    C_RESET: 0
    C_BOLD: 1
    C_BG_BLUE: 44
    C_BG_DEFAULT: 49
    C_BG_GREEN: 42
    C_BG_RED: 41
    C_FG_BLACK: 30
    C_FG_BLUE: 34
    C_FG_CYAN: 36
    C_FG_DARK_GRAY: 90
    C_FG_DEFAULT: 39
    C_FG_GREEN: 32
    C_FG_LIGHT_BLUE: 94
    C_FG_LIGHT_CYAN: 96
    C_FG_LIGHT_GRAY: 37
    C_FG_LIGHT_GREEN: 92
    C_FG_LIGHT_MAGENTA: 95
    C_FG_LIGHT_RED: 91
    C_FG_LIGHT_YELLOW: 93
    C_FG_MAGENTA: 35
    C_FG_RED: 31
    C_FG_WHITE: 97
    C_FG_YELLOW: 33
]


#define RESET               "^[[0m"
#define BOLD                "^[[1m"
#define BG_BLUE             "^[[44m"
#define BG_DEFAULT          "^[[49m"
#define BG_GREEN            "^[[42m"
#define BG_RED              "^[[41m"
#define FG_BLACK            "^[[30m"
#define FG_BLUE             "^[[34m"
#define FG_CYAN             "^[[36m"
#define FG_DARK_GRAY        "^[[90m"
#define FG_DEFAULT          "^[[39m"
#define FG_GREEN            "^[[32m"
#define FG_LIGHT_BLUE       "^[[94m"
#define FG_LIGHT_CYAN       "^[[96m"
#define FG_LIGHT_GRAY       "^[[37m"
#define FG_LIGHT_GREEN      "^[[92m"
#define FG_LIGHT_MAGENTA    "^[[95m"
#define FG_LIGHT_RED        "^[[91m"
#define FG_LIGHT_YELLOW     "^[[93m"
#define FG_MAGENTA          "^[[35m"
#define FG_RED              "^[[31m"
#define FG_WHITE            "^[[97m"
#define FG_YELLOW           "^[[33m"


comment {
    ; See https://www.cnblogs.com/clover-toeic/p/4031618.html
    printf ["%s%s%s^/" BG_BLUE "blue" RESET]
    printf ["%s%s%s^/" BG_RED "red" RESET]
    printf ["%s%s%s^/" FG_YELLOW "yellow" RESET]

    print-line ["test " BOLD_ON "BOLD " RESET FG_RED "RED" RESET]
    print-line ["^[[1;33mBLINK_AND_BOLD" RESET]
    print-line ["^[[5;33mBLINK_AND_BOLD" RESET]
}


comment {
 222222222222222         000000000            444444444       888888888                                                                 d::::::d                 
2:::::::::::::::22     00:::::::::00         4::::::::4     88:::::::::88                                                               d::::::d                 
2::::::222222:::::2  00:::::::::::::00      4:::::::::4   88:::::::::::::88                                                             d::::::d                 
2222222     2:::::2 0:::::::000:::::::0    4::::44::::4  8::::::88888::::::8                                                            d:::::d                  
            2:::::2 0::::::0   0::::::0   4::::4 4::::4  8:::::8     8:::::8        rrrrr   rrrrrrrrr       eeeeeeeeeeee        ddddddddd:::::d     ssssssssss   
            2:::::2 0:::::0     0:::::0  4::::4  4::::4  8:::::8     8:::::8        r::::rrr:::::::::r    ee::::::::::::ee    dd::::::::::::::d   ss::::::::::s  
         2222::::2  0:::::0     0:::::0 4::::4   4::::4   8:::::88888:::::8         r:::::::::::::::::r  e::::::eeeee:::::ee d::::::::::::::::d ss:::::::::::::s 
    22222::::::22   0:::::0 000 0:::::04::::444444::::444  8:::::::::::::8          rr::::::rrrrr::::::re::::::e     e:::::ed:::::::ddddd:::::d s::::::ssss:::::s
  22::::::::222     0:::::0 000 0:::::04::::::::::::::::4 8:::::88888:::::8          r:::::r     r:::::re:::::::eeeee::::::ed::::::d    d:::::d  s:::::s  ssssss 
 2:::::22222        0:::::0     0:::::04444444444:::::4448:::::8     8:::::8         r:::::r     rrrrrrre:::::::::::::::::e d:::::d     d:::::d    s::::::s      
2:::::2             0:::::0     0:::::0          4::::4  8:::::8     8:::::8         r:::::r            e::::::eeeeeeeeeee  d:::::d     d:::::d       s::::::s   
2:::::2             0::::::0   0::::::0          4::::4  8:::::8     8:::::8         r:::::r            e:::::::e           d:::::d     d:::::d ssssss   s:::::s 
2:::::2       2222220:::::::000:::::::0          4::::4  8::::::88888::::::8         r:::::r            e::::::::e          d::::::ddddd::::::dds:::::ssss::::::s
2::::::2222222:::::2 00:::::::::::::00         44::::::44 88:::::::::::::88  ......  r:::::r             e::::::::eeeeeeee   d:::::::::::::::::ds::::::::::::::s 
2::::::::::::::::::2   00:::::::::00           4::::::::4   88:::::::::88    .::::.  r:::::r              ee:::::::::::::e    d:::::::::ddd::::d s:::::::::::ss  
22222222222222222222     000000000             4444444444     888888888      ......  rrrrrrr                eeeeeeeeeeeeee     ddddddddd   ddddd  sssssssssss    
}

