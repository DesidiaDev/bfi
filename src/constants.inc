; system  call  numbers
SYS_EXIT	equ 1       ; man 2 exit
SYS_READ	equ 3       ; man 2 read
SYS_WRITE	equ 4       ; man 2 write
SYS_OPEN	equ 5       ; man 2 open
SYS_CLOSE	equ 6       ; man 2 close
SYS_CREAT	equ 8       ; man 2 creat

; standard  file  descriptors
STDIN		equ 0       ; standard  input
STDOUT		equ 1       ; standard  output
STDERR		equ 2       ; standard  error

; file  access  flags: see  man 2 open
O_RDONLY	equ 0000q   ; read -only
O_WRONLY	equ 0001q   ; write -only
O_RDWR		equ 0002q   ; read  and  write
O_CREAT		equ 0100q   ; create
O_TRUNC		equ 1000q   ; truncate
O_APPEND	equ 2000q   ; append

; file  permission  flags
S_IRUSR		equ 0400q   ; user  has  read  permission
S_IWUSR		equ 0200q   ; user  has  write  permission
S_IXUSR		equ 0100q   ; user  has  execute  permission
S_IRGRP		equ 0040q   ; group  has  read  permission
S_IWGRP		equ 0020q   ; group  has  write  permission
S_IXGRP		equ 0010q   ; group  has  execute  permission
S_IROTH		equ 0004q   ; others  have  read  permission
S_IWOTH		equ 0002q   ; others  have  write  permission
S_IXOTH		equ 0001q   ; others  have  execute  permission

; characters
LF			equ 0Ah     ; linefeed
