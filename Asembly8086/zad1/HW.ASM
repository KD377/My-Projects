display_letter:
                push ax
                push bx
                push cx
                push dx
                push si
                push di
                mov  ah,0x0e
                mov  bx,0x000f
                int  0x10
                pop  di
                pop  si
                pop  dx
                pop  cx
                pop  bx
                pop  ax
                ret
new_line:
          push ax
          mov  al,0x0a
          call display_letter
          mov  al,0x0d
          call display_letter
          pop  ax
          ret
print_digit:
             push ax
             add al,0x30
             pop ax
             ret