Red/System []

#define BOLD_ON             "^[[1m"
#define RESET               "^[[0m"
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



