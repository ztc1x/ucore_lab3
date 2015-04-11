
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 f0 11 00 	lgdtl  0x11f018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 f0 11 c0       	mov    $0xc011f000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba b0 0b 12 c0       	mov    $0xc0120bb0,%edx
c0100035:	b8 68 fa 11 c0       	mov    $0xc011fa68,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 68 fa 11 c0 	movl   $0xc011fa68,(%esp)
c0100051:	e8 7b 89 00 00       	call   c01089d1 <memset>

    cons_init();                // init the console
c0100056:	e8 87 15 00 00       	call   c01015e2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 60 8b 10 c0 	movl   $0xc0108b60,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 7c 8b 10 c0 	movl   $0xc0108b7c,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 46 4c 00 00       	call   c0104cca <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 37 1f 00 00       	call   c0101fc0 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 89 20 00 00       	call   c0102117 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 bb 73 00 00       	call   c010744e <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 7b 16 00 00       	call   c0101713 <ide_init>
    swap_init();                // init swap
c0100098:	e8 ea 5f 00 00       	call   c0106087 <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 f6 0c 00 00       	call   c0100d98 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 87 1e 00 00       	call   c0101f2e <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 ff 0b 00 00       	call   c0100cca <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 81 8b 10 c0 	movl   $0xc0108b81,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 8f 8b 10 c0 	movl   $0xc0108b8f,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 9d 8b 10 c0 	movl   $0xc0108b9d,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 ab 8b 10 c0 	movl   $0xc0108bab,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 b9 8b 10 c0 	movl   $0xc0108bb9,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 80 fa 11 c0       	mov    %eax,0xc011fa80
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 c8 8b 10 c0 	movl   $0xc0108bc8,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 e8 8b 10 c0 	movl   $0xc0108be8,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 07 8c 10 c0 	movl   $0xc0108c07,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 a0 fa 11 c0    	mov    %dl,-0x3fee0560(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 a0 fa 11 c0       	add    $0xc011faa0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 a0 fa 11 c0       	mov    $0xc011faa0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 05 13 00 00       	call   c010160e <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 cc 7d 00 00       	call   c0108112 <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 8c 12 00 00       	call   c010160e <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 6c 12 00 00       	call   c010164a <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 0c 8c 10 c0    	movl   $0xc0108c0c,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 0c 8c 10 c0 	movl   $0xc0108c0c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 38 aa 10 c0 	movl   $0xc010aa38,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 50 97 11 c0 	movl   $0xc0119750,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec 51 97 11 c0 	movl   $0xc0119751,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 e6 cf 11 c0 	movl   $0xc011cfe6,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 4a 81 00 00       	call   c0108845 <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 16 8c 10 c0 	movl   $0xc0108c16,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 2f 8c 10 c0 	movl   $0xc0108c2f,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 5a 8b 10 	movl   $0xc0108b5a,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 47 8c 10 c0 	movl   $0xc0108c47,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 68 fa 11 	movl   $0xc011fa68,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 5f 8c 10 c0 	movl   $0xc0108c5f,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 b0 0b 12 	movl   $0xc0120bb0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 77 8c 10 c0 	movl   $0xc0108c77,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 b0 0b 12 c0       	mov    $0xc0120bb0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 90 8c 10 c0 	movl   $0xc0108c90,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 ba 8c 10 c0 	movl   $0xc0108cba,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 d6 8c 10 c0 	movl   $0xc0108cd6,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
c01009cc:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
c01009d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

	uint32_t current_ebp = read_ebp();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
c01009da:	e8 d9 ff ff ff       	call   c01009b8 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while(current_ebp != 0)
c01009e2:	e9 9b 00 00 00       	jmp    c0100a82 <print_stackframe+0xb9>
	{
		cprintf("ebp:0x%08x ", current_ebp);
c01009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ee:	c7 04 24 e8 8c 10 c0 	movl   $0xc0108ce8,(%esp)
c01009f5:	e8 51 f9 ff ff       	call   c010034b <cprintf>
		cprintf("eip:0x%08x ", current_eip);
c01009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a01:	c7 04 24 f4 8c 10 c0 	movl   $0xc0108cf4,(%esp)
c0100a08:	e8 3e f9 ff ff       	call   c010034b <cprintf>

		cprintf("args:");
c0100a0d:	c7 04 24 00 8d 10 c0 	movl   $0xc0108d00,(%esp)
c0100a14:	e8 32 f9 ff ff       	call   c010034b <cprintf>
		int i = 0;
c0100a19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(i = 0; i < 4; i ++)
c0100a20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a27:	eb 26                	jmp    c0100a4f <print_stackframe+0x86>
			cprintf("0x%08x ", (uint32_t)(*(uint32_t*)(current_ebp + 8 + 4*i)));
c0100a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a2c:	c1 e0 02             	shl    $0x2,%eax
c0100a2f:	89 c2                	mov    %eax,%edx
c0100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a34:	01 d0                	add    %edx,%eax
c0100a36:	83 c0 08             	add    $0x8,%eax
c0100a39:	8b 00                	mov    (%eax),%eax
c0100a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3f:	c7 04 24 06 8d 10 c0 	movl   $0xc0108d06,(%esp)
c0100a46:	e8 00 f9 ff ff       	call   c010034b <cprintf>
		cprintf("ebp:0x%08x ", current_ebp);
		cprintf("eip:0x%08x ", current_eip);

		cprintf("args:");
		int i = 0;
		for(i = 0; i < 4; i ++)
c0100a4b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a4f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0100a53:	7e d4                	jle    c0100a29 <print_stackframe+0x60>
			cprintf("0x%08x ", (uint32_t)(*(uint32_t*)(current_ebp + 8 + 4*i)));
		cprintf("\n");
c0100a55:	c7 04 24 0e 8d 10 c0 	movl   $0xc0108d0e,(%esp)
c0100a5c:	e8 ea f8 ff ff       	call   c010034b <cprintf>

		print_debuginfo(current_eip - sizeof(uint32_t));
c0100a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a64:	83 e8 04             	sub    $0x4,%eax
c0100a67:	89 04 24             	mov    %eax,(%esp)
c0100a6a:	e8 a6 fe ff ff       	call   c0100915 <print_debuginfo>

		current_eip = (uint32_t)(*(uint32_t*)(current_ebp + 4));
c0100a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a72:	83 c0 04             	add    $0x4,%eax
c0100a75:	8b 00                	mov    (%eax),%eax
c0100a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = (uint32_t)(*(uint32_t*)current_ebp);
c0100a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7d:	8b 00                	mov    (%eax),%eax
c0100a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */

	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();

	while(current_ebp != 0)
c0100a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a86:	0f 85 5b ff ff ff    	jne    c01009e7 <print_stackframe+0x1e>

		current_eip = (uint32_t)(*(uint32_t*)(current_ebp + 4));
		current_ebp = (uint32_t)(*(uint32_t*)current_ebp);
	}

	return;
c0100a8c:	90                   	nop
}
c0100a8d:	c9                   	leave  
c0100a8e:	c3                   	ret    

c0100a8f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a8f:	55                   	push   %ebp
c0100a90:	89 e5                	mov    %esp,%ebp
c0100a92:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9c:	eb 0c                	jmp    c0100aaa <parse+0x1b>
            *buf ++ = '\0';
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa4:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aad:	0f b6 00             	movzbl (%eax),%eax
c0100ab0:	84 c0                	test   %al,%al
c0100ab2:	74 1d                	je     c0100ad1 <parse+0x42>
c0100ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab7:	0f b6 00             	movzbl (%eax),%eax
c0100aba:	0f be c0             	movsbl %al,%eax
c0100abd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac1:	c7 04 24 90 8d 10 c0 	movl   $0xc0108d90,(%esp)
c0100ac8:	e8 45 7d 00 00       	call   c0108812 <strchr>
c0100acd:	85 c0                	test   %eax,%eax
c0100acf:	75 cd                	jne    c0100a9e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad4:	0f b6 00             	movzbl (%eax),%eax
c0100ad7:	84 c0                	test   %al,%al
c0100ad9:	75 02                	jne    c0100add <parse+0x4e>
            break;
c0100adb:	eb 67                	jmp    c0100b44 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100add:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae1:	75 14                	jne    c0100af7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aea:	00 
c0100aeb:	c7 04 24 95 8d 10 c0 	movl   $0xc0108d95,(%esp)
c0100af2:	e8 54 f8 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afa:	8d 50 01             	lea    0x1(%eax),%edx
c0100afd:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0a:	01 c2                	add    %eax,%edx
c0100b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b11:	eb 04                	jmp    c0100b17 <parse+0x88>
            buf ++;
c0100b13:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1a:	0f b6 00             	movzbl (%eax),%eax
c0100b1d:	84 c0                	test   %al,%al
c0100b1f:	74 1d                	je     c0100b3e <parse+0xaf>
c0100b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b24:	0f b6 00             	movzbl (%eax),%eax
c0100b27:	0f be c0             	movsbl %al,%eax
c0100b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2e:	c7 04 24 90 8d 10 c0 	movl   $0xc0108d90,(%esp)
c0100b35:	e8 d8 7c 00 00       	call   c0108812 <strchr>
c0100b3a:	85 c0                	test   %eax,%eax
c0100b3c:	74 d5                	je     c0100b13 <parse+0x84>
            buf ++;
        }
    }
c0100b3e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b3f:	e9 66 ff ff ff       	jmp    c0100aaa <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b47:	c9                   	leave  
c0100b48:	c3                   	ret    

c0100b49 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b49:	55                   	push   %ebp
c0100b4a:	89 e5                	mov    %esp,%ebp
c0100b4c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b4f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b59:	89 04 24             	mov    %eax,(%esp)
c0100b5c:	e8 2e ff ff ff       	call   c0100a8f <parse>
c0100b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b68:	75 0a                	jne    c0100b74 <runcmd+0x2b>
        return 0;
c0100b6a:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b6f:	e9 85 00 00 00       	jmp    c0100bf9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7b:	eb 5c                	jmp    c0100bd9 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b7d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b83:	89 d0                	mov    %edx,%eax
c0100b85:	01 c0                	add    %eax,%eax
c0100b87:	01 d0                	add    %edx,%eax
c0100b89:	c1 e0 02             	shl    $0x2,%eax
c0100b8c:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100b91:	8b 00                	mov    (%eax),%eax
c0100b93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b97:	89 04 24             	mov    %eax,(%esp)
c0100b9a:	e8 d4 7b 00 00       	call   c0108773 <strcmp>
c0100b9f:	85 c0                	test   %eax,%eax
c0100ba1:	75 32                	jne    c0100bd5 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba6:	89 d0                	mov    %edx,%eax
c0100ba8:	01 c0                	add    %eax,%eax
c0100baa:	01 d0                	add    %edx,%eax
c0100bac:	c1 e0 02             	shl    $0x2,%eax
c0100baf:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100bb4:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bba:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc4:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc7:	83 c2 04             	add    $0x4,%edx
c0100bca:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bce:	89 0c 24             	mov    %ecx,(%esp)
c0100bd1:	ff d0                	call   *%eax
c0100bd3:	eb 24                	jmp    c0100bf9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdc:	83 f8 02             	cmp    $0x2,%eax
c0100bdf:	76 9c                	jbe    c0100b7d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be8:	c7 04 24 b3 8d 10 c0 	movl   $0xc0108db3,(%esp)
c0100bef:	e8 57 f7 ff ff       	call   c010034b <cprintf>
    return 0;
c0100bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf9:	c9                   	leave  
c0100bfa:	c3                   	ret    

c0100bfb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bfb:	55                   	push   %ebp
c0100bfc:	89 e5                	mov    %esp,%ebp
c0100bfe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c01:	c7 04 24 cc 8d 10 c0 	movl   $0xc0108dcc,(%esp)
c0100c08:	e8 3e f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c0d:	c7 04 24 f4 8d 10 c0 	movl   $0xc0108df4,(%esp)
c0100c14:	e8 32 f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100c19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c1d:	74 0b                	je     c0100c2a <kmonitor+0x2f>
        print_trapframe(tf);
c0100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c22:	89 04 24             	mov    %eax,(%esp)
c0100c25:	e8 fe 16 00 00       	call   c0102328 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2a:	c7 04 24 19 8e 10 c0 	movl   $0xc0108e19,(%esp)
c0100c31:	e8 0c f6 ff ff       	call   c0100242 <readline>
c0100c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c3d:	74 18                	je     c0100c57 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c49:	89 04 24             	mov    %eax,(%esp)
c0100c4c:	e8 f8 fe ff ff       	call   c0100b49 <runcmd>
c0100c51:	85 c0                	test   %eax,%eax
c0100c53:	79 02                	jns    c0100c57 <kmonitor+0x5c>
                break;
c0100c55:	eb 02                	jmp    c0100c59 <kmonitor+0x5e>
            }
        }
    }
c0100c57:	eb d1                	jmp    c0100c2a <kmonitor+0x2f>
}
c0100c59:	c9                   	leave  
c0100c5a:	c3                   	ret    

c0100c5b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c5b:	55                   	push   %ebp
c0100c5c:	89 e5                	mov    %esp,%ebp
c0100c5e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c68:	eb 3f                	jmp    c0100ca9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6d:	89 d0                	mov    %edx,%eax
c0100c6f:	01 c0                	add    %eax,%eax
c0100c71:	01 d0                	add    %edx,%eax
c0100c73:	c1 e0 02             	shl    $0x2,%eax
c0100c76:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100c7b:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c81:	89 d0                	mov    %edx,%eax
c0100c83:	01 c0                	add    %eax,%eax
c0100c85:	01 d0                	add    %edx,%eax
c0100c87:	c1 e0 02             	shl    $0x2,%eax
c0100c8a:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100c8f:	8b 00                	mov    (%eax),%eax
c0100c91:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c99:	c7 04 24 1d 8e 10 c0 	movl   $0xc0108e1d,(%esp)
c0100ca0:	e8 a6 f6 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cac:	83 f8 02             	cmp    $0x2,%eax
c0100caf:	76 b9                	jbe    c0100c6a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb6:	c9                   	leave  
c0100cb7:	c3                   	ret    

c0100cb8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb8:	55                   	push   %ebp
c0100cb9:	89 e5                	mov    %esp,%ebp
c0100cbb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cbe:	e8 bc fb ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc8:	c9                   	leave  
c0100cc9:	c3                   	ret    

c0100cca <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cca:	55                   	push   %ebp
c0100ccb:	89 e5                	mov    %esp,%ebp
c0100ccd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd0:	e8 f4 fc ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cda:	c9                   	leave  
c0100cdb:	c3                   	ret    

c0100cdc <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdc:	55                   	push   %ebp
c0100cdd:	89 e5                	mov    %esp,%ebp
c0100cdf:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce2:	a1 a0 fe 11 c0       	mov    0xc011fea0,%eax
c0100ce7:	85 c0                	test   %eax,%eax
c0100ce9:	74 02                	je     c0100ced <__panic+0x11>
        goto panic_dead;
c0100ceb:	eb 48                	jmp    c0100d35 <__panic+0x59>
    }
    is_panic = 1;
c0100ced:	c7 05 a0 fe 11 c0 01 	movl   $0x1,0xc011fea0
c0100cf4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf7:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d00:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0b:	c7 04 24 26 8e 10 c0 	movl   $0xc0108e26,(%esp)
c0100d12:	e8 34 f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d21:	89 04 24             	mov    %eax,(%esp)
c0100d24:	e8 ef f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d29:	c7 04 24 42 8e 10 c0 	movl   $0xc0108e42,(%esp)
c0100d30:	e8 16 f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d35:	e8 fa 11 00 00       	call   c0101f34 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d41:	e8 b5 fe ff ff       	call   c0100bfb <kmonitor>
    }
c0100d46:	eb f2                	jmp    c0100d3a <__panic+0x5e>

c0100d48 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d48:	55                   	push   %ebp
c0100d49:	89 e5                	mov    %esp,%ebp
c0100d4b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d4e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d57:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d62:	c7 04 24 44 8e 10 c0 	movl   $0xc0108e44,(%esp)
c0100d69:	e8 dd f5 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d75:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d78:	89 04 24             	mov    %eax,(%esp)
c0100d7b:	e8 98 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d80:	c7 04 24 42 8e 10 c0 	movl   $0xc0108e42,(%esp)
c0100d87:	e8 bf f5 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100d8c:	c9                   	leave  
c0100d8d:	c3                   	ret    

c0100d8e <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d8e:	55                   	push   %ebp
c0100d8f:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d91:	a1 a0 fe 11 c0       	mov    0xc011fea0,%eax
}
c0100d96:	5d                   	pop    %ebp
c0100d97:	c3                   	ret    

c0100d98 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d98:	55                   	push   %ebp
c0100d99:	89 e5                	mov    %esp,%ebp
c0100d9b:	83 ec 28             	sub    $0x28,%esp
c0100d9e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dac:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db0:	ee                   	out    %al,(%dx)
c0100db1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dbf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc3:	ee                   	out    %al,(%dx)
c0100dc4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dca:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd6:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd7:	c7 05 bc 0a 12 c0 00 	movl   $0x0,0xc0120abc
c0100dde:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de1:	c7 04 24 62 8e 10 c0 	movl   $0xc0108e62,(%esp)
c0100de8:	e8 5e f5 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100ded:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df4:	e8 99 11 00 00       	call   c0101f92 <pic_enable>
}
c0100df9:	c9                   	leave  
c0100dfa:	c3                   	ret    

c0100dfb <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfb:	55                   	push   %ebp
c0100dfc:	89 e5                	mov    %esp,%ebp
c0100dfe:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e01:	9c                   	pushf  
c0100e02:	58                   	pop    %eax
c0100e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e09:	25 00 02 00 00       	and    $0x200,%eax
c0100e0e:	85 c0                	test   %eax,%eax
c0100e10:	74 0c                	je     c0100e1e <__intr_save+0x23>
        intr_disable();
c0100e12:	e8 1d 11 00 00       	call   c0101f34 <intr_disable>
        return 1;
c0100e17:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1c:	eb 05                	jmp    c0100e23 <__intr_save+0x28>
    }
    return 0;
c0100e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e23:	c9                   	leave  
c0100e24:	c3                   	ret    

c0100e25 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e25:	55                   	push   %ebp
c0100e26:	89 e5                	mov    %esp,%ebp
c0100e28:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e2f:	74 05                	je     c0100e36 <__intr_restore+0x11>
        intr_enable();
c0100e31:	e8 f8 10 00 00       	call   c0101f2e <intr_enable>
    }
}
c0100e36:	c9                   	leave  
c0100e37:	c3                   	ret    

c0100e38 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e38:	55                   	push   %ebp
c0100e39:	89 e5                	mov    %esp,%ebp
c0100e3b:	83 ec 10             	sub    $0x10,%esp
c0100e3e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e44:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e48:	89 c2                	mov    %eax,%edx
c0100e4a:	ec                   	in     (%dx),%al
c0100e4b:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e54:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e58:	89 c2                	mov    %eax,%edx
c0100e5a:	ec                   	in     (%dx),%al
c0100e5b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e64:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e68:	89 c2                	mov    %eax,%edx
c0100e6a:	ec                   	in     (%dx),%al
c0100e6b:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e74:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e78:	89 c2                	mov    %eax,%edx
c0100e7a:	ec                   	in     (%dx),%al
c0100e7b:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7e:	c9                   	leave  
c0100e7f:	c3                   	ret    

c0100e80 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e80:	55                   	push   %ebp
c0100e81:	89 e5                	mov    %esp,%ebp
c0100e83:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e86:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e90:	0f b7 00             	movzwl (%eax),%eax
c0100e93:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea2:	0f b7 00             	movzwl (%eax),%eax
c0100ea5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea9:	74 12                	je     c0100ebd <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eab:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb2:	66 c7 05 c6 fe 11 c0 	movw   $0x3b4,0xc011fec6
c0100eb9:	b4 03 
c0100ebb:	eb 13                	jmp    c0100ed0 <cga_init+0x50>
    } else {
        *cp = was;
c0100ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec7:	66 c7 05 c6 fe 11 c0 	movw   $0x3d4,0xc011fec6
c0100ece:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed0:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100ed7:	0f b7 c0             	movzwl %ax,%eax
c0100eda:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ede:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eea:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eeb:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100ef2:	83 c0 01             	add    $0x1,%eax
c0100ef5:	0f b7 c0             	movzwl %ax,%eax
c0100ef8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efc:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f00:	89 c2                	mov    %eax,%edx
c0100f02:	ec                   	in     (%dx),%al
c0100f03:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f06:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0a:	0f b6 c0             	movzbl %al,%eax
c0100f0d:	c1 e0 08             	shl    $0x8,%eax
c0100f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f13:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100f1a:	0f b7 c0             	movzwl %ax,%eax
c0100f1d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f21:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f25:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f29:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f2d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2e:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100f35:	83 c0 01             	add    $0x1,%eax
c0100f38:	0f b7 c0             	movzwl %ax,%eax
c0100f3b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f43:	89 c2                	mov    %eax,%edx
c0100f45:	ec                   	in     (%dx),%al
c0100f46:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f49:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4d:	0f b6 c0             	movzbl %al,%eax
c0100f50:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f56:	a3 c0 fe 11 c0       	mov    %eax,0xc011fec0
    crt_pos = pos;
c0100f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5e:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
}
c0100f64:	c9                   	leave  
c0100f65:	c3                   	ret    

c0100f66 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f66:	55                   	push   %ebp
c0100f67:	89 e5                	mov    %esp,%ebp
c0100f69:	83 ec 48             	sub    $0x48,%esp
c0100f6c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f72:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f76:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7e:	ee                   	out    %al,(%dx)
c0100f7f:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f85:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f89:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f8d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f91:	ee                   	out    %al,(%dx)
c0100f92:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f98:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f9c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa4:	ee                   	out    %al,(%dx)
c0100fa5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fab:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100faf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb7:	ee                   	out    %al,(%dx)
c0100fb8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fbe:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fca:	ee                   	out    %al,(%dx)
c0100fcb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd1:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fdd:	ee                   	out    %al,(%dx)
c0100fde:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe4:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fec:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff0:	ee                   	out    %al,(%dx)
c0100ff1:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff7:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ffb:	89 c2                	mov    %eax,%edx
c0100ffd:	ec                   	in     (%dx),%al
c0100ffe:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101001:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101005:	3c ff                	cmp    $0xff,%al
c0101007:	0f 95 c0             	setne  %al
c010100a:	0f b6 c0             	movzbl %al,%eax
c010100d:	a3 c8 fe 11 c0       	mov    %eax,0xc011fec8
c0101012:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101018:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010101c:	89 c2                	mov    %eax,%edx
c010101e:	ec                   	in     (%dx),%al
c010101f:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101022:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101028:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010102c:	89 c2                	mov    %eax,%edx
c010102e:	ec                   	in     (%dx),%al
c010102f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101032:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c0101037:	85 c0                	test   %eax,%eax
c0101039:	74 0c                	je     c0101047 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101042:	e8 4b 0f 00 00       	call   c0101f92 <pic_enable>
    }
}
c0101047:	c9                   	leave  
c0101048:	c3                   	ret    

c0101049 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101049:	55                   	push   %ebp
c010104a:	89 e5                	mov    %esp,%ebp
c010104c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101056:	eb 09                	jmp    c0101061 <lpt_putc_sub+0x18>
        delay();
c0101058:	e8 db fd ff ff       	call   c0100e38 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101061:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101067:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106b:	89 c2                	mov    %eax,%edx
c010106d:	ec                   	in     (%dx),%al
c010106e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101071:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101075:	84 c0                	test   %al,%al
c0101077:	78 09                	js     c0101082 <lpt_putc_sub+0x39>
c0101079:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101080:	7e d6                	jle    c0101058 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101082:	8b 45 08             	mov    0x8(%ebp),%eax
c0101085:	0f b6 c0             	movzbl %al,%eax
c0101088:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108e:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101091:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101095:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101099:	ee                   	out    %al,(%dx)
c010109a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ac:	ee                   	out    %al,(%dx)
c01010ad:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010bb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010bf:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c0:	c9                   	leave  
c01010c1:	c3                   	ret    

c01010c2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c2:	55                   	push   %ebp
c01010c3:	89 e5                	mov    %esp,%ebp
c01010c5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010cc:	74 0d                	je     c01010db <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d1:	89 04 24             	mov    %eax,(%esp)
c01010d4:	e8 70 ff ff ff       	call   c0101049 <lpt_putc_sub>
c01010d9:	eb 24                	jmp    c01010ff <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010db:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e2:	e8 62 ff ff ff       	call   c0101049 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ee:	e8 56 ff ff ff       	call   c0101049 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fa:	e8 4a ff ff ff       	call   c0101049 <lpt_putc_sub>
    }
}
c01010ff:	c9                   	leave  
c0101100:	c3                   	ret    

c0101101 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101101:	55                   	push   %ebp
c0101102:	89 e5                	mov    %esp,%ebp
c0101104:	53                   	push   %ebx
c0101105:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101108:	8b 45 08             	mov    0x8(%ebp),%eax
c010110b:	b0 00                	mov    $0x0,%al
c010110d:	85 c0                	test   %eax,%eax
c010110f:	75 07                	jne    c0101118 <cga_putc+0x17>
        c |= 0x0700;
c0101111:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101118:	8b 45 08             	mov    0x8(%ebp),%eax
c010111b:	0f b6 c0             	movzbl %al,%eax
c010111e:	83 f8 0a             	cmp    $0xa,%eax
c0101121:	74 4c                	je     c010116f <cga_putc+0x6e>
c0101123:	83 f8 0d             	cmp    $0xd,%eax
c0101126:	74 57                	je     c010117f <cga_putc+0x7e>
c0101128:	83 f8 08             	cmp    $0x8,%eax
c010112b:	0f 85 88 00 00 00    	jne    c01011b9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101131:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101138:	66 85 c0             	test   %ax,%ax
c010113b:	74 30                	je     c010116d <cga_putc+0x6c>
            crt_pos --;
c010113d:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101144:	83 e8 01             	sub    $0x1,%eax
c0101147:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010114d:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c0101152:	0f b7 15 c4 fe 11 c0 	movzwl 0xc011fec4,%edx
c0101159:	0f b7 d2             	movzwl %dx,%edx
c010115c:	01 d2                	add    %edx,%edx
c010115e:	01 c2                	add    %eax,%edx
c0101160:	8b 45 08             	mov    0x8(%ebp),%eax
c0101163:	b0 00                	mov    $0x0,%al
c0101165:	83 c8 20             	or     $0x20,%eax
c0101168:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116b:	eb 72                	jmp    c01011df <cga_putc+0xde>
c010116d:	eb 70                	jmp    c01011df <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010116f:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101176:	83 c0 50             	add    $0x50,%eax
c0101179:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010117f:	0f b7 1d c4 fe 11 c0 	movzwl 0xc011fec4,%ebx
c0101186:	0f b7 0d c4 fe 11 c0 	movzwl 0xc011fec4,%ecx
c010118d:	0f b7 c1             	movzwl %cx,%eax
c0101190:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101196:	c1 e8 10             	shr    $0x10,%eax
c0101199:	89 c2                	mov    %eax,%edx
c010119b:	66 c1 ea 06          	shr    $0x6,%dx
c010119f:	89 d0                	mov    %edx,%eax
c01011a1:	c1 e0 02             	shl    $0x2,%eax
c01011a4:	01 d0                	add    %edx,%eax
c01011a6:	c1 e0 04             	shl    $0x4,%eax
c01011a9:	29 c1                	sub    %eax,%ecx
c01011ab:	89 ca                	mov    %ecx,%edx
c01011ad:	89 d8                	mov    %ebx,%eax
c01011af:	29 d0                	sub    %edx,%eax
c01011b1:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
        break;
c01011b7:	eb 26                	jmp    c01011df <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b9:	8b 0d c0 fe 11 c0    	mov    0xc011fec0,%ecx
c01011bf:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01011c6:	8d 50 01             	lea    0x1(%eax),%edx
c01011c9:	66 89 15 c4 fe 11 c0 	mov    %dx,0xc011fec4
c01011d0:	0f b7 c0             	movzwl %ax,%eax
c01011d3:	01 c0                	add    %eax,%eax
c01011d5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011db:	66 89 02             	mov    %ax,(%edx)
        break;
c01011de:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011df:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01011e6:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011ea:	76 5b                	jbe    c0101247 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ec:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c01011f1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f7:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c01011fc:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101203:	00 
c0101204:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101208:	89 04 24             	mov    %eax,(%esp)
c010120b:	e8 00 78 00 00       	call   c0108a10 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101210:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101217:	eb 15                	jmp    c010122e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101219:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c010121e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101221:	01 d2                	add    %edx,%edx
c0101223:	01 d0                	add    %edx,%eax
c0101225:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101235:	7e e2                	jle    c0101219 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101237:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c010123e:	83 e8 50             	sub    $0x50,%eax
c0101241:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101247:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c010124e:	0f b7 c0             	movzwl %ax,%eax
c0101251:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101255:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101259:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010125d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101261:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101262:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101269:	66 c1 e8 08          	shr    $0x8,%ax
c010126d:	0f b6 c0             	movzbl %al,%eax
c0101270:	0f b7 15 c6 fe 11 c0 	movzwl 0xc011fec6,%edx
c0101277:	83 c2 01             	add    $0x1,%edx
c010127a:	0f b7 d2             	movzwl %dx,%edx
c010127d:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101281:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101284:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101288:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128c:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010128d:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0101294:	0f b7 c0             	movzwl %ax,%eax
c0101297:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010129b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010129f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a8:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01012af:	0f b6 c0             	movzbl %al,%eax
c01012b2:	0f b7 15 c6 fe 11 c0 	movzwl 0xc011fec6,%edx
c01012b9:	83 c2 01             	add    $0x1,%edx
c01012bc:	0f b7 d2             	movzwl %dx,%edx
c01012bf:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c3:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ce:	ee                   	out    %al,(%dx)
}
c01012cf:	83 c4 34             	add    $0x34,%esp
c01012d2:	5b                   	pop    %ebx
c01012d3:	5d                   	pop    %ebp
c01012d4:	c3                   	ret    

c01012d5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d5:	55                   	push   %ebp
c01012d6:	89 e5                	mov    %esp,%ebp
c01012d8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e2:	eb 09                	jmp    c01012ed <serial_putc_sub+0x18>
        delay();
c01012e4:	e8 4f fb ff ff       	call   c0100e38 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ed:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f7:	89 c2                	mov    %eax,%edx
c01012f9:	ec                   	in     (%dx),%al
c01012fa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	83 e0 20             	and    $0x20,%eax
c0101307:	85 c0                	test   %eax,%eax
c0101309:	75 09                	jne    c0101314 <serial_putc_sub+0x3f>
c010130b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101312:	7e d0                	jle    c01012e4 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101314:	8b 45 08             	mov    0x8(%ebp),%eax
c0101317:	0f b6 c0             	movzbl %al,%eax
c010131a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101320:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101323:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101327:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132b:	ee                   	out    %al,(%dx)
}
c010132c:	c9                   	leave  
c010132d:	c3                   	ret    

c010132e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132e:	55                   	push   %ebp
c010132f:	89 e5                	mov    %esp,%ebp
c0101331:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101334:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101338:	74 0d                	je     c0101347 <serial_putc+0x19>
        serial_putc_sub(c);
c010133a:	8b 45 08             	mov    0x8(%ebp),%eax
c010133d:	89 04 24             	mov    %eax,(%esp)
c0101340:	e8 90 ff ff ff       	call   c01012d5 <serial_putc_sub>
c0101345:	eb 24                	jmp    c010136b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101347:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134e:	e8 82 ff ff ff       	call   c01012d5 <serial_putc_sub>
        serial_putc_sub(' ');
c0101353:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135a:	e8 76 ff ff ff       	call   c01012d5 <serial_putc_sub>
        serial_putc_sub('\b');
c010135f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101366:	e8 6a ff ff ff       	call   c01012d5 <serial_putc_sub>
    }
}
c010136b:	c9                   	leave  
c010136c:	c3                   	ret    

c010136d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010136d:	55                   	push   %ebp
c010136e:	89 e5                	mov    %esp,%ebp
c0101370:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101373:	eb 33                	jmp    c01013a8 <cons_intr+0x3b>
        if (c != 0) {
c0101375:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101379:	74 2d                	je     c01013a8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010137b:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c0101380:	8d 50 01             	lea    0x1(%eax),%edx
c0101383:	89 15 e4 00 12 c0    	mov    %edx,0xc01200e4
c0101389:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010138c:	88 90 e0 fe 11 c0    	mov    %dl,-0x3fee0120(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101392:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c0101397:	3d 00 02 00 00       	cmp    $0x200,%eax
c010139c:	75 0a                	jne    c01013a8 <cons_intr+0x3b>
                cons.wpos = 0;
c010139e:	c7 05 e4 00 12 c0 00 	movl   $0x0,0xc01200e4
c01013a5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ab:	ff d0                	call   *%eax
c01013ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b4:	75 bf                	jne    c0101375 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b6:	c9                   	leave  
c01013b7:	c3                   	ret    

c01013b8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b8:	55                   	push   %ebp
c01013b9:	89 e5                	mov    %esp,%ebp
c01013bb:	83 ec 10             	sub    $0x10,%esp
c01013be:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c8:	89 c2                	mov    %eax,%edx
c01013ca:	ec                   	in     (%dx),%al
c01013cb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ce:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d2:	0f b6 c0             	movzbl %al,%eax
c01013d5:	83 e0 01             	and    $0x1,%eax
c01013d8:	85 c0                	test   %eax,%eax
c01013da:	75 07                	jne    c01013e3 <serial_proc_data+0x2b>
        return -1;
c01013dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e1:	eb 2a                	jmp    c010140d <serial_proc_data+0x55>
c01013e3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ed:	89 c2                	mov    %eax,%edx
c01013ef:	ec                   	in     (%dx),%al
c01013f0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f7:	0f b6 c0             	movzbl %al,%eax
c01013fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fd:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101401:	75 07                	jne    c010140a <serial_proc_data+0x52>
        c = '\b';
c0101403:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140d:	c9                   	leave  
c010140e:	c3                   	ret    

c010140f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010140f:	55                   	push   %ebp
c0101410:	89 e5                	mov    %esp,%ebp
c0101412:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101415:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c010141a:	85 c0                	test   %eax,%eax
c010141c:	74 0c                	je     c010142a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141e:	c7 04 24 b8 13 10 c0 	movl   $0xc01013b8,(%esp)
c0101425:	e8 43 ff ff ff       	call   c010136d <cons_intr>
    }
}
c010142a:	c9                   	leave  
c010142b:	c3                   	ret    

c010142c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142c:	55                   	push   %ebp
c010142d:	89 e5                	mov    %esp,%ebp
c010142f:	83 ec 38             	sub    $0x38,%esp
c0101432:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101438:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143c:	89 c2                	mov    %eax,%edx
c010143e:	ec                   	in     (%dx),%al
c010143f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101442:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101446:	0f b6 c0             	movzbl %al,%eax
c0101449:	83 e0 01             	and    $0x1,%eax
c010144c:	85 c0                	test   %eax,%eax
c010144e:	75 0a                	jne    c010145a <kbd_proc_data+0x2e>
        return -1;
c0101450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101455:	e9 59 01 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
c010145a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101460:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101464:	89 c2                	mov    %eax,%edx
c0101466:	ec                   	in     (%dx),%al
c0101467:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101471:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101475:	75 17                	jne    c010148e <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101477:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010147c:	83 c8 40             	or     $0x40,%eax
c010147f:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
        return 0;
c0101484:	b8 00 00 00 00       	mov    $0x0,%eax
c0101489:	e9 25 01 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101492:	84 c0                	test   %al,%al
c0101494:	79 47                	jns    c01014dd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101496:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010149b:	83 e0 40             	and    $0x40,%eax
c010149e:	85 c0                	test   %eax,%eax
c01014a0:	75 09                	jne    c01014ab <kbd_proc_data+0x7f>
c01014a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a6:	83 e0 7f             	and    $0x7f,%eax
c01014a9:	eb 04                	jmp    c01014af <kbd_proc_data+0x83>
c01014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014af:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b6:	0f b6 80 60 f0 11 c0 	movzbl -0x3fee0fa0(%eax),%eax
c01014bd:	83 c8 40             	or     $0x40,%eax
c01014c0:	0f b6 c0             	movzbl %al,%eax
c01014c3:	f7 d0                	not    %eax
c01014c5:	89 c2                	mov    %eax,%edx
c01014c7:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014cc:	21 d0                	and    %edx,%eax
c01014ce:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
        return 0;
c01014d3:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d8:	e9 d6 00 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014dd:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014e2:	83 e0 40             	and    $0x40,%eax
c01014e5:	85 c0                	test   %eax,%eax
c01014e7:	74 11                	je     c01014fa <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ed:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014f2:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f5:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
    }

    shift |= shiftcode[data];
c01014fa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fe:	0f b6 80 60 f0 11 c0 	movzbl -0x3fee0fa0(%eax),%eax
c0101505:	0f b6 d0             	movzbl %al,%edx
c0101508:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010150d:	09 d0                	or     %edx,%eax
c010150f:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
    shift ^= togglecode[data];
c0101514:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101518:	0f b6 80 60 f1 11 c0 	movzbl -0x3fee0ea0(%eax),%eax
c010151f:	0f b6 d0             	movzbl %al,%edx
c0101522:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101527:	31 d0                	xor    %edx,%eax
c0101529:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8

    c = charcode[shift & (CTL | SHIFT)][data];
c010152e:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101533:	83 e0 03             	and    $0x3,%eax
c0101536:	8b 14 85 60 f5 11 c0 	mov    -0x3fee0aa0(,%eax,4),%edx
c010153d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101541:	01 d0                	add    %edx,%eax
c0101543:	0f b6 00             	movzbl (%eax),%eax
c0101546:	0f b6 c0             	movzbl %al,%eax
c0101549:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154c:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101551:	83 e0 08             	and    $0x8,%eax
c0101554:	85 c0                	test   %eax,%eax
c0101556:	74 22                	je     c010157a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101558:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155c:	7e 0c                	jle    c010156a <kbd_proc_data+0x13e>
c010155e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101562:	7f 06                	jg     c010156a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101564:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101568:	eb 10                	jmp    c010157a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156e:	7e 0a                	jle    c010157a <kbd_proc_data+0x14e>
c0101570:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101574:	7f 04                	jg     c010157a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101576:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157a:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010157f:	f7 d0                	not    %eax
c0101581:	83 e0 06             	and    $0x6,%eax
c0101584:	85 c0                	test   %eax,%eax
c0101586:	75 28                	jne    c01015b0 <kbd_proc_data+0x184>
c0101588:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010158f:	75 1f                	jne    c01015b0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101591:	c7 04 24 7d 8e 10 c0 	movl   $0xc0108e7d,(%esp)
c0101598:	e8 ae ed ff ff       	call   c010034b <cprintf>
c010159d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015ab:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015af:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b3:	c9                   	leave  
c01015b4:	c3                   	ret    

c01015b5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b5:	55                   	push   %ebp
c01015b6:	89 e5                	mov    %esp,%ebp
c01015b8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015bb:	c7 04 24 2c 14 10 c0 	movl   $0xc010142c,(%esp)
c01015c2:	e8 a6 fd ff ff       	call   c010136d <cons_intr>
}
c01015c7:	c9                   	leave  
c01015c8:	c3                   	ret    

c01015c9 <kbd_init>:

static void
kbd_init(void) {
c01015c9:	55                   	push   %ebp
c01015ca:	89 e5                	mov    %esp,%ebp
c01015cc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015cf:	e8 e1 ff ff ff       	call   c01015b5 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015db:	e8 b2 09 00 00       	call   c0101f92 <pic_enable>
}
c01015e0:	c9                   	leave  
c01015e1:	c3                   	ret    

c01015e2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e2:	55                   	push   %ebp
c01015e3:	89 e5                	mov    %esp,%ebp
c01015e5:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e8:	e8 93 f8 ff ff       	call   c0100e80 <cga_init>
    serial_init();
c01015ed:	e8 74 f9 ff ff       	call   c0100f66 <serial_init>
    kbd_init();
c01015f2:	e8 d2 ff ff ff       	call   c01015c9 <kbd_init>
    if (!serial_exists) {
c01015f7:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c01015fc:	85 c0                	test   %eax,%eax
c01015fe:	75 0c                	jne    c010160c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101600:	c7 04 24 89 8e 10 c0 	movl   $0xc0108e89,(%esp)
c0101607:	e8 3f ed ff ff       	call   c010034b <cprintf>
    }
}
c010160c:	c9                   	leave  
c010160d:	c3                   	ret    

c010160e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160e:	55                   	push   %ebp
c010160f:	89 e5                	mov    %esp,%ebp
c0101611:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101614:	e8 e2 f7 ff ff       	call   c0100dfb <__intr_save>
c0101619:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 9b fa ff ff       	call   c01010c2 <lpt_putc>
        cga_putc(c);
c0101627:	8b 45 08             	mov    0x8(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 cf fa ff ff       	call   c0101101 <cga_putc>
        serial_putc(c);
c0101632:	8b 45 08             	mov    0x8(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 f1 fc ff ff       	call   c010132e <serial_putc>
    }
    local_intr_restore(intr_flag);
c010163d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101640:	89 04 24             	mov    %eax,(%esp)
c0101643:	e8 dd f7 ff ff       	call   c0100e25 <__intr_restore>
}
c0101648:	c9                   	leave  
c0101649:	c3                   	ret    

c010164a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164a:	55                   	push   %ebp
c010164b:	89 e5                	mov    %esp,%ebp
c010164d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101650:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101657:	e8 9f f7 ff ff       	call   c0100dfb <__intr_save>
c010165c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010165f:	e8 ab fd ff ff       	call   c010140f <serial_intr>
        kbd_intr();
c0101664:	e8 4c ff ff ff       	call   c01015b5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101669:	8b 15 e0 00 12 c0    	mov    0xc01200e0,%edx
c010166f:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c0101674:	39 c2                	cmp    %eax,%edx
c0101676:	74 31                	je     c01016a9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101678:	a1 e0 00 12 c0       	mov    0xc01200e0,%eax
c010167d:	8d 50 01             	lea    0x1(%eax),%edx
c0101680:	89 15 e0 00 12 c0    	mov    %edx,0xc01200e0
c0101686:	0f b6 80 e0 fe 11 c0 	movzbl -0x3fee0120(%eax),%eax
c010168d:	0f b6 c0             	movzbl %al,%eax
c0101690:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101693:	a1 e0 00 12 c0       	mov    0xc01200e0,%eax
c0101698:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169d:	75 0a                	jne    c01016a9 <cons_getc+0x5f>
                cons.rpos = 0;
c010169f:	c7 05 e0 00 12 c0 00 	movl   $0x0,0xc01200e0
c01016a6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016ac:	89 04 24             	mov    %eax,(%esp)
c01016af:	e8 71 f7 ff ff       	call   c0100e25 <__intr_restore>
    return c;
c01016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b7:	c9                   	leave  
c01016b8:	c3                   	ret    

c01016b9 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016b9:	55                   	push   %ebp
c01016ba:	89 e5                	mov    %esp,%ebp
c01016bc:	83 ec 14             	sub    $0x14,%esp
c01016bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016c6:	90                   	nop
c01016c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cb:	83 c0 07             	add    $0x7,%eax
c01016ce:	0f b7 c0             	movzwl %ax,%eax
c01016d1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016d9:	89 c2                	mov    %eax,%edx
c01016db:	ec                   	in     (%dx),%al
c01016dc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016df:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016e3:	0f b6 c0             	movzbl %al,%eax
c01016e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ec:	25 80 00 00 00       	and    $0x80,%eax
c01016f1:	85 c0                	test   %eax,%eax
c01016f3:	75 d2                	jne    c01016c7 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016f9:	74 11                	je     c010170c <ide_wait_ready+0x53>
c01016fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016fe:	83 e0 21             	and    $0x21,%eax
c0101701:	85 c0                	test   %eax,%eax
c0101703:	74 07                	je     c010170c <ide_wait_ready+0x53>
        return -1;
c0101705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010170a:	eb 05                	jmp    c0101711 <ide_wait_ready+0x58>
    }
    return 0;
c010170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101711:	c9                   	leave  
c0101712:	c3                   	ret    

c0101713 <ide_init>:

void
ide_init(void) {
c0101713:	55                   	push   %ebp
c0101714:	89 e5                	mov    %esp,%ebp
c0101716:	57                   	push   %edi
c0101717:	53                   	push   %ebx
c0101718:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010171e:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101724:	e9 d6 02 00 00       	jmp    c01019ff <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101729:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010172d:	c1 e0 03             	shl    $0x3,%eax
c0101730:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101737:	29 c2                	sub    %eax,%edx
c0101739:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c010173f:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101742:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101746:	66 d1 e8             	shr    %ax
c0101749:	0f b7 c0             	movzwl %ax,%eax
c010174c:	0f b7 04 85 a8 8e 10 	movzwl -0x3fef7158(,%eax,4),%eax
c0101753:	c0 
c0101754:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101758:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010175c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101763:	00 
c0101764:	89 04 24             	mov    %eax,(%esp)
c0101767:	e8 4d ff ff ff       	call   c01016b9 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010176c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101770:	83 e0 01             	and    $0x1,%eax
c0101773:	c1 e0 04             	shl    $0x4,%eax
c0101776:	83 c8 e0             	or     $0xffffffe0,%eax
c0101779:	0f b6 c0             	movzbl %al,%eax
c010177c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101780:	83 c2 06             	add    $0x6,%edx
c0101783:	0f b7 d2             	movzwl %dx,%edx
c0101786:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010178a:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101791:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101795:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101796:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010179a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017a1:	00 
c01017a2:	89 04 24             	mov    %eax,(%esp)
c01017a5:	e8 0f ff ff ff       	call   c01016b9 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017aa:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ae:	83 c0 07             	add    $0x7,%eax
c01017b1:	0f b7 c0             	movzwl %ax,%eax
c01017b4:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b8:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017bc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017c0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017c4:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017c5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017d0:	00 
c01017d1:	89 04 24             	mov    %eax,(%esp)
c01017d4:	e8 e0 fe ff ff       	call   c01016b9 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017d9:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017dd:	83 c0 07             	add    $0x7,%eax
c01017e0:	0f b7 c0             	movzwl %ax,%eax
c01017e3:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e7:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017eb:	89 c2                	mov    %eax,%edx
c01017ed:	ec                   	in     (%dx),%al
c01017ee:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017f1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f5:	84 c0                	test   %al,%al
c01017f7:	0f 84 f7 01 00 00    	je     c01019f4 <ide_init+0x2e1>
c01017fd:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101801:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101808:	00 
c0101809:	89 04 24             	mov    %eax,(%esp)
c010180c:	e8 a8 fe ff ff       	call   c01016b9 <ide_wait_ready>
c0101811:	85 c0                	test   %eax,%eax
c0101813:	0f 85 db 01 00 00    	jne    c01019f4 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101819:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010181d:	c1 e0 03             	shl    $0x3,%eax
c0101820:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101827:	29 c2                	sub    %eax,%edx
c0101829:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c010182f:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101832:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101836:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101839:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010183f:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101842:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101849:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010184c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010184f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101852:	89 cb                	mov    %ecx,%ebx
c0101854:	89 df                	mov    %ebx,%edi
c0101856:	89 c1                	mov    %eax,%ecx
c0101858:	fc                   	cld    
c0101859:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010185b:	89 c8                	mov    %ecx,%eax
c010185d:	89 fb                	mov    %edi,%ebx
c010185f:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101862:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101865:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010186b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010186e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101871:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101877:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010187a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010187d:	25 00 00 00 04       	and    $0x4000000,%eax
c0101882:	85 c0                	test   %eax,%eax
c0101884:	74 0e                	je     c0101894 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101889:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c010188f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101892:	eb 09                	jmp    c010189d <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101897:	8b 40 78             	mov    0x78(%eax),%eax
c010189a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010189d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018a1:	c1 e0 03             	shl    $0x3,%eax
c01018a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ab:	29 c2                	sub    %eax,%edx
c01018ad:	81 c2 00 01 12 c0    	add    $0xc0120100,%edx
c01018b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018b6:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018b9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018bd:	c1 e0 03             	shl    $0x3,%eax
c01018c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c7:	29 c2                	sub    %eax,%edx
c01018c9:	81 c2 00 01 12 c0    	add    $0xc0120100,%edx
c01018cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018d2:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d8:	83 c0 62             	add    $0x62,%eax
c01018db:	0f b7 00             	movzwl (%eax),%eax
c01018de:	0f b7 c0             	movzwl %ax,%eax
c01018e1:	25 00 02 00 00       	and    $0x200,%eax
c01018e6:	85 c0                	test   %eax,%eax
c01018e8:	75 24                	jne    c010190e <ide_init+0x1fb>
c01018ea:	c7 44 24 0c b0 8e 10 	movl   $0xc0108eb0,0xc(%esp)
c01018f1:	c0 
c01018f2:	c7 44 24 08 f3 8e 10 	movl   $0xc0108ef3,0x8(%esp)
c01018f9:	c0 
c01018fa:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101901:	00 
c0101902:	c7 04 24 08 8f 10 c0 	movl   $0xc0108f08,(%esp)
c0101909:	e8 ce f3 ff ff       	call   c0100cdc <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010190e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101912:	c1 e0 03             	shl    $0x3,%eax
c0101915:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010191c:	29 c2                	sub    %eax,%edx
c010191e:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101924:	83 c0 0c             	add    $0xc,%eax
c0101927:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010192a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010192d:	83 c0 36             	add    $0x36,%eax
c0101930:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101933:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010193a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101941:	eb 34                	jmp    c0101977 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101943:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101946:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101949:	01 c2                	add    %eax,%edx
c010194b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010194e:	8d 48 01             	lea    0x1(%eax),%ecx
c0101951:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101954:	01 c8                	add    %ecx,%eax
c0101956:	0f b6 00             	movzbl (%eax),%eax
c0101959:	88 02                	mov    %al,(%edx)
c010195b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195e:	8d 50 01             	lea    0x1(%eax),%edx
c0101961:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101964:	01 c2                	add    %eax,%edx
c0101966:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101969:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010196c:	01 c8                	add    %ecx,%eax
c010196e:	0f b6 00             	movzbl (%eax),%eax
c0101971:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101973:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010197d:	72 c4                	jb     c0101943 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c010197f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101982:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101985:	01 d0                	add    %edx,%eax
c0101987:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010198a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101990:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101993:	85 c0                	test   %eax,%eax
c0101995:	74 0f                	je     c01019a6 <ide_init+0x293>
c0101997:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010199a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199d:	01 d0                	add    %edx,%eax
c010199f:	0f b6 00             	movzbl (%eax),%eax
c01019a2:	3c 20                	cmp    $0x20,%al
c01019a4:	74 d9                	je     c010197f <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019aa:	c1 e0 03             	shl    $0x3,%eax
c01019ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019b4:	29 c2                	sub    %eax,%edx
c01019b6:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c01019bc:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019bf:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c3:	c1 e0 03             	shl    $0x3,%eax
c01019c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019cd:	29 c2                	sub    %eax,%edx
c01019cf:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c01019d5:	8b 50 08             	mov    0x8(%eax),%edx
c01019d8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019dc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e8:	c7 04 24 1a 8f 10 c0 	movl   $0xc0108f1a,(%esp)
c01019ef:	e8 57 e9 ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019f4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f8:	83 c0 01             	add    $0x1,%eax
c01019fb:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019ff:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a04:	0f 86 1f fd ff ff    	jbe    c0101729 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a0a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a11:	e8 7c 05 00 00       	call   c0101f92 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a16:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a1d:	e8 70 05 00 00       	call   c0101f92 <pic_enable>
}
c0101a22:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a28:	5b                   	pop    %ebx
c0101a29:	5f                   	pop    %edi
c0101a2a:	5d                   	pop    %ebp
c0101a2b:	c3                   	ret    

c0101a2c <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a2c:	55                   	push   %ebp
c0101a2d:	89 e5                	mov    %esp,%ebp
c0101a2f:	83 ec 04             	sub    $0x4,%esp
c0101a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a35:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a39:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a3e:	77 24                	ja     c0101a64 <ide_device_valid+0x38>
c0101a40:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a44:	c1 e0 03             	shl    $0x3,%eax
c0101a47:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a4e:	29 c2                	sub    %eax,%edx
c0101a50:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101a56:	0f b6 00             	movzbl (%eax),%eax
c0101a59:	84 c0                	test   %al,%al
c0101a5b:	74 07                	je     c0101a64 <ide_device_valid+0x38>
c0101a5d:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a62:	eb 05                	jmp    c0101a69 <ide_device_valid+0x3d>
c0101a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a69:	c9                   	leave  
c0101a6a:	c3                   	ret    

c0101a6b <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a6b:	55                   	push   %ebp
c0101a6c:	89 e5                	mov    %esp,%ebp
c0101a6e:	83 ec 08             	sub    $0x8,%esp
c0101a71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a78:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a7c:	89 04 24             	mov    %eax,(%esp)
c0101a7f:	e8 a8 ff ff ff       	call   c0101a2c <ide_device_valid>
c0101a84:	85 c0                	test   %eax,%eax
c0101a86:	74 1b                	je     c0101aa3 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a88:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a8c:	c1 e0 03             	shl    $0x3,%eax
c0101a8f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a96:	29 c2                	sub    %eax,%edx
c0101a98:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101a9e:	8b 40 08             	mov    0x8(%eax),%eax
c0101aa1:	eb 05                	jmp    c0101aa8 <ide_device_size+0x3d>
    }
    return 0;
c0101aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa8:	c9                   	leave  
c0101aa9:	c3                   	ret    

c0101aaa <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aaa:	55                   	push   %ebp
c0101aab:	89 e5                	mov    %esp,%ebp
c0101aad:	57                   	push   %edi
c0101aae:	53                   	push   %ebx
c0101aaf:	83 ec 50             	sub    $0x50,%esp
c0101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab5:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ab9:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ac0:	77 24                	ja     c0101ae6 <ide_read_secs+0x3c>
c0101ac2:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac7:	77 1d                	ja     c0101ae6 <ide_read_secs+0x3c>
c0101ac9:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101acd:	c1 e0 03             	shl    $0x3,%eax
c0101ad0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad7:	29 c2                	sub    %eax,%edx
c0101ad9:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101adf:	0f b6 00             	movzbl (%eax),%eax
c0101ae2:	84 c0                	test   %al,%al
c0101ae4:	75 24                	jne    c0101b0a <ide_read_secs+0x60>
c0101ae6:	c7 44 24 0c 38 8f 10 	movl   $0xc0108f38,0xc(%esp)
c0101aed:	c0 
c0101aee:	c7 44 24 08 f3 8e 10 	movl   $0xc0108ef3,0x8(%esp)
c0101af5:	c0 
c0101af6:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101afd:	00 
c0101afe:	c7 04 24 08 8f 10 c0 	movl   $0xc0108f08,(%esp)
c0101b05:	e8 d2 f1 ff ff       	call   c0100cdc <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b0a:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b11:	77 0f                	ja     c0101b22 <ide_read_secs+0x78>
c0101b13:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b16:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b19:	01 d0                	add    %edx,%eax
c0101b1b:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b20:	76 24                	jbe    c0101b46 <ide_read_secs+0x9c>
c0101b22:	c7 44 24 0c 60 8f 10 	movl   $0xc0108f60,0xc(%esp)
c0101b29:	c0 
c0101b2a:	c7 44 24 08 f3 8e 10 	movl   $0xc0108ef3,0x8(%esp)
c0101b31:	c0 
c0101b32:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b39:	00 
c0101b3a:	c7 04 24 08 8f 10 c0 	movl   $0xc0108f08,(%esp)
c0101b41:	e8 96 f1 ff ff       	call   c0100cdc <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b46:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b4a:	66 d1 e8             	shr    %ax
c0101b4d:	0f b7 c0             	movzwl %ax,%eax
c0101b50:	0f b7 04 85 a8 8e 10 	movzwl -0x3fef7158(,%eax,4),%eax
c0101b57:	c0 
c0101b58:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b5c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b60:	66 d1 e8             	shr    %ax
c0101b63:	0f b7 c0             	movzwl %ax,%eax
c0101b66:	0f b7 04 85 aa 8e 10 	movzwl -0x3fef7156(,%eax,4),%eax
c0101b6d:	c0 
c0101b6e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b7d:	00 
c0101b7e:	89 04 24             	mov    %eax,(%esp)
c0101b81:	e8 33 fb ff ff       	call   c01016b9 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b86:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b8a:	83 c0 02             	add    $0x2,%eax
c0101b8d:	0f b7 c0             	movzwl %ax,%eax
c0101b90:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b94:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ba0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ba1:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ba4:	0f b6 c0             	movzbl %al,%eax
c0101ba7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bab:	83 c2 02             	add    $0x2,%edx
c0101bae:	0f b7 d2             	movzwl %dx,%edx
c0101bb1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bb5:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bbc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bc0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bc4:	0f b6 c0             	movzbl %al,%eax
c0101bc7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bcb:	83 c2 03             	add    $0x3,%edx
c0101bce:	0f b7 d2             	movzwl %dx,%edx
c0101bd1:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bd5:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bdc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101be0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101be1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be4:	c1 e8 08             	shr    $0x8,%eax
c0101be7:	0f b6 c0             	movzbl %al,%eax
c0101bea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bee:	83 c2 04             	add    $0x4,%edx
c0101bf1:	0f b7 d2             	movzwl %dx,%edx
c0101bf4:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf8:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bfb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bff:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c03:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c07:	c1 e8 10             	shr    $0x10,%eax
c0101c0a:	0f b6 c0             	movzbl %al,%eax
c0101c0d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c11:	83 c2 05             	add    $0x5,%edx
c0101c14:	0f b7 d2             	movzwl %dx,%edx
c0101c17:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c1b:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c1e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c22:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c26:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c27:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c2b:	83 e0 01             	and    $0x1,%eax
c0101c2e:	c1 e0 04             	shl    $0x4,%eax
c0101c31:	89 c2                	mov    %eax,%edx
c0101c33:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c36:	c1 e8 18             	shr    $0x18,%eax
c0101c39:	83 e0 0f             	and    $0xf,%eax
c0101c3c:	09 d0                	or     %edx,%eax
c0101c3e:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c41:	0f b6 c0             	movzbl %al,%eax
c0101c44:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c48:	83 c2 06             	add    $0x6,%edx
c0101c4b:	0f b7 d2             	movzwl %dx,%edx
c0101c4e:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c52:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c55:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c59:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c5d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c62:	83 c0 07             	add    $0x7,%eax
c0101c65:	0f b7 c0             	movzwl %ax,%eax
c0101c68:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c6c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c70:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c74:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c78:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c80:	eb 5a                	jmp    c0101cdc <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c82:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c86:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c8d:	00 
c0101c8e:	89 04 24             	mov    %eax,(%esp)
c0101c91:	e8 23 fa ff ff       	call   c01016b9 <ide_wait_ready>
c0101c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c9d:	74 02                	je     c0101ca1 <ide_read_secs+0x1f7>
            goto out;
c0101c9f:	eb 41                	jmp    c0101ce2 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101ca1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca8:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cab:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101cae:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cb5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb8:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cbb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cbe:	89 cb                	mov    %ecx,%ebx
c0101cc0:	89 df                	mov    %ebx,%edi
c0101cc2:	89 c1                	mov    %eax,%ecx
c0101cc4:	fc                   	cld    
c0101cc5:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc7:	89 c8                	mov    %ecx,%eax
c0101cc9:	89 fb                	mov    %edi,%ebx
c0101ccb:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cd1:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cd5:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cdc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101ce0:	75 a0                	jne    c0101c82 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ce5:	83 c4 50             	add    $0x50,%esp
c0101ce8:	5b                   	pop    %ebx
c0101ce9:	5f                   	pop    %edi
c0101cea:	5d                   	pop    %ebp
c0101ceb:	c3                   	ret    

c0101cec <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101cec:	55                   	push   %ebp
c0101ced:	89 e5                	mov    %esp,%ebp
c0101cef:	56                   	push   %esi
c0101cf0:	53                   	push   %ebx
c0101cf1:	83 ec 50             	sub    $0x50,%esp
c0101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf7:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cfb:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d02:	77 24                	ja     c0101d28 <ide_write_secs+0x3c>
c0101d04:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d09:	77 1d                	ja     c0101d28 <ide_write_secs+0x3c>
c0101d0b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d0f:	c1 e0 03             	shl    $0x3,%eax
c0101d12:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d19:	29 c2                	sub    %eax,%edx
c0101d1b:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101d21:	0f b6 00             	movzbl (%eax),%eax
c0101d24:	84 c0                	test   %al,%al
c0101d26:	75 24                	jne    c0101d4c <ide_write_secs+0x60>
c0101d28:	c7 44 24 0c 38 8f 10 	movl   $0xc0108f38,0xc(%esp)
c0101d2f:	c0 
c0101d30:	c7 44 24 08 f3 8e 10 	movl   $0xc0108ef3,0x8(%esp)
c0101d37:	c0 
c0101d38:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d3f:	00 
c0101d40:	c7 04 24 08 8f 10 c0 	movl   $0xc0108f08,(%esp)
c0101d47:	e8 90 ef ff ff       	call   c0100cdc <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d4c:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d53:	77 0f                	ja     c0101d64 <ide_write_secs+0x78>
c0101d55:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d58:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d5b:	01 d0                	add    %edx,%eax
c0101d5d:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d62:	76 24                	jbe    c0101d88 <ide_write_secs+0x9c>
c0101d64:	c7 44 24 0c 60 8f 10 	movl   $0xc0108f60,0xc(%esp)
c0101d6b:	c0 
c0101d6c:	c7 44 24 08 f3 8e 10 	movl   $0xc0108ef3,0x8(%esp)
c0101d73:	c0 
c0101d74:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d7b:	00 
c0101d7c:	c7 04 24 08 8f 10 c0 	movl   $0xc0108f08,(%esp)
c0101d83:	e8 54 ef ff ff       	call   c0100cdc <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d88:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d8c:	66 d1 e8             	shr    %ax
c0101d8f:	0f b7 c0             	movzwl %ax,%eax
c0101d92:	0f b7 04 85 a8 8e 10 	movzwl -0x3fef7158(,%eax,4),%eax
c0101d99:	c0 
c0101d9a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d9e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da2:	66 d1 e8             	shr    %ax
c0101da5:	0f b7 c0             	movzwl %ax,%eax
c0101da8:	0f b7 04 85 aa 8e 10 	movzwl -0x3fef7156(,%eax,4),%eax
c0101daf:	c0 
c0101db0:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101db4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dbf:	00 
c0101dc0:	89 04 24             	mov    %eax,(%esp)
c0101dc3:	e8 f1 f8 ff ff       	call   c01016b9 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dcc:	83 c0 02             	add    $0x2,%eax
c0101dcf:	0f b7 c0             	movzwl %ax,%eax
c0101dd2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dd6:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dda:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dde:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101de2:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101de3:	8b 45 14             	mov    0x14(%ebp),%eax
c0101de6:	0f b6 c0             	movzbl %al,%eax
c0101de9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ded:	83 c2 02             	add    $0x2,%edx
c0101df0:	0f b7 d2             	movzwl %dx,%edx
c0101df3:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df7:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101dfa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dfe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e02:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e06:	0f b6 c0             	movzbl %al,%eax
c0101e09:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e0d:	83 c2 03             	add    $0x3,%edx
c0101e10:	0f b7 d2             	movzwl %dx,%edx
c0101e13:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e17:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e1a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e1e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e22:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e26:	c1 e8 08             	shr    $0x8,%eax
c0101e29:	0f b6 c0             	movzbl %al,%eax
c0101e2c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e30:	83 c2 04             	add    $0x4,%edx
c0101e33:	0f b7 d2             	movzwl %dx,%edx
c0101e36:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e3a:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e3d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e41:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e45:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e49:	c1 e8 10             	shr    $0x10,%eax
c0101e4c:	0f b6 c0             	movzbl %al,%eax
c0101e4f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e53:	83 c2 05             	add    $0x5,%edx
c0101e56:	0f b7 d2             	movzwl %dx,%edx
c0101e59:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e5d:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e60:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e64:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e68:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e69:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e6d:	83 e0 01             	and    $0x1,%eax
c0101e70:	c1 e0 04             	shl    $0x4,%eax
c0101e73:	89 c2                	mov    %eax,%edx
c0101e75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e78:	c1 e8 18             	shr    $0x18,%eax
c0101e7b:	83 e0 0f             	and    $0xf,%eax
c0101e7e:	09 d0                	or     %edx,%eax
c0101e80:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e83:	0f b6 c0             	movzbl %al,%eax
c0101e86:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e8a:	83 c2 06             	add    $0x6,%edx
c0101e8d:	0f b7 d2             	movzwl %dx,%edx
c0101e90:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e94:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e97:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e9b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e9f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ea0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ea4:	83 c0 07             	add    $0x7,%eax
c0101ea7:	0f b7 c0             	movzwl %ax,%eax
c0101eaa:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101eae:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eb2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eb6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101eba:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ebb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ec2:	eb 5a                	jmp    c0101f1e <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ec4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ecf:	00 
c0101ed0:	89 04 24             	mov    %eax,(%esp)
c0101ed3:	e8 e1 f7 ff ff       	call   c01016b9 <ide_wait_ready>
c0101ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101edf:	74 02                	je     c0101ee3 <ide_write_secs+0x1f7>
            goto out;
c0101ee1:	eb 41                	jmp    c0101f24 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ee3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101eea:	8b 45 10             	mov    0x10(%ebp),%eax
c0101eed:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ef0:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101efa:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101efd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f00:	89 cb                	mov    %ecx,%ebx
c0101f02:	89 de                	mov    %ebx,%esi
c0101f04:	89 c1                	mov    %eax,%ecx
c0101f06:	fc                   	cld    
c0101f07:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f09:	89 c8                	mov    %ecx,%eax
c0101f0b:	89 f3                	mov    %esi,%ebx
c0101f0d:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f10:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f13:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f17:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f1e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f22:	75 a0                	jne    c0101ec4 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f27:	83 c4 50             	add    $0x50,%esp
c0101f2a:	5b                   	pop    %ebx
c0101f2b:	5e                   	pop    %esi
c0101f2c:	5d                   	pop    %ebp
c0101f2d:	c3                   	ret    

c0101f2e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f2e:	55                   	push   %ebp
c0101f2f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f31:	fb                   	sti    
    sti();
}
c0101f32:	5d                   	pop    %ebp
c0101f33:	c3                   	ret    

c0101f34 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f34:	55                   	push   %ebp
c0101f35:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f37:	fa                   	cli    
    cli();
}
c0101f38:	5d                   	pop    %ebp
c0101f39:	c3                   	ret    

c0101f3a <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f3a:	55                   	push   %ebp
c0101f3b:	89 e5                	mov    %esp,%ebp
c0101f3d:	83 ec 14             	sub    $0x14,%esp
c0101f40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f43:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f47:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f4b:	66 a3 70 f5 11 c0    	mov    %ax,0xc011f570
    if (did_init) {
c0101f51:	a1 e0 01 12 c0       	mov    0xc01201e0,%eax
c0101f56:	85 c0                	test   %eax,%eax
c0101f58:	74 36                	je     c0101f90 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f5a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f5e:	0f b6 c0             	movzbl %al,%eax
c0101f61:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f67:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f6a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f6e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f72:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f73:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f77:	66 c1 e8 08          	shr    $0x8,%ax
c0101f7b:	0f b6 c0             	movzbl %al,%eax
c0101f7e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f84:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f87:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f8b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f8f:	ee                   	out    %al,(%dx)
    }
}
c0101f90:	c9                   	leave  
c0101f91:	c3                   	ret    

c0101f92 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f92:	55                   	push   %ebp
c0101f93:	89 e5                	mov    %esp,%ebp
c0101f95:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fa0:	89 c1                	mov    %eax,%ecx
c0101fa2:	d3 e2                	shl    %cl,%edx
c0101fa4:	89 d0                	mov    %edx,%eax
c0101fa6:	f7 d0                	not    %eax
c0101fa8:	89 c2                	mov    %eax,%edx
c0101faa:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c0101fb1:	21 d0                	and    %edx,%eax
c0101fb3:	0f b7 c0             	movzwl %ax,%eax
c0101fb6:	89 04 24             	mov    %eax,(%esp)
c0101fb9:	e8 7c ff ff ff       	call   c0101f3a <pic_setmask>
}
c0101fbe:	c9                   	leave  
c0101fbf:	c3                   	ret    

c0101fc0 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fc0:	55                   	push   %ebp
c0101fc1:	89 e5                	mov    %esp,%ebp
c0101fc3:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fc6:	c7 05 e0 01 12 c0 01 	movl   $0x1,0xc01201e0
c0101fcd:	00 00 00 
c0101fd0:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fd6:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fda:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fde:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fe2:	ee                   	out    %al,(%dx)
c0101fe3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fe9:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ff1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff5:	ee                   	out    %al,(%dx)
c0101ff6:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ffc:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102000:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102004:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102008:	ee                   	out    %al,(%dx)
c0102009:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010200f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102013:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102017:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010201b:	ee                   	out    %al,(%dx)
c010201c:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102022:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102026:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010202a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010202e:	ee                   	out    %al,(%dx)
c010202f:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102035:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102039:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010203d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102041:	ee                   	out    %al,(%dx)
c0102042:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102048:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010204c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102050:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102054:	ee                   	out    %al,(%dx)
c0102055:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010205b:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010205f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102063:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102067:	ee                   	out    %al,(%dx)
c0102068:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010206e:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102072:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102076:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010207a:	ee                   	out    %al,(%dx)
c010207b:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102081:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102085:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102089:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010208d:	ee                   	out    %al,(%dx)
c010208e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102094:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102098:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010209c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020a0:	ee                   	out    %al,(%dx)
c01020a1:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a7:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020ab:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020af:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020b3:	ee                   	out    %al,(%dx)
c01020b4:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020ba:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020be:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020c2:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020c6:	ee                   	out    %al,(%dx)
c01020c7:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020cd:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020d1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020d5:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020d9:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020da:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c01020e1:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020e5:	74 12                	je     c01020f9 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e7:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c01020ee:	0f b7 c0             	movzwl %ax,%eax
c01020f1:	89 04 24             	mov    %eax,(%esp)
c01020f4:	e8 41 fe ff ff       	call   c0101f3a <pic_setmask>
    }
}
c01020f9:	c9                   	leave  
c01020fa:	c3                   	ret    

c01020fb <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020fb:	55                   	push   %ebp
c01020fc:	89 e5                	mov    %esp,%ebp
c01020fe:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102101:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102108:	00 
c0102109:	c7 04 24 a0 8f 10 c0 	movl   $0xc0108fa0,(%esp)
c0102110:	e8 36 e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102115:	c9                   	leave  
c0102116:	c3                   	ret    

c0102117 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102117:	55                   	push   %ebp
c0102118:	89 e5                	mov    %esp,%ebp
c010211a:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */

	extern uintptr_t __vectors[];
	int i = 0;
c010211d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < 256; i ++)
c0102124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010212b:	e9 94 01 00 00       	jmp    c01022c4 <idt_init+0x1ad>
	{
		if(i != T_SYSCALL)
c0102130:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c0102137:	0f 84 c4 00 00 00    	je     c0102201 <idt_init+0xea>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010213d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102140:	8b 04 85 00 f6 11 c0 	mov    -0x3fee0a00(,%eax,4),%eax
c0102147:	89 c2                	mov    %eax,%edx
c0102149:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010214c:	66 89 14 c5 00 02 12 	mov    %dx,-0x3fedfe00(,%eax,8)
c0102153:	c0 
c0102154:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102157:	66 c7 04 c5 02 02 12 	movw   $0x8,-0x3fedfdfe(,%eax,8)
c010215e:	c0 08 00 
c0102161:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102164:	0f b6 14 c5 04 02 12 	movzbl -0x3fedfdfc(,%eax,8),%edx
c010216b:	c0 
c010216c:	83 e2 e0             	and    $0xffffffe0,%edx
c010216f:	88 14 c5 04 02 12 c0 	mov    %dl,-0x3fedfdfc(,%eax,8)
c0102176:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102179:	0f b6 14 c5 04 02 12 	movzbl -0x3fedfdfc(,%eax,8),%edx
c0102180:	c0 
c0102181:	83 e2 1f             	and    $0x1f,%edx
c0102184:	88 14 c5 04 02 12 c0 	mov    %dl,-0x3fedfdfc(,%eax,8)
c010218b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218e:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c0102195:	c0 
c0102196:	83 e2 f0             	and    $0xfffffff0,%edx
c0102199:	83 ca 0e             	or     $0xe,%edx
c010219c:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01021a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a6:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c01021ad:	c0 
c01021ae:	83 e2 ef             	and    $0xffffffef,%edx
c01021b1:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01021b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bb:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c01021c2:	c0 
c01021c3:	83 e2 9f             	and    $0xffffff9f,%edx
c01021c6:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01021cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d0:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c01021d7:	c0 
c01021d8:	83 ca 80             	or     $0xffffff80,%edx
c01021db:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01021e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e5:	8b 04 85 00 f6 11 c0 	mov    -0x3fee0a00(,%eax,4),%eax
c01021ec:	c1 e8 10             	shr    $0x10,%eax
c01021ef:	89 c2                	mov    %eax,%edx
c01021f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f4:	66 89 14 c5 06 02 12 	mov    %dx,-0x3fedfdfa(,%eax,8)
c01021fb:	c0 
c01021fc:	e9 bf 00 00 00       	jmp    c01022c0 <idt_init+0x1a9>
		}
		else
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
c0102201:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102204:	8b 04 85 00 f6 11 c0 	mov    -0x3fee0a00(,%eax,4),%eax
c010220b:	89 c2                	mov    %eax,%edx
c010220d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102210:	66 89 14 c5 00 02 12 	mov    %dx,-0x3fedfe00(,%eax,8)
c0102217:	c0 
c0102218:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010221b:	66 c7 04 c5 02 02 12 	movw   $0x8,-0x3fedfdfe(,%eax,8)
c0102222:	c0 08 00 
c0102225:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102228:	0f b6 14 c5 04 02 12 	movzbl -0x3fedfdfc(,%eax,8),%edx
c010222f:	c0 
c0102230:	83 e2 e0             	and    $0xffffffe0,%edx
c0102233:	88 14 c5 04 02 12 c0 	mov    %dl,-0x3fedfdfc(,%eax,8)
c010223a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010223d:	0f b6 14 c5 04 02 12 	movzbl -0x3fedfdfc(,%eax,8),%edx
c0102244:	c0 
c0102245:	83 e2 1f             	and    $0x1f,%edx
c0102248:	88 14 c5 04 02 12 c0 	mov    %dl,-0x3fedfdfc(,%eax,8)
c010224f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102252:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c0102259:	c0 
c010225a:	83 e2 f0             	and    $0xfffffff0,%edx
c010225d:	83 ca 0e             	or     $0xe,%edx
c0102260:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c0102267:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010226a:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c0102271:	c0 
c0102272:	83 e2 ef             	and    $0xffffffef,%edx
c0102275:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c010227c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010227f:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c0102286:	c0 
c0102287:	83 ca 60             	or     $0x60,%edx
c010228a:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c0102291:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102294:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c010229b:	c0 
c010229c:	83 ca 80             	or     $0xffffff80,%edx
c010229f:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01022a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022a9:	8b 04 85 00 f6 11 c0 	mov    -0x3fee0a00(,%eax,4),%eax
c01022b0:	c1 e8 10             	shr    $0x10,%eax
c01022b3:	89 c2                	mov    %eax,%edx
c01022b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b8:	66 89 14 c5 06 02 12 	mov    %dx,-0x3fedfdfa(,%eax,8)
c01022bf:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */

	extern uintptr_t __vectors[];
	int i = 0;
	for(i = 0; i < 256; i ++)
c01022c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01022c4:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01022cb:	0f 8e 5f fe ff ff    	jle    c0102130 <idt_init+0x19>
c01022d1:	c7 45 f8 80 f5 11 c0 	movl   $0xc011f580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01022d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022db:	0f 01 18             	lidtl  (%eax)
		}
	}

	lidt(&idt_pd);

	return;
c01022de:	90                   	nop
}
c01022df:	c9                   	leave  
c01022e0:	c3                   	ret    

c01022e1 <trapname>:

static const char *
trapname(int trapno) {
c01022e1:	55                   	push   %ebp
c01022e2:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01022e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e7:	83 f8 13             	cmp    $0x13,%eax
c01022ea:	77 0c                	ja     c01022f8 <trapname+0x17>
        return excnames[trapno];
c01022ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ef:	8b 04 85 80 93 10 c0 	mov    -0x3fef6c80(,%eax,4),%eax
c01022f6:	eb 18                	jmp    c0102310 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022f8:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022fc:	7e 0d                	jle    c010230b <trapname+0x2a>
c01022fe:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102302:	7f 07                	jg     c010230b <trapname+0x2a>
        return "Hardware Interrupt";
c0102304:	b8 aa 8f 10 c0       	mov    $0xc0108faa,%eax
c0102309:	eb 05                	jmp    c0102310 <trapname+0x2f>
    }
    return "(unknown trap)";
c010230b:	b8 bd 8f 10 c0       	mov    $0xc0108fbd,%eax
}
c0102310:	5d                   	pop    %ebp
c0102311:	c3                   	ret    

c0102312 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102312:	55                   	push   %ebp
c0102313:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102315:	8b 45 08             	mov    0x8(%ebp),%eax
c0102318:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010231c:	66 83 f8 08          	cmp    $0x8,%ax
c0102320:	0f 94 c0             	sete   %al
c0102323:	0f b6 c0             	movzbl %al,%eax
}
c0102326:	5d                   	pop    %ebp
c0102327:	c3                   	ret    

c0102328 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102328:	55                   	push   %ebp
c0102329:	89 e5                	mov    %esp,%ebp
c010232b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010232e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102331:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102335:	c7 04 24 fe 8f 10 c0 	movl   $0xc0108ffe,(%esp)
c010233c:	e8 0a e0 ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c0102341:	8b 45 08             	mov    0x8(%ebp),%eax
c0102344:	89 04 24             	mov    %eax,(%esp)
c0102347:	e8 a1 01 00 00       	call   c01024ed <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010234c:	8b 45 08             	mov    0x8(%ebp),%eax
c010234f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102353:	0f b7 c0             	movzwl %ax,%eax
c0102356:	89 44 24 04          	mov    %eax,0x4(%esp)
c010235a:	c7 04 24 0f 90 10 c0 	movl   $0xc010900f,(%esp)
c0102361:	e8 e5 df ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102366:	8b 45 08             	mov    0x8(%ebp),%eax
c0102369:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010236d:	0f b7 c0             	movzwl %ax,%eax
c0102370:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102374:	c7 04 24 22 90 10 c0 	movl   $0xc0109022,(%esp)
c010237b:	e8 cb df ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102380:	8b 45 08             	mov    0x8(%ebp),%eax
c0102383:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102387:	0f b7 c0             	movzwl %ax,%eax
c010238a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010238e:	c7 04 24 35 90 10 c0 	movl   $0xc0109035,(%esp)
c0102395:	e8 b1 df ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010239a:	8b 45 08             	mov    0x8(%ebp),%eax
c010239d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01023a1:	0f b7 c0             	movzwl %ax,%eax
c01023a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023a8:	c7 04 24 48 90 10 c0 	movl   $0xc0109048,(%esp)
c01023af:	e8 97 df ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01023b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b7:	8b 40 30             	mov    0x30(%eax),%eax
c01023ba:	89 04 24             	mov    %eax,(%esp)
c01023bd:	e8 1f ff ff ff       	call   c01022e1 <trapname>
c01023c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01023c5:	8b 52 30             	mov    0x30(%edx),%edx
c01023c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01023cc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01023d0:	c7 04 24 5b 90 10 c0 	movl   $0xc010905b,(%esp)
c01023d7:	e8 6f df ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01023dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01023df:	8b 40 34             	mov    0x34(%eax),%eax
c01023e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e6:	c7 04 24 6d 90 10 c0 	movl   $0xc010906d,(%esp)
c01023ed:	e8 59 df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f5:	8b 40 38             	mov    0x38(%eax),%eax
c01023f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023fc:	c7 04 24 7c 90 10 c0 	movl   $0xc010907c,(%esp)
c0102403:	e8 43 df ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102408:	8b 45 08             	mov    0x8(%ebp),%eax
c010240b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010240f:	0f b7 c0             	movzwl %ax,%eax
c0102412:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102416:	c7 04 24 8b 90 10 c0 	movl   $0xc010908b,(%esp)
c010241d:	e8 29 df ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102422:	8b 45 08             	mov    0x8(%ebp),%eax
c0102425:	8b 40 40             	mov    0x40(%eax),%eax
c0102428:	89 44 24 04          	mov    %eax,0x4(%esp)
c010242c:	c7 04 24 9e 90 10 c0 	movl   $0xc010909e,(%esp)
c0102433:	e8 13 df ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010243f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102446:	eb 3e                	jmp    c0102486 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102448:	8b 45 08             	mov    0x8(%ebp),%eax
c010244b:	8b 50 40             	mov    0x40(%eax),%edx
c010244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102451:	21 d0                	and    %edx,%eax
c0102453:	85 c0                	test   %eax,%eax
c0102455:	74 28                	je     c010247f <print_trapframe+0x157>
c0102457:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010245a:	8b 04 85 a0 f5 11 c0 	mov    -0x3fee0a60(,%eax,4),%eax
c0102461:	85 c0                	test   %eax,%eax
c0102463:	74 1a                	je     c010247f <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102465:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102468:	8b 04 85 a0 f5 11 c0 	mov    -0x3fee0a60(,%eax,4),%eax
c010246f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102473:	c7 04 24 ad 90 10 c0 	movl   $0xc01090ad,(%esp)
c010247a:	e8 cc de ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010247f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102483:	d1 65 f0             	shll   -0x10(%ebp)
c0102486:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102489:	83 f8 17             	cmp    $0x17,%eax
c010248c:	76 ba                	jbe    c0102448 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010248e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102491:	8b 40 40             	mov    0x40(%eax),%eax
c0102494:	25 00 30 00 00       	and    $0x3000,%eax
c0102499:	c1 e8 0c             	shr    $0xc,%eax
c010249c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a0:	c7 04 24 b1 90 10 c0 	movl   $0xc01090b1,(%esp)
c01024a7:	e8 9f de ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c01024ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01024af:	89 04 24             	mov    %eax,(%esp)
c01024b2:	e8 5b fe ff ff       	call   c0102312 <trap_in_kernel>
c01024b7:	85 c0                	test   %eax,%eax
c01024b9:	75 30                	jne    c01024eb <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01024bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01024be:	8b 40 44             	mov    0x44(%eax),%eax
c01024c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024c5:	c7 04 24 ba 90 10 c0 	movl   $0xc01090ba,(%esp)
c01024cc:	e8 7a de ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01024d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01024d8:	0f b7 c0             	movzwl %ax,%eax
c01024db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024df:	c7 04 24 c9 90 10 c0 	movl   $0xc01090c9,(%esp)
c01024e6:	e8 60 de ff ff       	call   c010034b <cprintf>
    }
}
c01024eb:	c9                   	leave  
c01024ec:	c3                   	ret    

c01024ed <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024ed:	55                   	push   %ebp
c01024ee:	89 e5                	mov    %esp,%ebp
c01024f0:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f6:	8b 00                	mov    (%eax),%eax
c01024f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024fc:	c7 04 24 dc 90 10 c0 	movl   $0xc01090dc,(%esp)
c0102503:	e8 43 de ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102508:	8b 45 08             	mov    0x8(%ebp),%eax
c010250b:	8b 40 04             	mov    0x4(%eax),%eax
c010250e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102512:	c7 04 24 eb 90 10 c0 	movl   $0xc01090eb,(%esp)
c0102519:	e8 2d de ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010251e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102521:	8b 40 08             	mov    0x8(%eax),%eax
c0102524:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102528:	c7 04 24 fa 90 10 c0 	movl   $0xc01090fa,(%esp)
c010252f:	e8 17 de ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102534:	8b 45 08             	mov    0x8(%ebp),%eax
c0102537:	8b 40 0c             	mov    0xc(%eax),%eax
c010253a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010253e:	c7 04 24 09 91 10 c0 	movl   $0xc0109109,(%esp)
c0102545:	e8 01 de ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c010254a:	8b 45 08             	mov    0x8(%ebp),%eax
c010254d:	8b 40 10             	mov    0x10(%eax),%eax
c0102550:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102554:	c7 04 24 18 91 10 c0 	movl   $0xc0109118,(%esp)
c010255b:	e8 eb dd ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102560:	8b 45 08             	mov    0x8(%ebp),%eax
c0102563:	8b 40 14             	mov    0x14(%eax),%eax
c0102566:	89 44 24 04          	mov    %eax,0x4(%esp)
c010256a:	c7 04 24 27 91 10 c0 	movl   $0xc0109127,(%esp)
c0102571:	e8 d5 dd ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102576:	8b 45 08             	mov    0x8(%ebp),%eax
c0102579:	8b 40 18             	mov    0x18(%eax),%eax
c010257c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102580:	c7 04 24 36 91 10 c0 	movl   $0xc0109136,(%esp)
c0102587:	e8 bf dd ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010258c:	8b 45 08             	mov    0x8(%ebp),%eax
c010258f:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102592:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102596:	c7 04 24 45 91 10 c0 	movl   $0xc0109145,(%esp)
c010259d:	e8 a9 dd ff ff       	call   c010034b <cprintf>
}
c01025a2:	c9                   	leave  
c01025a3:	c3                   	ret    

c01025a4 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01025a4:	55                   	push   %ebp
c01025a5:	89 e5                	mov    %esp,%ebp
c01025a7:	53                   	push   %ebx
c01025a8:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01025ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ae:	8b 40 34             	mov    0x34(%eax),%eax
c01025b1:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025b4:	85 c0                	test   %eax,%eax
c01025b6:	74 07                	je     c01025bf <print_pgfault+0x1b>
c01025b8:	b9 54 91 10 c0       	mov    $0xc0109154,%ecx
c01025bd:	eb 05                	jmp    c01025c4 <print_pgfault+0x20>
c01025bf:	b9 65 91 10 c0       	mov    $0xc0109165,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c01025c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c7:	8b 40 34             	mov    0x34(%eax),%eax
c01025ca:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025cd:	85 c0                	test   %eax,%eax
c01025cf:	74 07                	je     c01025d8 <print_pgfault+0x34>
c01025d1:	ba 57 00 00 00       	mov    $0x57,%edx
c01025d6:	eb 05                	jmp    c01025dd <print_pgfault+0x39>
c01025d8:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c01025dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01025e0:	8b 40 34             	mov    0x34(%eax),%eax
c01025e3:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025e6:	85 c0                	test   %eax,%eax
c01025e8:	74 07                	je     c01025f1 <print_pgfault+0x4d>
c01025ea:	b8 55 00 00 00       	mov    $0x55,%eax
c01025ef:	eb 05                	jmp    c01025f6 <print_pgfault+0x52>
c01025f1:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025f6:	0f 20 d3             	mov    %cr2,%ebx
c01025f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01025fc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01025ff:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102603:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102607:	89 44 24 08          	mov    %eax,0x8(%esp)
c010260b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010260f:	c7 04 24 74 91 10 c0 	movl   $0xc0109174,(%esp)
c0102616:	e8 30 dd ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c010261b:	83 c4 34             	add    $0x34,%esp
c010261e:	5b                   	pop    %ebx
c010261f:	5d                   	pop    %ebp
c0102620:	c3                   	ret    

c0102621 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c0102621:	55                   	push   %ebp
c0102622:	89 e5                	mov    %esp,%ebp
c0102624:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102627:	8b 45 08             	mov    0x8(%ebp),%eax
c010262a:	89 04 24             	mov    %eax,(%esp)
c010262d:	e8 72 ff ff ff       	call   c01025a4 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102632:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0102637:	85 c0                	test   %eax,%eax
c0102639:	74 28                	je     c0102663 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010263b:	0f 20 d0             	mov    %cr2,%eax
c010263e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102641:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102644:	89 c1                	mov    %eax,%ecx
c0102646:	8b 45 08             	mov    0x8(%ebp),%eax
c0102649:	8b 50 34             	mov    0x34(%eax),%edx
c010264c:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0102651:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102655:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102659:	89 04 24             	mov    %eax,(%esp)
c010265c:	e8 55 55 00 00       	call   c0107bb6 <do_pgfault>
c0102661:	eb 1c                	jmp    c010267f <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c0102663:	c7 44 24 08 97 91 10 	movl   $0xc0109197,0x8(%esp)
c010266a:	c0 
c010266b:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102672:	00 
c0102673:	c7 04 24 ae 91 10 c0 	movl   $0xc01091ae,(%esp)
c010267a:	e8 5d e6 ff ff       	call   c0100cdc <__panic>
}
c010267f:	c9                   	leave  
c0102680:	c3                   	ret    

c0102681 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102681:	55                   	push   %ebp
c0102682:	89 e5                	mov    %esp,%ebp
c0102684:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102687:	8b 45 08             	mov    0x8(%ebp),%eax
c010268a:	8b 40 30             	mov    0x30(%eax),%eax
c010268d:	83 f8 24             	cmp    $0x24,%eax
c0102690:	0f 84 c2 00 00 00    	je     c0102758 <trap_dispatch+0xd7>
c0102696:	83 f8 24             	cmp    $0x24,%eax
c0102699:	77 18                	ja     c01026b3 <trap_dispatch+0x32>
c010269b:	83 f8 20             	cmp    $0x20,%eax
c010269e:	74 7d                	je     c010271d <trap_dispatch+0x9c>
c01026a0:	83 f8 21             	cmp    $0x21,%eax
c01026a3:	0f 84 d5 00 00 00    	je     c010277e <trap_dispatch+0xfd>
c01026a9:	83 f8 0e             	cmp    $0xe,%eax
c01026ac:	74 28                	je     c01026d6 <trap_dispatch+0x55>
c01026ae:	e9 0d 01 00 00       	jmp    c01027c0 <trap_dispatch+0x13f>
c01026b3:	83 f8 2e             	cmp    $0x2e,%eax
c01026b6:	0f 82 04 01 00 00    	jb     c01027c0 <trap_dispatch+0x13f>
c01026bc:	83 f8 2f             	cmp    $0x2f,%eax
c01026bf:	0f 86 33 01 00 00    	jbe    c01027f8 <trap_dispatch+0x177>
c01026c5:	83 e8 78             	sub    $0x78,%eax
c01026c8:	83 f8 01             	cmp    $0x1,%eax
c01026cb:	0f 87 ef 00 00 00    	ja     c01027c0 <trap_dispatch+0x13f>
c01026d1:	e9 ce 00 00 00       	jmp    c01027a4 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01026d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01026d9:	89 04 24             	mov    %eax,(%esp)
c01026dc:	e8 40 ff ff ff       	call   c0102621 <pgfault_handler>
c01026e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01026e8:	74 2e                	je     c0102718 <trap_dispatch+0x97>
            print_trapframe(tf);
c01026ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ed:	89 04 24             	mov    %eax,(%esp)
c01026f0:	e8 33 fc ff ff       	call   c0102328 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026fc:	c7 44 24 08 bf 91 10 	movl   $0xc01091bf,0x8(%esp)
c0102703:	c0 
c0102704:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c010270b:	00 
c010270c:	c7 04 24 ae 91 10 c0 	movl   $0xc01091ae,(%esp)
c0102713:	e8 c4 e5 ff ff       	call   c0100cdc <__panic>
        }
        break;
c0102718:	e9 dc 00 00 00       	jmp    c01027f9 <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks ++;
c010271d:	a1 bc 0a 12 c0       	mov    0xc0120abc,%eax
c0102722:	83 c0 01             	add    $0x1,%eax
c0102725:	a3 bc 0a 12 c0       	mov    %eax,0xc0120abc
		if(ticks % 100 == 0)
c010272a:	8b 0d bc 0a 12 c0    	mov    0xc0120abc,%ecx
c0102730:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102735:	89 c8                	mov    %ecx,%eax
c0102737:	f7 e2                	mul    %edx
c0102739:	89 d0                	mov    %edx,%eax
c010273b:	c1 e8 05             	shr    $0x5,%eax
c010273e:	6b c0 64             	imul   $0x64,%eax,%eax
c0102741:	29 c1                	sub    %eax,%ecx
c0102743:	89 c8                	mov    %ecx,%eax
c0102745:	85 c0                	test   %eax,%eax
c0102747:	75 0a                	jne    c0102753 <trap_dispatch+0xd2>
			print_ticks();
c0102749:	e8 ad f9 ff ff       	call   c01020fb <print_ticks>
		break;
c010274e:	e9 a6 00 00 00       	jmp    c01027f9 <trap_dispatch+0x178>
c0102753:	e9 a1 00 00 00       	jmp    c01027f9 <trap_dispatch+0x178>
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102758:	e8 ed ee ff ff       	call   c010164a <cons_getc>
c010275d:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102760:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102764:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102768:	89 54 24 08          	mov    %edx,0x8(%esp)
c010276c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102770:	c7 04 24 da 91 10 c0 	movl   $0xc01091da,(%esp)
c0102777:	e8 cf db ff ff       	call   c010034b <cprintf>
        break;
c010277c:	eb 7b                	jmp    c01027f9 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010277e:	e8 c7 ee ff ff       	call   c010164a <cons_getc>
c0102783:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102786:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010278a:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c010278e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102792:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102796:	c7 04 24 ec 91 10 c0 	movl   $0xc01091ec,(%esp)
c010279d:	e8 a9 db ff ff       	call   c010034b <cprintf>
        break;
c01027a2:	eb 55                	jmp    c01027f9 <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01027a4:	c7 44 24 08 fb 91 10 	movl   $0xc01091fb,0x8(%esp)
c01027ab:	c0 
c01027ac:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c01027b3:	00 
c01027b4:	c7 04 24 ae 91 10 c0 	movl   $0xc01091ae,(%esp)
c01027bb:	e8 1c e5 ff ff       	call   c0100cdc <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01027c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01027c7:	0f b7 c0             	movzwl %ax,%eax
c01027ca:	83 e0 03             	and    $0x3,%eax
c01027cd:	85 c0                	test   %eax,%eax
c01027cf:	75 28                	jne    c01027f9 <trap_dispatch+0x178>
            print_trapframe(tf);
c01027d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d4:	89 04 24             	mov    %eax,(%esp)
c01027d7:	e8 4c fb ff ff       	call   c0102328 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01027dc:	c7 44 24 08 0b 92 10 	movl   $0xc010920b,0x8(%esp)
c01027e3:	c0 
c01027e4:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01027eb:	00 
c01027ec:	c7 04 24 ae 91 10 c0 	movl   $0xc01091ae,(%esp)
c01027f3:	e8 e4 e4 ff ff       	call   c0100cdc <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c01027f8:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c01027f9:	c9                   	leave  
c01027fa:	c3                   	ret    

c01027fb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01027fb:	55                   	push   %ebp
c01027fc:	89 e5                	mov    %esp,%ebp
c01027fe:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102801:	8b 45 08             	mov    0x8(%ebp),%eax
c0102804:	89 04 24             	mov    %eax,(%esp)
c0102807:	e8 75 fe ff ff       	call   c0102681 <trap_dispatch>
}
c010280c:	c9                   	leave  
c010280d:	c3                   	ret    

c010280e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010280e:	1e                   	push   %ds
    pushl %es
c010280f:	06                   	push   %es
    pushl %fs
c0102810:	0f a0                	push   %fs
    pushl %gs
c0102812:	0f a8                	push   %gs
    pushal
c0102814:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102815:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010281a:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010281c:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010281e:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010281f:	e8 d7 ff ff ff       	call   c01027fb <trap>

    # pop the pushed stack pointer
    popl %esp
c0102824:	5c                   	pop    %esp

c0102825 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102825:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102826:	0f a9                	pop    %gs
    popl %fs
c0102828:	0f a1                	pop    %fs
    popl %es
c010282a:	07                   	pop    %es
    popl %ds
c010282b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010282c:	83 c4 08             	add    $0x8,%esp
    iret
c010282f:	cf                   	iret   

c0102830 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $0
c0102832:	6a 00                	push   $0x0
  jmp __alltraps
c0102834:	e9 d5 ff ff ff       	jmp    c010280e <__alltraps>

c0102839 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $1
c010283b:	6a 01                	push   $0x1
  jmp __alltraps
c010283d:	e9 cc ff ff ff       	jmp    c010280e <__alltraps>

c0102842 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $2
c0102844:	6a 02                	push   $0x2
  jmp __alltraps
c0102846:	e9 c3 ff ff ff       	jmp    c010280e <__alltraps>

c010284b <vector3>:
.globl vector3
vector3:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $3
c010284d:	6a 03                	push   $0x3
  jmp __alltraps
c010284f:	e9 ba ff ff ff       	jmp    c010280e <__alltraps>

c0102854 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $4
c0102856:	6a 04                	push   $0x4
  jmp __alltraps
c0102858:	e9 b1 ff ff ff       	jmp    c010280e <__alltraps>

c010285d <vector5>:
.globl vector5
vector5:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $5
c010285f:	6a 05                	push   $0x5
  jmp __alltraps
c0102861:	e9 a8 ff ff ff       	jmp    c010280e <__alltraps>

c0102866 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102866:	6a 00                	push   $0x0
  pushl $6
c0102868:	6a 06                	push   $0x6
  jmp __alltraps
c010286a:	e9 9f ff ff ff       	jmp    c010280e <__alltraps>

c010286f <vector7>:
.globl vector7
vector7:
  pushl $0
c010286f:	6a 00                	push   $0x0
  pushl $7
c0102871:	6a 07                	push   $0x7
  jmp __alltraps
c0102873:	e9 96 ff ff ff       	jmp    c010280e <__alltraps>

c0102878 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102878:	6a 08                	push   $0x8
  jmp __alltraps
c010287a:	e9 8f ff ff ff       	jmp    c010280e <__alltraps>

c010287f <vector9>:
.globl vector9
vector9:
  pushl $9
c010287f:	6a 09                	push   $0x9
  jmp __alltraps
c0102881:	e9 88 ff ff ff       	jmp    c010280e <__alltraps>

c0102886 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102886:	6a 0a                	push   $0xa
  jmp __alltraps
c0102888:	e9 81 ff ff ff       	jmp    c010280e <__alltraps>

c010288d <vector11>:
.globl vector11
vector11:
  pushl $11
c010288d:	6a 0b                	push   $0xb
  jmp __alltraps
c010288f:	e9 7a ff ff ff       	jmp    c010280e <__alltraps>

c0102894 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102894:	6a 0c                	push   $0xc
  jmp __alltraps
c0102896:	e9 73 ff ff ff       	jmp    c010280e <__alltraps>

c010289b <vector13>:
.globl vector13
vector13:
  pushl $13
c010289b:	6a 0d                	push   $0xd
  jmp __alltraps
c010289d:	e9 6c ff ff ff       	jmp    c010280e <__alltraps>

c01028a2 <vector14>:
.globl vector14
vector14:
  pushl $14
c01028a2:	6a 0e                	push   $0xe
  jmp __alltraps
c01028a4:	e9 65 ff ff ff       	jmp    c010280e <__alltraps>

c01028a9 <vector15>:
.globl vector15
vector15:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $15
c01028ab:	6a 0f                	push   $0xf
  jmp __alltraps
c01028ad:	e9 5c ff ff ff       	jmp    c010280e <__alltraps>

c01028b2 <vector16>:
.globl vector16
vector16:
  pushl $0
c01028b2:	6a 00                	push   $0x0
  pushl $16
c01028b4:	6a 10                	push   $0x10
  jmp __alltraps
c01028b6:	e9 53 ff ff ff       	jmp    c010280e <__alltraps>

c01028bb <vector17>:
.globl vector17
vector17:
  pushl $17
c01028bb:	6a 11                	push   $0x11
  jmp __alltraps
c01028bd:	e9 4c ff ff ff       	jmp    c010280e <__alltraps>

c01028c2 <vector18>:
.globl vector18
vector18:
  pushl $0
c01028c2:	6a 00                	push   $0x0
  pushl $18
c01028c4:	6a 12                	push   $0x12
  jmp __alltraps
c01028c6:	e9 43 ff ff ff       	jmp    c010280e <__alltraps>

c01028cb <vector19>:
.globl vector19
vector19:
  pushl $0
c01028cb:	6a 00                	push   $0x0
  pushl $19
c01028cd:	6a 13                	push   $0x13
  jmp __alltraps
c01028cf:	e9 3a ff ff ff       	jmp    c010280e <__alltraps>

c01028d4 <vector20>:
.globl vector20
vector20:
  pushl $0
c01028d4:	6a 00                	push   $0x0
  pushl $20
c01028d6:	6a 14                	push   $0x14
  jmp __alltraps
c01028d8:	e9 31 ff ff ff       	jmp    c010280e <__alltraps>

c01028dd <vector21>:
.globl vector21
vector21:
  pushl $0
c01028dd:	6a 00                	push   $0x0
  pushl $21
c01028df:	6a 15                	push   $0x15
  jmp __alltraps
c01028e1:	e9 28 ff ff ff       	jmp    c010280e <__alltraps>

c01028e6 <vector22>:
.globl vector22
vector22:
  pushl $0
c01028e6:	6a 00                	push   $0x0
  pushl $22
c01028e8:	6a 16                	push   $0x16
  jmp __alltraps
c01028ea:	e9 1f ff ff ff       	jmp    c010280e <__alltraps>

c01028ef <vector23>:
.globl vector23
vector23:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $23
c01028f1:	6a 17                	push   $0x17
  jmp __alltraps
c01028f3:	e9 16 ff ff ff       	jmp    c010280e <__alltraps>

c01028f8 <vector24>:
.globl vector24
vector24:
  pushl $0
c01028f8:	6a 00                	push   $0x0
  pushl $24
c01028fa:	6a 18                	push   $0x18
  jmp __alltraps
c01028fc:	e9 0d ff ff ff       	jmp    c010280e <__alltraps>

c0102901 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102901:	6a 00                	push   $0x0
  pushl $25
c0102903:	6a 19                	push   $0x19
  jmp __alltraps
c0102905:	e9 04 ff ff ff       	jmp    c010280e <__alltraps>

c010290a <vector26>:
.globl vector26
vector26:
  pushl $0
c010290a:	6a 00                	push   $0x0
  pushl $26
c010290c:	6a 1a                	push   $0x1a
  jmp __alltraps
c010290e:	e9 fb fe ff ff       	jmp    c010280e <__alltraps>

c0102913 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $27
c0102915:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102917:	e9 f2 fe ff ff       	jmp    c010280e <__alltraps>

c010291c <vector28>:
.globl vector28
vector28:
  pushl $0
c010291c:	6a 00                	push   $0x0
  pushl $28
c010291e:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102920:	e9 e9 fe ff ff       	jmp    c010280e <__alltraps>

c0102925 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102925:	6a 00                	push   $0x0
  pushl $29
c0102927:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102929:	e9 e0 fe ff ff       	jmp    c010280e <__alltraps>

c010292e <vector30>:
.globl vector30
vector30:
  pushl $0
c010292e:	6a 00                	push   $0x0
  pushl $30
c0102930:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102932:	e9 d7 fe ff ff       	jmp    c010280e <__alltraps>

c0102937 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102937:	6a 00                	push   $0x0
  pushl $31
c0102939:	6a 1f                	push   $0x1f
  jmp __alltraps
c010293b:	e9 ce fe ff ff       	jmp    c010280e <__alltraps>

c0102940 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102940:	6a 00                	push   $0x0
  pushl $32
c0102942:	6a 20                	push   $0x20
  jmp __alltraps
c0102944:	e9 c5 fe ff ff       	jmp    c010280e <__alltraps>

c0102949 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102949:	6a 00                	push   $0x0
  pushl $33
c010294b:	6a 21                	push   $0x21
  jmp __alltraps
c010294d:	e9 bc fe ff ff       	jmp    c010280e <__alltraps>

c0102952 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102952:	6a 00                	push   $0x0
  pushl $34
c0102954:	6a 22                	push   $0x22
  jmp __alltraps
c0102956:	e9 b3 fe ff ff       	jmp    c010280e <__alltraps>

c010295b <vector35>:
.globl vector35
vector35:
  pushl $0
c010295b:	6a 00                	push   $0x0
  pushl $35
c010295d:	6a 23                	push   $0x23
  jmp __alltraps
c010295f:	e9 aa fe ff ff       	jmp    c010280e <__alltraps>

c0102964 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102964:	6a 00                	push   $0x0
  pushl $36
c0102966:	6a 24                	push   $0x24
  jmp __alltraps
c0102968:	e9 a1 fe ff ff       	jmp    c010280e <__alltraps>

c010296d <vector37>:
.globl vector37
vector37:
  pushl $0
c010296d:	6a 00                	push   $0x0
  pushl $37
c010296f:	6a 25                	push   $0x25
  jmp __alltraps
c0102971:	e9 98 fe ff ff       	jmp    c010280e <__alltraps>

c0102976 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102976:	6a 00                	push   $0x0
  pushl $38
c0102978:	6a 26                	push   $0x26
  jmp __alltraps
c010297a:	e9 8f fe ff ff       	jmp    c010280e <__alltraps>

c010297f <vector39>:
.globl vector39
vector39:
  pushl $0
c010297f:	6a 00                	push   $0x0
  pushl $39
c0102981:	6a 27                	push   $0x27
  jmp __alltraps
c0102983:	e9 86 fe ff ff       	jmp    c010280e <__alltraps>

c0102988 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102988:	6a 00                	push   $0x0
  pushl $40
c010298a:	6a 28                	push   $0x28
  jmp __alltraps
c010298c:	e9 7d fe ff ff       	jmp    c010280e <__alltraps>

c0102991 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102991:	6a 00                	push   $0x0
  pushl $41
c0102993:	6a 29                	push   $0x29
  jmp __alltraps
c0102995:	e9 74 fe ff ff       	jmp    c010280e <__alltraps>

c010299a <vector42>:
.globl vector42
vector42:
  pushl $0
c010299a:	6a 00                	push   $0x0
  pushl $42
c010299c:	6a 2a                	push   $0x2a
  jmp __alltraps
c010299e:	e9 6b fe ff ff       	jmp    c010280e <__alltraps>

c01029a3 <vector43>:
.globl vector43
vector43:
  pushl $0
c01029a3:	6a 00                	push   $0x0
  pushl $43
c01029a5:	6a 2b                	push   $0x2b
  jmp __alltraps
c01029a7:	e9 62 fe ff ff       	jmp    c010280e <__alltraps>

c01029ac <vector44>:
.globl vector44
vector44:
  pushl $0
c01029ac:	6a 00                	push   $0x0
  pushl $44
c01029ae:	6a 2c                	push   $0x2c
  jmp __alltraps
c01029b0:	e9 59 fe ff ff       	jmp    c010280e <__alltraps>

c01029b5 <vector45>:
.globl vector45
vector45:
  pushl $0
c01029b5:	6a 00                	push   $0x0
  pushl $45
c01029b7:	6a 2d                	push   $0x2d
  jmp __alltraps
c01029b9:	e9 50 fe ff ff       	jmp    c010280e <__alltraps>

c01029be <vector46>:
.globl vector46
vector46:
  pushl $0
c01029be:	6a 00                	push   $0x0
  pushl $46
c01029c0:	6a 2e                	push   $0x2e
  jmp __alltraps
c01029c2:	e9 47 fe ff ff       	jmp    c010280e <__alltraps>

c01029c7 <vector47>:
.globl vector47
vector47:
  pushl $0
c01029c7:	6a 00                	push   $0x0
  pushl $47
c01029c9:	6a 2f                	push   $0x2f
  jmp __alltraps
c01029cb:	e9 3e fe ff ff       	jmp    c010280e <__alltraps>

c01029d0 <vector48>:
.globl vector48
vector48:
  pushl $0
c01029d0:	6a 00                	push   $0x0
  pushl $48
c01029d2:	6a 30                	push   $0x30
  jmp __alltraps
c01029d4:	e9 35 fe ff ff       	jmp    c010280e <__alltraps>

c01029d9 <vector49>:
.globl vector49
vector49:
  pushl $0
c01029d9:	6a 00                	push   $0x0
  pushl $49
c01029db:	6a 31                	push   $0x31
  jmp __alltraps
c01029dd:	e9 2c fe ff ff       	jmp    c010280e <__alltraps>

c01029e2 <vector50>:
.globl vector50
vector50:
  pushl $0
c01029e2:	6a 00                	push   $0x0
  pushl $50
c01029e4:	6a 32                	push   $0x32
  jmp __alltraps
c01029e6:	e9 23 fe ff ff       	jmp    c010280e <__alltraps>

c01029eb <vector51>:
.globl vector51
vector51:
  pushl $0
c01029eb:	6a 00                	push   $0x0
  pushl $51
c01029ed:	6a 33                	push   $0x33
  jmp __alltraps
c01029ef:	e9 1a fe ff ff       	jmp    c010280e <__alltraps>

c01029f4 <vector52>:
.globl vector52
vector52:
  pushl $0
c01029f4:	6a 00                	push   $0x0
  pushl $52
c01029f6:	6a 34                	push   $0x34
  jmp __alltraps
c01029f8:	e9 11 fe ff ff       	jmp    c010280e <__alltraps>

c01029fd <vector53>:
.globl vector53
vector53:
  pushl $0
c01029fd:	6a 00                	push   $0x0
  pushl $53
c01029ff:	6a 35                	push   $0x35
  jmp __alltraps
c0102a01:	e9 08 fe ff ff       	jmp    c010280e <__alltraps>

c0102a06 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102a06:	6a 00                	push   $0x0
  pushl $54
c0102a08:	6a 36                	push   $0x36
  jmp __alltraps
c0102a0a:	e9 ff fd ff ff       	jmp    c010280e <__alltraps>

c0102a0f <vector55>:
.globl vector55
vector55:
  pushl $0
c0102a0f:	6a 00                	push   $0x0
  pushl $55
c0102a11:	6a 37                	push   $0x37
  jmp __alltraps
c0102a13:	e9 f6 fd ff ff       	jmp    c010280e <__alltraps>

c0102a18 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102a18:	6a 00                	push   $0x0
  pushl $56
c0102a1a:	6a 38                	push   $0x38
  jmp __alltraps
c0102a1c:	e9 ed fd ff ff       	jmp    c010280e <__alltraps>

c0102a21 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102a21:	6a 00                	push   $0x0
  pushl $57
c0102a23:	6a 39                	push   $0x39
  jmp __alltraps
c0102a25:	e9 e4 fd ff ff       	jmp    c010280e <__alltraps>

c0102a2a <vector58>:
.globl vector58
vector58:
  pushl $0
c0102a2a:	6a 00                	push   $0x0
  pushl $58
c0102a2c:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102a2e:	e9 db fd ff ff       	jmp    c010280e <__alltraps>

c0102a33 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a33:	6a 00                	push   $0x0
  pushl $59
c0102a35:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a37:	e9 d2 fd ff ff       	jmp    c010280e <__alltraps>

c0102a3c <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a3c:	6a 00                	push   $0x0
  pushl $60
c0102a3e:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a40:	e9 c9 fd ff ff       	jmp    c010280e <__alltraps>

c0102a45 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a45:	6a 00                	push   $0x0
  pushl $61
c0102a47:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a49:	e9 c0 fd ff ff       	jmp    c010280e <__alltraps>

c0102a4e <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a4e:	6a 00                	push   $0x0
  pushl $62
c0102a50:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a52:	e9 b7 fd ff ff       	jmp    c010280e <__alltraps>

c0102a57 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a57:	6a 00                	push   $0x0
  pushl $63
c0102a59:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a5b:	e9 ae fd ff ff       	jmp    c010280e <__alltraps>

c0102a60 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a60:	6a 00                	push   $0x0
  pushl $64
c0102a62:	6a 40                	push   $0x40
  jmp __alltraps
c0102a64:	e9 a5 fd ff ff       	jmp    c010280e <__alltraps>

c0102a69 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a69:	6a 00                	push   $0x0
  pushl $65
c0102a6b:	6a 41                	push   $0x41
  jmp __alltraps
c0102a6d:	e9 9c fd ff ff       	jmp    c010280e <__alltraps>

c0102a72 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a72:	6a 00                	push   $0x0
  pushl $66
c0102a74:	6a 42                	push   $0x42
  jmp __alltraps
c0102a76:	e9 93 fd ff ff       	jmp    c010280e <__alltraps>

c0102a7b <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a7b:	6a 00                	push   $0x0
  pushl $67
c0102a7d:	6a 43                	push   $0x43
  jmp __alltraps
c0102a7f:	e9 8a fd ff ff       	jmp    c010280e <__alltraps>

c0102a84 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a84:	6a 00                	push   $0x0
  pushl $68
c0102a86:	6a 44                	push   $0x44
  jmp __alltraps
c0102a88:	e9 81 fd ff ff       	jmp    c010280e <__alltraps>

c0102a8d <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a8d:	6a 00                	push   $0x0
  pushl $69
c0102a8f:	6a 45                	push   $0x45
  jmp __alltraps
c0102a91:	e9 78 fd ff ff       	jmp    c010280e <__alltraps>

c0102a96 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a96:	6a 00                	push   $0x0
  pushl $70
c0102a98:	6a 46                	push   $0x46
  jmp __alltraps
c0102a9a:	e9 6f fd ff ff       	jmp    c010280e <__alltraps>

c0102a9f <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a9f:	6a 00                	push   $0x0
  pushl $71
c0102aa1:	6a 47                	push   $0x47
  jmp __alltraps
c0102aa3:	e9 66 fd ff ff       	jmp    c010280e <__alltraps>

c0102aa8 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102aa8:	6a 00                	push   $0x0
  pushl $72
c0102aaa:	6a 48                	push   $0x48
  jmp __alltraps
c0102aac:	e9 5d fd ff ff       	jmp    c010280e <__alltraps>

c0102ab1 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102ab1:	6a 00                	push   $0x0
  pushl $73
c0102ab3:	6a 49                	push   $0x49
  jmp __alltraps
c0102ab5:	e9 54 fd ff ff       	jmp    c010280e <__alltraps>

c0102aba <vector74>:
.globl vector74
vector74:
  pushl $0
c0102aba:	6a 00                	push   $0x0
  pushl $74
c0102abc:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102abe:	e9 4b fd ff ff       	jmp    c010280e <__alltraps>

c0102ac3 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102ac3:	6a 00                	push   $0x0
  pushl $75
c0102ac5:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ac7:	e9 42 fd ff ff       	jmp    c010280e <__alltraps>

c0102acc <vector76>:
.globl vector76
vector76:
  pushl $0
c0102acc:	6a 00                	push   $0x0
  pushl $76
c0102ace:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102ad0:	e9 39 fd ff ff       	jmp    c010280e <__alltraps>

c0102ad5 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102ad5:	6a 00                	push   $0x0
  pushl $77
c0102ad7:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102ad9:	e9 30 fd ff ff       	jmp    c010280e <__alltraps>

c0102ade <vector78>:
.globl vector78
vector78:
  pushl $0
c0102ade:	6a 00                	push   $0x0
  pushl $78
c0102ae0:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102ae2:	e9 27 fd ff ff       	jmp    c010280e <__alltraps>

c0102ae7 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102ae7:	6a 00                	push   $0x0
  pushl $79
c0102ae9:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102aeb:	e9 1e fd ff ff       	jmp    c010280e <__alltraps>

c0102af0 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102af0:	6a 00                	push   $0x0
  pushl $80
c0102af2:	6a 50                	push   $0x50
  jmp __alltraps
c0102af4:	e9 15 fd ff ff       	jmp    c010280e <__alltraps>

c0102af9 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102af9:	6a 00                	push   $0x0
  pushl $81
c0102afb:	6a 51                	push   $0x51
  jmp __alltraps
c0102afd:	e9 0c fd ff ff       	jmp    c010280e <__alltraps>

c0102b02 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102b02:	6a 00                	push   $0x0
  pushl $82
c0102b04:	6a 52                	push   $0x52
  jmp __alltraps
c0102b06:	e9 03 fd ff ff       	jmp    c010280e <__alltraps>

c0102b0b <vector83>:
.globl vector83
vector83:
  pushl $0
c0102b0b:	6a 00                	push   $0x0
  pushl $83
c0102b0d:	6a 53                	push   $0x53
  jmp __alltraps
c0102b0f:	e9 fa fc ff ff       	jmp    c010280e <__alltraps>

c0102b14 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102b14:	6a 00                	push   $0x0
  pushl $84
c0102b16:	6a 54                	push   $0x54
  jmp __alltraps
c0102b18:	e9 f1 fc ff ff       	jmp    c010280e <__alltraps>

c0102b1d <vector85>:
.globl vector85
vector85:
  pushl $0
c0102b1d:	6a 00                	push   $0x0
  pushl $85
c0102b1f:	6a 55                	push   $0x55
  jmp __alltraps
c0102b21:	e9 e8 fc ff ff       	jmp    c010280e <__alltraps>

c0102b26 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102b26:	6a 00                	push   $0x0
  pushl $86
c0102b28:	6a 56                	push   $0x56
  jmp __alltraps
c0102b2a:	e9 df fc ff ff       	jmp    c010280e <__alltraps>

c0102b2f <vector87>:
.globl vector87
vector87:
  pushl $0
c0102b2f:	6a 00                	push   $0x0
  pushl $87
c0102b31:	6a 57                	push   $0x57
  jmp __alltraps
c0102b33:	e9 d6 fc ff ff       	jmp    c010280e <__alltraps>

c0102b38 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b38:	6a 00                	push   $0x0
  pushl $88
c0102b3a:	6a 58                	push   $0x58
  jmp __alltraps
c0102b3c:	e9 cd fc ff ff       	jmp    c010280e <__alltraps>

c0102b41 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b41:	6a 00                	push   $0x0
  pushl $89
c0102b43:	6a 59                	push   $0x59
  jmp __alltraps
c0102b45:	e9 c4 fc ff ff       	jmp    c010280e <__alltraps>

c0102b4a <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b4a:	6a 00                	push   $0x0
  pushl $90
c0102b4c:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b4e:	e9 bb fc ff ff       	jmp    c010280e <__alltraps>

c0102b53 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b53:	6a 00                	push   $0x0
  pushl $91
c0102b55:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b57:	e9 b2 fc ff ff       	jmp    c010280e <__alltraps>

c0102b5c <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b5c:	6a 00                	push   $0x0
  pushl $92
c0102b5e:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b60:	e9 a9 fc ff ff       	jmp    c010280e <__alltraps>

c0102b65 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b65:	6a 00                	push   $0x0
  pushl $93
c0102b67:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b69:	e9 a0 fc ff ff       	jmp    c010280e <__alltraps>

c0102b6e <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b6e:	6a 00                	push   $0x0
  pushl $94
c0102b70:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b72:	e9 97 fc ff ff       	jmp    c010280e <__alltraps>

c0102b77 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b77:	6a 00                	push   $0x0
  pushl $95
c0102b79:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b7b:	e9 8e fc ff ff       	jmp    c010280e <__alltraps>

c0102b80 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b80:	6a 00                	push   $0x0
  pushl $96
c0102b82:	6a 60                	push   $0x60
  jmp __alltraps
c0102b84:	e9 85 fc ff ff       	jmp    c010280e <__alltraps>

c0102b89 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b89:	6a 00                	push   $0x0
  pushl $97
c0102b8b:	6a 61                	push   $0x61
  jmp __alltraps
c0102b8d:	e9 7c fc ff ff       	jmp    c010280e <__alltraps>

c0102b92 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b92:	6a 00                	push   $0x0
  pushl $98
c0102b94:	6a 62                	push   $0x62
  jmp __alltraps
c0102b96:	e9 73 fc ff ff       	jmp    c010280e <__alltraps>

c0102b9b <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b9b:	6a 00                	push   $0x0
  pushl $99
c0102b9d:	6a 63                	push   $0x63
  jmp __alltraps
c0102b9f:	e9 6a fc ff ff       	jmp    c010280e <__alltraps>

c0102ba4 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ba4:	6a 00                	push   $0x0
  pushl $100
c0102ba6:	6a 64                	push   $0x64
  jmp __alltraps
c0102ba8:	e9 61 fc ff ff       	jmp    c010280e <__alltraps>

c0102bad <vector101>:
.globl vector101
vector101:
  pushl $0
c0102bad:	6a 00                	push   $0x0
  pushl $101
c0102baf:	6a 65                	push   $0x65
  jmp __alltraps
c0102bb1:	e9 58 fc ff ff       	jmp    c010280e <__alltraps>

c0102bb6 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102bb6:	6a 00                	push   $0x0
  pushl $102
c0102bb8:	6a 66                	push   $0x66
  jmp __alltraps
c0102bba:	e9 4f fc ff ff       	jmp    c010280e <__alltraps>

c0102bbf <vector103>:
.globl vector103
vector103:
  pushl $0
c0102bbf:	6a 00                	push   $0x0
  pushl $103
c0102bc1:	6a 67                	push   $0x67
  jmp __alltraps
c0102bc3:	e9 46 fc ff ff       	jmp    c010280e <__alltraps>

c0102bc8 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102bc8:	6a 00                	push   $0x0
  pushl $104
c0102bca:	6a 68                	push   $0x68
  jmp __alltraps
c0102bcc:	e9 3d fc ff ff       	jmp    c010280e <__alltraps>

c0102bd1 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102bd1:	6a 00                	push   $0x0
  pushl $105
c0102bd3:	6a 69                	push   $0x69
  jmp __alltraps
c0102bd5:	e9 34 fc ff ff       	jmp    c010280e <__alltraps>

c0102bda <vector106>:
.globl vector106
vector106:
  pushl $0
c0102bda:	6a 00                	push   $0x0
  pushl $106
c0102bdc:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102bde:	e9 2b fc ff ff       	jmp    c010280e <__alltraps>

c0102be3 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102be3:	6a 00                	push   $0x0
  pushl $107
c0102be5:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102be7:	e9 22 fc ff ff       	jmp    c010280e <__alltraps>

c0102bec <vector108>:
.globl vector108
vector108:
  pushl $0
c0102bec:	6a 00                	push   $0x0
  pushl $108
c0102bee:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102bf0:	e9 19 fc ff ff       	jmp    c010280e <__alltraps>

c0102bf5 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102bf5:	6a 00                	push   $0x0
  pushl $109
c0102bf7:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102bf9:	e9 10 fc ff ff       	jmp    c010280e <__alltraps>

c0102bfe <vector110>:
.globl vector110
vector110:
  pushl $0
c0102bfe:	6a 00                	push   $0x0
  pushl $110
c0102c00:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102c02:	e9 07 fc ff ff       	jmp    c010280e <__alltraps>

c0102c07 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102c07:	6a 00                	push   $0x0
  pushl $111
c0102c09:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102c0b:	e9 fe fb ff ff       	jmp    c010280e <__alltraps>

c0102c10 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102c10:	6a 00                	push   $0x0
  pushl $112
c0102c12:	6a 70                	push   $0x70
  jmp __alltraps
c0102c14:	e9 f5 fb ff ff       	jmp    c010280e <__alltraps>

c0102c19 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102c19:	6a 00                	push   $0x0
  pushl $113
c0102c1b:	6a 71                	push   $0x71
  jmp __alltraps
c0102c1d:	e9 ec fb ff ff       	jmp    c010280e <__alltraps>

c0102c22 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102c22:	6a 00                	push   $0x0
  pushl $114
c0102c24:	6a 72                	push   $0x72
  jmp __alltraps
c0102c26:	e9 e3 fb ff ff       	jmp    c010280e <__alltraps>

c0102c2b <vector115>:
.globl vector115
vector115:
  pushl $0
c0102c2b:	6a 00                	push   $0x0
  pushl $115
c0102c2d:	6a 73                	push   $0x73
  jmp __alltraps
c0102c2f:	e9 da fb ff ff       	jmp    c010280e <__alltraps>

c0102c34 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c34:	6a 00                	push   $0x0
  pushl $116
c0102c36:	6a 74                	push   $0x74
  jmp __alltraps
c0102c38:	e9 d1 fb ff ff       	jmp    c010280e <__alltraps>

c0102c3d <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c3d:	6a 00                	push   $0x0
  pushl $117
c0102c3f:	6a 75                	push   $0x75
  jmp __alltraps
c0102c41:	e9 c8 fb ff ff       	jmp    c010280e <__alltraps>

c0102c46 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c46:	6a 00                	push   $0x0
  pushl $118
c0102c48:	6a 76                	push   $0x76
  jmp __alltraps
c0102c4a:	e9 bf fb ff ff       	jmp    c010280e <__alltraps>

c0102c4f <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c4f:	6a 00                	push   $0x0
  pushl $119
c0102c51:	6a 77                	push   $0x77
  jmp __alltraps
c0102c53:	e9 b6 fb ff ff       	jmp    c010280e <__alltraps>

c0102c58 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c58:	6a 00                	push   $0x0
  pushl $120
c0102c5a:	6a 78                	push   $0x78
  jmp __alltraps
c0102c5c:	e9 ad fb ff ff       	jmp    c010280e <__alltraps>

c0102c61 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c61:	6a 00                	push   $0x0
  pushl $121
c0102c63:	6a 79                	push   $0x79
  jmp __alltraps
c0102c65:	e9 a4 fb ff ff       	jmp    c010280e <__alltraps>

c0102c6a <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c6a:	6a 00                	push   $0x0
  pushl $122
c0102c6c:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c6e:	e9 9b fb ff ff       	jmp    c010280e <__alltraps>

c0102c73 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c73:	6a 00                	push   $0x0
  pushl $123
c0102c75:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c77:	e9 92 fb ff ff       	jmp    c010280e <__alltraps>

c0102c7c <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $124
c0102c7e:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c80:	e9 89 fb ff ff       	jmp    c010280e <__alltraps>

c0102c85 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c85:	6a 00                	push   $0x0
  pushl $125
c0102c87:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c89:	e9 80 fb ff ff       	jmp    c010280e <__alltraps>

c0102c8e <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c8e:	6a 00                	push   $0x0
  pushl $126
c0102c90:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c92:	e9 77 fb ff ff       	jmp    c010280e <__alltraps>

c0102c97 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c97:	6a 00                	push   $0x0
  pushl $127
c0102c99:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c9b:	e9 6e fb ff ff       	jmp    c010280e <__alltraps>

c0102ca0 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102ca0:	6a 00                	push   $0x0
  pushl $128
c0102ca2:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102ca7:	e9 62 fb ff ff       	jmp    c010280e <__alltraps>

c0102cac <vector129>:
.globl vector129
vector129:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $129
c0102cae:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102cb3:	e9 56 fb ff ff       	jmp    c010280e <__alltraps>

c0102cb8 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $130
c0102cba:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102cbf:	e9 4a fb ff ff       	jmp    c010280e <__alltraps>

c0102cc4 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102cc4:	6a 00                	push   $0x0
  pushl $131
c0102cc6:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102ccb:	e9 3e fb ff ff       	jmp    c010280e <__alltraps>

c0102cd0 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $132
c0102cd2:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102cd7:	e9 32 fb ff ff       	jmp    c010280e <__alltraps>

c0102cdc <vector133>:
.globl vector133
vector133:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $133
c0102cde:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102ce3:	e9 26 fb ff ff       	jmp    c010280e <__alltraps>

c0102ce8 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102ce8:	6a 00                	push   $0x0
  pushl $134
c0102cea:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102cef:	e9 1a fb ff ff       	jmp    c010280e <__alltraps>

c0102cf4 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $135
c0102cf6:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102cfb:	e9 0e fb ff ff       	jmp    c010280e <__alltraps>

c0102d00 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $136
c0102d02:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102d07:	e9 02 fb ff ff       	jmp    c010280e <__alltraps>

c0102d0c <vector137>:
.globl vector137
vector137:
  pushl $0
c0102d0c:	6a 00                	push   $0x0
  pushl $137
c0102d0e:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102d13:	e9 f6 fa ff ff       	jmp    c010280e <__alltraps>

c0102d18 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $138
c0102d1a:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102d1f:	e9 ea fa ff ff       	jmp    c010280e <__alltraps>

c0102d24 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $139
c0102d26:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102d2b:	e9 de fa ff ff       	jmp    c010280e <__alltraps>

c0102d30 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d30:	6a 00                	push   $0x0
  pushl $140
c0102d32:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d37:	e9 d2 fa ff ff       	jmp    c010280e <__alltraps>

c0102d3c <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $141
c0102d3e:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d43:	e9 c6 fa ff ff       	jmp    c010280e <__alltraps>

c0102d48 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $142
c0102d4a:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d4f:	e9 ba fa ff ff       	jmp    c010280e <__alltraps>

c0102d54 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d54:	6a 00                	push   $0x0
  pushl $143
c0102d56:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d5b:	e9 ae fa ff ff       	jmp    c010280e <__alltraps>

c0102d60 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $144
c0102d62:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d67:	e9 a2 fa ff ff       	jmp    c010280e <__alltraps>

c0102d6c <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $145
c0102d6e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d73:	e9 96 fa ff ff       	jmp    c010280e <__alltraps>

c0102d78 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d78:	6a 00                	push   $0x0
  pushl $146
c0102d7a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d7f:	e9 8a fa ff ff       	jmp    c010280e <__alltraps>

c0102d84 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $147
c0102d86:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d8b:	e9 7e fa ff ff       	jmp    c010280e <__alltraps>

c0102d90 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $148
c0102d92:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d97:	e9 72 fa ff ff       	jmp    c010280e <__alltraps>

c0102d9c <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d9c:	6a 00                	push   $0x0
  pushl $149
c0102d9e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102da3:	e9 66 fa ff ff       	jmp    c010280e <__alltraps>

c0102da8 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $150
c0102daa:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102daf:	e9 5a fa ff ff       	jmp    c010280e <__alltraps>

c0102db4 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $151
c0102db6:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102dbb:	e9 4e fa ff ff       	jmp    c010280e <__alltraps>

c0102dc0 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102dc0:	6a 00                	push   $0x0
  pushl $152
c0102dc2:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102dc7:	e9 42 fa ff ff       	jmp    c010280e <__alltraps>

c0102dcc <vector153>:
.globl vector153
vector153:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $153
c0102dce:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102dd3:	e9 36 fa ff ff       	jmp    c010280e <__alltraps>

c0102dd8 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $154
c0102dda:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102ddf:	e9 2a fa ff ff       	jmp    c010280e <__alltraps>

c0102de4 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102de4:	6a 00                	push   $0x0
  pushl $155
c0102de6:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102deb:	e9 1e fa ff ff       	jmp    c010280e <__alltraps>

c0102df0 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $156
c0102df2:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102df7:	e9 12 fa ff ff       	jmp    c010280e <__alltraps>

c0102dfc <vector157>:
.globl vector157
vector157:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $157
c0102dfe:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102e03:	e9 06 fa ff ff       	jmp    c010280e <__alltraps>

c0102e08 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102e08:	6a 00                	push   $0x0
  pushl $158
c0102e0a:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102e0f:	e9 fa f9 ff ff       	jmp    c010280e <__alltraps>

c0102e14 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102e14:	6a 00                	push   $0x0
  pushl $159
c0102e16:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102e1b:	e9 ee f9 ff ff       	jmp    c010280e <__alltraps>

c0102e20 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $160
c0102e22:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102e27:	e9 e2 f9 ff ff       	jmp    c010280e <__alltraps>

c0102e2c <vector161>:
.globl vector161
vector161:
  pushl $0
c0102e2c:	6a 00                	push   $0x0
  pushl $161
c0102e2e:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e33:	e9 d6 f9 ff ff       	jmp    c010280e <__alltraps>

c0102e38 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e38:	6a 00                	push   $0x0
  pushl $162
c0102e3a:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e3f:	e9 ca f9 ff ff       	jmp    c010280e <__alltraps>

c0102e44 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $163
c0102e46:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e4b:	e9 be f9 ff ff       	jmp    c010280e <__alltraps>

c0102e50 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e50:	6a 00                	push   $0x0
  pushl $164
c0102e52:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e57:	e9 b2 f9 ff ff       	jmp    c010280e <__alltraps>

c0102e5c <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e5c:	6a 00                	push   $0x0
  pushl $165
c0102e5e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e63:	e9 a6 f9 ff ff       	jmp    c010280e <__alltraps>

c0102e68 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $166
c0102e6a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e6f:	e9 9a f9 ff ff       	jmp    c010280e <__alltraps>

c0102e74 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e74:	6a 00                	push   $0x0
  pushl $167
c0102e76:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e7b:	e9 8e f9 ff ff       	jmp    c010280e <__alltraps>

c0102e80 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e80:	6a 00                	push   $0x0
  pushl $168
c0102e82:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e87:	e9 82 f9 ff ff       	jmp    c010280e <__alltraps>

c0102e8c <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e8c:	6a 00                	push   $0x0
  pushl $169
c0102e8e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e93:	e9 76 f9 ff ff       	jmp    c010280e <__alltraps>

c0102e98 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e98:	6a 00                	push   $0x0
  pushl $170
c0102e9a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e9f:	e9 6a f9 ff ff       	jmp    c010280e <__alltraps>

c0102ea4 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102ea4:	6a 00                	push   $0x0
  pushl $171
c0102ea6:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102eab:	e9 5e f9 ff ff       	jmp    c010280e <__alltraps>

c0102eb0 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102eb0:	6a 00                	push   $0x0
  pushl $172
c0102eb2:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102eb7:	e9 52 f9 ff ff       	jmp    c010280e <__alltraps>

c0102ebc <vector173>:
.globl vector173
vector173:
  pushl $0
c0102ebc:	6a 00                	push   $0x0
  pushl $173
c0102ebe:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102ec3:	e9 46 f9 ff ff       	jmp    c010280e <__alltraps>

c0102ec8 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102ec8:	6a 00                	push   $0x0
  pushl $174
c0102eca:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102ecf:	e9 3a f9 ff ff       	jmp    c010280e <__alltraps>

c0102ed4 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102ed4:	6a 00                	push   $0x0
  pushl $175
c0102ed6:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102edb:	e9 2e f9 ff ff       	jmp    c010280e <__alltraps>

c0102ee0 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102ee0:	6a 00                	push   $0x0
  pushl $176
c0102ee2:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102ee7:	e9 22 f9 ff ff       	jmp    c010280e <__alltraps>

c0102eec <vector177>:
.globl vector177
vector177:
  pushl $0
c0102eec:	6a 00                	push   $0x0
  pushl $177
c0102eee:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102ef3:	e9 16 f9 ff ff       	jmp    c010280e <__alltraps>

c0102ef8 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102ef8:	6a 00                	push   $0x0
  pushl $178
c0102efa:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102eff:	e9 0a f9 ff ff       	jmp    c010280e <__alltraps>

c0102f04 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102f04:	6a 00                	push   $0x0
  pushl $179
c0102f06:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102f0b:	e9 fe f8 ff ff       	jmp    c010280e <__alltraps>

c0102f10 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102f10:	6a 00                	push   $0x0
  pushl $180
c0102f12:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102f17:	e9 f2 f8 ff ff       	jmp    c010280e <__alltraps>

c0102f1c <vector181>:
.globl vector181
vector181:
  pushl $0
c0102f1c:	6a 00                	push   $0x0
  pushl $181
c0102f1e:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102f23:	e9 e6 f8 ff ff       	jmp    c010280e <__alltraps>

c0102f28 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102f28:	6a 00                	push   $0x0
  pushl $182
c0102f2a:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102f2f:	e9 da f8 ff ff       	jmp    c010280e <__alltraps>

c0102f34 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f34:	6a 00                	push   $0x0
  pushl $183
c0102f36:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f3b:	e9 ce f8 ff ff       	jmp    c010280e <__alltraps>

c0102f40 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f40:	6a 00                	push   $0x0
  pushl $184
c0102f42:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f47:	e9 c2 f8 ff ff       	jmp    c010280e <__alltraps>

c0102f4c <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f4c:	6a 00                	push   $0x0
  pushl $185
c0102f4e:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f53:	e9 b6 f8 ff ff       	jmp    c010280e <__alltraps>

c0102f58 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f58:	6a 00                	push   $0x0
  pushl $186
c0102f5a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f5f:	e9 aa f8 ff ff       	jmp    c010280e <__alltraps>

c0102f64 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f64:	6a 00                	push   $0x0
  pushl $187
c0102f66:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f6b:	e9 9e f8 ff ff       	jmp    c010280e <__alltraps>

c0102f70 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f70:	6a 00                	push   $0x0
  pushl $188
c0102f72:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f77:	e9 92 f8 ff ff       	jmp    c010280e <__alltraps>

c0102f7c <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f7c:	6a 00                	push   $0x0
  pushl $189
c0102f7e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f83:	e9 86 f8 ff ff       	jmp    c010280e <__alltraps>

c0102f88 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f88:	6a 00                	push   $0x0
  pushl $190
c0102f8a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f8f:	e9 7a f8 ff ff       	jmp    c010280e <__alltraps>

c0102f94 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f94:	6a 00                	push   $0x0
  pushl $191
c0102f96:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f9b:	e9 6e f8 ff ff       	jmp    c010280e <__alltraps>

c0102fa0 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102fa0:	6a 00                	push   $0x0
  pushl $192
c0102fa2:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102fa7:	e9 62 f8 ff ff       	jmp    c010280e <__alltraps>

c0102fac <vector193>:
.globl vector193
vector193:
  pushl $0
c0102fac:	6a 00                	push   $0x0
  pushl $193
c0102fae:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102fb3:	e9 56 f8 ff ff       	jmp    c010280e <__alltraps>

c0102fb8 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102fb8:	6a 00                	push   $0x0
  pushl $194
c0102fba:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102fbf:	e9 4a f8 ff ff       	jmp    c010280e <__alltraps>

c0102fc4 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102fc4:	6a 00                	push   $0x0
  pushl $195
c0102fc6:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102fcb:	e9 3e f8 ff ff       	jmp    c010280e <__alltraps>

c0102fd0 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102fd0:	6a 00                	push   $0x0
  pushl $196
c0102fd2:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102fd7:	e9 32 f8 ff ff       	jmp    c010280e <__alltraps>

c0102fdc <vector197>:
.globl vector197
vector197:
  pushl $0
c0102fdc:	6a 00                	push   $0x0
  pushl $197
c0102fde:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102fe3:	e9 26 f8 ff ff       	jmp    c010280e <__alltraps>

c0102fe8 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102fe8:	6a 00                	push   $0x0
  pushl $198
c0102fea:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102fef:	e9 1a f8 ff ff       	jmp    c010280e <__alltraps>

c0102ff4 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102ff4:	6a 00                	push   $0x0
  pushl $199
c0102ff6:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102ffb:	e9 0e f8 ff ff       	jmp    c010280e <__alltraps>

c0103000 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103000:	6a 00                	push   $0x0
  pushl $200
c0103002:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0103007:	e9 02 f8 ff ff       	jmp    c010280e <__alltraps>

c010300c <vector201>:
.globl vector201
vector201:
  pushl $0
c010300c:	6a 00                	push   $0x0
  pushl $201
c010300e:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103013:	e9 f6 f7 ff ff       	jmp    c010280e <__alltraps>

c0103018 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103018:	6a 00                	push   $0x0
  pushl $202
c010301a:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010301f:	e9 ea f7 ff ff       	jmp    c010280e <__alltraps>

c0103024 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103024:	6a 00                	push   $0x0
  pushl $203
c0103026:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010302b:	e9 de f7 ff ff       	jmp    c010280e <__alltraps>

c0103030 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103030:	6a 00                	push   $0x0
  pushl $204
c0103032:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103037:	e9 d2 f7 ff ff       	jmp    c010280e <__alltraps>

c010303c <vector205>:
.globl vector205
vector205:
  pushl $0
c010303c:	6a 00                	push   $0x0
  pushl $205
c010303e:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103043:	e9 c6 f7 ff ff       	jmp    c010280e <__alltraps>

c0103048 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103048:	6a 00                	push   $0x0
  pushl $206
c010304a:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010304f:	e9 ba f7 ff ff       	jmp    c010280e <__alltraps>

c0103054 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103054:	6a 00                	push   $0x0
  pushl $207
c0103056:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010305b:	e9 ae f7 ff ff       	jmp    c010280e <__alltraps>

c0103060 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103060:	6a 00                	push   $0x0
  pushl $208
c0103062:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103067:	e9 a2 f7 ff ff       	jmp    c010280e <__alltraps>

c010306c <vector209>:
.globl vector209
vector209:
  pushl $0
c010306c:	6a 00                	push   $0x0
  pushl $209
c010306e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103073:	e9 96 f7 ff ff       	jmp    c010280e <__alltraps>

c0103078 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103078:	6a 00                	push   $0x0
  pushl $210
c010307a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010307f:	e9 8a f7 ff ff       	jmp    c010280e <__alltraps>

c0103084 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103084:	6a 00                	push   $0x0
  pushl $211
c0103086:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010308b:	e9 7e f7 ff ff       	jmp    c010280e <__alltraps>

c0103090 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103090:	6a 00                	push   $0x0
  pushl $212
c0103092:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103097:	e9 72 f7 ff ff       	jmp    c010280e <__alltraps>

c010309c <vector213>:
.globl vector213
vector213:
  pushl $0
c010309c:	6a 00                	push   $0x0
  pushl $213
c010309e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01030a3:	e9 66 f7 ff ff       	jmp    c010280e <__alltraps>

c01030a8 <vector214>:
.globl vector214
vector214:
  pushl $0
c01030a8:	6a 00                	push   $0x0
  pushl $214
c01030aa:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01030af:	e9 5a f7 ff ff       	jmp    c010280e <__alltraps>

c01030b4 <vector215>:
.globl vector215
vector215:
  pushl $0
c01030b4:	6a 00                	push   $0x0
  pushl $215
c01030b6:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01030bb:	e9 4e f7 ff ff       	jmp    c010280e <__alltraps>

c01030c0 <vector216>:
.globl vector216
vector216:
  pushl $0
c01030c0:	6a 00                	push   $0x0
  pushl $216
c01030c2:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01030c7:	e9 42 f7 ff ff       	jmp    c010280e <__alltraps>

c01030cc <vector217>:
.globl vector217
vector217:
  pushl $0
c01030cc:	6a 00                	push   $0x0
  pushl $217
c01030ce:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01030d3:	e9 36 f7 ff ff       	jmp    c010280e <__alltraps>

c01030d8 <vector218>:
.globl vector218
vector218:
  pushl $0
c01030d8:	6a 00                	push   $0x0
  pushl $218
c01030da:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01030df:	e9 2a f7 ff ff       	jmp    c010280e <__alltraps>

c01030e4 <vector219>:
.globl vector219
vector219:
  pushl $0
c01030e4:	6a 00                	push   $0x0
  pushl $219
c01030e6:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01030eb:	e9 1e f7 ff ff       	jmp    c010280e <__alltraps>

c01030f0 <vector220>:
.globl vector220
vector220:
  pushl $0
c01030f0:	6a 00                	push   $0x0
  pushl $220
c01030f2:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01030f7:	e9 12 f7 ff ff       	jmp    c010280e <__alltraps>

c01030fc <vector221>:
.globl vector221
vector221:
  pushl $0
c01030fc:	6a 00                	push   $0x0
  pushl $221
c01030fe:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103103:	e9 06 f7 ff ff       	jmp    c010280e <__alltraps>

c0103108 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103108:	6a 00                	push   $0x0
  pushl $222
c010310a:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010310f:	e9 fa f6 ff ff       	jmp    c010280e <__alltraps>

c0103114 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103114:	6a 00                	push   $0x0
  pushl $223
c0103116:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010311b:	e9 ee f6 ff ff       	jmp    c010280e <__alltraps>

c0103120 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103120:	6a 00                	push   $0x0
  pushl $224
c0103122:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103127:	e9 e2 f6 ff ff       	jmp    c010280e <__alltraps>

c010312c <vector225>:
.globl vector225
vector225:
  pushl $0
c010312c:	6a 00                	push   $0x0
  pushl $225
c010312e:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103133:	e9 d6 f6 ff ff       	jmp    c010280e <__alltraps>

c0103138 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103138:	6a 00                	push   $0x0
  pushl $226
c010313a:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010313f:	e9 ca f6 ff ff       	jmp    c010280e <__alltraps>

c0103144 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103144:	6a 00                	push   $0x0
  pushl $227
c0103146:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010314b:	e9 be f6 ff ff       	jmp    c010280e <__alltraps>

c0103150 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103150:	6a 00                	push   $0x0
  pushl $228
c0103152:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103157:	e9 b2 f6 ff ff       	jmp    c010280e <__alltraps>

c010315c <vector229>:
.globl vector229
vector229:
  pushl $0
c010315c:	6a 00                	push   $0x0
  pushl $229
c010315e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103163:	e9 a6 f6 ff ff       	jmp    c010280e <__alltraps>

c0103168 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103168:	6a 00                	push   $0x0
  pushl $230
c010316a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010316f:	e9 9a f6 ff ff       	jmp    c010280e <__alltraps>

c0103174 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103174:	6a 00                	push   $0x0
  pushl $231
c0103176:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010317b:	e9 8e f6 ff ff       	jmp    c010280e <__alltraps>

c0103180 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103180:	6a 00                	push   $0x0
  pushl $232
c0103182:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103187:	e9 82 f6 ff ff       	jmp    c010280e <__alltraps>

c010318c <vector233>:
.globl vector233
vector233:
  pushl $0
c010318c:	6a 00                	push   $0x0
  pushl $233
c010318e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103193:	e9 76 f6 ff ff       	jmp    c010280e <__alltraps>

c0103198 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103198:	6a 00                	push   $0x0
  pushl $234
c010319a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010319f:	e9 6a f6 ff ff       	jmp    c010280e <__alltraps>

c01031a4 <vector235>:
.globl vector235
vector235:
  pushl $0
c01031a4:	6a 00                	push   $0x0
  pushl $235
c01031a6:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01031ab:	e9 5e f6 ff ff       	jmp    c010280e <__alltraps>

c01031b0 <vector236>:
.globl vector236
vector236:
  pushl $0
c01031b0:	6a 00                	push   $0x0
  pushl $236
c01031b2:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01031b7:	e9 52 f6 ff ff       	jmp    c010280e <__alltraps>

c01031bc <vector237>:
.globl vector237
vector237:
  pushl $0
c01031bc:	6a 00                	push   $0x0
  pushl $237
c01031be:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01031c3:	e9 46 f6 ff ff       	jmp    c010280e <__alltraps>

c01031c8 <vector238>:
.globl vector238
vector238:
  pushl $0
c01031c8:	6a 00                	push   $0x0
  pushl $238
c01031ca:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01031cf:	e9 3a f6 ff ff       	jmp    c010280e <__alltraps>

c01031d4 <vector239>:
.globl vector239
vector239:
  pushl $0
c01031d4:	6a 00                	push   $0x0
  pushl $239
c01031d6:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01031db:	e9 2e f6 ff ff       	jmp    c010280e <__alltraps>

c01031e0 <vector240>:
.globl vector240
vector240:
  pushl $0
c01031e0:	6a 00                	push   $0x0
  pushl $240
c01031e2:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01031e7:	e9 22 f6 ff ff       	jmp    c010280e <__alltraps>

c01031ec <vector241>:
.globl vector241
vector241:
  pushl $0
c01031ec:	6a 00                	push   $0x0
  pushl $241
c01031ee:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01031f3:	e9 16 f6 ff ff       	jmp    c010280e <__alltraps>

c01031f8 <vector242>:
.globl vector242
vector242:
  pushl $0
c01031f8:	6a 00                	push   $0x0
  pushl $242
c01031fa:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01031ff:	e9 0a f6 ff ff       	jmp    c010280e <__alltraps>

c0103204 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103204:	6a 00                	push   $0x0
  pushl $243
c0103206:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010320b:	e9 fe f5 ff ff       	jmp    c010280e <__alltraps>

c0103210 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103210:	6a 00                	push   $0x0
  pushl $244
c0103212:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103217:	e9 f2 f5 ff ff       	jmp    c010280e <__alltraps>

c010321c <vector245>:
.globl vector245
vector245:
  pushl $0
c010321c:	6a 00                	push   $0x0
  pushl $245
c010321e:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103223:	e9 e6 f5 ff ff       	jmp    c010280e <__alltraps>

c0103228 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103228:	6a 00                	push   $0x0
  pushl $246
c010322a:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010322f:	e9 da f5 ff ff       	jmp    c010280e <__alltraps>

c0103234 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103234:	6a 00                	push   $0x0
  pushl $247
c0103236:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010323b:	e9 ce f5 ff ff       	jmp    c010280e <__alltraps>

c0103240 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103240:	6a 00                	push   $0x0
  pushl $248
c0103242:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103247:	e9 c2 f5 ff ff       	jmp    c010280e <__alltraps>

c010324c <vector249>:
.globl vector249
vector249:
  pushl $0
c010324c:	6a 00                	push   $0x0
  pushl $249
c010324e:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103253:	e9 b6 f5 ff ff       	jmp    c010280e <__alltraps>

c0103258 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103258:	6a 00                	push   $0x0
  pushl $250
c010325a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010325f:	e9 aa f5 ff ff       	jmp    c010280e <__alltraps>

c0103264 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103264:	6a 00                	push   $0x0
  pushl $251
c0103266:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010326b:	e9 9e f5 ff ff       	jmp    c010280e <__alltraps>

c0103270 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103270:	6a 00                	push   $0x0
  pushl $252
c0103272:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103277:	e9 92 f5 ff ff       	jmp    c010280e <__alltraps>

c010327c <vector253>:
.globl vector253
vector253:
  pushl $0
c010327c:	6a 00                	push   $0x0
  pushl $253
c010327e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103283:	e9 86 f5 ff ff       	jmp    c010280e <__alltraps>

c0103288 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103288:	6a 00                	push   $0x0
  pushl $254
c010328a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010328f:	e9 7a f5 ff ff       	jmp    c010280e <__alltraps>

c0103294 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103294:	6a 00                	push   $0x0
  pushl $255
c0103296:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010329b:	e9 6e f5 ff ff       	jmp    c010280e <__alltraps>

c01032a0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01032a0:	55                   	push   %ebp
c01032a1:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01032a3:	8b 55 08             	mov    0x8(%ebp),%edx
c01032a6:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01032ab:	29 c2                	sub    %eax,%edx
c01032ad:	89 d0                	mov    %edx,%eax
c01032af:	c1 f8 05             	sar    $0x5,%eax
}
c01032b2:	5d                   	pop    %ebp
c01032b3:	c3                   	ret    

c01032b4 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01032b4:	55                   	push   %ebp
c01032b5:	89 e5                	mov    %esp,%ebp
c01032b7:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01032ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01032bd:	89 04 24             	mov    %eax,(%esp)
c01032c0:	e8 db ff ff ff       	call   c01032a0 <page2ppn>
c01032c5:	c1 e0 0c             	shl    $0xc,%eax
}
c01032c8:	c9                   	leave  
c01032c9:	c3                   	ret    

c01032ca <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01032ca:	55                   	push   %ebp
c01032cb:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01032cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01032d0:	8b 00                	mov    (%eax),%eax
}
c01032d2:	5d                   	pop    %ebp
c01032d3:	c3                   	ret    

c01032d4 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01032d4:	55                   	push   %ebp
c01032d5:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01032d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01032da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01032dd:	89 10                	mov    %edx,(%eax)
}
c01032df:	5d                   	pop    %ebp
c01032e0:	c3                   	ret    

c01032e1 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01032e1:	55                   	push   %ebp
c01032e2:	89 e5                	mov    %esp,%ebp
c01032e4:	83 ec 10             	sub    $0x10,%esp
c01032e7:	c7 45 fc c0 0a 12 c0 	movl   $0xc0120ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01032f4:	89 50 04             	mov    %edx,0x4(%eax)
c01032f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032fa:	8b 50 04             	mov    0x4(%eax),%edx
c01032fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103300:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103302:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0103309:	00 00 00 
}
c010330c:	c9                   	leave  
c010330d:	c3                   	ret    

c010330e <default_init_memmap>:

void
default_init_memmap(struct Page *base, size_t n) {
c010330e:	55                   	push   %ebp
c010330f:	89 e5                	mov    %esp,%ebp
c0103311:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103314:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103318:	75 24                	jne    c010333e <default_init_memmap+0x30>
c010331a:	c7 44 24 0c d0 93 10 	movl   $0xc01093d0,0xc(%esp)
c0103321:	c0 
c0103322:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103329:	c0 
c010332a:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103331:	00 
c0103332:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103339:	e8 9e d9 ff ff       	call   c0100cdc <__panic>
    struct Page *p = base;
c010333e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103341:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (p = base; p != base + n; p ++)
c0103344:	8b 45 08             	mov    0x8(%ebp),%eax
c0103347:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010334a:	e9 dc 00 00 00       	jmp    c010342b <default_init_memmap+0x11d>
    {
        assert(PageReserved(p));
c010334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103352:	83 c0 04             	add    $0x4,%eax
c0103355:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010335c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010335f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103362:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103365:	0f a3 10             	bt     %edx,(%eax)
c0103368:	19 c0                	sbb    %eax,%eax
c010336a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010336d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103371:	0f 95 c0             	setne  %al
c0103374:	0f b6 c0             	movzbl %al,%eax
c0103377:	85 c0                	test   %eax,%eax
c0103379:	75 24                	jne    c010339f <default_init_memmap+0x91>
c010337b:	c7 44 24 0c 01 94 10 	movl   $0xc0109401,0xc(%esp)
c0103382:	c0 
c0103383:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c010338a:	c0 
c010338b:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c0103392:	00 
c0103393:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c010339a:	e8 3d d9 ff ff       	call   c0100cdc <__panic>
        p->flags = 0;
c010339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c01033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ac:	83 c0 04             	add    $0x4,%eax
c01033af:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01033b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01033b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01033bf:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c01033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c01033cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01033d3:	00 
c01033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033d7:	89 04 24             	mov    %eax,(%esp)
c01033da:	e8 f5 fe ff ff       	call   c01032d4 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c01033df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033e2:	83 c0 0c             	add    $0xc,%eax
c01033e5:	c7 45 dc c0 0a 12 c0 	movl   $0xc0120ac0,-0x24(%ebp)
c01033ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01033ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033f2:	8b 00                	mov    (%eax),%eax
c01033f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01033f7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01033fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01033fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103400:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103403:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103406:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103409:	89 10                	mov    %edx,(%eax)
c010340b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010340e:	8b 10                	mov    (%eax),%edx
c0103410:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103413:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103416:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103419:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010341c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010341f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103422:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103425:	89 10                	mov    %edx,(%eax)

void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (p = base; p != base + n; p ++)
c0103427:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010342b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010342e:	c1 e0 05             	shl    $0x5,%eax
c0103431:	89 c2                	mov    %eax,%edx
c0103433:	8b 45 08             	mov    0x8(%ebp),%eax
c0103436:	01 d0                	add    %edx,%eax
c0103438:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010343b:	0f 85 0e ff ff ff    	jne    c010334f <default_init_memmap+0x41>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free = nr_free + n;
c0103441:	8b 15 c8 0a 12 c0    	mov    0xc0120ac8,%edx
c0103447:	8b 45 0c             	mov    0xc(%ebp),%eax
c010344a:	01 d0                	add    %edx,%eax
c010344c:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
    base->property = n;
c0103451:	8b 45 08             	mov    0x8(%ebp),%eax
c0103454:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103457:	89 50 08             	mov    %edx,0x8(%eax)
}
c010345a:	c9                   	leave  
c010345b:	c3                   	ret    

c010345c <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010345c:	55                   	push   %ebp
c010345d:	89 e5                	mov    %esp,%ebp
c010345f:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103466:	75 24                	jne    c010348c <default_alloc_pages+0x30>
c0103468:	c7 44 24 0c d0 93 10 	movl   $0xc01093d0,0xc(%esp)
c010346f:	c0 
c0103470:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103477:	c0 
c0103478:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c010347f:	00 
c0103480:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103487:	e8 50 d8 ff ff       	call   c0100cdc <__panic>

    if (n > nr_free) {
c010348c:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103491:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103494:	73 0a                	jae    c01034a0 <default_alloc_pages+0x44>
        return NULL;
c0103496:	b8 00 00 00 00       	mov    $0x0,%eax
c010349b:	e9 43 01 00 00       	jmp    c01035e3 <default_alloc_pages+0x187>
    }

    list_entry_t *le = &free_list, *le_next = NULL;
c01034a0:	c7 45 f4 c0 0a 12 c0 	movl   $0xc0120ac0,-0xc(%ebp)
c01034a7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    struct Page* result = NULL;
c01034ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while((le=list_next(le)) != &free_list)
c01034b5:	e9 0a 01 00 00       	jmp    c01035c4 <default_alloc_pages+0x168>
    {
    	struct Page *p = le2page(le, page_link);
c01034ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034bd:	83 e8 0c             	sub    $0xc,%eax
c01034c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	if(p->property >= n)
c01034c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034c6:	8b 40 08             	mov    0x8(%eax),%eax
c01034c9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034cc:	0f 82 f2 00 00 00    	jb     c01035c4 <default_alloc_pages+0x168>
    	{
    		int i;
    		for(i=0;i<n;i++)
c01034d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01034d9:	eb 79                	jmp    c0103554 <default_alloc_pages+0xf8>
c01034db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034de:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034e4:	8b 40 04             	mov    0x4(%eax),%eax
    		{
    			le_next = list_next(le);
c01034e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    			SetPageReserved(le2page(le, page_link));
c01034ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ed:	83 e8 0c             	sub    $0xc,%eax
c01034f0:	83 c0 04             	add    $0x4,%eax
c01034f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01034fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01034fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103500:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103503:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(le2page(le, page_link));
c0103506:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103509:	83 e8 0c             	sub    $0xc,%eax
c010350c:	83 c0 04             	add    $0x4,%eax
c010350f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103516:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103519:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010351c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010351f:	0f b3 10             	btr    %edx,(%eax)
c0103522:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103525:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103528:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010352b:	8b 40 04             	mov    0x4(%eax),%eax
c010352e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103531:	8b 12                	mov    (%edx),%edx
c0103533:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103536:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103539:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010353c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010353f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103542:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103545:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103548:	89 10                	mov    %edx,(%eax)
				list_del(le);
				le = le_next;
c010354a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010354d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
    	struct Page *p = le2page(le, page_link);
    	if(p->property >= n)
    	{
    		int i;
    		for(i=0;i<n;i++)
c0103550:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0103554:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103557:	3b 45 08             	cmp    0x8(%ebp),%eax
c010355a:	0f 82 7b ff ff ff    	jb     c01034db <default_alloc_pages+0x7f>
    			SetPageReserved(le2page(le, page_link));
				ClearPageProperty(le2page(le, page_link));
				list_del(le);
				le = le_next;
			}
			if(p->property > n)
c0103560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103563:	8b 40 08             	mov    0x8(%eax),%eax
c0103566:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103569:	76 12                	jbe    c010357d <default_alloc_pages+0x121>
			{
				(le2page(le, page_link))->property = p->property - n;
c010356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356e:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103574:	8b 40 08             	mov    0x8(%eax),%eax
c0103577:	2b 45 08             	sub    0x8(%ebp),%eax
c010357a:	89 42 08             	mov    %eax,0x8(%edx)
			}
			ClearPageProperty(p);
c010357d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103580:	83 c0 04             	add    $0x4,%eax
c0103583:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010358a:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010358d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103590:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103593:	0f b3 10             	btr    %edx,(%eax)
			SetPageReserved(p);
c0103596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103599:	83 c0 04             	add    $0x4,%eax
c010359c:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01035a3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035a6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035a9:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01035ac:	0f ab 10             	bts    %edx,(%eax)
			nr_free = nr_free - n;
c01035af:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01035b4:	2b 45 08             	sub    0x8(%ebp),%eax
c01035b7:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
			result = p;
c01035bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
c01035c2:	eb 1c                	jmp    c01035e0 <default_alloc_pages+0x184>
c01035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c7:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01035ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035cd:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le = &free_list, *le_next = NULL;

    struct Page* result = NULL;

    while((le=list_next(le)) != &free_list)
c01035d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035d3:	81 7d f4 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0xc(%ebp)
c01035da:	0f 85 da fe ff ff    	jne    c01034ba <default_alloc_pages+0x5e>
			result = p;
			break;
		}
    }

    return result;
c01035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01035e3:	c9                   	leave  
c01035e4:	c3                   	ret    

c01035e5 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01035e5:	55                   	push   %ebp
c01035e6:	89 e5                	mov    %esp,%ebp
c01035e8:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *le = &free_list;
c01035eb:	c7 45 fc c0 0a 12 c0 	movl   $0xc0120ac0,-0x4(%ebp)
    struct Page * p = NULL;
c01035f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((le=list_next(le)) != &free_list)
c01035f9:	eb 13                	jmp    c010360e <default_free_pages+0x29>
    {
    	p = le2page(le, page_link);
c01035fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01035fe:	83 e8 0c             	sub    $0xc,%eax
c0103601:	89 45 f8             	mov    %eax,-0x8(%ebp)
    	if(p > base)
c0103604:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103607:	3b 45 08             	cmp    0x8(%ebp),%eax
c010360a:	76 02                	jbe    c010360e <default_free_pages+0x29>
    	{
    		break;
c010360c:	eb 18                	jmp    c0103626 <default_free_pages+0x41>
c010360e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103611:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103614:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103617:	8b 40 04             	mov    0x4(%eax),%eax

static void
default_free_pages(struct Page *base, size_t n) {
    list_entry_t *le = &free_list;
    struct Page * p = NULL;
    while((le=list_next(le)) != &free_list)
c010361a:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010361d:	81 7d fc c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x4(%ebp)
c0103624:	75 d5                	jne    c01035fb <default_free_pages+0x16>
    	if(p > base)
    	{
    		break;
    	}
    }
    for(p = base; p < base + n; p ++)
c0103626:	8b 45 08             	mov    0x8(%ebp),%eax
c0103629:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010362c:	eb 4b                	jmp    c0103679 <default_free_pages+0x94>
    {
    	list_add_before(le, &(p->page_link));
c010362e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103631:	8d 50 0c             	lea    0xc(%eax),%edx
c0103634:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103637:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010363a:	89 55 ec             	mov    %edx,-0x14(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010363d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103640:	8b 00                	mov    (%eax),%eax
c0103642:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103645:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0103648:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010364b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010364e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103651:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103654:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103657:	89 10                	mov    %edx,(%eax)
c0103659:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010365c:	8b 10                	mov    (%eax),%edx
c010365e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103661:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103664:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103667:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010366a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010366d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103670:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103673:	89 10                	mov    %edx,(%eax)
    	if(p > base)
    	{
    		break;
    	}
    }
    for(p = base; p < base + n; p ++)
c0103675:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
c0103679:	8b 45 0c             	mov    0xc(%ebp),%eax
c010367c:	c1 e0 05             	shl    $0x5,%eax
c010367f:	89 c2                	mov    %eax,%edx
c0103681:	8b 45 08             	mov    0x8(%ebp),%eax
c0103684:	01 d0                	add    %edx,%eax
c0103686:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0103689:	77 a3                	ja     c010362e <default_free_pages+0x49>
    {
    	list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c010368b:	8b 45 08             	mov    0x8(%ebp),%eax
c010368e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    ClearPageProperty(base);
c0103695:	8b 45 08             	mov    0x8(%ebp),%eax
c0103698:	83 c0 04             	add    $0x4,%eax
c010369b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01036a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01036ab:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c01036ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b1:	83 c0 04             	add    $0x4,%eax
c01036b4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01036bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036be:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01036c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01036c4:	0f ab 10             	bts    %edx,(%eax)
    set_page_ref(base, 0);
c01036c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036ce:	00 
c01036cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01036d2:	89 04 24             	mov    %eax,(%esp)
c01036d5:	e8 fa fb ff ff       	call   c01032d4 <set_page_ref>
    base->property = n;
c01036da:	8b 45 08             	mov    0x8(%ebp),%eax
c01036dd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036e0:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le,page_link) ;
c01036e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01036e6:	83 e8 0c             	sub    $0xc,%eax
c01036e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(base + n == p)
c01036ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036ef:	c1 e0 05             	shl    $0x5,%eax
c01036f2:	89 c2                	mov    %eax,%edx
c01036f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f7:	01 d0                	add    %edx,%eax
c01036f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01036fc:	75 1e                	jne    c010371c <default_free_pages+0x137>
    {
    	base->property += p->property;
c01036fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103701:	8b 50 08             	mov    0x8(%eax),%edx
c0103704:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103707:	8b 40 08             	mov    0x8(%eax),%eax
c010370a:	01 c2                	add    %eax,%edx
c010370c:	8b 45 08             	mov    0x8(%ebp),%eax
c010370f:	89 50 08             	mov    %edx,0x8(%eax)
    	p->property = 0;
c0103712:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103715:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c010371c:	8b 45 08             	mov    0x8(%ebp),%eax
c010371f:	83 c0 0c             	add    $0xc,%eax
c0103722:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0103725:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103728:	8b 00                	mov    (%eax),%eax
c010372a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    p = le2page(le, page_link);
c010372d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103730:	83 e8 0c             	sub    $0xc,%eax
c0103733:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if((le != &free_list) && (p == base - 1)){
c0103736:	81 7d fc c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x4(%ebp)
c010373d:	74 57                	je     c0103796 <default_free_pages+0x1b1>
c010373f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103742:	83 e8 20             	sub    $0x20,%eax
c0103745:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0103748:	75 4c                	jne    c0103796 <default_free_pages+0x1b1>
    	while(le != &free_list)
c010374a:	eb 41                	jmp    c010378d <default_free_pages+0x1a8>
    	{
			if(p->property)
c010374c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010374f:	8b 40 08             	mov    0x8(%eax),%eax
c0103752:	85 c0                	test   %eax,%eax
c0103754:	74 20                	je     c0103776 <default_free_pages+0x191>
			{
				p->property += base->property;
c0103756:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103759:	8b 50 08             	mov    0x8(%eax),%edx
c010375c:	8b 45 08             	mov    0x8(%ebp),%eax
c010375f:	8b 40 08             	mov    0x8(%eax),%eax
c0103762:	01 c2                	add    %eax,%edx
c0103764:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103767:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
c010376a:	8b 45 08             	mov    0x8(%ebp),%eax
c010376d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
c0103774:	eb 20                	jmp    c0103796 <default_free_pages+0x1b1>
c0103776:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103779:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010377c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010377f:	8b 00                	mov    (%eax),%eax
			}
        le = list_prev(le);
c0103781:	89 45 fc             	mov    %eax,-0x4(%ebp)
        p = le2page(le,page_link);
c0103784:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103787:	83 e8 0c             	sub    $0xc,%eax
c010378a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    	p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if((le != &free_list) && (p == base - 1)){
    	while(le != &free_list)
c010378d:	81 7d fc c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x4(%ebp)
c0103794:	75 b6                	jne    c010374c <default_free_pages+0x167>
        le = list_prev(le);
        p = le2page(le,page_link);
    	}
    }

    nr_free += n;
c0103796:	8b 15 c8 0a 12 c0    	mov    0xc0120ac8,%edx
c010379c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010379f:	01 d0                	add    %edx,%eax
c01037a1:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
    return ;
c01037a6:	90                   	nop
}
c01037a7:	c9                   	leave  
c01037a8:	c3                   	ret    

c01037a9 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01037a9:	55                   	push   %ebp
c01037aa:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01037ac:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
}
c01037b1:	5d                   	pop    %ebp
c01037b2:	c3                   	ret    

c01037b3 <basic_check>:

static void
basic_check(void) {
c01037b3:	55                   	push   %ebp
c01037b4:	89 e5                	mov    %esp,%ebp
c01037b6:	83 ec 48             	sub    $0x48,%esp
	struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01037b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01037cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037d3:	e8 bf 0e 00 00       	call   c0104697 <alloc_pages>
c01037d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01037df:	75 24                	jne    c0103805 <basic_check+0x52>
c01037e1:	c7 44 24 0c 11 94 10 	movl   $0xc0109411,0xc(%esp)
c01037e8:	c0 
c01037e9:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c01037f0:	c0 
c01037f1:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01037f8:	00 
c01037f9:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103800:	e8 d7 d4 ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103805:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010380c:	e8 86 0e 00 00       	call   c0104697 <alloc_pages>
c0103811:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103814:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103818:	75 24                	jne    c010383e <basic_check+0x8b>
c010381a:	c7 44 24 0c 2d 94 10 	movl   $0xc010942d,0xc(%esp)
c0103821:	c0 
c0103822:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103829:	c0 
c010382a:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103831:	00 
c0103832:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103839:	e8 9e d4 ff ff       	call   c0100cdc <__panic>
    assert((p2 = alloc_page()) != NULL);
c010383e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103845:	e8 4d 0e 00 00       	call   c0104697 <alloc_pages>
c010384a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010384d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103851:	75 24                	jne    c0103877 <basic_check+0xc4>
c0103853:	c7 44 24 0c 49 94 10 	movl   $0xc0109449,0xc(%esp)
c010385a:	c0 
c010385b:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103862:	c0 
c0103863:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c010386a:	00 
c010386b:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103872:	e8 65 d4 ff ff       	call   c0100cdc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103877:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010387a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010387d:	74 10                	je     c010388f <basic_check+0xdc>
c010387f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103882:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103885:	74 08                	je     c010388f <basic_check+0xdc>
c0103887:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010388a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010388d:	75 24                	jne    c01038b3 <basic_check+0x100>
c010388f:	c7 44 24 0c 68 94 10 	movl   $0xc0109468,0xc(%esp)
c0103896:	c0 
c0103897:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c010389e:	c0 
c010389f:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01038a6:	00 
c01038a7:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c01038ae:	e8 29 d4 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01038b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038b6:	89 04 24             	mov    %eax,(%esp)
c01038b9:	e8 0c fa ff ff       	call   c01032ca <page_ref>
c01038be:	85 c0                	test   %eax,%eax
c01038c0:	75 1e                	jne    c01038e0 <basic_check+0x12d>
c01038c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038c5:	89 04 24             	mov    %eax,(%esp)
c01038c8:	e8 fd f9 ff ff       	call   c01032ca <page_ref>
c01038cd:	85 c0                	test   %eax,%eax
c01038cf:	75 0f                	jne    c01038e0 <basic_check+0x12d>
c01038d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038d4:	89 04 24             	mov    %eax,(%esp)
c01038d7:	e8 ee f9 ff ff       	call   c01032ca <page_ref>
c01038dc:	85 c0                	test   %eax,%eax
c01038de:	74 24                	je     c0103904 <basic_check+0x151>
c01038e0:	c7 44 24 0c 8c 94 10 	movl   $0xc010948c,0xc(%esp)
c01038e7:	c0 
c01038e8:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c01038ef:	c0 
c01038f0:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01038f7:	00 
c01038f8:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c01038ff:	e8 d8 d3 ff ff       	call   c0100cdc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103904:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103907:	89 04 24             	mov    %eax,(%esp)
c010390a:	e8 a5 f9 ff ff       	call   c01032b4 <page2pa>
c010390f:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c0103915:	c1 e2 0c             	shl    $0xc,%edx
c0103918:	39 d0                	cmp    %edx,%eax
c010391a:	72 24                	jb     c0103940 <basic_check+0x18d>
c010391c:	c7 44 24 0c c8 94 10 	movl   $0xc01094c8,0xc(%esp)
c0103923:	c0 
c0103924:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c010392b:	c0 
c010392c:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0103933:	00 
c0103934:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c010393b:	e8 9c d3 ff ff       	call   c0100cdc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103940:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103943:	89 04 24             	mov    %eax,(%esp)
c0103946:	e8 69 f9 ff ff       	call   c01032b4 <page2pa>
c010394b:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c0103951:	c1 e2 0c             	shl    $0xc,%edx
c0103954:	39 d0                	cmp    %edx,%eax
c0103956:	72 24                	jb     c010397c <basic_check+0x1c9>
c0103958:	c7 44 24 0c e5 94 10 	movl   $0xc01094e5,0xc(%esp)
c010395f:	c0 
c0103960:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103967:	c0 
c0103968:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c010396f:	00 
c0103970:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103977:	e8 60 d3 ff ff       	call   c0100cdc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010397c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010397f:	89 04 24             	mov    %eax,(%esp)
c0103982:	e8 2d f9 ff ff       	call   c01032b4 <page2pa>
c0103987:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c010398d:	c1 e2 0c             	shl    $0xc,%edx
c0103990:	39 d0                	cmp    %edx,%eax
c0103992:	72 24                	jb     c01039b8 <basic_check+0x205>
c0103994:	c7 44 24 0c 02 95 10 	movl   $0xc0109502,0xc(%esp)
c010399b:	c0 
c010399c:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c01039a3:	c0 
c01039a4:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01039ab:	00 
c01039ac:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c01039b3:	e8 24 d3 ff ff       	call   c0100cdc <__panic>

    list_entry_t free_list_store = free_list;
c01039b8:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c01039bd:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c01039c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01039c6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01039c9:	c7 45 e0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01039d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01039d6:	89 50 04             	mov    %edx,0x4(%eax)
c01039d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039dc:	8b 50 04             	mov    0x4(%eax),%edx
c01039df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039e2:	89 10                	mov    %edx,(%eax)
c01039e4:	c7 45 dc c0 0a 12 c0 	movl   $0xc0120ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01039eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039ee:	8b 40 04             	mov    0x4(%eax),%eax
c01039f1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01039f4:	0f 94 c0             	sete   %al
c01039f7:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01039fa:	85 c0                	test   %eax,%eax
c01039fc:	75 24                	jne    c0103a22 <basic_check+0x26f>
c01039fe:	c7 44 24 0c 1f 95 10 	movl   $0xc010951f,0xc(%esp)
c0103a05:	c0 
c0103a06:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103a0d:	c0 
c0103a0e:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103a15:	00 
c0103a16:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103a1d:	e8 ba d2 ff ff       	call   c0100cdc <__panic>

    unsigned int nr_free_store = nr_free;
c0103a22:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103a27:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103a2a:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0103a31:	00 00 00 

    assert(alloc_page() == NULL);
c0103a34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a3b:	e8 57 0c 00 00       	call   c0104697 <alloc_pages>
c0103a40:	85 c0                	test   %eax,%eax
c0103a42:	74 24                	je     c0103a68 <basic_check+0x2b5>
c0103a44:	c7 44 24 0c 36 95 10 	movl   $0xc0109536,0xc(%esp)
c0103a4b:	c0 
c0103a4c:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103a53:	c0 
c0103a54:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103a5b:	00 
c0103a5c:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103a63:	e8 74 d2 ff ff       	call   c0100cdc <__panic>

    free_page(p0);
c0103a68:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a6f:	00 
c0103a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a73:	89 04 24             	mov    %eax,(%esp)
c0103a76:	e8 87 0c 00 00       	call   c0104702 <free_pages>
    free_page(p1);
c0103a7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a82:	00 
c0103a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a86:	89 04 24             	mov    %eax,(%esp)
c0103a89:	e8 74 0c 00 00       	call   c0104702 <free_pages>
    free_page(p2);
c0103a8e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a95:	00 
c0103a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a99:	89 04 24             	mov    %eax,(%esp)
c0103a9c:	e8 61 0c 00 00       	call   c0104702 <free_pages>
    assert(nr_free == 3);
c0103aa1:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103aa6:	83 f8 03             	cmp    $0x3,%eax
c0103aa9:	74 24                	je     c0103acf <basic_check+0x31c>
c0103aab:	c7 44 24 0c 4b 95 10 	movl   $0xc010954b,0xc(%esp)
c0103ab2:	c0 
c0103ab3:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103aba:	c0 
c0103abb:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103ac2:	00 
c0103ac3:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103aca:	e8 0d d2 ff ff       	call   c0100cdc <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103acf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ad6:	e8 bc 0b 00 00       	call   c0104697 <alloc_pages>
c0103adb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ade:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103ae2:	75 24                	jne    c0103b08 <basic_check+0x355>
c0103ae4:	c7 44 24 0c 11 94 10 	movl   $0xc0109411,0xc(%esp)
c0103aeb:	c0 
c0103aec:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103af3:	c0 
c0103af4:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103afb:	00 
c0103afc:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103b03:	e8 d4 d1 ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103b08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b0f:	e8 83 0b 00 00       	call   c0104697 <alloc_pages>
c0103b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b1b:	75 24                	jne    c0103b41 <basic_check+0x38e>
c0103b1d:	c7 44 24 0c 2d 94 10 	movl   $0xc010942d,0xc(%esp)
c0103b24:	c0 
c0103b25:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103b2c:	c0 
c0103b2d:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103b34:	00 
c0103b35:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103b3c:	e8 9b d1 ff ff       	call   c0100cdc <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103b41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b48:	e8 4a 0b 00 00       	call   c0104697 <alloc_pages>
c0103b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b54:	75 24                	jne    c0103b7a <basic_check+0x3c7>
c0103b56:	c7 44 24 0c 49 94 10 	movl   $0xc0109449,0xc(%esp)
c0103b5d:	c0 
c0103b5e:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103b65:	c0 
c0103b66:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103b6d:	00 
c0103b6e:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103b75:	e8 62 d1 ff ff       	call   c0100cdc <__panic>

    assert(alloc_page() == NULL);
c0103b7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b81:	e8 11 0b 00 00       	call   c0104697 <alloc_pages>
c0103b86:	85 c0                	test   %eax,%eax
c0103b88:	74 24                	je     c0103bae <basic_check+0x3fb>
c0103b8a:	c7 44 24 0c 36 95 10 	movl   $0xc0109536,0xc(%esp)
c0103b91:	c0 
c0103b92:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103b99:	c0 
c0103b9a:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103ba1:	00 
c0103ba2:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103ba9:	e8 2e d1 ff ff       	call   c0100cdc <__panic>

    free_page(p0);
c0103bae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103bb5:	00 
c0103bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bb9:	89 04 24             	mov    %eax,(%esp)
c0103bbc:	e8 41 0b 00 00       	call   c0104702 <free_pages>
c0103bc1:	c7 45 d8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x28(%ebp)
c0103bc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103bcb:	8b 40 04             	mov    0x4(%eax),%eax
c0103bce:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103bd1:	0f 94 c0             	sete   %al
c0103bd4:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103bd7:	85 c0                	test   %eax,%eax
c0103bd9:	74 24                	je     c0103bff <basic_check+0x44c>
c0103bdb:	c7 44 24 0c 58 95 10 	movl   $0xc0109558,0xc(%esp)
c0103be2:	c0 
c0103be3:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103bea:	c0 
c0103beb:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103bf2:	00 
c0103bf3:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103bfa:	e8 dd d0 ff ff       	call   c0100cdc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103bff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c06:	e8 8c 0a 00 00       	call   c0104697 <alloc_pages>
c0103c0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c11:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103c14:	74 24                	je     c0103c3a <basic_check+0x487>
c0103c16:	c7 44 24 0c 70 95 10 	movl   $0xc0109570,0xc(%esp)
c0103c1d:	c0 
c0103c1e:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103c25:	c0 
c0103c26:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0103c2d:	00 
c0103c2e:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103c35:	e8 a2 d0 ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0103c3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c41:	e8 51 0a 00 00       	call   c0104697 <alloc_pages>
c0103c46:	85 c0                	test   %eax,%eax
c0103c48:	74 24                	je     c0103c6e <basic_check+0x4bb>
c0103c4a:	c7 44 24 0c 36 95 10 	movl   $0xc0109536,0xc(%esp)
c0103c51:	c0 
c0103c52:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103c59:	c0 
c0103c5a:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103c61:	00 
c0103c62:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103c69:	e8 6e d0 ff ff       	call   c0100cdc <__panic>

    assert(nr_free == 0);
c0103c6e:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103c73:	85 c0                	test   %eax,%eax
c0103c75:	74 24                	je     c0103c9b <basic_check+0x4e8>
c0103c77:	c7 44 24 0c 89 95 10 	movl   $0xc0109589,0xc(%esp)
c0103c7e:	c0 
c0103c7f:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103c86:	c0 
c0103c87:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103c8e:	00 
c0103c8f:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103c96:	e8 41 d0 ff ff       	call   c0100cdc <__panic>
    free_list = free_list_store;
c0103c9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c9e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ca1:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0103ca6:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4
    nr_free = nr_free_store;
c0103cac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103caf:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8

    free_page(p);
c0103cb4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cbb:	00 
c0103cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cbf:	89 04 24             	mov    %eax,(%esp)
c0103cc2:	e8 3b 0a 00 00       	call   c0104702 <free_pages>
    free_page(p1);
c0103cc7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cce:	00 
c0103ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cd2:	89 04 24             	mov    %eax,(%esp)
c0103cd5:	e8 28 0a 00 00       	call   c0104702 <free_pages>
    free_page(p2);
c0103cda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ce1:	00 
c0103ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce5:	89 04 24             	mov    %eax,(%esp)
c0103ce8:	e8 15 0a 00 00       	call   c0104702 <free_pages>
}
c0103ced:	c9                   	leave  
c0103cee:	c3                   	ret    

c0103cef <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103cef:	55                   	push   %ebp
c0103cf0:	89 e5                	mov    %esp,%ebp
c0103cf2:	53                   	push   %ebx
c0103cf3:	81 ec 94 00 00 00    	sub    $0x94,%esp
	int count = 0, total = 0;
c0103cf9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103d07:	c7 45 ec c0 0a 12 c0 	movl   $0xc0120ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103d0e:	eb 6b                	jmp    c0103d7b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d13:	83 e8 0c             	sub    $0xc,%eax
c0103d16:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d1c:	83 c0 04             	add    $0x4,%eax
c0103d1f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103d26:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d29:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d2c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d2f:	0f a3 10             	bt     %edx,(%eax)
c0103d32:	19 c0                	sbb    %eax,%eax
c0103d34:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103d37:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103d3b:	0f 95 c0             	setne  %al
c0103d3e:	0f b6 c0             	movzbl %al,%eax
c0103d41:	85 c0                	test   %eax,%eax
c0103d43:	75 24                	jne    c0103d69 <default_check+0x7a>
c0103d45:	c7 44 24 0c 96 95 10 	movl   $0xc0109596,0xc(%esp)
c0103d4c:	c0 
c0103d4d:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103d54:	c0 
c0103d55:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103d5c:	00 
c0103d5d:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103d64:	e8 73 cf ff ff       	call   c0100cdc <__panic>
        count ++, total += p->property;
c0103d69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103d6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d70:	8b 50 08             	mov    0x8(%eax),%edx
c0103d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d76:	01 d0                	add    %edx,%eax
c0103d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d7e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d84:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
	int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d8a:	81 7d ec c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x14(%ebp)
c0103d91:	0f 85 79 ff ff ff    	jne    c0103d10 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103d97:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103d9a:	e8 95 09 00 00       	call   c0104734 <nr_free_pages>
c0103d9f:	39 c3                	cmp    %eax,%ebx
c0103da1:	74 24                	je     c0103dc7 <default_check+0xd8>
c0103da3:	c7 44 24 0c a6 95 10 	movl   $0xc01095a6,0xc(%esp)
c0103daa:	c0 
c0103dab:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103db2:	c0 
c0103db3:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103dba:	00 
c0103dbb:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103dc2:	e8 15 cf ff ff       	call   c0100cdc <__panic>

    basic_check();
c0103dc7:	e8 e7 f9 ff ff       	call   c01037b3 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103dcc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103dd3:	e8 bf 08 00 00       	call   c0104697 <alloc_pages>
c0103dd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103ddb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ddf:	75 24                	jne    c0103e05 <default_check+0x116>
c0103de1:	c7 44 24 0c bf 95 10 	movl   $0xc01095bf,0xc(%esp)
c0103de8:	c0 
c0103de9:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103df0:	c0 
c0103df1:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103df8:	00 
c0103df9:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103e00:	e8 d7 ce ff ff       	call   c0100cdc <__panic>
    assert(!PageProperty(p0));
c0103e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e08:	83 c0 04             	add    $0x4,%eax
c0103e0b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103e12:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e15:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e18:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103e1b:	0f a3 10             	bt     %edx,(%eax)
c0103e1e:	19 c0                	sbb    %eax,%eax
c0103e20:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103e23:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103e27:	0f 95 c0             	setne  %al
c0103e2a:	0f b6 c0             	movzbl %al,%eax
c0103e2d:	85 c0                	test   %eax,%eax
c0103e2f:	74 24                	je     c0103e55 <default_check+0x166>
c0103e31:	c7 44 24 0c ca 95 10 	movl   $0xc01095ca,0xc(%esp)
c0103e38:	c0 
c0103e39:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103e40:	c0 
c0103e41:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0103e48:	00 
c0103e49:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103e50:	e8 87 ce ff ff       	call   c0100cdc <__panic>

    list_entry_t free_list_store = free_list;
c0103e55:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c0103e5a:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c0103e60:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103e63:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103e66:	c7 45 b4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103e6d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e70:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e73:	89 50 04             	mov    %edx,0x4(%eax)
c0103e76:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e79:	8b 50 04             	mov    0x4(%eax),%edx
c0103e7c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e7f:	89 10                	mov    %edx,(%eax)
c0103e81:	c7 45 b0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e88:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e8b:	8b 40 04             	mov    0x4(%eax),%eax
c0103e8e:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103e91:	0f 94 c0             	sete   %al
c0103e94:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e97:	85 c0                	test   %eax,%eax
c0103e99:	75 24                	jne    c0103ebf <default_check+0x1d0>
c0103e9b:	c7 44 24 0c 1f 95 10 	movl   $0xc010951f,0xc(%esp)
c0103ea2:	c0 
c0103ea3:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103eaa:	c0 
c0103eab:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103eb2:	00 
c0103eb3:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103eba:	e8 1d ce ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0103ebf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ec6:	e8 cc 07 00 00       	call   c0104697 <alloc_pages>
c0103ecb:	85 c0                	test   %eax,%eax
c0103ecd:	74 24                	je     c0103ef3 <default_check+0x204>
c0103ecf:	c7 44 24 0c 36 95 10 	movl   $0xc0109536,0xc(%esp)
c0103ed6:	c0 
c0103ed7:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103ede:	c0 
c0103edf:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103ee6:	00 
c0103ee7:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103eee:	e8 e9 cd ff ff       	call   c0100cdc <__panic>

    unsigned int nr_free_store = nr_free;
c0103ef3:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103ef8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103efb:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0103f02:	00 00 00 

    free_pages(p0 + 2, 3);
c0103f05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f08:	83 c0 40             	add    $0x40,%eax
c0103f0b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103f12:	00 
c0103f13:	89 04 24             	mov    %eax,(%esp)
c0103f16:	e8 e7 07 00 00       	call   c0104702 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103f1b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103f22:	e8 70 07 00 00       	call   c0104697 <alloc_pages>
c0103f27:	85 c0                	test   %eax,%eax
c0103f29:	74 24                	je     c0103f4f <default_check+0x260>
c0103f2b:	c7 44 24 0c dc 95 10 	movl   $0xc01095dc,0xc(%esp)
c0103f32:	c0 
c0103f33:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103f3a:	c0 
c0103f3b:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103f42:	00 
c0103f43:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103f4a:	e8 8d cd ff ff       	call   c0100cdc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103f4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f52:	83 c0 40             	add    $0x40,%eax
c0103f55:	83 c0 04             	add    $0x4,%eax
c0103f58:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103f5f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f62:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f65:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103f68:	0f a3 10             	bt     %edx,(%eax)
c0103f6b:	19 c0                	sbb    %eax,%eax
c0103f6d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103f70:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103f74:	0f 95 c0             	setne  %al
c0103f77:	0f b6 c0             	movzbl %al,%eax
c0103f7a:	85 c0                	test   %eax,%eax
c0103f7c:	74 0e                	je     c0103f8c <default_check+0x29d>
c0103f7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f81:	83 c0 40             	add    $0x40,%eax
c0103f84:	8b 40 08             	mov    0x8(%eax),%eax
c0103f87:	83 f8 03             	cmp    $0x3,%eax
c0103f8a:	74 24                	je     c0103fb0 <default_check+0x2c1>
c0103f8c:	c7 44 24 0c f4 95 10 	movl   $0xc01095f4,0xc(%esp)
c0103f93:	c0 
c0103f94:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103f9b:	c0 
c0103f9c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103fa3:	00 
c0103fa4:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103fab:	e8 2c cd ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103fb0:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103fb7:	e8 db 06 00 00       	call   c0104697 <alloc_pages>
c0103fbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103fbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103fc3:	75 24                	jne    c0103fe9 <default_check+0x2fa>
c0103fc5:	c7 44 24 0c 20 96 10 	movl   $0xc0109620,0xc(%esp)
c0103fcc:	c0 
c0103fcd:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0103fd4:	c0 
c0103fd5:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103fdc:	00 
c0103fdd:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0103fe4:	e8 f3 cc ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0103fe9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ff0:	e8 a2 06 00 00       	call   c0104697 <alloc_pages>
c0103ff5:	85 c0                	test   %eax,%eax
c0103ff7:	74 24                	je     c010401d <default_check+0x32e>
c0103ff9:	c7 44 24 0c 36 95 10 	movl   $0xc0109536,0xc(%esp)
c0104000:	c0 
c0104001:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0104008:	c0 
c0104009:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0104010:	00 
c0104011:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0104018:	e8 bf cc ff ff       	call   c0100cdc <__panic>
    assert(p0 + 2 == p1);
c010401d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104020:	83 c0 40             	add    $0x40,%eax
c0104023:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104026:	74 24                	je     c010404c <default_check+0x35d>
c0104028:	c7 44 24 0c 3e 96 10 	movl   $0xc010963e,0xc(%esp)
c010402f:	c0 
c0104030:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0104037:	c0 
c0104038:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c010403f:	00 
c0104040:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0104047:	e8 90 cc ff ff       	call   c0100cdc <__panic>

    p2 = p0 + 1;
c010404c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010404f:	83 c0 20             	add    $0x20,%eax
c0104052:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0104055:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010405c:	00 
c010405d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104060:	89 04 24             	mov    %eax,(%esp)
c0104063:	e8 9a 06 00 00       	call   c0104702 <free_pages>
    free_pages(p1, 3);
c0104068:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010406f:	00 
c0104070:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104073:	89 04 24             	mov    %eax,(%esp)
c0104076:	e8 87 06 00 00       	call   c0104702 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010407b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010407e:	83 c0 04             	add    $0x4,%eax
c0104081:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104088:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010408b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010408e:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104091:	0f a3 10             	bt     %edx,(%eax)
c0104094:	19 c0                	sbb    %eax,%eax
c0104096:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104099:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010409d:	0f 95 c0             	setne  %al
c01040a0:	0f b6 c0             	movzbl %al,%eax
c01040a3:	85 c0                	test   %eax,%eax
c01040a5:	74 0b                	je     c01040b2 <default_check+0x3c3>
c01040a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040aa:	8b 40 08             	mov    0x8(%eax),%eax
c01040ad:	83 f8 01             	cmp    $0x1,%eax
c01040b0:	74 24                	je     c01040d6 <default_check+0x3e7>
c01040b2:	c7 44 24 0c 4c 96 10 	movl   $0xc010964c,0xc(%esp)
c01040b9:	c0 
c01040ba:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c01040c1:	c0 
c01040c2:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01040c9:	00 
c01040ca:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c01040d1:	e8 06 cc ff ff       	call   c0100cdc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01040d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040d9:	83 c0 04             	add    $0x4,%eax
c01040dc:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01040e3:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040e6:	8b 45 90             	mov    -0x70(%ebp),%eax
c01040e9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01040ec:	0f a3 10             	bt     %edx,(%eax)
c01040ef:	19 c0                	sbb    %eax,%eax
c01040f1:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01040f4:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01040f8:	0f 95 c0             	setne  %al
c01040fb:	0f b6 c0             	movzbl %al,%eax
c01040fe:	85 c0                	test   %eax,%eax
c0104100:	74 0b                	je     c010410d <default_check+0x41e>
c0104102:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104105:	8b 40 08             	mov    0x8(%eax),%eax
c0104108:	83 f8 03             	cmp    $0x3,%eax
c010410b:	74 24                	je     c0104131 <default_check+0x442>
c010410d:	c7 44 24 0c 74 96 10 	movl   $0xc0109674,0xc(%esp)
c0104114:	c0 
c0104115:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c010411c:	c0 
c010411d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104124:	00 
c0104125:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c010412c:	e8 ab cb ff ff       	call   c0100cdc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104131:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104138:	e8 5a 05 00 00       	call   c0104697 <alloc_pages>
c010413d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104140:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104143:	83 e8 20             	sub    $0x20,%eax
c0104146:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104149:	74 24                	je     c010416f <default_check+0x480>
c010414b:	c7 44 24 0c 9a 96 10 	movl   $0xc010969a,0xc(%esp)
c0104152:	c0 
c0104153:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c010415a:	c0 
c010415b:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104162:	00 
c0104163:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c010416a:	e8 6d cb ff ff       	call   c0100cdc <__panic>
    free_page(p0);
c010416f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104176:	00 
c0104177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010417a:	89 04 24             	mov    %eax,(%esp)
c010417d:	e8 80 05 00 00       	call   c0104702 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104182:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104189:	e8 09 05 00 00       	call   c0104697 <alloc_pages>
c010418e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104191:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104194:	83 c0 20             	add    $0x20,%eax
c0104197:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010419a:	74 24                	je     c01041c0 <default_check+0x4d1>
c010419c:	c7 44 24 0c b8 96 10 	movl   $0xc01096b8,0xc(%esp)
c01041a3:	c0 
c01041a4:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c01041ab:	c0 
c01041ac:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01041b3:	00 
c01041b4:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c01041bb:	e8 1c cb ff ff       	call   c0100cdc <__panic>

    free_pages(p0, 2);
c01041c0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01041c7:	00 
c01041c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041cb:	89 04 24             	mov    %eax,(%esp)
c01041ce:	e8 2f 05 00 00       	call   c0104702 <free_pages>
    free_page(p2);
c01041d3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041da:	00 
c01041db:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041de:	89 04 24             	mov    %eax,(%esp)
c01041e1:	e8 1c 05 00 00       	call   c0104702 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01041e6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01041ed:	e8 a5 04 00 00       	call   c0104697 <alloc_pages>
c01041f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01041f9:	75 24                	jne    c010421f <default_check+0x530>
c01041fb:	c7 44 24 0c d8 96 10 	movl   $0xc01096d8,0xc(%esp)
c0104202:	c0 
c0104203:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c010420a:	c0 
c010420b:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0104212:	00 
c0104213:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c010421a:	e8 bd ca ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c010421f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104226:	e8 6c 04 00 00       	call   c0104697 <alloc_pages>
c010422b:	85 c0                	test   %eax,%eax
c010422d:	74 24                	je     c0104253 <default_check+0x564>
c010422f:	c7 44 24 0c 36 95 10 	movl   $0xc0109536,0xc(%esp)
c0104236:	c0 
c0104237:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c010423e:	c0 
c010423f:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104246:	00 
c0104247:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c010424e:	e8 89 ca ff ff       	call   c0100cdc <__panic>

    assert(nr_free == 0);
c0104253:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0104258:	85 c0                	test   %eax,%eax
c010425a:	74 24                	je     c0104280 <default_check+0x591>
c010425c:	c7 44 24 0c 89 95 10 	movl   $0xc0109589,0xc(%esp)
c0104263:	c0 
c0104264:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c010426b:	c0 
c010426c:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0104273:	00 
c0104274:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c010427b:	e8 5c ca ff ff       	call   c0100cdc <__panic>
    nr_free = nr_free_store;
c0104280:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104283:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8

    free_list = free_list_store;
c0104288:	8b 45 80             	mov    -0x80(%ebp),%eax
c010428b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010428e:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0104293:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4
    free_pages(p0, 5);
c0104299:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01042a0:	00 
c01042a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042a4:	89 04 24             	mov    %eax,(%esp)
c01042a7:	e8 56 04 00 00       	call   c0104702 <free_pages>

    le = &free_list;
c01042ac:	c7 45 ec c0 0a 12 c0 	movl   $0xc0120ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01042b3:	eb 1d                	jmp    c01042d2 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01042b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042b8:	83 e8 0c             	sub    $0xc,%eax
c01042bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01042be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01042c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01042c8:	8b 40 08             	mov    0x8(%eax),%eax
c01042cb:	29 c2                	sub    %eax,%edx
c01042cd:	89 d0                	mov    %edx,%eax
c01042cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042d5:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01042d8:	8b 45 88             	mov    -0x78(%ebp),%eax
c01042db:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01042de:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042e1:	81 7d ec c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x14(%ebp)
c01042e8:	75 cb                	jne    c01042b5 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01042ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042ee:	74 24                	je     c0104314 <default_check+0x625>
c01042f0:	c7 44 24 0c f6 96 10 	movl   $0xc01096f6,0xc(%esp)
c01042f7:	c0 
c01042f8:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c01042ff:	c0 
c0104300:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104307:	00 
c0104308:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c010430f:	e8 c8 c9 ff ff       	call   c0100cdc <__panic>
    assert(total == 0);
c0104314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104318:	74 24                	je     c010433e <default_check+0x64f>
c010431a:	c7 44 24 0c 01 97 10 	movl   $0xc0109701,0xc(%esp)
c0104321:	c0 
c0104322:	c7 44 24 08 d6 93 10 	movl   $0xc01093d6,0x8(%esp)
c0104329:	c0 
c010432a:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0104331:	00 
c0104332:	c7 04 24 eb 93 10 c0 	movl   $0xc01093eb,(%esp)
c0104339:	e8 9e c9 ff ff       	call   c0100cdc <__panic>
}
c010433e:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104344:	5b                   	pop    %ebx
c0104345:	5d                   	pop    %ebp
c0104346:	c3                   	ret    

c0104347 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104347:	55                   	push   %ebp
c0104348:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010434a:	8b 55 08             	mov    0x8(%ebp),%edx
c010434d:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0104352:	29 c2                	sub    %eax,%edx
c0104354:	89 d0                	mov    %edx,%eax
c0104356:	c1 f8 05             	sar    $0x5,%eax
}
c0104359:	5d                   	pop    %ebp
c010435a:	c3                   	ret    

c010435b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010435b:	55                   	push   %ebp
c010435c:	89 e5                	mov    %esp,%ebp
c010435e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104361:	8b 45 08             	mov    0x8(%ebp),%eax
c0104364:	89 04 24             	mov    %eax,(%esp)
c0104367:	e8 db ff ff ff       	call   c0104347 <page2ppn>
c010436c:	c1 e0 0c             	shl    $0xc,%eax
}
c010436f:	c9                   	leave  
c0104370:	c3                   	ret    

c0104371 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104371:	55                   	push   %ebp
c0104372:	89 e5                	mov    %esp,%ebp
c0104374:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104377:	8b 45 08             	mov    0x8(%ebp),%eax
c010437a:	c1 e8 0c             	shr    $0xc,%eax
c010437d:	89 c2                	mov    %eax,%edx
c010437f:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104384:	39 c2                	cmp    %eax,%edx
c0104386:	72 1c                	jb     c01043a4 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104388:	c7 44 24 08 3c 97 10 	movl   $0xc010973c,0x8(%esp)
c010438f:	c0 
c0104390:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0104397:	00 
c0104398:	c7 04 24 5b 97 10 c0 	movl   $0xc010975b,(%esp)
c010439f:	e8 38 c9 ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c01043a4:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01043a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01043ac:	c1 ea 0c             	shr    $0xc,%edx
c01043af:	c1 e2 05             	shl    $0x5,%edx
c01043b2:	01 d0                	add    %edx,%eax
}
c01043b4:	c9                   	leave  
c01043b5:	c3                   	ret    

c01043b6 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01043b6:	55                   	push   %ebp
c01043b7:	89 e5                	mov    %esp,%ebp
c01043b9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01043bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01043bf:	89 04 24             	mov    %eax,(%esp)
c01043c2:	e8 94 ff ff ff       	call   c010435b <page2pa>
c01043c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043cd:	c1 e8 0c             	shr    $0xc,%eax
c01043d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043d3:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01043d8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01043db:	72 23                	jb     c0104400 <page2kva+0x4a>
c01043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043e4:	c7 44 24 08 6c 97 10 	movl   $0xc010976c,0x8(%esp)
c01043eb:	c0 
c01043ec:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01043f3:	00 
c01043f4:	c7 04 24 5b 97 10 c0 	movl   $0xc010975b,(%esp)
c01043fb:	e8 dc c8 ff ff       	call   c0100cdc <__panic>
c0104400:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104403:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104408:	c9                   	leave  
c0104409:	c3                   	ret    

c010440a <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010440a:	55                   	push   %ebp
c010440b:	89 e5                	mov    %esp,%ebp
c010440d:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104410:	8b 45 08             	mov    0x8(%ebp),%eax
c0104413:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104416:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010441d:	77 23                	ja     c0104442 <kva2page+0x38>
c010441f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104422:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104426:	c7 44 24 08 90 97 10 	movl   $0xc0109790,0x8(%esp)
c010442d:	c0 
c010442e:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0104435:	00 
c0104436:	c7 04 24 5b 97 10 c0 	movl   $0xc010975b,(%esp)
c010443d:	e8 9a c8 ff ff       	call   c0100cdc <__panic>
c0104442:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104445:	05 00 00 00 40       	add    $0x40000000,%eax
c010444a:	89 04 24             	mov    %eax,(%esp)
c010444d:	e8 1f ff ff ff       	call   c0104371 <pa2page>
}
c0104452:	c9                   	leave  
c0104453:	c3                   	ret    

c0104454 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c0104454:	55                   	push   %ebp
c0104455:	89 e5                	mov    %esp,%ebp
c0104457:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010445a:	8b 45 08             	mov    0x8(%ebp),%eax
c010445d:	83 e0 01             	and    $0x1,%eax
c0104460:	85 c0                	test   %eax,%eax
c0104462:	75 1c                	jne    c0104480 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104464:	c7 44 24 08 b4 97 10 	movl   $0xc01097b4,0x8(%esp)
c010446b:	c0 
c010446c:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104473:	00 
c0104474:	c7 04 24 5b 97 10 c0 	movl   $0xc010975b,(%esp)
c010447b:	e8 5c c8 ff ff       	call   c0100cdc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104480:	8b 45 08             	mov    0x8(%ebp),%eax
c0104483:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104488:	89 04 24             	mov    %eax,(%esp)
c010448b:	e8 e1 fe ff ff       	call   c0104371 <pa2page>
}
c0104490:	c9                   	leave  
c0104491:	c3                   	ret    

c0104492 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104492:	55                   	push   %ebp
c0104493:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104495:	8b 45 08             	mov    0x8(%ebp),%eax
c0104498:	8b 00                	mov    (%eax),%eax
}
c010449a:	5d                   	pop    %ebp
c010449b:	c3                   	ret    

c010449c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010449c:	55                   	push   %ebp
c010449d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010449f:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044a5:	89 10                	mov    %edx,(%eax)
}
c01044a7:	5d                   	pop    %ebp
c01044a8:	c3                   	ret    

c01044a9 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01044a9:	55                   	push   %ebp
c01044aa:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01044ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01044af:	8b 00                	mov    (%eax),%eax
c01044b1:	8d 50 01             	lea    0x1(%eax),%edx
c01044b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01044b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bc:	8b 00                	mov    (%eax),%eax
}
c01044be:	5d                   	pop    %ebp
c01044bf:	c3                   	ret    

c01044c0 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01044c0:	55                   	push   %ebp
c01044c1:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01044c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c6:	8b 00                	mov    (%eax),%eax
c01044c8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01044cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ce:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01044d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d3:	8b 00                	mov    (%eax),%eax
}
c01044d5:	5d                   	pop    %ebp
c01044d6:	c3                   	ret    

c01044d7 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01044d7:	55                   	push   %ebp
c01044d8:	89 e5                	mov    %esp,%ebp
c01044da:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01044dd:	9c                   	pushf  
c01044de:	58                   	pop    %eax
c01044df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01044e5:	25 00 02 00 00       	and    $0x200,%eax
c01044ea:	85 c0                	test   %eax,%eax
c01044ec:	74 0c                	je     c01044fa <__intr_save+0x23>
        intr_disable();
c01044ee:	e8 41 da ff ff       	call   c0101f34 <intr_disable>
        return 1;
c01044f3:	b8 01 00 00 00       	mov    $0x1,%eax
c01044f8:	eb 05                	jmp    c01044ff <__intr_save+0x28>
    }
    return 0;
c01044fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044ff:	c9                   	leave  
c0104500:	c3                   	ret    

c0104501 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104501:	55                   	push   %ebp
c0104502:	89 e5                	mov    %esp,%ebp
c0104504:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104507:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010450b:	74 05                	je     c0104512 <__intr_restore+0x11>
        intr_enable();
c010450d:	e8 1c da ff ff       	call   c0101f2e <intr_enable>
    }
}
c0104512:	c9                   	leave  
c0104513:	c3                   	ret    

c0104514 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104514:	55                   	push   %ebp
c0104515:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104517:	8b 45 08             	mov    0x8(%ebp),%eax
c010451a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010451d:	b8 23 00 00 00       	mov    $0x23,%eax
c0104522:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104524:	b8 23 00 00 00       	mov    $0x23,%eax
c0104529:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c010452b:	b8 10 00 00 00       	mov    $0x10,%eax
c0104530:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104532:	b8 10 00 00 00       	mov    $0x10,%eax
c0104537:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104539:	b8 10 00 00 00       	mov    $0x10,%eax
c010453e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104540:	ea 47 45 10 c0 08 00 	ljmp   $0x8,$0xc0104547
}
c0104547:	5d                   	pop    %ebp
c0104548:	c3                   	ret    

c0104549 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104549:	55                   	push   %ebp
c010454a:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c010454c:	8b 45 08             	mov    0x8(%ebp),%eax
c010454f:	a3 44 0a 12 c0       	mov    %eax,0xc0120a44
}
c0104554:	5d                   	pop    %ebp
c0104555:	c3                   	ret    

c0104556 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104556:	55                   	push   %ebp
c0104557:	89 e5                	mov    %esp,%ebp
c0104559:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c010455c:	b8 00 f0 11 c0       	mov    $0xc011f000,%eax
c0104561:	89 04 24             	mov    %eax,(%esp)
c0104564:	e8 e0 ff ff ff       	call   c0104549 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104569:	66 c7 05 48 0a 12 c0 	movw   $0x10,0xc0120a48
c0104570:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104572:	66 c7 05 28 fa 11 c0 	movw   $0x68,0xc011fa28
c0104579:	68 00 
c010457b:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c0104580:	66 a3 2a fa 11 c0    	mov    %ax,0xc011fa2a
c0104586:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c010458b:	c1 e8 10             	shr    $0x10,%eax
c010458e:	a2 2c fa 11 c0       	mov    %al,0xc011fa2c
c0104593:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c010459a:	83 e0 f0             	and    $0xfffffff0,%eax
c010459d:	83 c8 09             	or     $0x9,%eax
c01045a0:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01045a5:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01045ac:	83 e0 ef             	and    $0xffffffef,%eax
c01045af:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01045b4:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01045bb:	83 e0 9f             	and    $0xffffff9f,%eax
c01045be:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01045c3:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01045ca:	83 c8 80             	or     $0xffffff80,%eax
c01045cd:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01045d2:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c01045d9:	83 e0 f0             	and    $0xfffffff0,%eax
c01045dc:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c01045e1:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c01045e8:	83 e0 ef             	and    $0xffffffef,%eax
c01045eb:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c01045f0:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c01045f7:	83 e0 df             	and    $0xffffffdf,%eax
c01045fa:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c01045ff:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104606:	83 c8 40             	or     $0x40,%eax
c0104609:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c010460e:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104615:	83 e0 7f             	and    $0x7f,%eax
c0104618:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c010461d:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c0104622:	c1 e8 18             	shr    $0x18,%eax
c0104625:	a2 2f fa 11 c0       	mov    %al,0xc011fa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c010462a:	c7 04 24 30 fa 11 c0 	movl   $0xc011fa30,(%esp)
c0104631:	e8 de fe ff ff       	call   c0104514 <lgdt>
c0104636:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c010463c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104640:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104643:	c9                   	leave  
c0104644:	c3                   	ret    

c0104645 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104645:	55                   	push   %ebp
c0104646:	89 e5                	mov    %esp,%ebp
c0104648:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c010464b:	c7 05 cc 0a 12 c0 20 	movl   $0xc0109720,0xc0120acc
c0104652:	97 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104655:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c010465a:	8b 00                	mov    (%eax),%eax
c010465c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104660:	c7 04 24 e0 97 10 c0 	movl   $0xc01097e0,(%esp)
c0104667:	e8 df bc ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c010466c:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104671:	8b 40 04             	mov    0x4(%eax),%eax
c0104674:	ff d0                	call   *%eax
}
c0104676:	c9                   	leave  
c0104677:	c3                   	ret    

c0104678 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104678:	55                   	push   %ebp
c0104679:	89 e5                	mov    %esp,%ebp
c010467b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c010467e:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104683:	8b 40 08             	mov    0x8(%eax),%eax
c0104686:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104689:	89 54 24 04          	mov    %edx,0x4(%esp)
c010468d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104690:	89 14 24             	mov    %edx,(%esp)
c0104693:	ff d0                	call   *%eax
}
c0104695:	c9                   	leave  
c0104696:	c3                   	ret    

c0104697 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104697:	55                   	push   %ebp
c0104698:	89 e5                	mov    %esp,%ebp
c010469a:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c010469d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c01046a4:	e8 2e fe ff ff       	call   c01044d7 <__intr_save>
c01046a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c01046ac:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c01046b1:	8b 40 0c             	mov    0xc(%eax),%eax
c01046b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01046b7:	89 14 24             	mov    %edx,(%esp)
c01046ba:	ff d0                	call   *%eax
c01046bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c01046bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046c2:	89 04 24             	mov    %eax,(%esp)
c01046c5:	e8 37 fe ff ff       	call   c0104501 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01046ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046ce:	75 2d                	jne    c01046fd <alloc_pages+0x66>
c01046d0:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01046d4:	77 27                	ja     c01046fd <alloc_pages+0x66>
c01046d6:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c01046db:	85 c0                	test   %eax,%eax
c01046dd:	74 1e                	je     c01046fd <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c01046df:	8b 55 08             	mov    0x8(%ebp),%edx
c01046e2:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01046e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046ee:	00 
c01046ef:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046f3:	89 04 24             	mov    %eax,(%esp)
c01046f6:	e8 98 1a 00 00       	call   c0106193 <swap_out>
    }
c01046fb:	eb a7                	jmp    c01046a4 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104700:	c9                   	leave  
c0104701:	c3                   	ret    

c0104702 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104702:	55                   	push   %ebp
c0104703:	89 e5                	mov    %esp,%ebp
c0104705:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104708:	e8 ca fd ff ff       	call   c01044d7 <__intr_save>
c010470d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104710:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104715:	8b 40 10             	mov    0x10(%eax),%eax
c0104718:	8b 55 0c             	mov    0xc(%ebp),%edx
c010471b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010471f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104722:	89 14 24             	mov    %edx,(%esp)
c0104725:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104727:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472a:	89 04 24             	mov    %eax,(%esp)
c010472d:	e8 cf fd ff ff       	call   c0104501 <__intr_restore>
}
c0104732:	c9                   	leave  
c0104733:	c3                   	ret    

c0104734 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104734:	55                   	push   %ebp
c0104735:	89 e5                	mov    %esp,%ebp
c0104737:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010473a:	e8 98 fd ff ff       	call   c01044d7 <__intr_save>
c010473f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104742:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104747:	8b 40 14             	mov    0x14(%eax),%eax
c010474a:	ff d0                	call   *%eax
c010474c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010474f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104752:	89 04 24             	mov    %eax,(%esp)
c0104755:	e8 a7 fd ff ff       	call   c0104501 <__intr_restore>
    return ret;
c010475a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010475d:	c9                   	leave  
c010475e:	c3                   	ret    

c010475f <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010475f:	55                   	push   %ebp
c0104760:	89 e5                	mov    %esp,%ebp
c0104762:	57                   	push   %edi
c0104763:	56                   	push   %esi
c0104764:	53                   	push   %ebx
c0104765:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010476b:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104772:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104779:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104780:	c7 04 24 f7 97 10 c0 	movl   $0xc01097f7,(%esp)
c0104787:	e8 bf bb ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010478c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104793:	e9 15 01 00 00       	jmp    c01048ad <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104798:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010479b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010479e:	89 d0                	mov    %edx,%eax
c01047a0:	c1 e0 02             	shl    $0x2,%eax
c01047a3:	01 d0                	add    %edx,%eax
c01047a5:	c1 e0 02             	shl    $0x2,%eax
c01047a8:	01 c8                	add    %ecx,%eax
c01047aa:	8b 50 08             	mov    0x8(%eax),%edx
c01047ad:	8b 40 04             	mov    0x4(%eax),%eax
c01047b0:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01047b3:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01047b6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047bc:	89 d0                	mov    %edx,%eax
c01047be:	c1 e0 02             	shl    $0x2,%eax
c01047c1:	01 d0                	add    %edx,%eax
c01047c3:	c1 e0 02             	shl    $0x2,%eax
c01047c6:	01 c8                	add    %ecx,%eax
c01047c8:	8b 48 0c             	mov    0xc(%eax),%ecx
c01047cb:	8b 58 10             	mov    0x10(%eax),%ebx
c01047ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01047d1:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01047d4:	01 c8                	add    %ecx,%eax
c01047d6:	11 da                	adc    %ebx,%edx
c01047d8:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01047db:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01047de:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047e4:	89 d0                	mov    %edx,%eax
c01047e6:	c1 e0 02             	shl    $0x2,%eax
c01047e9:	01 d0                	add    %edx,%eax
c01047eb:	c1 e0 02             	shl    $0x2,%eax
c01047ee:	01 c8                	add    %ecx,%eax
c01047f0:	83 c0 14             	add    $0x14,%eax
c01047f3:	8b 00                	mov    (%eax),%eax
c01047f5:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01047fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01047fe:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104801:	83 c0 ff             	add    $0xffffffff,%eax
c0104804:	83 d2 ff             	adc    $0xffffffff,%edx
c0104807:	89 c6                	mov    %eax,%esi
c0104809:	89 d7                	mov    %edx,%edi
c010480b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010480e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104811:	89 d0                	mov    %edx,%eax
c0104813:	c1 e0 02             	shl    $0x2,%eax
c0104816:	01 d0                	add    %edx,%eax
c0104818:	c1 e0 02             	shl    $0x2,%eax
c010481b:	01 c8                	add    %ecx,%eax
c010481d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104820:	8b 58 10             	mov    0x10(%eax),%ebx
c0104823:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104829:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c010482d:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104831:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104835:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104838:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010483b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010483f:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104843:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104847:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c010484b:	c7 04 24 04 98 10 c0 	movl   $0xc0109804,(%esp)
c0104852:	e8 f4 ba ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104857:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010485a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010485d:	89 d0                	mov    %edx,%eax
c010485f:	c1 e0 02             	shl    $0x2,%eax
c0104862:	01 d0                	add    %edx,%eax
c0104864:	c1 e0 02             	shl    $0x2,%eax
c0104867:	01 c8                	add    %ecx,%eax
c0104869:	83 c0 14             	add    $0x14,%eax
c010486c:	8b 00                	mov    (%eax),%eax
c010486e:	83 f8 01             	cmp    $0x1,%eax
c0104871:	75 36                	jne    c01048a9 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104873:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104876:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104879:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010487c:	77 2b                	ja     c01048a9 <page_init+0x14a>
c010487e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104881:	72 05                	jb     c0104888 <page_init+0x129>
c0104883:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104886:	73 21                	jae    c01048a9 <page_init+0x14a>
c0104888:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010488c:	77 1b                	ja     c01048a9 <page_init+0x14a>
c010488e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104892:	72 09                	jb     c010489d <page_init+0x13e>
c0104894:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c010489b:	77 0c                	ja     c01048a9 <page_init+0x14a>
                maxpa = end;
c010489d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01048a0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01048a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01048a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01048a9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01048ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01048b0:	8b 00                	mov    (%eax),%eax
c01048b2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01048b5:	0f 8f dd fe ff ff    	jg     c0104798 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01048bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01048bf:	72 1d                	jb     c01048de <page_init+0x17f>
c01048c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01048c5:	77 09                	ja     c01048d0 <page_init+0x171>
c01048c7:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01048ce:	76 0e                	jbe    c01048de <page_init+0x17f>
        maxpa = KMEMSIZE;
c01048d0:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01048d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01048de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01048e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048e4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01048e8:	c1 ea 0c             	shr    $0xc,%edx
c01048eb:	a3 20 0a 12 c0       	mov    %eax,0xc0120a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01048f0:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01048f7:	b8 b0 0b 12 c0       	mov    $0xc0120bb0,%eax
c01048fc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01048ff:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104902:	01 d0                	add    %edx,%eax
c0104904:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104907:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010490a:	ba 00 00 00 00       	mov    $0x0,%edx
c010490f:	f7 75 ac             	divl   -0x54(%ebp)
c0104912:	89 d0                	mov    %edx,%eax
c0104914:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104917:	29 c2                	sub    %eax,%edx
c0104919:	89 d0                	mov    %edx,%eax
c010491b:	a3 d4 0a 12 c0       	mov    %eax,0xc0120ad4

    for (i = 0; i < npage; i ++) {
c0104920:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104927:	eb 27                	jmp    c0104950 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104929:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c010492e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104931:	c1 e2 05             	shl    $0x5,%edx
c0104934:	01 d0                	add    %edx,%eax
c0104936:	83 c0 04             	add    $0x4,%eax
c0104939:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104940:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104943:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104946:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104949:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010494c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104950:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104953:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104958:	39 c2                	cmp    %eax,%edx
c010495a:	72 cd                	jb     c0104929 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010495c:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104961:	c1 e0 05             	shl    $0x5,%eax
c0104964:	89 c2                	mov    %eax,%edx
c0104966:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c010496b:	01 d0                	add    %edx,%eax
c010496d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104970:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104977:	77 23                	ja     c010499c <page_init+0x23d>
c0104979:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010497c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104980:	c7 44 24 08 90 97 10 	movl   $0xc0109790,0x8(%esp)
c0104987:	c0 
c0104988:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c010498f:	00 
c0104990:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0104997:	e8 40 c3 ff ff       	call   c0100cdc <__panic>
c010499c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010499f:	05 00 00 00 40       	add    $0x40000000,%eax
c01049a4:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01049a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01049ae:	e9 74 01 00 00       	jmp    c0104b27 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01049b3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049b9:	89 d0                	mov    %edx,%eax
c01049bb:	c1 e0 02             	shl    $0x2,%eax
c01049be:	01 d0                	add    %edx,%eax
c01049c0:	c1 e0 02             	shl    $0x2,%eax
c01049c3:	01 c8                	add    %ecx,%eax
c01049c5:	8b 50 08             	mov    0x8(%eax),%edx
c01049c8:	8b 40 04             	mov    0x4(%eax),%eax
c01049cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01049ce:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01049d1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049d7:	89 d0                	mov    %edx,%eax
c01049d9:	c1 e0 02             	shl    $0x2,%eax
c01049dc:	01 d0                	add    %edx,%eax
c01049de:	c1 e0 02             	shl    $0x2,%eax
c01049e1:	01 c8                	add    %ecx,%eax
c01049e3:	8b 48 0c             	mov    0xc(%eax),%ecx
c01049e6:	8b 58 10             	mov    0x10(%eax),%ebx
c01049e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01049ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01049ef:	01 c8                	add    %ecx,%eax
c01049f1:	11 da                	adc    %ebx,%edx
c01049f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01049f6:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01049f9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049ff:	89 d0                	mov    %edx,%eax
c0104a01:	c1 e0 02             	shl    $0x2,%eax
c0104a04:	01 d0                	add    %edx,%eax
c0104a06:	c1 e0 02             	shl    $0x2,%eax
c0104a09:	01 c8                	add    %ecx,%eax
c0104a0b:	83 c0 14             	add    $0x14,%eax
c0104a0e:	8b 00                	mov    (%eax),%eax
c0104a10:	83 f8 01             	cmp    $0x1,%eax
c0104a13:	0f 85 0a 01 00 00    	jne    c0104b23 <page_init+0x3c4>
            if (begin < freemem) {
c0104a19:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a1c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a21:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104a24:	72 17                	jb     c0104a3d <page_init+0x2de>
c0104a26:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104a29:	77 05                	ja     c0104a30 <page_init+0x2d1>
c0104a2b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104a2e:	76 0d                	jbe    c0104a3d <page_init+0x2de>
                begin = freemem;
c0104a30:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a33:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a36:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104a3d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104a41:	72 1d                	jb     c0104a60 <page_init+0x301>
c0104a43:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104a47:	77 09                	ja     c0104a52 <page_init+0x2f3>
c0104a49:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104a50:	76 0e                	jbe    c0104a60 <page_init+0x301>
                end = KMEMSIZE;
c0104a52:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104a59:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104a60:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a66:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a69:	0f 87 b4 00 00 00    	ja     c0104b23 <page_init+0x3c4>
c0104a6f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a72:	72 09                	jb     c0104a7d <page_init+0x31e>
c0104a74:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104a77:	0f 83 a6 00 00 00    	jae    c0104b23 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104a7d:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104a84:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a87:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104a8a:	01 d0                	add    %edx,%eax
c0104a8c:	83 e8 01             	sub    $0x1,%eax
c0104a8f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a92:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104a95:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a9a:	f7 75 9c             	divl   -0x64(%ebp)
c0104a9d:	89 d0                	mov    %edx,%eax
c0104a9f:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104aa2:	29 c2                	sub    %eax,%edx
c0104aa4:	89 d0                	mov    %edx,%eax
c0104aa6:	ba 00 00 00 00       	mov    $0x0,%edx
c0104aab:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104aae:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104ab1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104ab4:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104ab7:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104aba:	ba 00 00 00 00       	mov    $0x0,%edx
c0104abf:	89 c7                	mov    %eax,%edi
c0104ac1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104ac7:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104aca:	89 d0                	mov    %edx,%eax
c0104acc:	83 e0 00             	and    $0x0,%eax
c0104acf:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104ad2:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104ad5:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104ad8:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104adb:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104ade:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ae1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ae4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104ae7:	77 3a                	ja     c0104b23 <page_init+0x3c4>
c0104ae9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104aec:	72 05                	jb     c0104af3 <page_init+0x394>
c0104aee:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104af1:	73 30                	jae    c0104b23 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104af3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104af6:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104af9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104afc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104aff:	29 c8                	sub    %ecx,%eax
c0104b01:	19 da                	sbb    %ebx,%edx
c0104b03:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104b07:	c1 ea 0c             	shr    $0xc,%edx
c0104b0a:	89 c3                	mov    %eax,%ebx
c0104b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b0f:	89 04 24             	mov    %eax,(%esp)
c0104b12:	e8 5a f8 ff ff       	call   c0104371 <pa2page>
c0104b17:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104b1b:	89 04 24             	mov    %eax,(%esp)
c0104b1e:	e8 55 fb ff ff       	call   c0104678 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104b23:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104b27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104b2a:	8b 00                	mov    (%eax),%eax
c0104b2c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104b2f:	0f 8f 7e fe ff ff    	jg     c01049b3 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104b35:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104b3b:	5b                   	pop    %ebx
c0104b3c:	5e                   	pop    %esi
c0104b3d:	5f                   	pop    %edi
c0104b3e:	5d                   	pop    %ebp
c0104b3f:	c3                   	ret    

c0104b40 <enable_paging>:

static void
enable_paging(void) {
c0104b40:	55                   	push   %ebp
c0104b41:	89 e5                	mov    %esp,%ebp
c0104b43:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104b46:	a1 d0 0a 12 c0       	mov    0xc0120ad0,%eax
c0104b4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104b4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104b51:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104b54:	0f 20 c0             	mov    %cr0,%eax
c0104b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104b5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104b60:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104b67:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b74:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104b77:	c9                   	leave  
c0104b78:	c3                   	ret    

c0104b79 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104b79:	55                   	push   %ebp
c0104b7a:	89 e5                	mov    %esp,%ebp
c0104b7c:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104b7f:	8b 45 14             	mov    0x14(%ebp),%eax
c0104b82:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b85:	31 d0                	xor    %edx,%eax
c0104b87:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b8c:	85 c0                	test   %eax,%eax
c0104b8e:	74 24                	je     c0104bb4 <boot_map_segment+0x3b>
c0104b90:	c7 44 24 0c 42 98 10 	movl   $0xc0109842,0xc(%esp)
c0104b97:	c0 
c0104b98:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0104b9f:	c0 
c0104ba0:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104ba7:	00 
c0104ba8:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0104baf:	e8 28 c1 ff ff       	call   c0100cdc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104bb4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bbe:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104bc3:	89 c2                	mov    %eax,%edx
c0104bc5:	8b 45 10             	mov    0x10(%ebp),%eax
c0104bc8:	01 c2                	add    %eax,%edx
c0104bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bcd:	01 d0                	add    %edx,%eax
c0104bcf:	83 e8 01             	sub    $0x1,%eax
c0104bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bd8:	ba 00 00 00 00       	mov    $0x0,%edx
c0104bdd:	f7 75 f0             	divl   -0x10(%ebp)
c0104be0:	89 d0                	mov    %edx,%eax
c0104be2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104be5:	29 c2                	sub    %eax,%edx
c0104be7:	89 d0                	mov    %edx,%eax
c0104be9:	c1 e8 0c             	shr    $0xc,%eax
c0104bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104bef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bf2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104bf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104bf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bfd:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104c00:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c0e:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104c11:	eb 6b                	jmp    c0104c7e <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104c13:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104c1a:	00 
c0104c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c25:	89 04 24             	mov    %eax,(%esp)
c0104c28:	e8 cc 01 00 00       	call   c0104df9 <get_pte>
c0104c2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104c30:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104c34:	75 24                	jne    c0104c5a <boot_map_segment+0xe1>
c0104c36:	c7 44 24 0c 6e 98 10 	movl   $0xc010986e,0xc(%esp)
c0104c3d:	c0 
c0104c3e:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0104c45:	c0 
c0104c46:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104c4d:	00 
c0104c4e:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0104c55:	e8 82 c0 ff ff       	call   c0100cdc <__panic>
        *ptep = pa | PTE_P | perm;
c0104c5a:	8b 45 18             	mov    0x18(%ebp),%eax
c0104c5d:	8b 55 14             	mov    0x14(%ebp),%edx
c0104c60:	09 d0                	or     %edx,%eax
c0104c62:	83 c8 01             	or     $0x1,%eax
c0104c65:	89 c2                	mov    %eax,%edx
c0104c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c6a:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104c6c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104c70:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104c77:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104c7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c82:	75 8f                	jne    c0104c13 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104c84:	c9                   	leave  
c0104c85:	c3                   	ret    

c0104c86 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104c86:	55                   	push   %ebp
c0104c87:	89 e5                	mov    %esp,%ebp
c0104c89:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104c8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c93:	e8 ff f9 ff ff       	call   c0104697 <alloc_pages>
c0104c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104c9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c9f:	75 1c                	jne    c0104cbd <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104ca1:	c7 44 24 08 7b 98 10 	movl   $0xc010987b,0x8(%esp)
c0104ca8:	c0 
c0104ca9:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104cb0:	00 
c0104cb1:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0104cb8:	e8 1f c0 ff ff       	call   c0100cdc <__panic>
    }
    return page2kva(p);
c0104cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cc0:	89 04 24             	mov    %eax,(%esp)
c0104cc3:	e8 ee f6 ff ff       	call   c01043b6 <page2kva>
}
c0104cc8:	c9                   	leave  
c0104cc9:	c3                   	ret    

c0104cca <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104cca:	55                   	push   %ebp
c0104ccb:	89 e5                	mov    %esp,%ebp
c0104ccd:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104cd0:	e8 70 f9 ff ff       	call   c0104645 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104cd5:	e8 85 fa ff ff       	call   c010475f <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104cda:	e8 32 05 00 00       	call   c0105211 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104cdf:	e8 a2 ff ff ff       	call   c0104c86 <boot_alloc_page>
c0104ce4:	a3 24 0a 12 c0       	mov    %eax,0xc0120a24
    memset(boot_pgdir, 0, PGSIZE);
c0104ce9:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104cee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104cf5:	00 
c0104cf6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104cfd:	00 
c0104cfe:	89 04 24             	mov    %eax,(%esp)
c0104d01:	e8 cb 3c 00 00       	call   c01089d1 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104d06:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d0e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104d15:	77 23                	ja     c0104d3a <pmm_init+0x70>
c0104d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d1e:	c7 44 24 08 90 97 10 	movl   $0xc0109790,0x8(%esp)
c0104d25:	c0 
c0104d26:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104d2d:	00 
c0104d2e:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0104d35:	e8 a2 bf ff ff       	call   c0100cdc <__panic>
c0104d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d3d:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d42:	a3 d0 0a 12 c0       	mov    %eax,0xc0120ad0

    check_pgdir();
c0104d47:	e8 e3 04 00 00       	call   c010522f <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104d4c:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104d51:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104d57:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104d5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d5f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104d66:	77 23                	ja     c0104d8b <pmm_init+0xc1>
c0104d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d6f:	c7 44 24 08 90 97 10 	movl   $0xc0109790,0x8(%esp)
c0104d76:	c0 
c0104d77:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104d7e:	00 
c0104d7f:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0104d86:	e8 51 bf ff ff       	call   c0100cdc <__panic>
c0104d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d8e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d93:	83 c8 03             	or     $0x3,%eax
c0104d96:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104d98:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104d9d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104da4:	00 
c0104da5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104dac:	00 
c0104dad:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104db4:	38 
c0104db5:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104dbc:	c0 
c0104dbd:	89 04 24             	mov    %eax,(%esp)
c0104dc0:	e8 b4 fd ff ff       	call   c0104b79 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104dc5:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104dca:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c0104dd0:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104dd6:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104dd8:	e8 63 fd ff ff       	call   c0104b40 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104ddd:	e8 74 f7 ff ff       	call   c0104556 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104de2:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104de7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104ded:	e8 d8 0a 00 00       	call   c01058ca <check_boot_pgdir>

    print_pgdir();
c0104df2:	e8 65 0f 00 00       	call   c0105d5c <print_pgdir>

}
c0104df7:	c9                   	leave  
c0104df8:	c3                   	ret    

c0104df9 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104df9:	55                   	push   %ebp
c0104dfa:	89 e5                	mov    %esp,%ebp
c0104dfc:	83 ec 38             	sub    $0x38,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
	pde_t *pdep = &pgdir[PDX(la)];
c0104dff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e02:	c1 e8 16             	shr    $0x16,%eax
c0104e05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e0f:	01 d0                	add    %edx,%eax
c0104e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(*pdep & PTE_P))
c0104e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e17:	8b 00                	mov    (%eax),%eax
c0104e19:	83 e0 01             	and    $0x1,%eax
c0104e1c:	85 c0                	test   %eax,%eax
c0104e1e:	0f 85 af 00 00 00    	jne    c0104ed3 <get_pte+0xda>
	{
		struct Page *p;
		p = alloc_page();
c0104e24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e2b:	e8 67 f8 ff ff       	call   c0104697 <alloc_pages>
c0104e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((!create) || (p  == NULL))
c0104e33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104e37:	74 06                	je     c0104e3f <get_pte+0x46>
c0104e39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e3d:	75 0a                	jne    c0104e49 <get_pte+0x50>
		{
			return NULL;
c0104e3f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e44:	e9 e6 00 00 00       	jmp    c0104f2f <get_pte+0x136>
		}
		set_page_ref(p, 1);
c0104e49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e50:	00 
c0104e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e54:	89 04 24             	mov    %eax,(%esp)
c0104e57:	e8 40 f6 ff ff       	call   c010449c <set_page_ref>
		uintptr_t pa = page2pa(p);
c0104e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e5f:	89 04 24             	mov    %eax,(%esp)
c0104e62:	e8 f4 f4 ff ff       	call   c010435b <page2pa>
c0104e67:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
c0104e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e70:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e73:	c1 e8 0c             	shr    $0xc,%eax
c0104e76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e79:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104e7e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104e81:	72 23                	jb     c0104ea6 <get_pte+0xad>
c0104e83:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e86:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e8a:	c7 44 24 08 6c 97 10 	movl   $0xc010976c,0x8(%esp)
c0104e91:	c0 
c0104e92:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c0104e99:	00 
c0104e9a:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0104ea1:	e8 36 be ff ff       	call   c0100cdc <__panic>
c0104ea6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ea9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104eae:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104eb5:	00 
c0104eb6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ebd:	00 
c0104ebe:	89 04 24             	mov    %eax,(%esp)
c0104ec1:	e8 0b 3b 00 00       	call   c01089d1 <memset>
		*pdep = pa | PTE_U | PTE_W | PTE_P;
c0104ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ec9:	83 c8 07             	or     $0x7,%eax
c0104ecc:	89 c2                	mov    %eax,%edx
c0104ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed1:	89 10                	mov    %edx,(%eax)
	}
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed6:	8b 00                	mov    (%eax),%eax
c0104ed8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104edd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ee3:	c1 e8 0c             	shr    $0xc,%eax
c0104ee6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ee9:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104eee:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104ef1:	72 23                	jb     c0104f16 <get_pte+0x11d>
c0104ef3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ef6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104efa:	c7 44 24 08 6c 97 10 	movl   $0xc010976c,0x8(%esp)
c0104f01:	c0 
c0104f02:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
c0104f09:	00 
c0104f0a:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0104f11:	e8 c6 bd ff ff       	call   c0100cdc <__panic>
c0104f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f19:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104f21:	c1 ea 0c             	shr    $0xc,%edx
c0104f24:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104f2a:	c1 e2 02             	shl    $0x2,%edx
c0104f2d:	01 d0                	add    %edx,%eax
}
c0104f2f:	c9                   	leave  
c0104f30:	c3                   	ret    

c0104f31 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104f31:	55                   	push   %ebp
c0104f32:	89 e5                	mov    %esp,%ebp
c0104f34:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104f37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f3e:	00 
c0104f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f46:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f49:	89 04 24             	mov    %eax,(%esp)
c0104f4c:	e8 a8 fe ff ff       	call   c0104df9 <get_pte>
c0104f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104f54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104f58:	74 08                	je     c0104f62 <get_page+0x31>
        *ptep_store = ptep;
c0104f5a:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f60:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104f62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f66:	74 1b                	je     c0104f83 <get_page+0x52>
c0104f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f6b:	8b 00                	mov    (%eax),%eax
c0104f6d:	83 e0 01             	and    $0x1,%eax
c0104f70:	85 c0                	test   %eax,%eax
c0104f72:	74 0f                	je     c0104f83 <get_page+0x52>
        return pa2page(*ptep);
c0104f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f77:	8b 00                	mov    (%eax),%eax
c0104f79:	89 04 24             	mov    %eax,(%esp)
c0104f7c:	e8 f0 f3 ff ff       	call   c0104371 <pa2page>
c0104f81:	eb 05                	jmp    c0104f88 <get_page+0x57>
    }
    return NULL;
c0104f83:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f88:	c9                   	leave  
c0104f89:	c3                   	ret    

c0104f8a <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104f8a:	55                   	push   %ebp
c0104f8b:	89 e5                	mov    %esp,%ebp
c0104f8d:	83 ec 28             	sub    $0x28,%esp
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
	if (*ptep & PTE_P)
c0104f90:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f93:	8b 00                	mov    (%eax),%eax
c0104f95:	83 e0 01             	and    $0x1,%eax
c0104f98:	85 c0                	test   %eax,%eax
c0104f9a:	74 4d                	je     c0104fe9 <page_remove_pte+0x5f>
	{
		struct Page *p = pte2page(*ptep);
c0104f9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f9f:	8b 00                	mov    (%eax),%eax
c0104fa1:	89 04 24             	mov    %eax,(%esp)
c0104fa4:	e8 ab f4 ff ff       	call   c0104454 <pte2page>
c0104fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (page_ref_dec(p) == 0)
c0104fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104faf:	89 04 24             	mov    %eax,(%esp)
c0104fb2:	e8 09 f5 ff ff       	call   c01044c0 <page_ref_dec>
c0104fb7:	85 c0                	test   %eax,%eax
c0104fb9:	75 13                	jne    c0104fce <page_remove_pte+0x44>
		{
			free_page(p);
c0104fbb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fc2:	00 
c0104fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fc6:	89 04 24             	mov    %eax,(%esp)
c0104fc9:	e8 34 f7 ff ff       	call   c0104702 <free_pages>
		}
		*ptep = 0;
c0104fce:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
c0104fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fde:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fe1:	89 04 24             	mov    %eax,(%esp)
c0104fe4:	e8 00 01 00 00       	call   c01050e9 <tlb_invalidate>
	}
	return;
c0104fe9:	90                   	nop
}
c0104fea:	c9                   	leave  
c0104feb:	c3                   	ret    

c0104fec <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104fec:	55                   	push   %ebp
c0104fed:	89 e5                	mov    %esp,%ebp
c0104fef:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104ff2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ff9:	00 
c0104ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105001:	8b 45 08             	mov    0x8(%ebp),%eax
c0105004:	89 04 24             	mov    %eax,(%esp)
c0105007:	e8 ed fd ff ff       	call   c0104df9 <get_pte>
c010500c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010500f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105013:	74 19                	je     c010502e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105015:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105018:	89 44 24 08          	mov    %eax,0x8(%esp)
c010501c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010501f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105023:	8b 45 08             	mov    0x8(%ebp),%eax
c0105026:	89 04 24             	mov    %eax,(%esp)
c0105029:	e8 5c ff ff ff       	call   c0104f8a <page_remove_pte>
    }
}
c010502e:	c9                   	leave  
c010502f:	c3                   	ret    

c0105030 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105030:	55                   	push   %ebp
c0105031:	89 e5                	mov    %esp,%ebp
c0105033:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105036:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010503d:	00 
c010503e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105041:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105045:	8b 45 08             	mov    0x8(%ebp),%eax
c0105048:	89 04 24             	mov    %eax,(%esp)
c010504b:	e8 a9 fd ff ff       	call   c0104df9 <get_pte>
c0105050:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105057:	75 0a                	jne    c0105063 <page_insert+0x33>
        return -E_NO_MEM;
c0105059:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010505e:	e9 84 00 00 00       	jmp    c01050e7 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105063:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105066:	89 04 24             	mov    %eax,(%esp)
c0105069:	e8 3b f4 ff ff       	call   c01044a9 <page_ref_inc>
    if (*ptep & PTE_P) {
c010506e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105071:	8b 00                	mov    (%eax),%eax
c0105073:	83 e0 01             	and    $0x1,%eax
c0105076:	85 c0                	test   %eax,%eax
c0105078:	74 3e                	je     c01050b8 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010507a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010507d:	8b 00                	mov    (%eax),%eax
c010507f:	89 04 24             	mov    %eax,(%esp)
c0105082:	e8 cd f3 ff ff       	call   c0104454 <pte2page>
c0105087:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010508a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010508d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105090:	75 0d                	jne    c010509f <page_insert+0x6f>
            page_ref_dec(page);
c0105092:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105095:	89 04 24             	mov    %eax,(%esp)
c0105098:	e8 23 f4 ff ff       	call   c01044c0 <page_ref_dec>
c010509d:	eb 19                	jmp    c01050b8 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010509f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050a2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01050a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01050a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01050b0:	89 04 24             	mov    %eax,(%esp)
c01050b3:	e8 d2 fe ff ff       	call   c0104f8a <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01050b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050bb:	89 04 24             	mov    %eax,(%esp)
c01050be:	e8 98 f2 ff ff       	call   c010435b <page2pa>
c01050c3:	0b 45 14             	or     0x14(%ebp),%eax
c01050c6:	83 c8 01             	or     $0x1,%eax
c01050c9:	89 c2                	mov    %eax,%edx
c01050cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050ce:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01050d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01050d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01050da:	89 04 24             	mov    %eax,(%esp)
c01050dd:	e8 07 00 00 00       	call   c01050e9 <tlb_invalidate>
    return 0;
c01050e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050e7:	c9                   	leave  
c01050e8:	c3                   	ret    

c01050e9 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01050e9:	55                   	push   %ebp
c01050ea:	89 e5                	mov    %esp,%ebp
c01050ec:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01050ef:	0f 20 d8             	mov    %cr3,%eax
c01050f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01050f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01050f8:	89 c2                	mov    %eax,%edx
c01050fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01050fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105100:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105107:	77 23                	ja     c010512c <tlb_invalidate+0x43>
c0105109:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010510c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105110:	c7 44 24 08 90 97 10 	movl   $0xc0109790,0x8(%esp)
c0105117:	c0 
c0105118:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c010511f:	00 
c0105120:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105127:	e8 b0 bb ff ff       	call   c0100cdc <__panic>
c010512c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010512f:	05 00 00 00 40       	add    $0x40000000,%eax
c0105134:	39 c2                	cmp    %eax,%edx
c0105136:	75 0c                	jne    c0105144 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105138:	8b 45 0c             	mov    0xc(%ebp),%eax
c010513b:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010513e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105141:	0f 01 38             	invlpg (%eax)
    }
}
c0105144:	c9                   	leave  
c0105145:	c3                   	ret    

c0105146 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105146:	55                   	push   %ebp
c0105147:	89 e5                	mov    %esp,%ebp
c0105149:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c010514c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105153:	e8 3f f5 ff ff       	call   c0104697 <alloc_pages>
c0105158:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c010515b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010515f:	0f 84 a7 00 00 00    	je     c010520c <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105165:	8b 45 10             	mov    0x10(%ebp),%eax
c0105168:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010516c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010516f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105173:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105176:	89 44 24 04          	mov    %eax,0x4(%esp)
c010517a:	8b 45 08             	mov    0x8(%ebp),%eax
c010517d:	89 04 24             	mov    %eax,(%esp)
c0105180:	e8 ab fe ff ff       	call   c0105030 <page_insert>
c0105185:	85 c0                	test   %eax,%eax
c0105187:	74 1a                	je     c01051a3 <pgdir_alloc_page+0x5d>
            free_page(page);
c0105189:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105190:	00 
c0105191:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105194:	89 04 24             	mov    %eax,(%esp)
c0105197:	e8 66 f5 ff ff       	call   c0104702 <free_pages>
            return NULL;
c010519c:	b8 00 00 00 00       	mov    $0x0,%eax
c01051a1:	eb 6c                	jmp    c010520f <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01051a3:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c01051a8:	85 c0                	test   %eax,%eax
c01051aa:	74 60                	je     c010520c <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01051ac:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01051b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01051b8:	00 
c01051b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01051bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01051c0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051c3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051c7:	89 04 24             	mov    %eax,(%esp)
c01051ca:	e8 78 0f 00 00       	call   c0106147 <swap_map_swappable>
            page->pra_vaddr=la;
c01051cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051d2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051d5:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01051d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051db:	89 04 24             	mov    %eax,(%esp)
c01051de:	e8 af f2 ff ff       	call   c0104492 <page_ref>
c01051e3:	83 f8 01             	cmp    $0x1,%eax
c01051e6:	74 24                	je     c010520c <pgdir_alloc_page+0xc6>
c01051e8:	c7 44 24 0c 94 98 10 	movl   $0xc0109894,0xc(%esp)
c01051ef:	c0 
c01051f0:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01051f7:	c0 
c01051f8:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c01051ff:	00 
c0105200:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105207:	e8 d0 ba ff ff       	call   c0100cdc <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c010520c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010520f:	c9                   	leave  
c0105210:	c3                   	ret    

c0105211 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105211:	55                   	push   %ebp
c0105212:	89 e5                	mov    %esp,%ebp
c0105214:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105217:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c010521c:	8b 40 18             	mov    0x18(%eax),%eax
c010521f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105221:	c7 04 24 a8 98 10 c0 	movl   $0xc01098a8,(%esp)
c0105228:	e8 1e b1 ff ff       	call   c010034b <cprintf>
}
c010522d:	c9                   	leave  
c010522e:	c3                   	ret    

c010522f <check_pgdir>:

static void
check_pgdir(void) {
c010522f:	55                   	push   %ebp
c0105230:	89 e5                	mov    %esp,%ebp
c0105232:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105235:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c010523a:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010523f:	76 24                	jbe    c0105265 <check_pgdir+0x36>
c0105241:	c7 44 24 0c c7 98 10 	movl   $0xc01098c7,0xc(%esp)
c0105248:	c0 
c0105249:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105250:	c0 
c0105251:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0105258:	00 
c0105259:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105260:	e8 77 ba ff ff       	call   c0100cdc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105265:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010526a:	85 c0                	test   %eax,%eax
c010526c:	74 0e                	je     c010527c <check_pgdir+0x4d>
c010526e:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105273:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105278:	85 c0                	test   %eax,%eax
c010527a:	74 24                	je     c01052a0 <check_pgdir+0x71>
c010527c:	c7 44 24 0c e4 98 10 	movl   $0xc01098e4,0xc(%esp)
c0105283:	c0 
c0105284:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010528b:	c0 
c010528c:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0105293:	00 
c0105294:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010529b:	e8 3c ba ff ff       	call   c0100cdc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01052a0:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01052a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052ac:	00 
c01052ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01052b4:	00 
c01052b5:	89 04 24             	mov    %eax,(%esp)
c01052b8:	e8 74 fc ff ff       	call   c0104f31 <get_page>
c01052bd:	85 c0                	test   %eax,%eax
c01052bf:	74 24                	je     c01052e5 <check_pgdir+0xb6>
c01052c1:	c7 44 24 0c 1c 99 10 	movl   $0xc010991c,0xc(%esp)
c01052c8:	c0 
c01052c9:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01052d0:	c0 
c01052d1:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c01052d8:	00 
c01052d9:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01052e0:	e8 f7 b9 ff ff       	call   c0100cdc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01052e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052ec:	e8 a6 f3 ff ff       	call   c0104697 <alloc_pages>
c01052f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01052f4:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01052f9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105300:	00 
c0105301:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105308:	00 
c0105309:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010530c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105310:	89 04 24             	mov    %eax,(%esp)
c0105313:	e8 18 fd ff ff       	call   c0105030 <page_insert>
c0105318:	85 c0                	test   %eax,%eax
c010531a:	74 24                	je     c0105340 <check_pgdir+0x111>
c010531c:	c7 44 24 0c 44 99 10 	movl   $0xc0109944,0xc(%esp)
c0105323:	c0 
c0105324:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010532b:	c0 
c010532c:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0105333:	00 
c0105334:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010533b:	e8 9c b9 ff ff       	call   c0100cdc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105340:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105345:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010534c:	00 
c010534d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105354:	00 
c0105355:	89 04 24             	mov    %eax,(%esp)
c0105358:	e8 9c fa ff ff       	call   c0104df9 <get_pte>
c010535d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105364:	75 24                	jne    c010538a <check_pgdir+0x15b>
c0105366:	c7 44 24 0c 70 99 10 	movl   $0xc0109970,0xc(%esp)
c010536d:	c0 
c010536e:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105375:	c0 
c0105376:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c010537d:	00 
c010537e:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105385:	e8 52 b9 ff ff       	call   c0100cdc <__panic>
    assert(pa2page(*ptep) == p1);
c010538a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010538d:	8b 00                	mov    (%eax),%eax
c010538f:	89 04 24             	mov    %eax,(%esp)
c0105392:	e8 da ef ff ff       	call   c0104371 <pa2page>
c0105397:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010539a:	74 24                	je     c01053c0 <check_pgdir+0x191>
c010539c:	c7 44 24 0c 9d 99 10 	movl   $0xc010999d,0xc(%esp)
c01053a3:	c0 
c01053a4:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01053ab:	c0 
c01053ac:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c01053b3:	00 
c01053b4:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01053bb:	e8 1c b9 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p1) == 1);
c01053c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053c3:	89 04 24             	mov    %eax,(%esp)
c01053c6:	e8 c7 f0 ff ff       	call   c0104492 <page_ref>
c01053cb:	83 f8 01             	cmp    $0x1,%eax
c01053ce:	74 24                	je     c01053f4 <check_pgdir+0x1c5>
c01053d0:	c7 44 24 0c b2 99 10 	movl   $0xc01099b2,0xc(%esp)
c01053d7:	c0 
c01053d8:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01053df:	c0 
c01053e0:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c01053e7:	00 
c01053e8:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01053ef:	e8 e8 b8 ff ff       	call   c0100cdc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01053f4:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01053f9:	8b 00                	mov    (%eax),%eax
c01053fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105400:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105403:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105406:	c1 e8 0c             	shr    $0xc,%eax
c0105409:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010540c:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105411:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105414:	72 23                	jb     c0105439 <check_pgdir+0x20a>
c0105416:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105419:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010541d:	c7 44 24 08 6c 97 10 	movl   $0xc010976c,0x8(%esp)
c0105424:	c0 
c0105425:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c010542c:	00 
c010542d:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105434:	e8 a3 b8 ff ff       	call   c0100cdc <__panic>
c0105439:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010543c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105441:	83 c0 04             	add    $0x4,%eax
c0105444:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105447:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010544c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105453:	00 
c0105454:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010545b:	00 
c010545c:	89 04 24             	mov    %eax,(%esp)
c010545f:	e8 95 f9 ff ff       	call   c0104df9 <get_pte>
c0105464:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105467:	74 24                	je     c010548d <check_pgdir+0x25e>
c0105469:	c7 44 24 0c c4 99 10 	movl   $0xc01099c4,0xc(%esp)
c0105470:	c0 
c0105471:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105478:	c0 
c0105479:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0105480:	00 
c0105481:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105488:	e8 4f b8 ff ff       	call   c0100cdc <__panic>

    p2 = alloc_page();
c010548d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105494:	e8 fe f1 ff ff       	call   c0104697 <alloc_pages>
c0105499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010549c:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01054a1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01054a8:	00 
c01054a9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01054b0:	00 
c01054b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054b4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054b8:	89 04 24             	mov    %eax,(%esp)
c01054bb:	e8 70 fb ff ff       	call   c0105030 <page_insert>
c01054c0:	85 c0                	test   %eax,%eax
c01054c2:	74 24                	je     c01054e8 <check_pgdir+0x2b9>
c01054c4:	c7 44 24 0c ec 99 10 	movl   $0xc01099ec,0xc(%esp)
c01054cb:	c0 
c01054cc:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01054d3:	c0 
c01054d4:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c01054db:	00 
c01054dc:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01054e3:	e8 f4 b7 ff ff       	call   c0100cdc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01054e8:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01054ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01054f4:	00 
c01054f5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01054fc:	00 
c01054fd:	89 04 24             	mov    %eax,(%esp)
c0105500:	e8 f4 f8 ff ff       	call   c0104df9 <get_pte>
c0105505:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105508:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010550c:	75 24                	jne    c0105532 <check_pgdir+0x303>
c010550e:	c7 44 24 0c 24 9a 10 	movl   $0xc0109a24,0xc(%esp)
c0105515:	c0 
c0105516:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010551d:	c0 
c010551e:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0105525:	00 
c0105526:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010552d:	e8 aa b7 ff ff       	call   c0100cdc <__panic>
    assert(*ptep & PTE_U);
c0105532:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105535:	8b 00                	mov    (%eax),%eax
c0105537:	83 e0 04             	and    $0x4,%eax
c010553a:	85 c0                	test   %eax,%eax
c010553c:	75 24                	jne    c0105562 <check_pgdir+0x333>
c010553e:	c7 44 24 0c 54 9a 10 	movl   $0xc0109a54,0xc(%esp)
c0105545:	c0 
c0105546:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010554d:	c0 
c010554e:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0105555:	00 
c0105556:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010555d:	e8 7a b7 ff ff       	call   c0100cdc <__panic>
    assert(*ptep & PTE_W);
c0105562:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105565:	8b 00                	mov    (%eax),%eax
c0105567:	83 e0 02             	and    $0x2,%eax
c010556a:	85 c0                	test   %eax,%eax
c010556c:	75 24                	jne    c0105592 <check_pgdir+0x363>
c010556e:	c7 44 24 0c 62 9a 10 	movl   $0xc0109a62,0xc(%esp)
c0105575:	c0 
c0105576:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010557d:	c0 
c010557e:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0105585:	00 
c0105586:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010558d:	e8 4a b7 ff ff       	call   c0100cdc <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105592:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105597:	8b 00                	mov    (%eax),%eax
c0105599:	83 e0 04             	and    $0x4,%eax
c010559c:	85 c0                	test   %eax,%eax
c010559e:	75 24                	jne    c01055c4 <check_pgdir+0x395>
c01055a0:	c7 44 24 0c 70 9a 10 	movl   $0xc0109a70,0xc(%esp)
c01055a7:	c0 
c01055a8:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01055af:	c0 
c01055b0:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c01055b7:	00 
c01055b8:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01055bf:	e8 18 b7 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 1);
c01055c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055c7:	89 04 24             	mov    %eax,(%esp)
c01055ca:	e8 c3 ee ff ff       	call   c0104492 <page_ref>
c01055cf:	83 f8 01             	cmp    $0x1,%eax
c01055d2:	74 24                	je     c01055f8 <check_pgdir+0x3c9>
c01055d4:	c7 44 24 0c 86 9a 10 	movl   $0xc0109a86,0xc(%esp)
c01055db:	c0 
c01055dc:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01055e3:	c0 
c01055e4:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c01055eb:	00 
c01055ec:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01055f3:	e8 e4 b6 ff ff       	call   c0100cdc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01055f8:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01055fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105604:	00 
c0105605:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010560c:	00 
c010560d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105610:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105614:	89 04 24             	mov    %eax,(%esp)
c0105617:	e8 14 fa ff ff       	call   c0105030 <page_insert>
c010561c:	85 c0                	test   %eax,%eax
c010561e:	74 24                	je     c0105644 <check_pgdir+0x415>
c0105620:	c7 44 24 0c 98 9a 10 	movl   $0xc0109a98,0xc(%esp)
c0105627:	c0 
c0105628:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010562f:	c0 
c0105630:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0105637:	00 
c0105638:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010563f:	e8 98 b6 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p1) == 2);
c0105644:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105647:	89 04 24             	mov    %eax,(%esp)
c010564a:	e8 43 ee ff ff       	call   c0104492 <page_ref>
c010564f:	83 f8 02             	cmp    $0x2,%eax
c0105652:	74 24                	je     c0105678 <check_pgdir+0x449>
c0105654:	c7 44 24 0c c4 9a 10 	movl   $0xc0109ac4,0xc(%esp)
c010565b:	c0 
c010565c:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105663:	c0 
c0105664:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c010566b:	00 
c010566c:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105673:	e8 64 b6 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c0105678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010567b:	89 04 24             	mov    %eax,(%esp)
c010567e:	e8 0f ee ff ff       	call   c0104492 <page_ref>
c0105683:	85 c0                	test   %eax,%eax
c0105685:	74 24                	je     c01056ab <check_pgdir+0x47c>
c0105687:	c7 44 24 0c d6 9a 10 	movl   $0xc0109ad6,0xc(%esp)
c010568e:	c0 
c010568f:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105696:	c0 
c0105697:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c010569e:	00 
c010569f:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01056a6:	e8 31 b6 ff ff       	call   c0100cdc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01056ab:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01056b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056b7:	00 
c01056b8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01056bf:	00 
c01056c0:	89 04 24             	mov    %eax,(%esp)
c01056c3:	e8 31 f7 ff ff       	call   c0104df9 <get_pte>
c01056c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056cf:	75 24                	jne    c01056f5 <check_pgdir+0x4c6>
c01056d1:	c7 44 24 0c 24 9a 10 	movl   $0xc0109a24,0xc(%esp)
c01056d8:	c0 
c01056d9:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01056e0:	c0 
c01056e1:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01056e8:	00 
c01056e9:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01056f0:	e8 e7 b5 ff ff       	call   c0100cdc <__panic>
    assert(pa2page(*ptep) == p1);
c01056f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056f8:	8b 00                	mov    (%eax),%eax
c01056fa:	89 04 24             	mov    %eax,(%esp)
c01056fd:	e8 6f ec ff ff       	call   c0104371 <pa2page>
c0105702:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105705:	74 24                	je     c010572b <check_pgdir+0x4fc>
c0105707:	c7 44 24 0c 9d 99 10 	movl   $0xc010999d,0xc(%esp)
c010570e:	c0 
c010570f:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105716:	c0 
c0105717:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c010571e:	00 
c010571f:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105726:	e8 b1 b5 ff ff       	call   c0100cdc <__panic>
    assert((*ptep & PTE_U) == 0);
c010572b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010572e:	8b 00                	mov    (%eax),%eax
c0105730:	83 e0 04             	and    $0x4,%eax
c0105733:	85 c0                	test   %eax,%eax
c0105735:	74 24                	je     c010575b <check_pgdir+0x52c>
c0105737:	c7 44 24 0c e8 9a 10 	movl   $0xc0109ae8,0xc(%esp)
c010573e:	c0 
c010573f:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105746:	c0 
c0105747:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c010574e:	00 
c010574f:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105756:	e8 81 b5 ff ff       	call   c0100cdc <__panic>

    page_remove(boot_pgdir, 0x0);
c010575b:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105760:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105767:	00 
c0105768:	89 04 24             	mov    %eax,(%esp)
c010576b:	e8 7c f8 ff ff       	call   c0104fec <page_remove>
    assert(page_ref(p1) == 1);
c0105770:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105773:	89 04 24             	mov    %eax,(%esp)
c0105776:	e8 17 ed ff ff       	call   c0104492 <page_ref>
c010577b:	83 f8 01             	cmp    $0x1,%eax
c010577e:	74 24                	je     c01057a4 <check_pgdir+0x575>
c0105780:	c7 44 24 0c b2 99 10 	movl   $0xc01099b2,0xc(%esp)
c0105787:	c0 
c0105788:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010578f:	c0 
c0105790:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105797:	00 
c0105798:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010579f:	e8 38 b5 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c01057a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057a7:	89 04 24             	mov    %eax,(%esp)
c01057aa:	e8 e3 ec ff ff       	call   c0104492 <page_ref>
c01057af:	85 c0                	test   %eax,%eax
c01057b1:	74 24                	je     c01057d7 <check_pgdir+0x5a8>
c01057b3:	c7 44 24 0c d6 9a 10 	movl   $0xc0109ad6,0xc(%esp)
c01057ba:	c0 
c01057bb:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c01057c2:	c0 
c01057c3:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01057ca:	00 
c01057cb:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01057d2:	e8 05 b5 ff ff       	call   c0100cdc <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01057d7:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01057dc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01057e3:	00 
c01057e4:	89 04 24             	mov    %eax,(%esp)
c01057e7:	e8 00 f8 ff ff       	call   c0104fec <page_remove>
    assert(page_ref(p1) == 0);
c01057ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057ef:	89 04 24             	mov    %eax,(%esp)
c01057f2:	e8 9b ec ff ff       	call   c0104492 <page_ref>
c01057f7:	85 c0                	test   %eax,%eax
c01057f9:	74 24                	je     c010581f <check_pgdir+0x5f0>
c01057fb:	c7 44 24 0c fd 9a 10 	movl   $0xc0109afd,0xc(%esp)
c0105802:	c0 
c0105803:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010580a:	c0 
c010580b:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105812:	00 
c0105813:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010581a:	e8 bd b4 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c010581f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105822:	89 04 24             	mov    %eax,(%esp)
c0105825:	e8 68 ec ff ff       	call   c0104492 <page_ref>
c010582a:	85 c0                	test   %eax,%eax
c010582c:	74 24                	je     c0105852 <check_pgdir+0x623>
c010582e:	c7 44 24 0c d6 9a 10 	movl   $0xc0109ad6,0xc(%esp)
c0105835:	c0 
c0105836:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010583d:	c0 
c010583e:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105845:	00 
c0105846:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010584d:	e8 8a b4 ff ff       	call   c0100cdc <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105852:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105857:	8b 00                	mov    (%eax),%eax
c0105859:	89 04 24             	mov    %eax,(%esp)
c010585c:	e8 10 eb ff ff       	call   c0104371 <pa2page>
c0105861:	89 04 24             	mov    %eax,(%esp)
c0105864:	e8 29 ec ff ff       	call   c0104492 <page_ref>
c0105869:	83 f8 01             	cmp    $0x1,%eax
c010586c:	74 24                	je     c0105892 <check_pgdir+0x663>
c010586e:	c7 44 24 0c 10 9b 10 	movl   $0xc0109b10,0xc(%esp)
c0105875:	c0 
c0105876:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010587d:	c0 
c010587e:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105885:	00 
c0105886:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010588d:	e8 4a b4 ff ff       	call   c0100cdc <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105892:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105897:	8b 00                	mov    (%eax),%eax
c0105899:	89 04 24             	mov    %eax,(%esp)
c010589c:	e8 d0 ea ff ff       	call   c0104371 <pa2page>
c01058a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01058a8:	00 
c01058a9:	89 04 24             	mov    %eax,(%esp)
c01058ac:	e8 51 ee ff ff       	call   c0104702 <free_pages>
    boot_pgdir[0] = 0;
c01058b1:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01058b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01058bc:	c7 04 24 36 9b 10 c0 	movl   $0xc0109b36,(%esp)
c01058c3:	e8 83 aa ff ff       	call   c010034b <cprintf>
}
c01058c8:	c9                   	leave  
c01058c9:	c3                   	ret    

c01058ca <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01058ca:	55                   	push   %ebp
c01058cb:	89 e5                	mov    %esp,%ebp
c01058cd:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01058d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01058d7:	e9 ca 00 00 00       	jmp    c01059a6 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01058dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058e5:	c1 e8 0c             	shr    $0xc,%eax
c01058e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058eb:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01058f0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01058f3:	72 23                	jb     c0105918 <check_boot_pgdir+0x4e>
c01058f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058fc:	c7 44 24 08 6c 97 10 	movl   $0xc010976c,0x8(%esp)
c0105903:	c0 
c0105904:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c010590b:	00 
c010590c:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105913:	e8 c4 b3 ff ff       	call   c0100cdc <__panic>
c0105918:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010591b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105920:	89 c2                	mov    %eax,%edx
c0105922:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010592e:	00 
c010592f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105933:	89 04 24             	mov    %eax,(%esp)
c0105936:	e8 be f4 ff ff       	call   c0104df9 <get_pte>
c010593b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010593e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105942:	75 24                	jne    c0105968 <check_boot_pgdir+0x9e>
c0105944:	c7 44 24 0c 50 9b 10 	movl   $0xc0109b50,0xc(%esp)
c010594b:	c0 
c010594c:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105953:	c0 
c0105954:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c010595b:	00 
c010595c:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105963:	e8 74 b3 ff ff       	call   c0100cdc <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105968:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010596b:	8b 00                	mov    (%eax),%eax
c010596d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105972:	89 c2                	mov    %eax,%edx
c0105974:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105977:	39 c2                	cmp    %eax,%edx
c0105979:	74 24                	je     c010599f <check_boot_pgdir+0xd5>
c010597b:	c7 44 24 0c 8d 9b 10 	movl   $0xc0109b8d,0xc(%esp)
c0105982:	c0 
c0105983:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c010598a:	c0 
c010598b:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105992:	00 
c0105993:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c010599a:	e8 3d b3 ff ff       	call   c0100cdc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010599f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01059a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059a9:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01059ae:	39 c2                	cmp    %eax,%edx
c01059b0:	0f 82 26 ff ff ff    	jb     c01058dc <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01059b6:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01059bb:	05 ac 0f 00 00       	add    $0xfac,%eax
c01059c0:	8b 00                	mov    (%eax),%eax
c01059c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01059c7:	89 c2                	mov    %eax,%edx
c01059c9:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01059ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01059d1:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01059d8:	77 23                	ja     c01059fd <check_boot_pgdir+0x133>
c01059da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059e1:	c7 44 24 08 90 97 10 	movl   $0xc0109790,0x8(%esp)
c01059e8:	c0 
c01059e9:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c01059f0:	00 
c01059f1:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c01059f8:	e8 df b2 ff ff       	call   c0100cdc <__panic>
c01059fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a00:	05 00 00 00 40       	add    $0x40000000,%eax
c0105a05:	39 c2                	cmp    %eax,%edx
c0105a07:	74 24                	je     c0105a2d <check_boot_pgdir+0x163>
c0105a09:	c7 44 24 0c a4 9b 10 	movl   $0xc0109ba4,0xc(%esp)
c0105a10:	c0 
c0105a11:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105a18:	c0 
c0105a19:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0105a20:	00 
c0105a21:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105a28:	e8 af b2 ff ff       	call   c0100cdc <__panic>

    assert(boot_pgdir[0] == 0);
c0105a2d:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105a32:	8b 00                	mov    (%eax),%eax
c0105a34:	85 c0                	test   %eax,%eax
c0105a36:	74 24                	je     c0105a5c <check_boot_pgdir+0x192>
c0105a38:	c7 44 24 0c d8 9b 10 	movl   $0xc0109bd8,0xc(%esp)
c0105a3f:	c0 
c0105a40:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105a47:	c0 
c0105a48:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105a4f:	00 
c0105a50:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105a57:	e8 80 b2 ff ff       	call   c0100cdc <__panic>

    struct Page *p;
    p = alloc_page();
c0105a5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105a63:	e8 2f ec ff ff       	call   c0104697 <alloc_pages>
c0105a68:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105a6b:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105a70:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105a77:	00 
c0105a78:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105a7f:	00 
c0105a80:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a83:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a87:	89 04 24             	mov    %eax,(%esp)
c0105a8a:	e8 a1 f5 ff ff       	call   c0105030 <page_insert>
c0105a8f:	85 c0                	test   %eax,%eax
c0105a91:	74 24                	je     c0105ab7 <check_boot_pgdir+0x1ed>
c0105a93:	c7 44 24 0c ec 9b 10 	movl   $0xc0109bec,0xc(%esp)
c0105a9a:	c0 
c0105a9b:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105aa2:	c0 
c0105aa3:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0105aaa:	00 
c0105aab:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105ab2:	e8 25 b2 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p) == 1);
c0105ab7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105aba:	89 04 24             	mov    %eax,(%esp)
c0105abd:	e8 d0 e9 ff ff       	call   c0104492 <page_ref>
c0105ac2:	83 f8 01             	cmp    $0x1,%eax
c0105ac5:	74 24                	je     c0105aeb <check_boot_pgdir+0x221>
c0105ac7:	c7 44 24 0c 1a 9c 10 	movl   $0xc0109c1a,0xc(%esp)
c0105ace:	c0 
c0105acf:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105ad6:	c0 
c0105ad7:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c0105ade:	00 
c0105adf:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105ae6:	e8 f1 b1 ff ff       	call   c0100cdc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105aeb:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105af0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105af7:	00 
c0105af8:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105aff:	00 
c0105b00:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b03:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b07:	89 04 24             	mov    %eax,(%esp)
c0105b0a:	e8 21 f5 ff ff       	call   c0105030 <page_insert>
c0105b0f:	85 c0                	test   %eax,%eax
c0105b11:	74 24                	je     c0105b37 <check_boot_pgdir+0x26d>
c0105b13:	c7 44 24 0c 2c 9c 10 	movl   $0xc0109c2c,0xc(%esp)
c0105b1a:	c0 
c0105b1b:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105b22:	c0 
c0105b23:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c0105b2a:	00 
c0105b2b:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105b32:	e8 a5 b1 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p) == 2);
c0105b37:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b3a:	89 04 24             	mov    %eax,(%esp)
c0105b3d:	e8 50 e9 ff ff       	call   c0104492 <page_ref>
c0105b42:	83 f8 02             	cmp    $0x2,%eax
c0105b45:	74 24                	je     c0105b6b <check_boot_pgdir+0x2a1>
c0105b47:	c7 44 24 0c 63 9c 10 	movl   $0xc0109c63,0xc(%esp)
c0105b4e:	c0 
c0105b4f:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105b56:	c0 
c0105b57:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c0105b5e:	00 
c0105b5f:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105b66:	e8 71 b1 ff ff       	call   c0100cdc <__panic>

    const char *str = "ucore: Hello world!!";
c0105b6b:	c7 45 dc 74 9c 10 c0 	movl   $0xc0109c74,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105b72:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b79:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b80:	e8 75 2b 00 00       	call   c01086fa <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105b85:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105b8c:	00 
c0105b8d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b94:	e8 da 2b 00 00       	call   c0108773 <strcmp>
c0105b99:	85 c0                	test   %eax,%eax
c0105b9b:	74 24                	je     c0105bc1 <check_boot_pgdir+0x2f7>
c0105b9d:	c7 44 24 0c 8c 9c 10 	movl   $0xc0109c8c,0xc(%esp)
c0105ba4:	c0 
c0105ba5:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105bac:	c0 
c0105bad:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c0105bb4:	00 
c0105bb5:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105bbc:	e8 1b b1 ff ff       	call   c0100cdc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bc4:	89 04 24             	mov    %eax,(%esp)
c0105bc7:	e8 ea e7 ff ff       	call   c01043b6 <page2kva>
c0105bcc:	05 00 01 00 00       	add    $0x100,%eax
c0105bd1:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105bd4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105bdb:	e8 c2 2a 00 00       	call   c01086a2 <strlen>
c0105be0:	85 c0                	test   %eax,%eax
c0105be2:	74 24                	je     c0105c08 <check_boot_pgdir+0x33e>
c0105be4:	c7 44 24 0c c4 9c 10 	movl   $0xc0109cc4,0xc(%esp)
c0105beb:	c0 
c0105bec:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105bf3:	c0 
c0105bf4:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c0105bfb:	00 
c0105bfc:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105c03:	e8 d4 b0 ff ff       	call   c0100cdc <__panic>

    free_page(p);
c0105c08:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c0f:	00 
c0105c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c13:	89 04 24             	mov    %eax,(%esp)
c0105c16:	e8 e7 ea ff ff       	call   c0104702 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105c1b:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105c20:	8b 00                	mov    (%eax),%eax
c0105c22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105c27:	89 04 24             	mov    %eax,(%esp)
c0105c2a:	e8 42 e7 ff ff       	call   c0104371 <pa2page>
c0105c2f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c36:	00 
c0105c37:	89 04 24             	mov    %eax,(%esp)
c0105c3a:	e8 c3 ea ff ff       	call   c0104702 <free_pages>
    boot_pgdir[0] = 0;
c0105c3f:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105c4a:	c7 04 24 e8 9c 10 c0 	movl   $0xc0109ce8,(%esp)
c0105c51:	e8 f5 a6 ff ff       	call   c010034b <cprintf>
}
c0105c56:	c9                   	leave  
c0105c57:	c3                   	ret    

c0105c58 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105c58:	55                   	push   %ebp
c0105c59:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105c5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5e:	83 e0 04             	and    $0x4,%eax
c0105c61:	85 c0                	test   %eax,%eax
c0105c63:	74 07                	je     c0105c6c <perm2str+0x14>
c0105c65:	b8 75 00 00 00       	mov    $0x75,%eax
c0105c6a:	eb 05                	jmp    c0105c71 <perm2str+0x19>
c0105c6c:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c71:	a2 a8 0a 12 c0       	mov    %al,0xc0120aa8
    str[1] = 'r';
c0105c76:	c6 05 a9 0a 12 c0 72 	movb   $0x72,0xc0120aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c80:	83 e0 02             	and    $0x2,%eax
c0105c83:	85 c0                	test   %eax,%eax
c0105c85:	74 07                	je     c0105c8e <perm2str+0x36>
c0105c87:	b8 77 00 00 00       	mov    $0x77,%eax
c0105c8c:	eb 05                	jmp    c0105c93 <perm2str+0x3b>
c0105c8e:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c93:	a2 aa 0a 12 c0       	mov    %al,0xc0120aaa
    str[3] = '\0';
c0105c98:	c6 05 ab 0a 12 c0 00 	movb   $0x0,0xc0120aab
    return str;
c0105c9f:	b8 a8 0a 12 c0       	mov    $0xc0120aa8,%eax
}
c0105ca4:	5d                   	pop    %ebp
c0105ca5:	c3                   	ret    

c0105ca6 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105ca6:	55                   	push   %ebp
c0105ca7:	89 e5                	mov    %esp,%ebp
c0105ca9:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105cac:	8b 45 10             	mov    0x10(%ebp),%eax
c0105caf:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cb2:	72 0a                	jb     c0105cbe <get_pgtable_items+0x18>
        return 0;
c0105cb4:	b8 00 00 00 00       	mov    $0x0,%eax
c0105cb9:	e9 9c 00 00 00       	jmp    c0105d5a <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105cbe:	eb 04                	jmp    c0105cc4 <get_pgtable_items+0x1e>
        start ++;
c0105cc0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105cc4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cc7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cca:	73 18                	jae    c0105ce4 <get_pgtable_items+0x3e>
c0105ccc:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105cd6:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cd9:	01 d0                	add    %edx,%eax
c0105cdb:	8b 00                	mov    (%eax),%eax
c0105cdd:	83 e0 01             	and    $0x1,%eax
c0105ce0:	85 c0                	test   %eax,%eax
c0105ce2:	74 dc                	je     c0105cc0 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105ce4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ce7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cea:	73 69                	jae    c0105d55 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105cec:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105cf0:	74 08                	je     c0105cfa <get_pgtable_items+0x54>
            *left_store = start;
c0105cf2:	8b 45 18             	mov    0x18(%ebp),%eax
c0105cf5:	8b 55 10             	mov    0x10(%ebp),%edx
c0105cf8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105cfa:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cfd:	8d 50 01             	lea    0x1(%eax),%edx
c0105d00:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d03:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d0a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d0d:	01 d0                	add    %edx,%eax
c0105d0f:	8b 00                	mov    (%eax),%eax
c0105d11:	83 e0 07             	and    $0x7,%eax
c0105d14:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105d17:	eb 04                	jmp    c0105d1d <get_pgtable_items+0x77>
            start ++;
c0105d19:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105d1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d20:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d23:	73 1d                	jae    c0105d42 <get_pgtable_items+0x9c>
c0105d25:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d2f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d32:	01 d0                	add    %edx,%eax
c0105d34:	8b 00                	mov    (%eax),%eax
c0105d36:	83 e0 07             	and    $0x7,%eax
c0105d39:	89 c2                	mov    %eax,%edx
c0105d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d3e:	39 c2                	cmp    %eax,%edx
c0105d40:	74 d7                	je     c0105d19 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105d42:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105d46:	74 08                	je     c0105d50 <get_pgtable_items+0xaa>
            *right_store = start;
c0105d48:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105d4b:	8b 55 10             	mov    0x10(%ebp),%edx
c0105d4e:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d53:	eb 05                	jmp    c0105d5a <get_pgtable_items+0xb4>
    }
    return 0;
c0105d55:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d5a:	c9                   	leave  
c0105d5b:	c3                   	ret    

c0105d5c <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105d5c:	55                   	push   %ebp
c0105d5d:	89 e5                	mov    %esp,%ebp
c0105d5f:	57                   	push   %edi
c0105d60:	56                   	push   %esi
c0105d61:	53                   	push   %ebx
c0105d62:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105d65:	c7 04 24 08 9d 10 c0 	movl   $0xc0109d08,(%esp)
c0105d6c:	e8 da a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c0105d71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105d78:	e9 fa 00 00 00       	jmp    c0105e77 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d80:	89 04 24             	mov    %eax,(%esp)
c0105d83:	e8 d0 fe ff ff       	call   c0105c58 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105d88:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d8e:	29 d1                	sub    %edx,%ecx
c0105d90:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d92:	89 d6                	mov    %edx,%esi
c0105d94:	c1 e6 16             	shl    $0x16,%esi
c0105d97:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105d9a:	89 d3                	mov    %edx,%ebx
c0105d9c:	c1 e3 16             	shl    $0x16,%ebx
c0105d9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105da2:	89 d1                	mov    %edx,%ecx
c0105da4:	c1 e1 16             	shl    $0x16,%ecx
c0105da7:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105daa:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105dad:	29 d7                	sub    %edx,%edi
c0105daf:	89 fa                	mov    %edi,%edx
c0105db1:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105db5:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105db9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105dbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105dc1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105dc5:	c7 04 24 39 9d 10 c0 	movl   $0xc0109d39,(%esp)
c0105dcc:	e8 7a a5 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dd4:	c1 e0 0a             	shl    $0xa,%eax
c0105dd7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105dda:	eb 54                	jmp    c0105e30 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ddf:	89 04 24             	mov    %eax,(%esp)
c0105de2:	e8 71 fe ff ff       	call   c0105c58 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105de7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105dea:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105ded:	29 d1                	sub    %edx,%ecx
c0105def:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105df1:	89 d6                	mov    %edx,%esi
c0105df3:	c1 e6 0c             	shl    $0xc,%esi
c0105df6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105df9:	89 d3                	mov    %edx,%ebx
c0105dfb:	c1 e3 0c             	shl    $0xc,%ebx
c0105dfe:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e01:	c1 e2 0c             	shl    $0xc,%edx
c0105e04:	89 d1                	mov    %edx,%ecx
c0105e06:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105e09:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105e0c:	29 d7                	sub    %edx,%edi
c0105e0e:	89 fa                	mov    %edi,%edx
c0105e10:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105e14:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105e18:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105e1c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105e20:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e24:	c7 04 24 58 9d 10 c0 	movl   $0xc0109d58,(%esp)
c0105e2b:	e8 1b a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105e30:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105e35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105e38:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e3b:	89 ce                	mov    %ecx,%esi
c0105e3d:	c1 e6 0a             	shl    $0xa,%esi
c0105e40:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105e43:	89 cb                	mov    %ecx,%ebx
c0105e45:	c1 e3 0a             	shl    $0xa,%ebx
c0105e48:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105e4b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e4f:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105e52:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e56:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e5a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e5e:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105e62:	89 1c 24             	mov    %ebx,(%esp)
c0105e65:	e8 3c fe ff ff       	call   c0105ca6 <get_pgtable_items>
c0105e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e71:	0f 85 65 ff ff ff    	jne    c0105ddc <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105e77:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105e7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e7f:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105e82:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e86:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105e89:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e8d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e91:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e95:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105e9c:	00 
c0105e9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105ea4:	e8 fd fd ff ff       	call   c0105ca6 <get_pgtable_items>
c0105ea9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105eac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105eb0:	0f 85 c7 fe ff ff    	jne    c0105d7d <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105eb6:	c7 04 24 7c 9d 10 c0 	movl   $0xc0109d7c,(%esp)
c0105ebd:	e8 89 a4 ff ff       	call   c010034b <cprintf>
}
c0105ec2:	83 c4 4c             	add    $0x4c,%esp
c0105ec5:	5b                   	pop    %ebx
c0105ec6:	5e                   	pop    %esi
c0105ec7:	5f                   	pop    %edi
c0105ec8:	5d                   	pop    %ebp
c0105ec9:	c3                   	ret    

c0105eca <kmalloc>:

void *
kmalloc(size_t n) {
c0105eca:	55                   	push   %ebp
c0105ecb:	89 e5                	mov    %esp,%ebp
c0105ecd:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105ed0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105ed7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105ede:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ee2:	74 09                	je     c0105eed <kmalloc+0x23>
c0105ee4:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105eeb:	76 24                	jbe    c0105f11 <kmalloc+0x47>
c0105eed:	c7 44 24 0c ad 9d 10 	movl   $0xc0109dad,0xc(%esp)
c0105ef4:	c0 
c0105ef5:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105efc:	c0 
c0105efd:	c7 44 24 04 a1 02 00 	movl   $0x2a1,0x4(%esp)
c0105f04:	00 
c0105f05:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105f0c:	e8 cb ad ff ff       	call   c0100cdc <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105f11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f14:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105f19:	c1 e8 0c             	shr    $0xc,%eax
c0105f1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f22:	89 04 24             	mov    %eax,(%esp)
c0105f25:	e8 6d e7 ff ff       	call   c0104697 <alloc_pages>
c0105f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105f2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f31:	75 24                	jne    c0105f57 <kmalloc+0x8d>
c0105f33:	c7 44 24 0c c4 9d 10 	movl   $0xc0109dc4,0xc(%esp)
c0105f3a:	c0 
c0105f3b:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105f42:	c0 
c0105f43:	c7 44 24 04 a4 02 00 	movl   $0x2a4,0x4(%esp)
c0105f4a:	00 
c0105f4b:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105f52:	e8 85 ad ff ff       	call   c0100cdc <__panic>
    ptr=page2kva(base);
c0105f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f5a:	89 04 24             	mov    %eax,(%esp)
c0105f5d:	e8 54 e4 ff ff       	call   c01043b6 <page2kva>
c0105f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f68:	c9                   	leave  
c0105f69:	c3                   	ret    

c0105f6a <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105f6a:	55                   	push   %ebp
c0105f6b:	89 e5                	mov    %esp,%ebp
c0105f6d:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105f70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f74:	74 09                	je     c0105f7f <kfree+0x15>
c0105f76:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105f7d:	76 24                	jbe    c0105fa3 <kfree+0x39>
c0105f7f:	c7 44 24 0c ad 9d 10 	movl   $0xc0109dad,0xc(%esp)
c0105f86:	c0 
c0105f87:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105f8e:	c0 
c0105f8f:	c7 44 24 04 ab 02 00 	movl   $0x2ab,0x4(%esp)
c0105f96:	00 
c0105f97:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105f9e:	e8 39 ad ff ff       	call   c0100cdc <__panic>
    assert(ptr != NULL);
c0105fa3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105fa7:	75 24                	jne    c0105fcd <kfree+0x63>
c0105fa9:	c7 44 24 0c d1 9d 10 	movl   $0xc0109dd1,0xc(%esp)
c0105fb0:	c0 
c0105fb1:	c7 44 24 08 59 98 10 	movl   $0xc0109859,0x8(%esp)
c0105fb8:	c0 
c0105fb9:	c7 44 24 04 ac 02 00 	movl   $0x2ac,0x4(%esp)
c0105fc0:	00 
c0105fc1:	c7 04 24 34 98 10 c0 	movl   $0xc0109834,(%esp)
c0105fc8:	e8 0f ad ff ff       	call   c0100cdc <__panic>
    struct Page *base=NULL;
c0105fcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fd7:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105fdc:	c1 e8 0c             	shr    $0xc,%eax
c0105fdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105fe2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe5:	89 04 24             	mov    %eax,(%esp)
c0105fe8:	e8 1d e4 ff ff       	call   c010440a <kva2page>
c0105fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ffa:	89 04 24             	mov    %eax,(%esp)
c0105ffd:	e8 00 e7 ff ff       	call   c0104702 <free_pages>
}
c0106002:	c9                   	leave  
c0106003:	c3                   	ret    

c0106004 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106004:	55                   	push   %ebp
c0106005:	89 e5                	mov    %esp,%ebp
c0106007:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010600a:	8b 45 08             	mov    0x8(%ebp),%eax
c010600d:	c1 e8 0c             	shr    $0xc,%eax
c0106010:	89 c2                	mov    %eax,%edx
c0106012:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0106017:	39 c2                	cmp    %eax,%edx
c0106019:	72 1c                	jb     c0106037 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010601b:	c7 44 24 08 e0 9d 10 	movl   $0xc0109de0,0x8(%esp)
c0106022:	c0 
c0106023:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010602a:	00 
c010602b:	c7 04 24 ff 9d 10 c0 	movl   $0xc0109dff,(%esp)
c0106032:	e8 a5 ac ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c0106037:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c010603c:	8b 55 08             	mov    0x8(%ebp),%edx
c010603f:	c1 ea 0c             	shr    $0xc,%edx
c0106042:	c1 e2 05             	shl    $0x5,%edx
c0106045:	01 d0                	add    %edx,%eax
}
c0106047:	c9                   	leave  
c0106048:	c3                   	ret    

c0106049 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106049:	55                   	push   %ebp
c010604a:	89 e5                	mov    %esp,%ebp
c010604c:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010604f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106052:	83 e0 01             	and    $0x1,%eax
c0106055:	85 c0                	test   %eax,%eax
c0106057:	75 1c                	jne    c0106075 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106059:	c7 44 24 08 10 9e 10 	movl   $0xc0109e10,0x8(%esp)
c0106060:	c0 
c0106061:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106068:	00 
c0106069:	c7 04 24 ff 9d 10 c0 	movl   $0xc0109dff,(%esp)
c0106070:	e8 67 ac ff ff       	call   c0100cdc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106075:	8b 45 08             	mov    0x8(%ebp),%eax
c0106078:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010607d:	89 04 24             	mov    %eax,(%esp)
c0106080:	e8 7f ff ff ff       	call   c0106004 <pa2page>
}
c0106085:	c9                   	leave  
c0106086:	c3                   	ret    

c0106087 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106087:	55                   	push   %ebp
c0106088:	89 e5                	mov    %esp,%ebp
c010608a:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c010608d:	e8 8b 1d 00 00       	call   c0107e1d <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106092:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0106097:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c010609c:	76 0c                	jbe    c01060aa <swap_init+0x23>
c010609e:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c01060a3:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01060a8:	76 25                	jbe    c01060cf <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01060aa:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c01060af:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060b3:	c7 44 24 08 31 9e 10 	movl   $0xc0109e31,0x8(%esp)
c01060ba:	c0 
c01060bb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c01060c2:	00 
c01060c3:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c01060ca:	e8 0d ac ff ff       	call   c0100cdc <__panic>
     }
     

     sm = &swap_manager_fifo;
c01060cf:	c7 05 b4 0a 12 c0 40 	movl   $0xc011fa40,0xc0120ab4
c01060d6:	fa 11 c0 
     int r = sm->init();
c01060d9:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01060de:	8b 40 04             	mov    0x4(%eax),%eax
c01060e1:	ff d0                	call   *%eax
c01060e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01060e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01060ea:	75 26                	jne    c0106112 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01060ec:	c7 05 ac 0a 12 c0 01 	movl   $0x1,0xc0120aac
c01060f3:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01060f6:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01060fb:	8b 00                	mov    (%eax),%eax
c01060fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106101:	c7 04 24 5b 9e 10 c0 	movl   $0xc0109e5b,(%esp)
c0106108:	e8 3e a2 ff ff       	call   c010034b <cprintf>
          check_swap();
c010610d:	e8 a4 04 00 00       	call   c01065b6 <check_swap>
     }

     return r;
c0106112:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106115:	c9                   	leave  
c0106116:	c3                   	ret    

c0106117 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106117:	55                   	push   %ebp
c0106118:	89 e5                	mov    %esp,%ebp
c010611a:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c010611d:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0106122:	8b 40 08             	mov    0x8(%eax),%eax
c0106125:	8b 55 08             	mov    0x8(%ebp),%edx
c0106128:	89 14 24             	mov    %edx,(%esp)
c010612b:	ff d0                	call   *%eax
}
c010612d:	c9                   	leave  
c010612e:	c3                   	ret    

c010612f <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c010612f:	55                   	push   %ebp
c0106130:	89 e5                	mov    %esp,%ebp
c0106132:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106135:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010613a:	8b 40 0c             	mov    0xc(%eax),%eax
c010613d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106140:	89 14 24             	mov    %edx,(%esp)
c0106143:	ff d0                	call   *%eax
}
c0106145:	c9                   	leave  
c0106146:	c3                   	ret    

c0106147 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106147:	55                   	push   %ebp
c0106148:	89 e5                	mov    %esp,%ebp
c010614a:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010614d:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0106152:	8b 40 10             	mov    0x10(%eax),%eax
c0106155:	8b 55 14             	mov    0x14(%ebp),%edx
c0106158:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010615c:	8b 55 10             	mov    0x10(%ebp),%edx
c010615f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106163:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106166:	89 54 24 04          	mov    %edx,0x4(%esp)
c010616a:	8b 55 08             	mov    0x8(%ebp),%edx
c010616d:	89 14 24             	mov    %edx,(%esp)
c0106170:	ff d0                	call   *%eax
}
c0106172:	c9                   	leave  
c0106173:	c3                   	ret    

c0106174 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106174:	55                   	push   %ebp
c0106175:	89 e5                	mov    %esp,%ebp
c0106177:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010617a:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010617f:	8b 40 14             	mov    0x14(%eax),%eax
c0106182:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106185:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106189:	8b 55 08             	mov    0x8(%ebp),%edx
c010618c:	89 14 24             	mov    %edx,(%esp)
c010618f:	ff d0                	call   *%eax
}
c0106191:	c9                   	leave  
c0106192:	c3                   	ret    

c0106193 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106193:	55                   	push   %ebp
c0106194:	89 e5                	mov    %esp,%ebp
c0106196:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106199:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01061a0:	e9 5a 01 00 00       	jmp    c01062ff <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01061a5:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01061aa:	8b 40 18             	mov    0x18(%eax),%eax
c01061ad:	8b 55 10             	mov    0x10(%ebp),%edx
c01061b0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01061b4:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01061b7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061bb:	8b 55 08             	mov    0x8(%ebp),%edx
c01061be:	89 14 24             	mov    %edx,(%esp)
c01061c1:	ff d0                	call   *%eax
c01061c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01061c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01061ca:	74 18                	je     c01061e4 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01061cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061d3:	c7 04 24 70 9e 10 c0 	movl   $0xc0109e70,(%esp)
c01061da:	e8 6c a1 ff ff       	call   c010034b <cprintf>
c01061df:	e9 27 01 00 00       	jmp    c010630b <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01061e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061e7:	8b 40 1c             	mov    0x1c(%eax),%eax
c01061ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01061ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01061f0:	8b 40 0c             	mov    0xc(%eax),%eax
c01061f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01061fa:	00 
c01061fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01061fe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106202:	89 04 24             	mov    %eax,(%esp)
c0106205:	e8 ef eb ff ff       	call   c0104df9 <get_pte>
c010620a:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c010620d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106210:	8b 00                	mov    (%eax),%eax
c0106212:	83 e0 01             	and    $0x1,%eax
c0106215:	85 c0                	test   %eax,%eax
c0106217:	75 24                	jne    c010623d <swap_out+0xaa>
c0106219:	c7 44 24 0c 9d 9e 10 	movl   $0xc0109e9d,0xc(%esp)
c0106220:	c0 
c0106221:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106228:	c0 
c0106229:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106230:	00 
c0106231:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106238:	e8 9f aa ff ff       	call   c0100cdc <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010623d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106240:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106243:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106246:	c1 ea 0c             	shr    $0xc,%edx
c0106249:	83 c2 01             	add    $0x1,%edx
c010624c:	c1 e2 08             	shl    $0x8,%edx
c010624f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106253:	89 14 24             	mov    %edx,(%esp)
c0106256:	e8 7c 1c 00 00       	call   c0107ed7 <swapfs_write>
c010625b:	85 c0                	test   %eax,%eax
c010625d:	74 34                	je     c0106293 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c010625f:	c7 04 24 c7 9e 10 c0 	movl   $0xc0109ec7,(%esp)
c0106266:	e8 e0 a0 ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010626b:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0106270:	8b 40 10             	mov    0x10(%eax),%eax
c0106273:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106276:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010627d:	00 
c010627e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106282:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106285:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106289:	8b 55 08             	mov    0x8(%ebp),%edx
c010628c:	89 14 24             	mov    %edx,(%esp)
c010628f:	ff d0                	call   *%eax
c0106291:	eb 68                	jmp    c01062fb <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106296:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106299:	c1 e8 0c             	shr    $0xc,%eax
c010629c:	83 c0 01             	add    $0x1,%eax
c010629f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01062a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01062aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062b1:	c7 04 24 e0 9e 10 c0 	movl   $0xc0109ee0,(%esp)
c01062b8:	e8 8e a0 ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01062bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062c0:	8b 40 1c             	mov    0x1c(%eax),%eax
c01062c3:	c1 e8 0c             	shr    $0xc,%eax
c01062c6:	83 c0 01             	add    $0x1,%eax
c01062c9:	c1 e0 08             	shl    $0x8,%eax
c01062cc:	89 c2                	mov    %eax,%edx
c01062ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062d1:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01062d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062dd:	00 
c01062de:	89 04 24             	mov    %eax,(%esp)
c01062e1:	e8 1c e4 ff ff       	call   c0104702 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01062e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01062e9:	8b 40 0c             	mov    0xc(%eax),%eax
c01062ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062ef:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062f3:	89 04 24             	mov    %eax,(%esp)
c01062f6:	e8 ee ed ff ff       	call   c01050e9 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01062fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01062ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106302:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106305:	0f 85 9a fe ff ff    	jne    c01061a5 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010630b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010630e:	c9                   	leave  
c010630f:	c3                   	ret    

c0106310 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106310:	55                   	push   %ebp
c0106311:	89 e5                	mov    %esp,%ebp
c0106313:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106316:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010631d:	e8 75 e3 ff ff       	call   c0104697 <alloc_pages>
c0106322:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106325:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106329:	75 24                	jne    c010634f <swap_in+0x3f>
c010632b:	c7 44 24 0c 20 9f 10 	movl   $0xc0109f20,0xc(%esp)
c0106332:	c0 
c0106333:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c010633a:	c0 
c010633b:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0106342:	00 
c0106343:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c010634a:	e8 8d a9 ff ff       	call   c0100cdc <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010634f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106352:	8b 40 0c             	mov    0xc(%eax),%eax
c0106355:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010635c:	00 
c010635d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106360:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106364:	89 04 24             	mov    %eax,(%esp)
c0106367:	e8 8d ea ff ff       	call   c0104df9 <get_pte>
c010636c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010636f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106372:	8b 00                	mov    (%eax),%eax
c0106374:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106377:	89 54 24 04          	mov    %edx,0x4(%esp)
c010637b:	89 04 24             	mov    %eax,(%esp)
c010637e:	e8 e2 1a 00 00       	call   c0107e65 <swapfs_read>
c0106383:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106386:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010638a:	74 2a                	je     c01063b6 <swap_in+0xa6>
     {
        assert(r!=0);
c010638c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106390:	75 24                	jne    c01063b6 <swap_in+0xa6>
c0106392:	c7 44 24 0c 2d 9f 10 	movl   $0xc0109f2d,0xc(%esp)
c0106399:	c0 
c010639a:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c01063a1:	c0 
c01063a2:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c01063a9:	00 
c01063aa:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c01063b1:	e8 26 a9 ff ff       	call   c0100cdc <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01063b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063b9:	8b 00                	mov    (%eax),%eax
c01063bb:	c1 e8 08             	shr    $0x8,%eax
c01063be:	89 c2                	mov    %eax,%edx
c01063c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01063c3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01063c7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063cb:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c01063d2:	e8 74 9f ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c01063d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01063da:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01063dd:	89 10                	mov    %edx,(%eax)
     return 0;
c01063df:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01063e4:	c9                   	leave  
c01063e5:	c3                   	ret    

c01063e6 <check_content_set>:



static inline void
check_content_set(void)
{
c01063e6:	55                   	push   %ebp
c01063e7:	89 e5                	mov    %esp,%ebp
c01063e9:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01063ec:	b8 00 10 00 00       	mov    $0x1000,%eax
c01063f1:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01063f4:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01063f9:	83 f8 01             	cmp    $0x1,%eax
c01063fc:	74 24                	je     c0106422 <check_content_set+0x3c>
c01063fe:	c7 44 24 0c 72 9f 10 	movl   $0xc0109f72,0xc(%esp)
c0106405:	c0 
c0106406:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c010640d:	c0 
c010640e:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106415:	00 
c0106416:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c010641d:	e8 ba a8 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106422:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106427:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010642a:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010642f:	83 f8 01             	cmp    $0x1,%eax
c0106432:	74 24                	je     c0106458 <check_content_set+0x72>
c0106434:	c7 44 24 0c 72 9f 10 	movl   $0xc0109f72,0xc(%esp)
c010643b:	c0 
c010643c:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106443:	c0 
c0106444:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010644b:	00 
c010644c:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106453:	e8 84 a8 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106458:	b8 00 20 00 00       	mov    $0x2000,%eax
c010645d:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106460:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106465:	83 f8 02             	cmp    $0x2,%eax
c0106468:	74 24                	je     c010648e <check_content_set+0xa8>
c010646a:	c7 44 24 0c 81 9f 10 	movl   $0xc0109f81,0xc(%esp)
c0106471:	c0 
c0106472:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106479:	c0 
c010647a:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106481:	00 
c0106482:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106489:	e8 4e a8 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c010648e:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106493:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106496:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010649b:	83 f8 02             	cmp    $0x2,%eax
c010649e:	74 24                	je     c01064c4 <check_content_set+0xde>
c01064a0:	c7 44 24 0c 81 9f 10 	movl   $0xc0109f81,0xc(%esp)
c01064a7:	c0 
c01064a8:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c01064af:	c0 
c01064b0:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c01064b7:	00 
c01064b8:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c01064bf:	e8 18 a8 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01064c4:	b8 00 30 00 00       	mov    $0x3000,%eax
c01064c9:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01064cc:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01064d1:	83 f8 03             	cmp    $0x3,%eax
c01064d4:	74 24                	je     c01064fa <check_content_set+0x114>
c01064d6:	c7 44 24 0c 90 9f 10 	movl   $0xc0109f90,0xc(%esp)
c01064dd:	c0 
c01064de:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c01064e5:	c0 
c01064e6:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01064ed:	00 
c01064ee:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c01064f5:	e8 e2 a7 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01064fa:	b8 10 30 00 00       	mov    $0x3010,%eax
c01064ff:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106502:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106507:	83 f8 03             	cmp    $0x3,%eax
c010650a:	74 24                	je     c0106530 <check_content_set+0x14a>
c010650c:	c7 44 24 0c 90 9f 10 	movl   $0xc0109f90,0xc(%esp)
c0106513:	c0 
c0106514:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c010651b:	c0 
c010651c:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106523:	00 
c0106524:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c010652b:	e8 ac a7 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106530:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106535:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106538:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010653d:	83 f8 04             	cmp    $0x4,%eax
c0106540:	74 24                	je     c0106566 <check_content_set+0x180>
c0106542:	c7 44 24 0c 9f 9f 10 	movl   $0xc0109f9f,0xc(%esp)
c0106549:	c0 
c010654a:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106551:	c0 
c0106552:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106559:	00 
c010655a:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106561:	e8 76 a7 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106566:	b8 10 40 00 00       	mov    $0x4010,%eax
c010656b:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010656e:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106573:	83 f8 04             	cmp    $0x4,%eax
c0106576:	74 24                	je     c010659c <check_content_set+0x1b6>
c0106578:	c7 44 24 0c 9f 9f 10 	movl   $0xc0109f9f,0xc(%esp)
c010657f:	c0 
c0106580:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106587:	c0 
c0106588:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c010658f:	00 
c0106590:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106597:	e8 40 a7 ff ff       	call   c0100cdc <__panic>
}
c010659c:	c9                   	leave  
c010659d:	c3                   	ret    

c010659e <check_content_access>:

static inline int
check_content_access(void)
{
c010659e:	55                   	push   %ebp
c010659f:	89 e5                	mov    %esp,%ebp
c01065a1:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c01065a4:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01065a9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01065ac:	ff d0                	call   *%eax
c01065ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c01065b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01065b4:	c9                   	leave  
c01065b5:	c3                   	ret    

c01065b6 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c01065b6:	55                   	push   %ebp
c01065b7:	89 e5                	mov    %esp,%ebp
c01065b9:	53                   	push   %ebx
c01065ba:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01065bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01065c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01065cb:	c7 45 e8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01065d2:	eb 6b                	jmp    c010663f <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c01065d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065d7:	83 e8 0c             	sub    $0xc,%eax
c01065da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01065dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065e0:	83 c0 04             	add    $0x4,%eax
c01065e3:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01065ea:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01065ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01065f0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01065f3:	0f a3 10             	bt     %edx,(%eax)
c01065f6:	19 c0                	sbb    %eax,%eax
c01065f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01065fb:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01065ff:	0f 95 c0             	setne  %al
c0106602:	0f b6 c0             	movzbl %al,%eax
c0106605:	85 c0                	test   %eax,%eax
c0106607:	75 24                	jne    c010662d <check_swap+0x77>
c0106609:	c7 44 24 0c ae 9f 10 	movl   $0xc0109fae,0xc(%esp)
c0106610:	c0 
c0106611:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106618:	c0 
c0106619:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106620:	00 
c0106621:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106628:	e8 af a6 ff ff       	call   c0100cdc <__panic>
        count ++, total += p->property;
c010662d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106634:	8b 50 08             	mov    0x8(%eax),%edx
c0106637:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010663a:	01 d0                	add    %edx,%eax
c010663c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010663f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106642:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106645:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106648:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010664b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010664e:	81 7d e8 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x18(%ebp)
c0106655:	0f 85 79 ff ff ff    	jne    c01065d4 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c010665b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010665e:	e8 d1 e0 ff ff       	call   c0104734 <nr_free_pages>
c0106663:	39 c3                	cmp    %eax,%ebx
c0106665:	74 24                	je     c010668b <check_swap+0xd5>
c0106667:	c7 44 24 0c be 9f 10 	movl   $0xc0109fbe,0xc(%esp)
c010666e:	c0 
c010666f:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106676:	c0 
c0106677:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c010667e:	00 
c010667f:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106686:	e8 51 a6 ff ff       	call   c0100cdc <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010668b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010668e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106692:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106695:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106699:	c7 04 24 d8 9f 10 c0 	movl   $0xc0109fd8,(%esp)
c01066a0:	e8 a6 9c ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c01066a5:	e8 ed 09 00 00       	call   c0107097 <mm_create>
c01066aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c01066ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01066b1:	75 24                	jne    c01066d7 <check_swap+0x121>
c01066b3:	c7 44 24 0c fe 9f 10 	movl   $0xc0109ffe,0xc(%esp)
c01066ba:	c0 
c01066bb:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c01066c2:	c0 
c01066c3:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01066ca:	00 
c01066cb:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c01066d2:	e8 05 a6 ff ff       	call   c0100cdc <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01066d7:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01066dc:	85 c0                	test   %eax,%eax
c01066de:	74 24                	je     c0106704 <check_swap+0x14e>
c01066e0:	c7 44 24 0c 09 a0 10 	movl   $0xc010a009,0xc(%esp)
c01066e7:	c0 
c01066e8:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c01066ef:	c0 
c01066f0:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01066f7:	00 
c01066f8:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c01066ff:	e8 d8 a5 ff ff       	call   c0100cdc <__panic>

     check_mm_struct = mm;
c0106704:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106707:	a3 ac 0b 12 c0       	mov    %eax,0xc0120bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010670c:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c0106712:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106715:	89 50 0c             	mov    %edx,0xc(%eax)
c0106718:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010671b:	8b 40 0c             	mov    0xc(%eax),%eax
c010671e:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106721:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106724:	8b 00                	mov    (%eax),%eax
c0106726:	85 c0                	test   %eax,%eax
c0106728:	74 24                	je     c010674e <check_swap+0x198>
c010672a:	c7 44 24 0c 21 a0 10 	movl   $0xc010a021,0xc(%esp)
c0106731:	c0 
c0106732:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106739:	c0 
c010673a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106741:	00 
c0106742:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106749:	e8 8e a5 ff ff       	call   c0100cdc <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c010674e:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106755:	00 
c0106756:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c010675d:	00 
c010675e:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106765:	e8 a5 09 00 00       	call   c010710f <vma_create>
c010676a:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c010676d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106771:	75 24                	jne    c0106797 <check_swap+0x1e1>
c0106773:	c7 44 24 0c 2f a0 10 	movl   $0xc010a02f,0xc(%esp)
c010677a:	c0 
c010677b:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106782:	c0 
c0106783:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010678a:	00 
c010678b:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106792:	e8 45 a5 ff ff       	call   c0100cdc <__panic>

     insert_vma_struct(mm, vma);
c0106797:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010679a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010679e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067a1:	89 04 24             	mov    %eax,(%esp)
c01067a4:	e8 f6 0a 00 00       	call   c010729f <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01067a9:	c7 04 24 3c a0 10 c0 	movl   $0xc010a03c,(%esp)
c01067b0:	e8 96 9b ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c01067b5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01067bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067bf:	8b 40 0c             	mov    0xc(%eax),%eax
c01067c2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01067c9:	00 
c01067ca:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01067d1:	00 
c01067d2:	89 04 24             	mov    %eax,(%esp)
c01067d5:	e8 1f e6 ff ff       	call   c0104df9 <get_pte>
c01067da:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c01067dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01067e1:	75 24                	jne    c0106807 <check_swap+0x251>
c01067e3:	c7 44 24 0c 70 a0 10 	movl   $0xc010a070,0xc(%esp)
c01067ea:	c0 
c01067eb:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c01067f2:	c0 
c01067f3:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01067fa:	00 
c01067fb:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106802:	e8 d5 a4 ff ff       	call   c0100cdc <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106807:	c7 04 24 84 a0 10 c0 	movl   $0xc010a084,(%esp)
c010680e:	e8 38 9b ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106813:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010681a:	e9 a3 00 00 00       	jmp    c01068c2 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c010681f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106826:	e8 6c de ff ff       	call   c0104697 <alloc_pages>
c010682b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010682e:	89 04 95 e0 0a 12 c0 	mov    %eax,-0x3fedf520(,%edx,4)
          assert(check_rp[i] != NULL );
c0106835:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106838:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c010683f:	85 c0                	test   %eax,%eax
c0106841:	75 24                	jne    c0106867 <check_swap+0x2b1>
c0106843:	c7 44 24 0c a8 a0 10 	movl   $0xc010a0a8,0xc(%esp)
c010684a:	c0 
c010684b:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106852:	c0 
c0106853:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010685a:	00 
c010685b:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106862:	e8 75 a4 ff ff       	call   c0100cdc <__panic>
          assert(!PageProperty(check_rp[i]));
c0106867:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010686a:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c0106871:	83 c0 04             	add    $0x4,%eax
c0106874:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010687b:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010687e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106881:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106884:	0f a3 10             	bt     %edx,(%eax)
c0106887:	19 c0                	sbb    %eax,%eax
c0106889:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010688c:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106890:	0f 95 c0             	setne  %al
c0106893:	0f b6 c0             	movzbl %al,%eax
c0106896:	85 c0                	test   %eax,%eax
c0106898:	74 24                	je     c01068be <check_swap+0x308>
c010689a:	c7 44 24 0c bc a0 10 	movl   $0xc010a0bc,0xc(%esp)
c01068a1:	c0 
c01068a2:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c01068a9:	c0 
c01068aa:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01068b1:	00 
c01068b2:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c01068b9:	e8 1e a4 ff ff       	call   c0100cdc <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068be:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01068c2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01068c6:	0f 8e 53 ff ff ff    	jle    c010681f <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01068cc:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c01068d1:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c01068d7:	89 45 98             	mov    %eax,-0x68(%ebp)
c01068da:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01068dd:	c7 45 a8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01068e4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068e7:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01068ea:	89 50 04             	mov    %edx,0x4(%eax)
c01068ed:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068f0:	8b 50 04             	mov    0x4(%eax),%edx
c01068f3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068f6:	89 10                	mov    %edx,(%eax)
c01068f8:	c7 45 a4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01068ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106902:	8b 40 04             	mov    0x4(%eax),%eax
c0106905:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106908:	0f 94 c0             	sete   %al
c010690b:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c010690e:	85 c0                	test   %eax,%eax
c0106910:	75 24                	jne    c0106936 <check_swap+0x380>
c0106912:	c7 44 24 0c d7 a0 10 	movl   $0xc010a0d7,0xc(%esp)
c0106919:	c0 
c010691a:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106921:	c0 
c0106922:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106929:	00 
c010692a:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106931:	e8 a6 a3 ff ff       	call   c0100cdc <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106936:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c010693b:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c010693e:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0106945:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106948:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010694f:	eb 1e                	jmp    c010696f <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106951:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106954:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c010695b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106962:	00 
c0106963:	89 04 24             	mov    %eax,(%esp)
c0106966:	e8 97 dd ff ff       	call   c0104702 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010696b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010696f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106973:	7e dc                	jle    c0106951 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106975:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c010697a:	83 f8 04             	cmp    $0x4,%eax
c010697d:	74 24                	je     c01069a3 <check_swap+0x3ed>
c010697f:	c7 44 24 0c f0 a0 10 	movl   $0xc010a0f0,0xc(%esp)
c0106986:	c0 
c0106987:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c010698e:	c0 
c010698f:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106996:	00 
c0106997:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c010699e:	e8 39 a3 ff ff       	call   c0100cdc <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c01069a3:	c7 04 24 14 a1 10 c0 	movl   $0xc010a114,(%esp)
c01069aa:	e8 9c 99 ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c01069af:	c7 05 b8 0a 12 c0 00 	movl   $0x0,0xc0120ab8
c01069b6:	00 00 00 
     
     check_content_set();
c01069b9:	e8 28 fa ff ff       	call   c01063e6 <check_content_set>
     assert( nr_free == 0);         
c01069be:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01069c3:	85 c0                	test   %eax,%eax
c01069c5:	74 24                	je     c01069eb <check_swap+0x435>
c01069c7:	c7 44 24 0c 3b a1 10 	movl   $0xc010a13b,0xc(%esp)
c01069ce:	c0 
c01069cf:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c01069d6:	c0 
c01069d7:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01069de:	00 
c01069df:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c01069e6:	e8 f1 a2 ff ff       	call   c0100cdc <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01069eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069f2:	eb 26                	jmp    c0106a1a <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01069f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069f7:	c7 04 85 00 0b 12 c0 	movl   $0xffffffff,-0x3fedf500(,%eax,4)
c01069fe:	ff ff ff ff 
c0106a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a05:	8b 14 85 00 0b 12 c0 	mov    -0x3fedf500(,%eax,4),%edx
c0106a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a0f:	89 14 85 40 0b 12 c0 	mov    %edx,-0x3fedf4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106a16:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a1a:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106a1e:	7e d4                	jle    c01069f4 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106a27:	e9 eb 00 00 00       	jmp    c0106b17 <check_swap+0x561>
         check_ptep[i]=0;
c0106a2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a2f:	c7 04 85 94 0b 12 c0 	movl   $0x0,-0x3fedf46c(,%eax,4)
c0106a36:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a3d:	83 c0 01             	add    $0x1,%eax
c0106a40:	c1 e0 0c             	shl    $0xc,%eax
c0106a43:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106a4a:	00 
c0106a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a52:	89 04 24             	mov    %eax,(%esp)
c0106a55:	e8 9f e3 ff ff       	call   c0104df9 <get_pte>
c0106a5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a5d:	89 04 95 94 0b 12 c0 	mov    %eax,-0x3fedf46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a67:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c0106a6e:	85 c0                	test   %eax,%eax
c0106a70:	75 24                	jne    c0106a96 <check_swap+0x4e0>
c0106a72:	c7 44 24 0c 48 a1 10 	movl   $0xc010a148,0xc(%esp)
c0106a79:	c0 
c0106a7a:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106a81:	c0 
c0106a82:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106a89:	00 
c0106a8a:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106a91:	e8 46 a2 ff ff       	call   c0100cdc <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a99:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c0106aa0:	8b 00                	mov    (%eax),%eax
c0106aa2:	89 04 24             	mov    %eax,(%esp)
c0106aa5:	e8 9f f5 ff ff       	call   c0106049 <pte2page>
c0106aaa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106aad:	8b 14 95 e0 0a 12 c0 	mov    -0x3fedf520(,%edx,4),%edx
c0106ab4:	39 d0                	cmp    %edx,%eax
c0106ab6:	74 24                	je     c0106adc <check_swap+0x526>
c0106ab8:	c7 44 24 0c 60 a1 10 	movl   $0xc010a160,0xc(%esp)
c0106abf:	c0 
c0106ac0:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106ac7:	c0 
c0106ac8:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106acf:	00 
c0106ad0:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106ad7:	e8 00 a2 ff ff       	call   c0100cdc <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106adf:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c0106ae6:	8b 00                	mov    (%eax),%eax
c0106ae8:	83 e0 01             	and    $0x1,%eax
c0106aeb:	85 c0                	test   %eax,%eax
c0106aed:	75 24                	jne    c0106b13 <check_swap+0x55d>
c0106aef:	c7 44 24 0c 88 a1 10 	movl   $0xc010a188,0xc(%esp)
c0106af6:	c0 
c0106af7:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106afe:	c0 
c0106aff:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106b06:	00 
c0106b07:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106b0e:	e8 c9 a1 ff ff       	call   c0100cdc <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b13:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b17:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b1b:	0f 8e 0b ff ff ff    	jle    c0106a2c <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106b21:	c7 04 24 a4 a1 10 c0 	movl   $0xc010a1a4,(%esp)
c0106b28:	e8 1e 98 ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106b2d:	e8 6c fa ff ff       	call   c010659e <check_content_access>
c0106b32:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106b35:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106b39:	74 24                	je     c0106b5f <check_swap+0x5a9>
c0106b3b:	c7 44 24 0c ca a1 10 	movl   $0xc010a1ca,0xc(%esp)
c0106b42:	c0 
c0106b43:	c7 44 24 08 b2 9e 10 	movl   $0xc0109eb2,0x8(%esp)
c0106b4a:	c0 
c0106b4b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106b52:	00 
c0106b53:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0106b5a:	e8 7d a1 ff ff       	call   c0100cdc <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b5f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b66:	eb 1e                	jmp    c0106b86 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b6b:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c0106b72:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106b79:	00 
c0106b7a:	89 04 24             	mov    %eax,(%esp)
c0106b7d:	e8 80 db ff ff       	call   c0104702 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b82:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b86:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b8a:	7e dc                	jle    c0106b68 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106b8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b8f:	89 04 24             	mov    %eax,(%esp)
c0106b92:	e8 38 08 00 00       	call   c01073cf <mm_destroy>
         
     nr_free = nr_free_store;
c0106b97:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106b9a:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
     free_list = free_list_store;
c0106b9f:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106ba2:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106ba5:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0106baa:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4

     
     le = &free_list;
c0106bb0:	c7 45 e8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106bb7:	eb 1d                	jmp    c0106bd6 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bbc:	83 e8 0c             	sub    $0xc,%eax
c0106bbf:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106bc2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106bc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106bc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106bcc:	8b 40 08             	mov    0x8(%eax),%eax
c0106bcf:	29 c2                	sub    %eax,%edx
c0106bd1:	89 d0                	mov    %edx,%eax
c0106bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bd9:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106bdc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106bdf:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106be2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106be5:	81 7d e8 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x18(%ebp)
c0106bec:	75 cb                	jne    c0106bb9 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bf1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bfc:	c7 04 24 d1 a1 10 c0 	movl   $0xc010a1d1,(%esp)
c0106c03:	e8 43 97 ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106c08:	c7 04 24 eb a1 10 c0 	movl   $0xc010a1eb,(%esp)
c0106c0f:	e8 37 97 ff ff       	call   c010034b <cprintf>
}
c0106c14:	83 c4 74             	add    $0x74,%esp
c0106c17:	5b                   	pop    %ebx
c0106c18:	5d                   	pop    %ebp
c0106c19:	c3                   	ret    

c0106c1a <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106c1a:	55                   	push   %ebp
c0106c1b:	89 e5                	mov    %esp,%ebp
c0106c1d:	83 ec 10             	sub    $0x10,%esp
c0106c20:	c7 45 fc a4 0b 12 c0 	movl   $0xc0120ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106c2d:	89 50 04             	mov    %edx,0x4(%eax)
c0106c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c33:	8b 50 04             	mov    0x4(%eax),%edx
c0106c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c39:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c3e:	c7 40 14 a4 0b 12 c0 	movl   $0xc0120ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c4a:	c9                   	leave  
c0106c4b:	c3                   	ret    

c0106c4c <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106c4c:	55                   	push   %ebp
c0106c4d:	89 e5                	mov    %esp,%ebp
c0106c4f:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c55:	8b 40 14             	mov    0x14(%eax),%eax
c0106c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106c5b:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c5e:	83 c0 14             	add    $0x14,%eax
c0106c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106c64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106c68:	74 06                	je     c0106c70 <_fifo_map_swappable+0x24>
c0106c6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c6e:	75 24                	jne    c0106c94 <_fifo_map_swappable+0x48>
c0106c70:	c7 44 24 0c 04 a2 10 	movl   $0xc010a204,0xc(%esp)
c0106c77:	c0 
c0106c78:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106c7f:	c0 
c0106c80:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106c87:	00 
c0106c88:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106c8f:	e8 48 a0 ff ff       	call   c0100cdc <__panic>
c0106c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c97:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106cac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106caf:	8b 40 04             	mov    0x4(%eax),%eax
c0106cb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106cb5:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106cb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106cbb:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0106cbe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106cc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106cc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106cc7:	89 10                	mov    %edx,(%eax)
c0106cc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106ccc:	8b 10                	mov    (%eax),%edx
c0106cce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106cd1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106cd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106cd7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106cda:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106cdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106ce0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106ce3:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2012011267*/
    //(1)link the most recent arrival page at the back of the pra_list_head queue.
    list_add(head, entry);
    return 0;
c0106ce5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106cea:	c9                   	leave  
c0106ceb:	c3                   	ret    

c0106cec <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106cec:	55                   	push   %ebp
c0106ced:	89 e5                	mov    %esp,%ebp
c0106cef:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cf5:	8b 40 14             	mov    0x14(%eax),%eax
c0106cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106cff:	75 24                	jne    c0106d25 <_fifo_swap_out_victim+0x39>
c0106d01:	c7 44 24 0c 4b a2 10 	movl   $0xc010a24b,0xc(%esp)
c0106d08:	c0 
c0106d09:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106d10:	c0 
c0106d11:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106d18:	00 
c0106d19:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106d20:	e8 b7 9f ff ff       	call   c0100cdc <__panic>
     assert(in_tick==0);
c0106d25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106d29:	74 24                	je     c0106d4f <_fifo_swap_out_victim+0x63>
c0106d2b:	c7 44 24 0c 58 a2 10 	movl   $0xc010a258,0xc(%esp)
c0106d32:	c0 
c0106d33:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106d3a:	c0 
c0106d3b:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106d42:	00 
c0106d43:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106d4a:	e8 8d 9f ff ff       	call   c0100cdc <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2012011267*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head queue
     //(2)  set the addr of addr of this page to ptr_page
     struct Page *p_tmp = le2page(head->prev, pra_page_link);
c0106d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d52:	8b 00                	mov    (%eax),%eax
c0106d54:	83 e8 14             	sub    $0x14,%eax
c0106d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
     *ptr_page = p_tmp;
c0106d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106d60:	89 10                	mov    %edx,(%eax)
     list_del(head->prev);
c0106d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d65:	8b 00                	mov    (%eax),%eax
c0106d67:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d6d:	8b 40 04             	mov    0x4(%eax),%eax
c0106d70:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d73:	8b 12                	mov    (%edx),%edx
c0106d75:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0106d78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106d7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d81:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d87:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106d8a:	89 10                	mov    %edx,(%eax)
     return 0;
c0106d8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d91:	c9                   	leave  
c0106d92:	c3                   	ret    

c0106d93 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106d93:	55                   	push   %ebp
c0106d94:	89 e5                	mov    %esp,%ebp
c0106d96:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106d99:	c7 04 24 64 a2 10 c0 	movl   $0xc010a264,(%esp)
c0106da0:	e8 a6 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106da5:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106daa:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106dad:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106db2:	83 f8 04             	cmp    $0x4,%eax
c0106db5:	74 24                	je     c0106ddb <_fifo_check_swap+0x48>
c0106db7:	c7 44 24 0c 8a a2 10 	movl   $0xc010a28a,0xc(%esp)
c0106dbe:	c0 
c0106dbf:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106dc6:	c0 
c0106dc7:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
c0106dce:	00 
c0106dcf:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106dd6:	e8 01 9f ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106ddb:	c7 04 24 9c a2 10 c0 	movl   $0xc010a29c,(%esp)
c0106de2:	e8 64 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106de7:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106dec:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106def:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106df4:	83 f8 04             	cmp    $0x4,%eax
c0106df7:	74 24                	je     c0106e1d <_fifo_check_swap+0x8a>
c0106df9:	c7 44 24 0c 8a a2 10 	movl   $0xc010a28a,0xc(%esp)
c0106e00:	c0 
c0106e01:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106e08:	c0 
c0106e09:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0106e10:	00 
c0106e11:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106e18:	e8 bf 9e ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106e1d:	c7 04 24 c4 a2 10 c0 	movl   $0xc010a2c4,(%esp)
c0106e24:	e8 22 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106e29:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106e2e:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106e31:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106e36:	83 f8 04             	cmp    $0x4,%eax
c0106e39:	74 24                	je     c0106e5f <_fifo_check_swap+0xcc>
c0106e3b:	c7 44 24 0c 8a a2 10 	movl   $0xc010a28a,0xc(%esp)
c0106e42:	c0 
c0106e43:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106e4a:	c0 
c0106e4b:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0106e52:	00 
c0106e53:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106e5a:	e8 7d 9e ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106e5f:	c7 04 24 ec a2 10 c0 	movl   $0xc010a2ec,(%esp)
c0106e66:	e8 e0 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106e6b:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106e70:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106e73:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106e78:	83 f8 04             	cmp    $0x4,%eax
c0106e7b:	74 24                	je     c0106ea1 <_fifo_check_swap+0x10e>
c0106e7d:	c7 44 24 0c 8a a2 10 	movl   $0xc010a28a,0xc(%esp)
c0106e84:	c0 
c0106e85:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106e8c:	c0 
c0106e8d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0106e94:	00 
c0106e95:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106e9c:	e8 3b 9e ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106ea1:	c7 04 24 14 a3 10 c0 	movl   $0xc010a314,(%esp)
c0106ea8:	e8 9e 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106ead:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106eb2:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106eb5:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106eba:	83 f8 05             	cmp    $0x5,%eax
c0106ebd:	74 24                	je     c0106ee3 <_fifo_check_swap+0x150>
c0106ebf:	c7 44 24 0c 3a a3 10 	movl   $0xc010a33a,0xc(%esp)
c0106ec6:	c0 
c0106ec7:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106ece:	c0 
c0106ecf:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0106ed6:	00 
c0106ed7:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106ede:	e8 f9 9d ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106ee3:	c7 04 24 ec a2 10 c0 	movl   $0xc010a2ec,(%esp)
c0106eea:	e8 5c 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106eef:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106ef4:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106ef7:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106efc:	83 f8 05             	cmp    $0x5,%eax
c0106eff:	74 24                	je     c0106f25 <_fifo_check_swap+0x192>
c0106f01:	c7 44 24 0c 3a a3 10 	movl   $0xc010a33a,0xc(%esp)
c0106f08:	c0 
c0106f09:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106f10:	c0 
c0106f11:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0106f18:	00 
c0106f19:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106f20:	e8 b7 9d ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106f25:	c7 04 24 9c a2 10 c0 	movl   $0xc010a29c,(%esp)
c0106f2c:	e8 1a 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106f31:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106f36:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106f39:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106f3e:	83 f8 06             	cmp    $0x6,%eax
c0106f41:	74 24                	je     c0106f67 <_fifo_check_swap+0x1d4>
c0106f43:	c7 44 24 0c 49 a3 10 	movl   $0xc010a349,0xc(%esp)
c0106f4a:	c0 
c0106f4b:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106f52:	c0 
c0106f53:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0106f5a:	00 
c0106f5b:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106f62:	e8 75 9d ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106f67:	c7 04 24 ec a2 10 c0 	movl   $0xc010a2ec,(%esp)
c0106f6e:	e8 d8 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106f73:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106f78:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106f7b:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106f80:	83 f8 07             	cmp    $0x7,%eax
c0106f83:	74 24                	je     c0106fa9 <_fifo_check_swap+0x216>
c0106f85:	c7 44 24 0c 58 a3 10 	movl   $0xc010a358,0xc(%esp)
c0106f8c:	c0 
c0106f8d:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106f94:	c0 
c0106f95:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0106f9c:	00 
c0106f9d:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106fa4:	e8 33 9d ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106fa9:	c7 04 24 64 a2 10 c0 	movl   $0xc010a264,(%esp)
c0106fb0:	e8 96 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106fb5:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106fba:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0106fbd:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106fc2:	83 f8 08             	cmp    $0x8,%eax
c0106fc5:	74 24                	je     c0106feb <_fifo_check_swap+0x258>
c0106fc7:	c7 44 24 0c 67 a3 10 	movl   $0xc010a367,0xc(%esp)
c0106fce:	c0 
c0106fcf:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0106fd6:	c0 
c0106fd7:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0106fde:	00 
c0106fdf:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0106fe6:	e8 f1 9c ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106feb:	c7 04 24 c4 a2 10 c0 	movl   $0xc010a2c4,(%esp)
c0106ff2:	e8 54 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106ff7:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106ffc:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0106fff:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0107004:	83 f8 09             	cmp    $0x9,%eax
c0107007:	74 24                	je     c010702d <_fifo_check_swap+0x29a>
c0107009:	c7 44 24 0c 76 a3 10 	movl   $0xc010a376,0xc(%esp)
c0107010:	c0 
c0107011:	c7 44 24 08 22 a2 10 	movl   $0xc010a222,0x8(%esp)
c0107018:	c0 
c0107019:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107020:	00 
c0107021:	c7 04 24 37 a2 10 c0 	movl   $0xc010a237,(%esp)
c0107028:	e8 af 9c ff ff       	call   c0100cdc <__panic>
    return 0;
c010702d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107032:	c9                   	leave  
c0107033:	c3                   	ret    

c0107034 <_fifo_init>:


static int
_fifo_init(void)
{
c0107034:	55                   	push   %ebp
c0107035:	89 e5                	mov    %esp,%ebp
    return 0;
c0107037:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010703c:	5d                   	pop    %ebp
c010703d:	c3                   	ret    

c010703e <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010703e:	55                   	push   %ebp
c010703f:	89 e5                	mov    %esp,%ebp
    return 0;
c0107041:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107046:	5d                   	pop    %ebp
c0107047:	c3                   	ret    

c0107048 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107048:	55                   	push   %ebp
c0107049:	89 e5                	mov    %esp,%ebp
c010704b:	b8 00 00 00 00       	mov    $0x0,%eax
c0107050:	5d                   	pop    %ebp
c0107051:	c3                   	ret    

c0107052 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107052:	55                   	push   %ebp
c0107053:	89 e5                	mov    %esp,%ebp
c0107055:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107058:	8b 45 08             	mov    0x8(%ebp),%eax
c010705b:	c1 e8 0c             	shr    $0xc,%eax
c010705e:	89 c2                	mov    %eax,%edx
c0107060:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0107065:	39 c2                	cmp    %eax,%edx
c0107067:	72 1c                	jb     c0107085 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107069:	c7 44 24 08 98 a3 10 	movl   $0xc010a398,0x8(%esp)
c0107070:	c0 
c0107071:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0107078:	00 
c0107079:	c7 04 24 b7 a3 10 c0 	movl   $0xc010a3b7,(%esp)
c0107080:	e8 57 9c ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c0107085:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c010708a:	8b 55 08             	mov    0x8(%ebp),%edx
c010708d:	c1 ea 0c             	shr    $0xc,%edx
c0107090:	c1 e2 05             	shl    $0x5,%edx
c0107093:	01 d0                	add    %edx,%eax
}
c0107095:	c9                   	leave  
c0107096:	c3                   	ret    

c0107097 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107097:	55                   	push   %ebp
c0107098:	89 e5                	mov    %esp,%ebp
c010709a:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c010709d:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01070a4:	e8 21 ee ff ff       	call   c0105eca <kmalloc>
c01070a9:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01070ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01070b0:	74 58                	je     c010710a <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01070b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01070b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01070be:	89 50 04             	mov    %edx,0x4(%eax)
c01070c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070c4:	8b 50 04             	mov    0x4(%eax),%edx
c01070c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070ca:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01070cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01070d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c01070e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070e3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c01070ea:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c01070ef:	85 c0                	test   %eax,%eax
c01070f1:	74 0d                	je     c0107100 <mm_create+0x69>
c01070f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070f6:	89 04 24             	mov    %eax,(%esp)
c01070f9:	e8 19 f0 ff ff       	call   c0106117 <swap_init_mm>
c01070fe:	eb 0a                	jmp    c010710a <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107100:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107103:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c010710a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010710d:	c9                   	leave  
c010710e:	c3                   	ret    

c010710f <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c010710f:	55                   	push   %ebp
c0107110:	89 e5                	mov    %esp,%ebp
c0107112:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107115:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010711c:	e8 a9 ed ff ff       	call   c0105eca <kmalloc>
c0107121:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107124:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107128:	74 1b                	je     c0107145 <vma_create+0x36>
        vma->vm_start = vm_start;
c010712a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010712d:	8b 55 08             	mov    0x8(%ebp),%edx
c0107130:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107133:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107136:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107139:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c010713c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010713f:	8b 55 10             	mov    0x10(%ebp),%edx
c0107142:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107145:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107148:	c9                   	leave  
c0107149:	c3                   	ret    

c010714a <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c010714a:	55                   	push   %ebp
c010714b:	89 e5                	mov    %esp,%ebp
c010714d:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107157:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010715b:	0f 84 95 00 00 00    	je     c01071f6 <find_vma+0xac>
        vma = mm->mmap_cache;
c0107161:	8b 45 08             	mov    0x8(%ebp),%eax
c0107164:	8b 40 08             	mov    0x8(%eax),%eax
c0107167:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c010716a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010716e:	74 16                	je     c0107186 <find_vma+0x3c>
c0107170:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107173:	8b 40 04             	mov    0x4(%eax),%eax
c0107176:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107179:	77 0b                	ja     c0107186 <find_vma+0x3c>
c010717b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010717e:	8b 40 08             	mov    0x8(%eax),%eax
c0107181:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107184:	77 61                	ja     c01071e7 <find_vma+0x9d>
                bool found = 0;
c0107186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c010718d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107190:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107193:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107196:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107199:	eb 28                	jmp    c01071c3 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c010719b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010719e:	83 e8 10             	sub    $0x10,%eax
c01071a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01071a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071a7:	8b 40 04             	mov    0x4(%eax),%eax
c01071aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01071ad:	77 14                	ja     c01071c3 <find_vma+0x79>
c01071af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071b2:	8b 40 08             	mov    0x8(%eax),%eax
c01071b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01071b8:	76 09                	jbe    c01071c3 <find_vma+0x79>
                        found = 1;
c01071ba:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01071c1:	eb 17                	jmp    c01071da <find_vma+0x90>
c01071c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01071c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071cc:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c01071cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01071d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01071d8:	75 c1                	jne    c010719b <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c01071da:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01071de:	75 07                	jne    c01071e7 <find_vma+0x9d>
                    vma = NULL;
c01071e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c01071e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01071eb:	74 09                	je     c01071f6 <find_vma+0xac>
            mm->mmap_cache = vma;
c01071ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01071f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01071f3:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c01071f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01071f9:	c9                   	leave  
c01071fa:	c3                   	ret    

c01071fb <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c01071fb:	55                   	push   %ebp
c01071fc:	89 e5                	mov    %esp,%ebp
c01071fe:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107201:	8b 45 08             	mov    0x8(%ebp),%eax
c0107204:	8b 50 04             	mov    0x4(%eax),%edx
c0107207:	8b 45 08             	mov    0x8(%ebp),%eax
c010720a:	8b 40 08             	mov    0x8(%eax),%eax
c010720d:	39 c2                	cmp    %eax,%edx
c010720f:	72 24                	jb     c0107235 <check_vma_overlap+0x3a>
c0107211:	c7 44 24 0c c5 a3 10 	movl   $0xc010a3c5,0xc(%esp)
c0107218:	c0 
c0107219:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107220:	c0 
c0107221:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107228:	00 
c0107229:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107230:	e8 a7 9a ff ff       	call   c0100cdc <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107235:	8b 45 08             	mov    0x8(%ebp),%eax
c0107238:	8b 50 08             	mov    0x8(%eax),%edx
c010723b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010723e:	8b 40 04             	mov    0x4(%eax),%eax
c0107241:	39 c2                	cmp    %eax,%edx
c0107243:	76 24                	jbe    c0107269 <check_vma_overlap+0x6e>
c0107245:	c7 44 24 0c 08 a4 10 	movl   $0xc010a408,0xc(%esp)
c010724c:	c0 
c010724d:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107254:	c0 
c0107255:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c010725c:	00 
c010725d:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107264:	e8 73 9a ff ff       	call   c0100cdc <__panic>
    assert(next->vm_start < next->vm_end);
c0107269:	8b 45 0c             	mov    0xc(%ebp),%eax
c010726c:	8b 50 04             	mov    0x4(%eax),%edx
c010726f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107272:	8b 40 08             	mov    0x8(%eax),%eax
c0107275:	39 c2                	cmp    %eax,%edx
c0107277:	72 24                	jb     c010729d <check_vma_overlap+0xa2>
c0107279:	c7 44 24 0c 27 a4 10 	movl   $0xc010a427,0xc(%esp)
c0107280:	c0 
c0107281:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107288:	c0 
c0107289:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107290:	00 
c0107291:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107298:	e8 3f 9a ff ff       	call   c0100cdc <__panic>
}
c010729d:	c9                   	leave  
c010729e:	c3                   	ret    

c010729f <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010729f:	55                   	push   %ebp
c01072a0:	89 e5                	mov    %esp,%ebp
c01072a2:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01072a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072a8:	8b 50 04             	mov    0x4(%eax),%edx
c01072ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072ae:	8b 40 08             	mov    0x8(%eax),%eax
c01072b1:	39 c2                	cmp    %eax,%edx
c01072b3:	72 24                	jb     c01072d9 <insert_vma_struct+0x3a>
c01072b5:	c7 44 24 0c 45 a4 10 	movl   $0xc010a445,0xc(%esp)
c01072bc:	c0 
c01072bd:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c01072c4:	c0 
c01072c5:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01072cc:	00 
c01072cd:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c01072d4:	e8 03 9a ff ff       	call   c0100cdc <__panic>
    list_entry_t *list = &(mm->mmap_list);
c01072d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01072dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c01072df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c01072e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c01072eb:	eb 21                	jmp    c010730e <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c01072ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072f0:	83 e8 10             	sub    $0x10,%eax
c01072f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c01072f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072f9:	8b 50 04             	mov    0x4(%eax),%edx
c01072fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072ff:	8b 40 04             	mov    0x4(%eax),%eax
c0107302:	39 c2                	cmp    %eax,%edx
c0107304:	76 02                	jbe    c0107308 <insert_vma_struct+0x69>
                break;
c0107306:	eb 1d                	jmp    c0107325 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107308:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010730b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010730e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107311:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107314:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107317:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c010731a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010731d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107320:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107323:	75 c8                	jne    c01072ed <insert_vma_struct+0x4e>
c0107325:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107328:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010732b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010732e:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107331:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107334:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107337:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010733a:	74 15                	je     c0107351 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c010733c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010733f:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107342:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107345:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107349:	89 14 24             	mov    %edx,(%esp)
c010734c:	e8 aa fe ff ff       	call   c01071fb <check_vma_overlap>
    }
    if (le_next != list) {
c0107351:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107354:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107357:	74 15                	je     c010736e <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107359:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010735c:	83 e8 10             	sub    $0x10,%eax
c010735f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107363:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107366:	89 04 24             	mov    %eax,(%esp)
c0107369:	e8 8d fe ff ff       	call   c01071fb <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010736e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107371:	8b 55 08             	mov    0x8(%ebp),%edx
c0107374:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107376:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107379:	8d 50 10             	lea    0x10(%eax),%edx
c010737c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010737f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107382:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107385:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107388:	8b 40 04             	mov    0x4(%eax),%eax
c010738b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010738e:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107391:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107394:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107397:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010739a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010739d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01073a0:	89 10                	mov    %edx,(%eax)
c01073a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01073a5:	8b 10                	mov    (%eax),%edx
c01073a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01073aa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01073ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01073b0:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01073b3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01073b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01073b9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01073bc:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c01073be:	8b 45 08             	mov    0x8(%ebp),%eax
c01073c1:	8b 40 10             	mov    0x10(%eax),%eax
c01073c4:	8d 50 01             	lea    0x1(%eax),%edx
c01073c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01073ca:	89 50 10             	mov    %edx,0x10(%eax)
}
c01073cd:	c9                   	leave  
c01073ce:	c3                   	ret    

c01073cf <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01073cf:	55                   	push   %ebp
c01073d0:	89 e5                	mov    %esp,%ebp
c01073d2:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c01073d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01073d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c01073db:	eb 3e                	jmp    c010741b <mm_destroy+0x4c>
c01073dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01073e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073e6:	8b 40 04             	mov    0x4(%eax),%eax
c01073e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01073ec:	8b 12                	mov    (%edx),%edx
c01073ee:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01073f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01073f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01073f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01073fa:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01073fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107400:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107403:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0107405:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107408:	83 e8 10             	sub    $0x10,%eax
c010740b:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107412:	00 
c0107413:	89 04 24             	mov    %eax,(%esp)
c0107416:	e8 4f eb ff ff       	call   c0105f6a <kfree>
c010741b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010741e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107421:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107424:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0107427:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010742a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010742d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107430:	75 ab                	jne    c01073dd <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0107432:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107439:	00 
c010743a:	8b 45 08             	mov    0x8(%ebp),%eax
c010743d:	89 04 24             	mov    %eax,(%esp)
c0107440:	e8 25 eb ff ff       	call   c0105f6a <kfree>
    mm=NULL;
c0107445:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c010744c:	c9                   	leave  
c010744d:	c3                   	ret    

c010744e <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c010744e:	55                   	push   %ebp
c010744f:	89 e5                	mov    %esp,%ebp
c0107451:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107454:	e8 02 00 00 00       	call   c010745b <check_vmm>
}
c0107459:	c9                   	leave  
c010745a:	c3                   	ret    

c010745b <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c010745b:	55                   	push   %ebp
c010745c:	89 e5                	mov    %esp,%ebp
c010745e:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107461:	e8 ce d2 ff ff       	call   c0104734 <nr_free_pages>
c0107466:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107469:	e8 3c 00 00 00       	call   c01074aa <check_vma_struct>
    //check_pgfault();

    assert(nr_free_pages_store == nr_free_pages());
c010746e:	e8 c1 d2 ff ff       	call   c0104734 <nr_free_pages>
c0107473:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107476:	74 24                	je     c010749c <check_vmm+0x41>
c0107478:	c7 44 24 0c 64 a4 10 	movl   $0xc010a464,0xc(%esp)
c010747f:	c0 
c0107480:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107487:	c0 
c0107488:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010748f:	00 
c0107490:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107497:	e8 40 98 ff ff       	call   c0100cdc <__panic>

    cprintf("check_vmm() succeeded.\n");
c010749c:	c7 04 24 8b a4 10 c0 	movl   $0xc010a48b,(%esp)
c01074a3:	e8 a3 8e ff ff       	call   c010034b <cprintf>
}
c01074a8:	c9                   	leave  
c01074a9:	c3                   	ret    

c01074aa <check_vma_struct>:

static void
check_vma_struct(void) {
c01074aa:	55                   	push   %ebp
c01074ab:	89 e5                	mov    %esp,%ebp
c01074ad:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01074b0:	e8 7f d2 ff ff       	call   c0104734 <nr_free_pages>
c01074b5:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01074b8:	e8 da fb ff ff       	call   c0107097 <mm_create>
c01074bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01074c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01074c4:	75 24                	jne    c01074ea <check_vma_struct+0x40>
c01074c6:	c7 44 24 0c a3 a4 10 	movl   $0xc010a4a3,0xc(%esp)
c01074cd:	c0 
c01074ce:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c01074d5:	c0 
c01074d6:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c01074dd:	00 
c01074de:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c01074e5:	e8 f2 97 ff ff       	call   c0100cdc <__panic>

    int step1 = 10, step2 = step1 * 10;
c01074ea:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01074f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01074f4:	89 d0                	mov    %edx,%eax
c01074f6:	c1 e0 02             	shl    $0x2,%eax
c01074f9:	01 d0                	add    %edx,%eax
c01074fb:	01 c0                	add    %eax,%eax
c01074fd:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107503:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107506:	eb 70                	jmp    c0107578 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107508:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010750b:	89 d0                	mov    %edx,%eax
c010750d:	c1 e0 02             	shl    $0x2,%eax
c0107510:	01 d0                	add    %edx,%eax
c0107512:	83 c0 02             	add    $0x2,%eax
c0107515:	89 c1                	mov    %eax,%ecx
c0107517:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010751a:	89 d0                	mov    %edx,%eax
c010751c:	c1 e0 02             	shl    $0x2,%eax
c010751f:	01 d0                	add    %edx,%eax
c0107521:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107528:	00 
c0107529:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010752d:	89 04 24             	mov    %eax,(%esp)
c0107530:	e8 da fb ff ff       	call   c010710f <vma_create>
c0107535:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107538:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010753c:	75 24                	jne    c0107562 <check_vma_struct+0xb8>
c010753e:	c7 44 24 0c ae a4 10 	movl   $0xc010a4ae,0xc(%esp)
c0107545:	c0 
c0107546:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c010754d:	c0 
c010754e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0107555:	00 
c0107556:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c010755d:	e8 7a 97 ff ff       	call   c0100cdc <__panic>
        insert_vma_struct(mm, vma);
c0107562:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107565:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107569:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010756c:	89 04 24             	mov    %eax,(%esp)
c010756f:	e8 2b fd ff ff       	call   c010729f <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107574:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010757c:	7f 8a                	jg     c0107508 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c010757e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107581:	83 c0 01             	add    $0x1,%eax
c0107584:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107587:	eb 70                	jmp    c01075f9 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107589:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010758c:	89 d0                	mov    %edx,%eax
c010758e:	c1 e0 02             	shl    $0x2,%eax
c0107591:	01 d0                	add    %edx,%eax
c0107593:	83 c0 02             	add    $0x2,%eax
c0107596:	89 c1                	mov    %eax,%ecx
c0107598:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010759b:	89 d0                	mov    %edx,%eax
c010759d:	c1 e0 02             	shl    $0x2,%eax
c01075a0:	01 d0                	add    %edx,%eax
c01075a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01075a9:	00 
c01075aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01075ae:	89 04 24             	mov    %eax,(%esp)
c01075b1:	e8 59 fb ff ff       	call   c010710f <vma_create>
c01075b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01075b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01075bd:	75 24                	jne    c01075e3 <check_vma_struct+0x139>
c01075bf:	c7 44 24 0c ae a4 10 	movl   $0xc010a4ae,0xc(%esp)
c01075c6:	c0 
c01075c7:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c01075ce:	c0 
c01075cf:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01075d6:	00 
c01075d7:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c01075de:	e8 f9 96 ff ff       	call   c0100cdc <__panic>
        insert_vma_struct(mm, vma);
c01075e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01075e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01075ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01075ed:	89 04 24             	mov    %eax,(%esp)
c01075f0:	e8 aa fc ff ff       	call   c010729f <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01075f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01075f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075fc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01075ff:	7e 88                	jle    c0107589 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107601:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107604:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107607:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010760a:	8b 40 04             	mov    0x4(%eax),%eax
c010760d:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107610:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107617:	e9 97 00 00 00       	jmp    c01076b3 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c010761c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010761f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107622:	75 24                	jne    c0107648 <check_vma_struct+0x19e>
c0107624:	c7 44 24 0c ba a4 10 	movl   $0xc010a4ba,0xc(%esp)
c010762b:	c0 
c010762c:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107633:	c0 
c0107634:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c010763b:	00 
c010763c:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107643:	e8 94 96 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107648:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010764b:	83 e8 10             	sub    $0x10,%eax
c010764e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107651:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107654:	8b 48 04             	mov    0x4(%eax),%ecx
c0107657:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010765a:	89 d0                	mov    %edx,%eax
c010765c:	c1 e0 02             	shl    $0x2,%eax
c010765f:	01 d0                	add    %edx,%eax
c0107661:	39 c1                	cmp    %eax,%ecx
c0107663:	75 17                	jne    c010767c <check_vma_struct+0x1d2>
c0107665:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107668:	8b 48 08             	mov    0x8(%eax),%ecx
c010766b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010766e:	89 d0                	mov    %edx,%eax
c0107670:	c1 e0 02             	shl    $0x2,%eax
c0107673:	01 d0                	add    %edx,%eax
c0107675:	83 c0 02             	add    $0x2,%eax
c0107678:	39 c1                	cmp    %eax,%ecx
c010767a:	74 24                	je     c01076a0 <check_vma_struct+0x1f6>
c010767c:	c7 44 24 0c d4 a4 10 	movl   $0xc010a4d4,0xc(%esp)
c0107683:	c0 
c0107684:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c010768b:	c0 
c010768c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0107693:	00 
c0107694:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c010769b:	e8 3c 96 ff ff       	call   c0100cdc <__panic>
c01076a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076a3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01076a6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01076a9:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01076ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01076af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01076b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076b6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01076b9:	0f 8e 5d ff ff ff    	jle    c010761c <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01076bf:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01076c6:	e9 cd 01 00 00       	jmp    c0107898 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c01076cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076d5:	89 04 24             	mov    %eax,(%esp)
c01076d8:	e8 6d fa ff ff       	call   c010714a <find_vma>
c01076dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c01076e0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01076e4:	75 24                	jne    c010770a <check_vma_struct+0x260>
c01076e6:	c7 44 24 0c 09 a5 10 	movl   $0xc010a509,0xc(%esp)
c01076ed:	c0 
c01076ee:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c01076f5:	c0 
c01076f6:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01076fd:	00 
c01076fe:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107705:	e8 d2 95 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c010770a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010770d:	83 c0 01             	add    $0x1,%eax
c0107710:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107714:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107717:	89 04 24             	mov    %eax,(%esp)
c010771a:	e8 2b fa ff ff       	call   c010714a <find_vma>
c010771f:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107722:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107726:	75 24                	jne    c010774c <check_vma_struct+0x2a2>
c0107728:	c7 44 24 0c 16 a5 10 	movl   $0xc010a516,0xc(%esp)
c010772f:	c0 
c0107730:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107737:	c0 
c0107738:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c010773f:	00 
c0107740:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107747:	e8 90 95 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c010774c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010774f:	83 c0 02             	add    $0x2,%eax
c0107752:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107756:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107759:	89 04 24             	mov    %eax,(%esp)
c010775c:	e8 e9 f9 ff ff       	call   c010714a <find_vma>
c0107761:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107764:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107768:	74 24                	je     c010778e <check_vma_struct+0x2e4>
c010776a:	c7 44 24 0c 23 a5 10 	movl   $0xc010a523,0xc(%esp)
c0107771:	c0 
c0107772:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107779:	c0 
c010777a:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0107781:	00 
c0107782:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107789:	e8 4e 95 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c010778e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107791:	83 c0 03             	add    $0x3,%eax
c0107794:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107798:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010779b:	89 04 24             	mov    %eax,(%esp)
c010779e:	e8 a7 f9 ff ff       	call   c010714a <find_vma>
c01077a3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c01077a6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01077aa:	74 24                	je     c01077d0 <check_vma_struct+0x326>
c01077ac:	c7 44 24 0c 30 a5 10 	movl   $0xc010a530,0xc(%esp)
c01077b3:	c0 
c01077b4:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c01077bb:	c0 
c01077bc:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c01077c3:	00 
c01077c4:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c01077cb:	e8 0c 95 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01077d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077d3:	83 c0 04             	add    $0x4,%eax
c01077d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077da:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01077dd:	89 04 24             	mov    %eax,(%esp)
c01077e0:	e8 65 f9 ff ff       	call   c010714a <find_vma>
c01077e5:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c01077e8:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01077ec:	74 24                	je     c0107812 <check_vma_struct+0x368>
c01077ee:	c7 44 24 0c 3d a5 10 	movl   $0xc010a53d,0xc(%esp)
c01077f5:	c0 
c01077f6:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c01077fd:	c0 
c01077fe:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107805:	00 
c0107806:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c010780d:	e8 ca 94 ff ff       	call   c0100cdc <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107812:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107815:	8b 50 04             	mov    0x4(%eax),%edx
c0107818:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010781b:	39 c2                	cmp    %eax,%edx
c010781d:	75 10                	jne    c010782f <check_vma_struct+0x385>
c010781f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107822:	8b 50 08             	mov    0x8(%eax),%edx
c0107825:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107828:	83 c0 02             	add    $0x2,%eax
c010782b:	39 c2                	cmp    %eax,%edx
c010782d:	74 24                	je     c0107853 <check_vma_struct+0x3a9>
c010782f:	c7 44 24 0c 4c a5 10 	movl   $0xc010a54c,0xc(%esp)
c0107836:	c0 
c0107837:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c010783e:	c0 
c010783f:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107846:	00 
c0107847:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c010784e:	e8 89 94 ff ff       	call   c0100cdc <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107853:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107856:	8b 50 04             	mov    0x4(%eax),%edx
c0107859:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010785c:	39 c2                	cmp    %eax,%edx
c010785e:	75 10                	jne    c0107870 <check_vma_struct+0x3c6>
c0107860:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107863:	8b 50 08             	mov    0x8(%eax),%edx
c0107866:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107869:	83 c0 02             	add    $0x2,%eax
c010786c:	39 c2                	cmp    %eax,%edx
c010786e:	74 24                	je     c0107894 <check_vma_struct+0x3ea>
c0107870:	c7 44 24 0c 7c a5 10 	movl   $0xc010a57c,0xc(%esp)
c0107877:	c0 
c0107878:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c010787f:	c0 
c0107880:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0107887:	00 
c0107888:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c010788f:	e8 48 94 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107894:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107898:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010789b:	89 d0                	mov    %edx,%eax
c010789d:	c1 e0 02             	shl    $0x2,%eax
c01078a0:	01 d0                	add    %edx,%eax
c01078a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01078a5:	0f 8d 20 fe ff ff    	jge    c01076cb <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01078ab:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01078b2:	eb 70                	jmp    c0107924 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01078b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01078be:	89 04 24             	mov    %eax,(%esp)
c01078c1:	e8 84 f8 ff ff       	call   c010714a <find_vma>
c01078c6:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c01078c9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01078cd:	74 27                	je     c01078f6 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01078cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01078d2:	8b 50 08             	mov    0x8(%eax),%edx
c01078d5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01078d8:	8b 40 04             	mov    0x4(%eax),%eax
c01078db:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01078df:	89 44 24 08          	mov    %eax,0x8(%esp)
c01078e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078ea:	c7 04 24 ac a5 10 c0 	movl   $0xc010a5ac,(%esp)
c01078f1:	e8 55 8a ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c01078f6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01078fa:	74 24                	je     c0107920 <check_vma_struct+0x476>
c01078fc:	c7 44 24 0c d1 a5 10 	movl   $0xc010a5d1,0xc(%esp)
c0107903:	c0 
c0107904:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c010790b:	c0 
c010790c:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107913:	00 
c0107914:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c010791b:	e8 bc 93 ff ff       	call   c0100cdc <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107920:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107924:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107928:	79 8a                	jns    c01078b4 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c010792a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010792d:	89 04 24             	mov    %eax,(%esp)
c0107930:	e8 9a fa ff ff       	call   c01073cf <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0107935:	e8 fa cd ff ff       	call   c0104734 <nr_free_pages>
c010793a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010793d:	74 24                	je     c0107963 <check_vma_struct+0x4b9>
c010793f:	c7 44 24 0c 64 a4 10 	movl   $0xc010a464,0xc(%esp)
c0107946:	c0 
c0107947:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c010794e:	c0 
c010794f:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107956:	00 
c0107957:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c010795e:	e8 79 93 ff ff       	call   c0100cdc <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107963:	c7 04 24 e8 a5 10 c0 	movl   $0xc010a5e8,(%esp)
c010796a:	e8 dc 89 ff ff       	call   c010034b <cprintf>
}
c010796f:	c9                   	leave  
c0107970:	c3                   	ret    

c0107971 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107971:	55                   	push   %ebp
c0107972:	89 e5                	mov    %esp,%ebp
c0107974:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107977:	e8 b8 cd ff ff       	call   c0104734 <nr_free_pages>
c010797c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c010797f:	e8 13 f7 ff ff       	call   c0107097 <mm_create>
c0107984:	a3 ac 0b 12 c0       	mov    %eax,0xc0120bac
    assert(check_mm_struct != NULL);
c0107989:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c010798e:	85 c0                	test   %eax,%eax
c0107990:	75 24                	jne    c01079b6 <check_pgfault+0x45>
c0107992:	c7 44 24 0c 07 a6 10 	movl   $0xc010a607,0xc(%esp)
c0107999:	c0 
c010799a:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c01079a1:	c0 
c01079a2:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01079a9:	00 
c01079aa:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c01079b1:	e8 26 93 ff ff       	call   c0100cdc <__panic>

    struct mm_struct *mm = check_mm_struct;
c01079b6:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01079bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c01079be:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c01079c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079c7:	89 50 0c             	mov    %edx,0xc(%eax)
c01079ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079cd:	8b 40 0c             	mov    0xc(%eax),%eax
c01079d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c01079d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01079d6:	8b 00                	mov    (%eax),%eax
c01079d8:	85 c0                	test   %eax,%eax
c01079da:	74 24                	je     c0107a00 <check_pgfault+0x8f>
c01079dc:	c7 44 24 0c 1f a6 10 	movl   $0xc010a61f,0xc(%esp)
c01079e3:	c0 
c01079e4:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c01079eb:	c0 
c01079ec:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01079f3:	00 
c01079f4:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c01079fb:	e8 dc 92 ff ff       	call   c0100cdc <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107a00:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107a07:	00 
c0107a08:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107a0f:	00 
c0107a10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107a17:	e8 f3 f6 ff ff       	call   c010710f <vma_create>
c0107a1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107a23:	75 24                	jne    c0107a49 <check_pgfault+0xd8>
c0107a25:	c7 44 24 0c ae a4 10 	movl   $0xc010a4ae,0xc(%esp)
c0107a2c:	c0 
c0107a2d:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107a34:	c0 
c0107a35:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107a3c:	00 
c0107a3d:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107a44:	e8 93 92 ff ff       	call   c0100cdc <__panic>

    insert_vma_struct(mm, vma);
c0107a49:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a53:	89 04 24             	mov    %eax,(%esp)
c0107a56:	e8 44 f8 ff ff       	call   c010729f <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107a5b:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a6c:	89 04 24             	mov    %eax,(%esp)
c0107a6f:	e8 d6 f6 ff ff       	call   c010714a <find_vma>
c0107a74:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107a77:	74 24                	je     c0107a9d <check_pgfault+0x12c>
c0107a79:	c7 44 24 0c 2d a6 10 	movl   $0xc010a62d,0xc(%esp)
c0107a80:	c0 
c0107a81:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107a88:	c0 
c0107a89:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107a90:	00 
c0107a91:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107a98:	e8 3f 92 ff ff       	call   c0100cdc <__panic>

    int i, sum = 0;
c0107a9d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107aab:	eb 17                	jmp    c0107ac4 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ab0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ab3:	01 d0                	add    %edx,%eax
c0107ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ab8:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107abd:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107ac0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107ac4:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107ac8:	7e e3                	jle    c0107aad <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107aca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107ad1:	eb 15                	jmp    c0107ae8 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ad6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ad9:	01 d0                	add    %edx,%eax
c0107adb:	0f b6 00             	movzbl (%eax),%eax
c0107ade:	0f be c0             	movsbl %al,%eax
c0107ae1:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107ae4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107ae8:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107aec:	7e e5                	jle    c0107ad3 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107aee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107af2:	74 24                	je     c0107b18 <check_pgfault+0x1a7>
c0107af4:	c7 44 24 0c 47 a6 10 	movl   $0xc010a647,0xc(%esp)
c0107afb:	c0 
c0107afc:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107b03:	c0 
c0107b04:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107b0b:	00 
c0107b0c:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107b13:	e8 c4 91 ff ff       	call   c0100cdc <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107b18:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b1b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107b1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107b21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107b26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b2d:	89 04 24             	mov    %eax,(%esp)
c0107b30:	e8 b7 d4 ff ff       	call   c0104fec <page_remove>
    free_page(pa2page(pgdir[0]));
c0107b35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b38:	8b 00                	mov    (%eax),%eax
c0107b3a:	89 04 24             	mov    %eax,(%esp)
c0107b3d:	e8 10 f5 ff ff       	call   c0107052 <pa2page>
c0107b42:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107b49:	00 
c0107b4a:	89 04 24             	mov    %eax,(%esp)
c0107b4d:	e8 b0 cb ff ff       	call   c0104702 <free_pages>
    pgdir[0] = 0;
c0107b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107b5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107b65:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b68:	89 04 24             	mov    %eax,(%esp)
c0107b6b:	e8 5f f8 ff ff       	call   c01073cf <mm_destroy>
    check_mm_struct = NULL;
c0107b70:	c7 05 ac 0b 12 c0 00 	movl   $0x0,0xc0120bac
c0107b77:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107b7a:	e8 b5 cb ff ff       	call   c0104734 <nr_free_pages>
c0107b7f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b82:	74 24                	je     c0107ba8 <check_pgfault+0x237>
c0107b84:	c7 44 24 0c 64 a4 10 	movl   $0xc010a464,0xc(%esp)
c0107b8b:	c0 
c0107b8c:	c7 44 24 08 e3 a3 10 	movl   $0xc010a3e3,0x8(%esp)
c0107b93:	c0 
c0107b94:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107b9b:	00 
c0107b9c:	c7 04 24 f8 a3 10 c0 	movl   $0xc010a3f8,(%esp)
c0107ba3:	e8 34 91 ff ff       	call   c0100cdc <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107ba8:	c7 04 24 50 a6 10 c0 	movl   $0xc010a650,(%esp)
c0107baf:	e8 97 87 ff ff       	call   c010034b <cprintf>
}
c0107bb4:	c9                   	leave  
c0107bb5:	c3                   	ret    

c0107bb6 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107bb6:	55                   	push   %ebp
c0107bb7:	89 e5                	mov    %esp,%ebp
c0107bb9:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107bbc:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107bc3:	8b 45 10             	mov    0x10(%ebp),%eax
c0107bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bcd:	89 04 24             	mov    %eax,(%esp)
c0107bd0:	e8 75 f5 ff ff       	call   c010714a <find_vma>
c0107bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107bd8:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0107bdd:	83 c0 01             	add    $0x1,%eax
c0107be0:	a3 b8 0a 12 c0       	mov    %eax,0xc0120ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107be5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107be9:	74 0b                	je     c0107bf6 <do_pgfault+0x40>
c0107beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bee:	8b 40 04             	mov    0x4(%eax),%eax
c0107bf1:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107bf4:	76 18                	jbe    c0107c0e <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107bf6:	8b 45 10             	mov    0x10(%ebp),%eax
c0107bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107bfd:	c7 04 24 6c a6 10 c0 	movl   $0xc010a66c,(%esp)
c0107c04:	e8 42 87 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107c09:	e9 8c 01 00 00       	jmp    c0107d9a <do_pgfault+0x1e4>
    }
    //check the error_code
    switch (error_code & 3) {
c0107c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107c11:	83 e0 03             	and    $0x3,%eax
c0107c14:	85 c0                	test   %eax,%eax
c0107c16:	74 36                	je     c0107c4e <do_pgfault+0x98>
c0107c18:	83 f8 01             	cmp    $0x1,%eax
c0107c1b:	74 20                	je     c0107c3d <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c20:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c23:	83 e0 02             	and    $0x2,%eax
c0107c26:	85 c0                	test   %eax,%eax
c0107c28:	75 11                	jne    c0107c3b <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107c2a:	c7 04 24 9c a6 10 c0 	movl   $0xc010a69c,(%esp)
c0107c31:	e8 15 87 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107c36:	e9 5f 01 00 00       	jmp    c0107d9a <do_pgfault+0x1e4>
        }
        break;
c0107c3b:	eb 2f                	jmp    c0107c6c <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107c3d:	c7 04 24 fc a6 10 c0 	movl   $0xc010a6fc,(%esp)
c0107c44:	e8 02 87 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107c49:	e9 4c 01 00 00       	jmp    c0107d9a <do_pgfault+0x1e4>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c51:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c54:	83 e0 05             	and    $0x5,%eax
c0107c57:	85 c0                	test   %eax,%eax
c0107c59:	75 11                	jne    c0107c6c <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107c5b:	c7 04 24 34 a7 10 c0 	movl   $0xc010a734,(%esp)
c0107c62:	e8 e4 86 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107c67:	e9 2e 01 00 00       	jmp    c0107d9a <do_pgfault+0x1e4>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107c6c:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c76:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c79:	83 e0 02             	and    $0x2,%eax
c0107c7c:	85 c0                	test   %eax,%eax
c0107c7e:	74 04                	je     c0107c84 <do_pgfault+0xce>
        perm |= PTE_W;
c0107c80:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107c84:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c87:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107c8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107c92:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107c95:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107c9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *   mm->pgdir : the PDT of these vma
    *
    */
//#if 0
    /*LAB3 EXERCISE 1: 2012011267*/
    ptep = get_pte(mm->pgdir, addr, 1);              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c0107ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ca6:	8b 40 0c             	mov    0xc(%eax),%eax
c0107ca9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107cb0:	00 
c0107cb1:	8b 55 10             	mov    0x10(%ebp),%edx
c0107cb4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107cb8:	89 04 24             	mov    %eax,(%esp)
c0107cbb:	e8 39 d1 ff ff       	call   c0104df9 <get_pte>
c0107cc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(ptep == NULL)
c0107cc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107cc7:	75 05                	jne    c0107cce <do_pgfault+0x118>
    	goto failed;
c0107cc9:	e9 cc 00 00 00       	jmp    c0107d9a <do_pgfault+0x1e4>
    if (*ptep == 0) {
c0107cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107cd1:	8b 00                	mov    (%eax),%eax
c0107cd3:	85 c0                	test   %eax,%eax
c0107cd5:	75 2f                	jne    c0107d06 <do_pgfault+0x150>
    	struct Page *page = pgdir_alloc_page(mm->pgdir, addr, perm);	//(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
c0107cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cda:	8b 40 0c             	mov    0xc(%eax),%eax
c0107cdd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107ce0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107ce4:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ce7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107ceb:	89 04 24             	mov    %eax,(%esp)
c0107cee:	e8 53 d4 ff ff       	call   c0105146 <pgdir_alloc_page>
c0107cf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    	if(page == NULL)
c0107cf6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107cfa:	75 05                	jne    c0107d01 <do_pgfault+0x14b>
    		goto failed;
c0107cfc:	e9 99 00 00 00       	jmp    c0107d9a <do_pgfault+0x1e4>
c0107d01:	e9 8d 00 00 00       	jmp    c0107d93 <do_pgfault+0x1dd>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c0107d06:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0107d0b:	85 c0                	test   %eax,%eax
c0107d0d:	74 6d                	je     c0107d7c <do_pgfault+0x1c6>
            struct Page *page=NULL;
c0107d0f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
            swap_in(mm, addr, &page);          				//(1）According to the mm AND addr, try to load the content of right disk page
c0107d16:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0107d19:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107d1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d24:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d27:	89 04 24             	mov    %eax,(%esp)
c0107d2a:	e8 e1 e5 ff ff       	call   c0106310 <swap_in>
                                    						//    into the memory which page managed.
            if(page == NULL)
c0107d2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d32:	85 c0                	test   %eax,%eax
c0107d34:	74 64                	je     c0107d9a <do_pgfault+0x1e4>
        	   goto failed;
            page_insert(mm->pgdir, page, addr, perm);       //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
c0107d36:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107d39:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d3c:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d3f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107d42:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107d49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107d4d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107d51:	89 04 24             	mov    %eax,(%esp)
c0107d54:	e8 d7 d2 ff ff       	call   c0105030 <page_insert>
            swap_map_swappable(mm, addr, page, 1);      	//(3) make the page swappable.
c0107d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d5c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0107d63:	00 
c0107d64:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107d68:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d72:	89 04 24             	mov    %eax,(%esp)
c0107d75:	e8 cd e3 ff ff       	call   c0106147 <swap_map_swappable>
c0107d7a:	eb 17                	jmp    c0107d93 <do_pgfault+0x1dd>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0107d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d7f:	8b 00                	mov    (%eax),%eax
c0107d81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d85:	c7 04 24 98 a7 10 c0 	movl   $0xc010a798,(%esp)
c0107d8c:	e8 ba 85 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107d91:	eb 07                	jmp    c0107d9a <do_pgfault+0x1e4>
        }
   }
//#endif
   ret = 0;
c0107d93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107d9d:	c9                   	leave  
c0107d9e:	c3                   	ret    

c0107d9f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107d9f:	55                   	push   %ebp
c0107da0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107da2:	8b 55 08             	mov    0x8(%ebp),%edx
c0107da5:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0107daa:	29 c2                	sub    %eax,%edx
c0107dac:	89 d0                	mov    %edx,%eax
c0107dae:	c1 f8 05             	sar    $0x5,%eax
}
c0107db1:	5d                   	pop    %ebp
c0107db2:	c3                   	ret    

c0107db3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107db3:	55                   	push   %ebp
c0107db4:	89 e5                	mov    %esp,%ebp
c0107db6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107db9:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dbc:	89 04 24             	mov    %eax,(%esp)
c0107dbf:	e8 db ff ff ff       	call   c0107d9f <page2ppn>
c0107dc4:	c1 e0 0c             	shl    $0xc,%eax
}
c0107dc7:	c9                   	leave  
c0107dc8:	c3                   	ret    

c0107dc9 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107dc9:	55                   	push   %ebp
c0107dca:	89 e5                	mov    %esp,%ebp
c0107dcc:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0107dcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dd2:	89 04 24             	mov    %eax,(%esp)
c0107dd5:	e8 d9 ff ff ff       	call   c0107db3 <page2pa>
c0107dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107de0:	c1 e8 0c             	shr    $0xc,%eax
c0107de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107de6:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0107deb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107dee:	72 23                	jb     c0107e13 <page2kva+0x4a>
c0107df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107df3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107df7:	c7 44 24 08 c0 a7 10 	movl   $0xc010a7c0,0x8(%esp)
c0107dfe:	c0 
c0107dff:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0107e06:	00 
c0107e07:	c7 04 24 e3 a7 10 c0 	movl   $0xc010a7e3,(%esp)
c0107e0e:	e8 c9 8e ff ff       	call   c0100cdc <__panic>
c0107e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e16:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107e1b:	c9                   	leave  
c0107e1c:	c3                   	ret    

c0107e1d <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107e1d:	55                   	push   %ebp
c0107e1e:	89 e5                	mov    %esp,%ebp
c0107e20:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107e23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107e2a:	e8 fd 9b ff ff       	call   c0101a2c <ide_device_valid>
c0107e2f:	85 c0                	test   %eax,%eax
c0107e31:	75 1c                	jne    c0107e4f <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0107e33:	c7 44 24 08 f1 a7 10 	movl   $0xc010a7f1,0x8(%esp)
c0107e3a:	c0 
c0107e3b:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107e42:	00 
c0107e43:	c7 04 24 0b a8 10 c0 	movl   $0xc010a80b,(%esp)
c0107e4a:	e8 8d 8e ff ff       	call   c0100cdc <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107e4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107e56:	e8 10 9c ff ff       	call   c0101a6b <ide_device_size>
c0107e5b:	c1 e8 03             	shr    $0x3,%eax
c0107e5e:	a3 7c 0b 12 c0       	mov    %eax,0xc0120b7c
}
c0107e63:	c9                   	leave  
c0107e64:	c3                   	ret    

c0107e65 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107e65:	55                   	push   %ebp
c0107e66:	89 e5                	mov    %esp,%ebp
c0107e68:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e6e:	89 04 24             	mov    %eax,(%esp)
c0107e71:	e8 53 ff ff ff       	call   c0107dc9 <page2kva>
c0107e76:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e79:	c1 ea 08             	shr    $0x8,%edx
c0107e7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107e7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e83:	74 0b                	je     c0107e90 <swapfs_read+0x2b>
c0107e85:	8b 15 7c 0b 12 c0    	mov    0xc0120b7c,%edx
c0107e8b:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107e8e:	72 23                	jb     c0107eb3 <swapfs_read+0x4e>
c0107e90:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e93:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107e97:	c7 44 24 08 1c a8 10 	movl   $0xc010a81c,0x8(%esp)
c0107e9e:	c0 
c0107e9f:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0107ea6:	00 
c0107ea7:	c7 04 24 0b a8 10 c0 	movl   $0xc010a80b,(%esp)
c0107eae:	e8 29 8e ff ff       	call   c0100cdc <__panic>
c0107eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107eb6:	c1 e2 03             	shl    $0x3,%edx
c0107eb9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107ec0:	00 
c0107ec1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107ec5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107ec9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107ed0:	e8 d5 9b ff ff       	call   c0101aaa <ide_read_secs>
}
c0107ed5:	c9                   	leave  
c0107ed6:	c3                   	ret    

c0107ed7 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107ed7:	55                   	push   %ebp
c0107ed8:	89 e5                	mov    %esp,%ebp
c0107eda:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107edd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ee0:	89 04 24             	mov    %eax,(%esp)
c0107ee3:	e8 e1 fe ff ff       	call   c0107dc9 <page2kva>
c0107ee8:	8b 55 08             	mov    0x8(%ebp),%edx
c0107eeb:	c1 ea 08             	shr    $0x8,%edx
c0107eee:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107ef5:	74 0b                	je     c0107f02 <swapfs_write+0x2b>
c0107ef7:	8b 15 7c 0b 12 c0    	mov    0xc0120b7c,%edx
c0107efd:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107f00:	72 23                	jb     c0107f25 <swapfs_write+0x4e>
c0107f02:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f05:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107f09:	c7 44 24 08 1c a8 10 	movl   $0xc010a81c,0x8(%esp)
c0107f10:	c0 
c0107f11:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0107f18:	00 
c0107f19:	c7 04 24 0b a8 10 c0 	movl   $0xc010a80b,(%esp)
c0107f20:	e8 b7 8d ff ff       	call   c0100cdc <__panic>
c0107f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f28:	c1 e2 03             	shl    $0x3,%edx
c0107f2b:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107f32:	00 
c0107f33:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107f37:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f42:	e8 a5 9d ff ff       	call   c0101cec <ide_write_secs>
}
c0107f47:	c9                   	leave  
c0107f48:	c3                   	ret    

c0107f49 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107f49:	55                   	push   %ebp
c0107f4a:	89 e5                	mov    %esp,%ebp
c0107f4c:	83 ec 58             	sub    $0x58,%esp
c0107f4f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107f52:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107f55:	8b 45 14             	mov    0x14(%ebp),%eax
c0107f58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0107f5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107f5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107f61:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107f64:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0107f67:	8b 45 18             	mov    0x18(%ebp),%eax
c0107f6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f70:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107f73:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107f76:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0107f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107f7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107f83:	74 1c                	je     c0107fa1 <printnum+0x58>
c0107f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f88:	ba 00 00 00 00       	mov    $0x0,%edx
c0107f8d:	f7 75 e4             	divl   -0x1c(%ebp)
c0107f90:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f96:	ba 00 00 00 00       	mov    $0x0,%edx
c0107f9b:	f7 75 e4             	divl   -0x1c(%ebp)
c0107f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107fa7:	f7 75 e4             	divl   -0x1c(%ebp)
c0107faa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107fad:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107fb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107fb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107fb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107fb9:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0107fbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107fbf:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0107fc2:	8b 45 18             	mov    0x18(%ebp),%eax
c0107fc5:	ba 00 00 00 00       	mov    $0x0,%edx
c0107fca:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107fcd:	77 56                	ja     c0108025 <printnum+0xdc>
c0107fcf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107fd2:	72 05                	jb     c0107fd9 <printnum+0x90>
c0107fd4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0107fd7:	77 4c                	ja     c0108025 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0107fd9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107fdc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107fdf:	8b 45 20             	mov    0x20(%ebp),%eax
c0107fe2:	89 44 24 18          	mov    %eax,0x18(%esp)
c0107fe6:	89 54 24 14          	mov    %edx,0x14(%esp)
c0107fea:	8b 45 18             	mov    0x18(%ebp),%eax
c0107fed:	89 44 24 10          	mov    %eax,0x10(%esp)
c0107ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ff4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107ff7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107ffb:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107fff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108002:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108006:	8b 45 08             	mov    0x8(%ebp),%eax
c0108009:	89 04 24             	mov    %eax,(%esp)
c010800c:	e8 38 ff ff ff       	call   c0107f49 <printnum>
c0108011:	eb 1c                	jmp    c010802f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108013:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108016:	89 44 24 04          	mov    %eax,0x4(%esp)
c010801a:	8b 45 20             	mov    0x20(%ebp),%eax
c010801d:	89 04 24             	mov    %eax,(%esp)
c0108020:	8b 45 08             	mov    0x8(%ebp),%eax
c0108023:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0108025:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0108029:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010802d:	7f e4                	jg     c0108013 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010802f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108032:	05 bc a8 10 c0       	add    $0xc010a8bc,%eax
c0108037:	0f b6 00             	movzbl (%eax),%eax
c010803a:	0f be c0             	movsbl %al,%eax
c010803d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108040:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108044:	89 04 24             	mov    %eax,(%esp)
c0108047:	8b 45 08             	mov    0x8(%ebp),%eax
c010804a:	ff d0                	call   *%eax
}
c010804c:	c9                   	leave  
c010804d:	c3                   	ret    

c010804e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010804e:	55                   	push   %ebp
c010804f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108051:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108055:	7e 14                	jle    c010806b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0108057:	8b 45 08             	mov    0x8(%ebp),%eax
c010805a:	8b 00                	mov    (%eax),%eax
c010805c:	8d 48 08             	lea    0x8(%eax),%ecx
c010805f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108062:	89 0a                	mov    %ecx,(%edx)
c0108064:	8b 50 04             	mov    0x4(%eax),%edx
c0108067:	8b 00                	mov    (%eax),%eax
c0108069:	eb 30                	jmp    c010809b <getuint+0x4d>
    }
    else if (lflag) {
c010806b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010806f:	74 16                	je     c0108087 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108071:	8b 45 08             	mov    0x8(%ebp),%eax
c0108074:	8b 00                	mov    (%eax),%eax
c0108076:	8d 48 04             	lea    0x4(%eax),%ecx
c0108079:	8b 55 08             	mov    0x8(%ebp),%edx
c010807c:	89 0a                	mov    %ecx,(%edx)
c010807e:	8b 00                	mov    (%eax),%eax
c0108080:	ba 00 00 00 00       	mov    $0x0,%edx
c0108085:	eb 14                	jmp    c010809b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0108087:	8b 45 08             	mov    0x8(%ebp),%eax
c010808a:	8b 00                	mov    (%eax),%eax
c010808c:	8d 48 04             	lea    0x4(%eax),%ecx
c010808f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108092:	89 0a                	mov    %ecx,(%edx)
c0108094:	8b 00                	mov    (%eax),%eax
c0108096:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010809b:	5d                   	pop    %ebp
c010809c:	c3                   	ret    

c010809d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010809d:	55                   	push   %ebp
c010809e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01080a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01080a4:	7e 14                	jle    c01080ba <getint+0x1d>
        return va_arg(*ap, long long);
c01080a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01080a9:	8b 00                	mov    (%eax),%eax
c01080ab:	8d 48 08             	lea    0x8(%eax),%ecx
c01080ae:	8b 55 08             	mov    0x8(%ebp),%edx
c01080b1:	89 0a                	mov    %ecx,(%edx)
c01080b3:	8b 50 04             	mov    0x4(%eax),%edx
c01080b6:	8b 00                	mov    (%eax),%eax
c01080b8:	eb 28                	jmp    c01080e2 <getint+0x45>
    }
    else if (lflag) {
c01080ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01080be:	74 12                	je     c01080d2 <getint+0x35>
        return va_arg(*ap, long);
c01080c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01080c3:	8b 00                	mov    (%eax),%eax
c01080c5:	8d 48 04             	lea    0x4(%eax),%ecx
c01080c8:	8b 55 08             	mov    0x8(%ebp),%edx
c01080cb:	89 0a                	mov    %ecx,(%edx)
c01080cd:	8b 00                	mov    (%eax),%eax
c01080cf:	99                   	cltd   
c01080d0:	eb 10                	jmp    c01080e2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01080d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01080d5:	8b 00                	mov    (%eax),%eax
c01080d7:	8d 48 04             	lea    0x4(%eax),%ecx
c01080da:	8b 55 08             	mov    0x8(%ebp),%edx
c01080dd:	89 0a                	mov    %ecx,(%edx)
c01080df:	8b 00                	mov    (%eax),%eax
c01080e1:	99                   	cltd   
    }
}
c01080e2:	5d                   	pop    %ebp
c01080e3:	c3                   	ret    

c01080e4 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01080e4:	55                   	push   %ebp
c01080e5:	89 e5                	mov    %esp,%ebp
c01080e7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01080ea:	8d 45 14             	lea    0x14(%ebp),%eax
c01080ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01080f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01080f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01080fa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01080fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108101:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108105:	8b 45 08             	mov    0x8(%ebp),%eax
c0108108:	89 04 24             	mov    %eax,(%esp)
c010810b:	e8 02 00 00 00       	call   c0108112 <vprintfmt>
    va_end(ap);
}
c0108110:	c9                   	leave  
c0108111:	c3                   	ret    

c0108112 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108112:	55                   	push   %ebp
c0108113:	89 e5                	mov    %esp,%ebp
c0108115:	56                   	push   %esi
c0108116:	53                   	push   %ebx
c0108117:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010811a:	eb 18                	jmp    c0108134 <vprintfmt+0x22>
            if (ch == '\0') {
c010811c:	85 db                	test   %ebx,%ebx
c010811e:	75 05                	jne    c0108125 <vprintfmt+0x13>
                return;
c0108120:	e9 d1 03 00 00       	jmp    c01084f6 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0108125:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108128:	89 44 24 04          	mov    %eax,0x4(%esp)
c010812c:	89 1c 24             	mov    %ebx,(%esp)
c010812f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108132:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108134:	8b 45 10             	mov    0x10(%ebp),%eax
c0108137:	8d 50 01             	lea    0x1(%eax),%edx
c010813a:	89 55 10             	mov    %edx,0x10(%ebp)
c010813d:	0f b6 00             	movzbl (%eax),%eax
c0108140:	0f b6 d8             	movzbl %al,%ebx
c0108143:	83 fb 25             	cmp    $0x25,%ebx
c0108146:	75 d4                	jne    c010811c <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0108148:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010814c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108156:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108159:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108160:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108163:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108166:	8b 45 10             	mov    0x10(%ebp),%eax
c0108169:	8d 50 01             	lea    0x1(%eax),%edx
c010816c:	89 55 10             	mov    %edx,0x10(%ebp)
c010816f:	0f b6 00             	movzbl (%eax),%eax
c0108172:	0f b6 d8             	movzbl %al,%ebx
c0108175:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108178:	83 f8 55             	cmp    $0x55,%eax
c010817b:	0f 87 44 03 00 00    	ja     c01084c5 <vprintfmt+0x3b3>
c0108181:	8b 04 85 e0 a8 10 c0 	mov    -0x3fef5720(,%eax,4),%eax
c0108188:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010818a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010818e:	eb d6                	jmp    c0108166 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108190:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0108194:	eb d0                	jmp    c0108166 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108196:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010819d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01081a0:	89 d0                	mov    %edx,%eax
c01081a2:	c1 e0 02             	shl    $0x2,%eax
c01081a5:	01 d0                	add    %edx,%eax
c01081a7:	01 c0                	add    %eax,%eax
c01081a9:	01 d8                	add    %ebx,%eax
c01081ab:	83 e8 30             	sub    $0x30,%eax
c01081ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01081b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01081b4:	0f b6 00             	movzbl (%eax),%eax
c01081b7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01081ba:	83 fb 2f             	cmp    $0x2f,%ebx
c01081bd:	7e 0b                	jle    c01081ca <vprintfmt+0xb8>
c01081bf:	83 fb 39             	cmp    $0x39,%ebx
c01081c2:	7f 06                	jg     c01081ca <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01081c4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01081c8:	eb d3                	jmp    c010819d <vprintfmt+0x8b>
            goto process_precision;
c01081ca:	eb 33                	jmp    c01081ff <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01081cc:	8b 45 14             	mov    0x14(%ebp),%eax
c01081cf:	8d 50 04             	lea    0x4(%eax),%edx
c01081d2:	89 55 14             	mov    %edx,0x14(%ebp)
c01081d5:	8b 00                	mov    (%eax),%eax
c01081d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01081da:	eb 23                	jmp    c01081ff <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01081dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01081e0:	79 0c                	jns    c01081ee <vprintfmt+0xdc>
                width = 0;
c01081e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01081e9:	e9 78 ff ff ff       	jmp    c0108166 <vprintfmt+0x54>
c01081ee:	e9 73 ff ff ff       	jmp    c0108166 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01081f3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01081fa:	e9 67 ff ff ff       	jmp    c0108166 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01081ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108203:	79 12                	jns    c0108217 <vprintfmt+0x105>
                width = precision, precision = -1;
c0108205:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108208:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010820b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108212:	e9 4f ff ff ff       	jmp    c0108166 <vprintfmt+0x54>
c0108217:	e9 4a ff ff ff       	jmp    c0108166 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010821c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0108220:	e9 41 ff ff ff       	jmp    c0108166 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108225:	8b 45 14             	mov    0x14(%ebp),%eax
c0108228:	8d 50 04             	lea    0x4(%eax),%edx
c010822b:	89 55 14             	mov    %edx,0x14(%ebp)
c010822e:	8b 00                	mov    (%eax),%eax
c0108230:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108233:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108237:	89 04 24             	mov    %eax,(%esp)
c010823a:	8b 45 08             	mov    0x8(%ebp),%eax
c010823d:	ff d0                	call   *%eax
            break;
c010823f:	e9 ac 02 00 00       	jmp    c01084f0 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108244:	8b 45 14             	mov    0x14(%ebp),%eax
c0108247:	8d 50 04             	lea    0x4(%eax),%edx
c010824a:	89 55 14             	mov    %edx,0x14(%ebp)
c010824d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010824f:	85 db                	test   %ebx,%ebx
c0108251:	79 02                	jns    c0108255 <vprintfmt+0x143>
                err = -err;
c0108253:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108255:	83 fb 06             	cmp    $0x6,%ebx
c0108258:	7f 0b                	jg     c0108265 <vprintfmt+0x153>
c010825a:	8b 34 9d a0 a8 10 c0 	mov    -0x3fef5760(,%ebx,4),%esi
c0108261:	85 f6                	test   %esi,%esi
c0108263:	75 23                	jne    c0108288 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0108265:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108269:	c7 44 24 08 cd a8 10 	movl   $0xc010a8cd,0x8(%esp)
c0108270:	c0 
c0108271:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108274:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108278:	8b 45 08             	mov    0x8(%ebp),%eax
c010827b:	89 04 24             	mov    %eax,(%esp)
c010827e:	e8 61 fe ff ff       	call   c01080e4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108283:	e9 68 02 00 00       	jmp    c01084f0 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0108288:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010828c:	c7 44 24 08 d6 a8 10 	movl   $0xc010a8d6,0x8(%esp)
c0108293:	c0 
c0108294:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108297:	89 44 24 04          	mov    %eax,0x4(%esp)
c010829b:	8b 45 08             	mov    0x8(%ebp),%eax
c010829e:	89 04 24             	mov    %eax,(%esp)
c01082a1:	e8 3e fe ff ff       	call   c01080e4 <printfmt>
            }
            break;
c01082a6:	e9 45 02 00 00       	jmp    c01084f0 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01082ab:	8b 45 14             	mov    0x14(%ebp),%eax
c01082ae:	8d 50 04             	lea    0x4(%eax),%edx
c01082b1:	89 55 14             	mov    %edx,0x14(%ebp)
c01082b4:	8b 30                	mov    (%eax),%esi
c01082b6:	85 f6                	test   %esi,%esi
c01082b8:	75 05                	jne    c01082bf <vprintfmt+0x1ad>
                p = "(null)";
c01082ba:	be d9 a8 10 c0       	mov    $0xc010a8d9,%esi
            }
            if (width > 0 && padc != '-') {
c01082bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01082c3:	7e 3e                	jle    c0108303 <vprintfmt+0x1f1>
c01082c5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01082c9:	74 38                	je     c0108303 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01082cb:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01082ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082d5:	89 34 24             	mov    %esi,(%esp)
c01082d8:	e8 ed 03 00 00       	call   c01086ca <strnlen>
c01082dd:	29 c3                	sub    %eax,%ebx
c01082df:	89 d8                	mov    %ebx,%eax
c01082e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01082e4:	eb 17                	jmp    c01082fd <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01082e6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01082ea:	8b 55 0c             	mov    0xc(%ebp),%edx
c01082ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082f1:	89 04 24             	mov    %eax,(%esp)
c01082f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01082f7:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01082f9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01082fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108301:	7f e3                	jg     c01082e6 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108303:	eb 38                	jmp    c010833d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108305:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108309:	74 1f                	je     c010832a <vprintfmt+0x218>
c010830b:	83 fb 1f             	cmp    $0x1f,%ebx
c010830e:	7e 05                	jle    c0108315 <vprintfmt+0x203>
c0108310:	83 fb 7e             	cmp    $0x7e,%ebx
c0108313:	7e 15                	jle    c010832a <vprintfmt+0x218>
                    putch('?', putdat);
c0108315:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108318:	89 44 24 04          	mov    %eax,0x4(%esp)
c010831c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0108323:	8b 45 08             	mov    0x8(%ebp),%eax
c0108326:	ff d0                	call   *%eax
c0108328:	eb 0f                	jmp    c0108339 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010832a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010832d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108331:	89 1c 24             	mov    %ebx,(%esp)
c0108334:	8b 45 08             	mov    0x8(%ebp),%eax
c0108337:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108339:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010833d:	89 f0                	mov    %esi,%eax
c010833f:	8d 70 01             	lea    0x1(%eax),%esi
c0108342:	0f b6 00             	movzbl (%eax),%eax
c0108345:	0f be d8             	movsbl %al,%ebx
c0108348:	85 db                	test   %ebx,%ebx
c010834a:	74 10                	je     c010835c <vprintfmt+0x24a>
c010834c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108350:	78 b3                	js     c0108305 <vprintfmt+0x1f3>
c0108352:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0108356:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010835a:	79 a9                	jns    c0108305 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010835c:	eb 17                	jmp    c0108375 <vprintfmt+0x263>
                putch(' ', putdat);
c010835e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108361:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108365:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010836c:	8b 45 08             	mov    0x8(%ebp),%eax
c010836f:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108371:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108375:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108379:	7f e3                	jg     c010835e <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010837b:	e9 70 01 00 00       	jmp    c01084f0 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108380:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108383:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108387:	8d 45 14             	lea    0x14(%ebp),%eax
c010838a:	89 04 24             	mov    %eax,(%esp)
c010838d:	e8 0b fd ff ff       	call   c010809d <getint>
c0108392:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108395:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108398:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010839b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010839e:	85 d2                	test   %edx,%edx
c01083a0:	79 26                	jns    c01083c8 <vprintfmt+0x2b6>
                putch('-', putdat);
c01083a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083a9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01083b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01083b3:	ff d0                	call   *%eax
                num = -(long long)num;
c01083b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01083b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01083bb:	f7 d8                	neg    %eax
c01083bd:	83 d2 00             	adc    $0x0,%edx
c01083c0:	f7 da                	neg    %edx
c01083c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01083c8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01083cf:	e9 a8 00 00 00       	jmp    c010847c <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01083d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083db:	8d 45 14             	lea    0x14(%ebp),%eax
c01083de:	89 04 24             	mov    %eax,(%esp)
c01083e1:	e8 68 fc ff ff       	call   c010804e <getuint>
c01083e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01083ec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01083f3:	e9 84 00 00 00       	jmp    c010847c <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01083f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083ff:	8d 45 14             	lea    0x14(%ebp),%eax
c0108402:	89 04 24             	mov    %eax,(%esp)
c0108405:	e8 44 fc ff ff       	call   c010804e <getuint>
c010840a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010840d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0108410:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108417:	eb 63                	jmp    c010847c <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0108419:	8b 45 0c             	mov    0xc(%ebp),%eax
c010841c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108420:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108427:	8b 45 08             	mov    0x8(%ebp),%eax
c010842a:	ff d0                	call   *%eax
            putch('x', putdat);
c010842c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010842f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108433:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010843a:	8b 45 08             	mov    0x8(%ebp),%eax
c010843d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010843f:	8b 45 14             	mov    0x14(%ebp),%eax
c0108442:	8d 50 04             	lea    0x4(%eax),%edx
c0108445:	89 55 14             	mov    %edx,0x14(%ebp)
c0108448:	8b 00                	mov    (%eax),%eax
c010844a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010844d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0108454:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010845b:	eb 1f                	jmp    c010847c <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010845d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108460:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108464:	8d 45 14             	lea    0x14(%ebp),%eax
c0108467:	89 04 24             	mov    %eax,(%esp)
c010846a:	e8 df fb ff ff       	call   c010804e <getuint>
c010846f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108472:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0108475:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010847c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108480:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108483:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108487:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010848a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010848e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108492:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108495:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108498:	89 44 24 08          	mov    %eax,0x8(%esp)
c010849c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01084a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01084aa:	89 04 24             	mov    %eax,(%esp)
c01084ad:	e8 97 fa ff ff       	call   c0107f49 <printnum>
            break;
c01084b2:	eb 3c                	jmp    c01084f0 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01084b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084bb:	89 1c 24             	mov    %ebx,(%esp)
c01084be:	8b 45 08             	mov    0x8(%ebp),%eax
c01084c1:	ff d0                	call   *%eax
            break;
c01084c3:	eb 2b                	jmp    c01084f0 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01084c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084cc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01084d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01084d6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01084d8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01084dc:	eb 04                	jmp    c01084e2 <vprintfmt+0x3d0>
c01084de:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01084e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01084e5:	83 e8 01             	sub    $0x1,%eax
c01084e8:	0f b6 00             	movzbl (%eax),%eax
c01084eb:	3c 25                	cmp    $0x25,%al
c01084ed:	75 ef                	jne    c01084de <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01084ef:	90                   	nop
        }
    }
c01084f0:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01084f1:	e9 3e fc ff ff       	jmp    c0108134 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01084f6:	83 c4 40             	add    $0x40,%esp
c01084f9:	5b                   	pop    %ebx
c01084fa:	5e                   	pop    %esi
c01084fb:	5d                   	pop    %ebp
c01084fc:	c3                   	ret    

c01084fd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01084fd:	55                   	push   %ebp
c01084fe:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0108500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108503:	8b 40 08             	mov    0x8(%eax),%eax
c0108506:	8d 50 01             	lea    0x1(%eax),%edx
c0108509:	8b 45 0c             	mov    0xc(%ebp),%eax
c010850c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010850f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108512:	8b 10                	mov    (%eax),%edx
c0108514:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108517:	8b 40 04             	mov    0x4(%eax),%eax
c010851a:	39 c2                	cmp    %eax,%edx
c010851c:	73 12                	jae    c0108530 <sprintputch+0x33>
        *b->buf ++ = ch;
c010851e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108521:	8b 00                	mov    (%eax),%eax
c0108523:	8d 48 01             	lea    0x1(%eax),%ecx
c0108526:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108529:	89 0a                	mov    %ecx,(%edx)
c010852b:	8b 55 08             	mov    0x8(%ebp),%edx
c010852e:	88 10                	mov    %dl,(%eax)
    }
}
c0108530:	5d                   	pop    %ebp
c0108531:	c3                   	ret    

c0108532 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0108532:	55                   	push   %ebp
c0108533:	89 e5                	mov    %esp,%ebp
c0108535:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108538:	8d 45 14             	lea    0x14(%ebp),%eax
c010853b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010853e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108541:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108545:	8b 45 10             	mov    0x10(%ebp),%eax
c0108548:	89 44 24 08          	mov    %eax,0x8(%esp)
c010854c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010854f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108553:	8b 45 08             	mov    0x8(%ebp),%eax
c0108556:	89 04 24             	mov    %eax,(%esp)
c0108559:	e8 08 00 00 00       	call   c0108566 <vsnprintf>
c010855e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108561:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108564:	c9                   	leave  
c0108565:	c3                   	ret    

c0108566 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108566:	55                   	push   %ebp
c0108567:	89 e5                	mov    %esp,%ebp
c0108569:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010856c:	8b 45 08             	mov    0x8(%ebp),%eax
c010856f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108572:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108575:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108578:	8b 45 08             	mov    0x8(%ebp),%eax
c010857b:	01 d0                	add    %edx,%eax
c010857d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108587:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010858b:	74 0a                	je     c0108597 <vsnprintf+0x31>
c010858d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108590:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108593:	39 c2                	cmp    %eax,%edx
c0108595:	76 07                	jbe    c010859e <vsnprintf+0x38>
        return -E_INVAL;
c0108597:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010859c:	eb 2a                	jmp    c01085c8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010859e:	8b 45 14             	mov    0x14(%ebp),%eax
c01085a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01085a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01085ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01085af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085b3:	c7 04 24 fd 84 10 c0 	movl   $0xc01084fd,(%esp)
c01085ba:	e8 53 fb ff ff       	call   c0108112 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01085bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01085c2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01085c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01085c8:	c9                   	leave  
c01085c9:	c3                   	ret    

c01085ca <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01085ca:	55                   	push   %ebp
c01085cb:	89 e5                	mov    %esp,%ebp
c01085cd:	57                   	push   %edi
c01085ce:	56                   	push   %esi
c01085cf:	53                   	push   %ebx
c01085d0:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c01085d3:	a1 60 fa 11 c0       	mov    0xc011fa60,%eax
c01085d8:	8b 15 64 fa 11 c0    	mov    0xc011fa64,%edx
c01085de:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c01085e4:	6b f0 05             	imul   $0x5,%eax,%esi
c01085e7:	01 f7                	add    %esi,%edi
c01085e9:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c01085ee:	f7 e6                	mul    %esi
c01085f0:	8d 34 17             	lea    (%edi,%edx,1),%esi
c01085f3:	89 f2                	mov    %esi,%edx
c01085f5:	83 c0 0b             	add    $0xb,%eax
c01085f8:	83 d2 00             	adc    $0x0,%edx
c01085fb:	89 c7                	mov    %eax,%edi
c01085fd:	83 e7 ff             	and    $0xffffffff,%edi
c0108600:	89 f9                	mov    %edi,%ecx
c0108602:	0f b7 da             	movzwl %dx,%ebx
c0108605:	89 0d 60 fa 11 c0    	mov    %ecx,0xc011fa60
c010860b:	89 1d 64 fa 11 c0    	mov    %ebx,0xc011fa64
    unsigned long long result = (next >> 12);
c0108611:	a1 60 fa 11 c0       	mov    0xc011fa60,%eax
c0108616:	8b 15 64 fa 11 c0    	mov    0xc011fa64,%edx
c010861c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0108620:	c1 ea 0c             	shr    $0xc,%edx
c0108623:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108626:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108629:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0108630:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108636:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108639:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010863c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010863f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108642:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108646:	74 1c                	je     c0108664 <rand+0x9a>
c0108648:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010864b:	ba 00 00 00 00       	mov    $0x0,%edx
c0108650:	f7 75 dc             	divl   -0x24(%ebp)
c0108653:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108656:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108659:	ba 00 00 00 00       	mov    $0x0,%edx
c010865e:	f7 75 dc             	divl   -0x24(%ebp)
c0108661:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108664:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108667:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010866a:	f7 75 dc             	divl   -0x24(%ebp)
c010866d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108670:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108673:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108676:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108679:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010867c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010867f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108682:	83 c4 24             	add    $0x24,%esp
c0108685:	5b                   	pop    %ebx
c0108686:	5e                   	pop    %esi
c0108687:	5f                   	pop    %edi
c0108688:	5d                   	pop    %ebp
c0108689:	c3                   	ret    

c010868a <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010868a:	55                   	push   %ebp
c010868b:	89 e5                	mov    %esp,%ebp
    next = seed;
c010868d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108690:	ba 00 00 00 00       	mov    $0x0,%edx
c0108695:	a3 60 fa 11 c0       	mov    %eax,0xc011fa60
c010869a:	89 15 64 fa 11 c0    	mov    %edx,0xc011fa64
}
c01086a0:	5d                   	pop    %ebp
c01086a1:	c3                   	ret    

c01086a2 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01086a2:	55                   	push   %ebp
c01086a3:	89 e5                	mov    %esp,%ebp
c01086a5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01086a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01086af:	eb 04                	jmp    c01086b5 <strlen+0x13>
        cnt ++;
c01086b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01086b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01086b8:	8d 50 01             	lea    0x1(%eax),%edx
c01086bb:	89 55 08             	mov    %edx,0x8(%ebp)
c01086be:	0f b6 00             	movzbl (%eax),%eax
c01086c1:	84 c0                	test   %al,%al
c01086c3:	75 ec                	jne    c01086b1 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01086c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01086c8:	c9                   	leave  
c01086c9:	c3                   	ret    

c01086ca <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01086ca:	55                   	push   %ebp
c01086cb:	89 e5                	mov    %esp,%ebp
c01086cd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01086d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01086d7:	eb 04                	jmp    c01086dd <strnlen+0x13>
        cnt ++;
c01086d9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01086dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01086e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01086e3:	73 10                	jae    c01086f5 <strnlen+0x2b>
c01086e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01086e8:	8d 50 01             	lea    0x1(%eax),%edx
c01086eb:	89 55 08             	mov    %edx,0x8(%ebp)
c01086ee:	0f b6 00             	movzbl (%eax),%eax
c01086f1:	84 c0                	test   %al,%al
c01086f3:	75 e4                	jne    c01086d9 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01086f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01086f8:	c9                   	leave  
c01086f9:	c3                   	ret    

c01086fa <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01086fa:	55                   	push   %ebp
c01086fb:	89 e5                	mov    %esp,%ebp
c01086fd:	57                   	push   %edi
c01086fe:	56                   	push   %esi
c01086ff:	83 ec 20             	sub    $0x20,%esp
c0108702:	8b 45 08             	mov    0x8(%ebp),%eax
c0108705:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108708:	8b 45 0c             	mov    0xc(%ebp),%eax
c010870b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010870e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108711:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108714:	89 d1                	mov    %edx,%ecx
c0108716:	89 c2                	mov    %eax,%edx
c0108718:	89 ce                	mov    %ecx,%esi
c010871a:	89 d7                	mov    %edx,%edi
c010871c:	ac                   	lods   %ds:(%esi),%al
c010871d:	aa                   	stos   %al,%es:(%edi)
c010871e:	84 c0                	test   %al,%al
c0108720:	75 fa                	jne    c010871c <strcpy+0x22>
c0108722:	89 fa                	mov    %edi,%edx
c0108724:	89 f1                	mov    %esi,%ecx
c0108726:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108729:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010872c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010872f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108732:	83 c4 20             	add    $0x20,%esp
c0108735:	5e                   	pop    %esi
c0108736:	5f                   	pop    %edi
c0108737:	5d                   	pop    %ebp
c0108738:	c3                   	ret    

c0108739 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0108739:	55                   	push   %ebp
c010873a:	89 e5                	mov    %esp,%ebp
c010873c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010873f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108742:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0108745:	eb 21                	jmp    c0108768 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0108747:	8b 45 0c             	mov    0xc(%ebp),%eax
c010874a:	0f b6 10             	movzbl (%eax),%edx
c010874d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108750:	88 10                	mov    %dl,(%eax)
c0108752:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108755:	0f b6 00             	movzbl (%eax),%eax
c0108758:	84 c0                	test   %al,%al
c010875a:	74 04                	je     c0108760 <strncpy+0x27>
            src ++;
c010875c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0108760:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108764:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0108768:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010876c:	75 d9                	jne    c0108747 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010876e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108771:	c9                   	leave  
c0108772:	c3                   	ret    

c0108773 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108773:	55                   	push   %ebp
c0108774:	89 e5                	mov    %esp,%ebp
c0108776:	57                   	push   %edi
c0108777:	56                   	push   %esi
c0108778:	83 ec 20             	sub    $0x20,%esp
c010877b:	8b 45 08             	mov    0x8(%ebp),%eax
c010877e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108781:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108784:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0108787:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010878a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010878d:	89 d1                	mov    %edx,%ecx
c010878f:	89 c2                	mov    %eax,%edx
c0108791:	89 ce                	mov    %ecx,%esi
c0108793:	89 d7                	mov    %edx,%edi
c0108795:	ac                   	lods   %ds:(%esi),%al
c0108796:	ae                   	scas   %es:(%edi),%al
c0108797:	75 08                	jne    c01087a1 <strcmp+0x2e>
c0108799:	84 c0                	test   %al,%al
c010879b:	75 f8                	jne    c0108795 <strcmp+0x22>
c010879d:	31 c0                	xor    %eax,%eax
c010879f:	eb 04                	jmp    c01087a5 <strcmp+0x32>
c01087a1:	19 c0                	sbb    %eax,%eax
c01087a3:	0c 01                	or     $0x1,%al
c01087a5:	89 fa                	mov    %edi,%edx
c01087a7:	89 f1                	mov    %esi,%ecx
c01087a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01087ac:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01087af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01087b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01087b5:	83 c4 20             	add    $0x20,%esp
c01087b8:	5e                   	pop    %esi
c01087b9:	5f                   	pop    %edi
c01087ba:	5d                   	pop    %ebp
c01087bb:	c3                   	ret    

c01087bc <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01087bc:	55                   	push   %ebp
c01087bd:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01087bf:	eb 0c                	jmp    c01087cd <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01087c1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01087c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01087c9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01087cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01087d1:	74 1a                	je     c01087ed <strncmp+0x31>
c01087d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01087d6:	0f b6 00             	movzbl (%eax),%eax
c01087d9:	84 c0                	test   %al,%al
c01087db:	74 10                	je     c01087ed <strncmp+0x31>
c01087dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01087e0:	0f b6 10             	movzbl (%eax),%edx
c01087e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087e6:	0f b6 00             	movzbl (%eax),%eax
c01087e9:	38 c2                	cmp    %al,%dl
c01087eb:	74 d4                	je     c01087c1 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01087ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01087f1:	74 18                	je     c010880b <strncmp+0x4f>
c01087f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01087f6:	0f b6 00             	movzbl (%eax),%eax
c01087f9:	0f b6 d0             	movzbl %al,%edx
c01087fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087ff:	0f b6 00             	movzbl (%eax),%eax
c0108802:	0f b6 c0             	movzbl %al,%eax
c0108805:	29 c2                	sub    %eax,%edx
c0108807:	89 d0                	mov    %edx,%eax
c0108809:	eb 05                	jmp    c0108810 <strncmp+0x54>
c010880b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108810:	5d                   	pop    %ebp
c0108811:	c3                   	ret    

c0108812 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108812:	55                   	push   %ebp
c0108813:	89 e5                	mov    %esp,%ebp
c0108815:	83 ec 04             	sub    $0x4,%esp
c0108818:	8b 45 0c             	mov    0xc(%ebp),%eax
c010881b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010881e:	eb 14                	jmp    c0108834 <strchr+0x22>
        if (*s == c) {
c0108820:	8b 45 08             	mov    0x8(%ebp),%eax
c0108823:	0f b6 00             	movzbl (%eax),%eax
c0108826:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108829:	75 05                	jne    c0108830 <strchr+0x1e>
            return (char *)s;
c010882b:	8b 45 08             	mov    0x8(%ebp),%eax
c010882e:	eb 13                	jmp    c0108843 <strchr+0x31>
        }
        s ++;
c0108830:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108834:	8b 45 08             	mov    0x8(%ebp),%eax
c0108837:	0f b6 00             	movzbl (%eax),%eax
c010883a:	84 c0                	test   %al,%al
c010883c:	75 e2                	jne    c0108820 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010883e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108843:	c9                   	leave  
c0108844:	c3                   	ret    

c0108845 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108845:	55                   	push   %ebp
c0108846:	89 e5                	mov    %esp,%ebp
c0108848:	83 ec 04             	sub    $0x4,%esp
c010884b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010884e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108851:	eb 11                	jmp    c0108864 <strfind+0x1f>
        if (*s == c) {
c0108853:	8b 45 08             	mov    0x8(%ebp),%eax
c0108856:	0f b6 00             	movzbl (%eax),%eax
c0108859:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010885c:	75 02                	jne    c0108860 <strfind+0x1b>
            break;
c010885e:	eb 0e                	jmp    c010886e <strfind+0x29>
        }
        s ++;
c0108860:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108864:	8b 45 08             	mov    0x8(%ebp),%eax
c0108867:	0f b6 00             	movzbl (%eax),%eax
c010886a:	84 c0                	test   %al,%al
c010886c:	75 e5                	jne    c0108853 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010886e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108871:	c9                   	leave  
c0108872:	c3                   	ret    

c0108873 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108873:	55                   	push   %ebp
c0108874:	89 e5                	mov    %esp,%ebp
c0108876:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108879:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0108880:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108887:	eb 04                	jmp    c010888d <strtol+0x1a>
        s ++;
c0108889:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010888d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108890:	0f b6 00             	movzbl (%eax),%eax
c0108893:	3c 20                	cmp    $0x20,%al
c0108895:	74 f2                	je     c0108889 <strtol+0x16>
c0108897:	8b 45 08             	mov    0x8(%ebp),%eax
c010889a:	0f b6 00             	movzbl (%eax),%eax
c010889d:	3c 09                	cmp    $0x9,%al
c010889f:	74 e8                	je     c0108889 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01088a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01088a4:	0f b6 00             	movzbl (%eax),%eax
c01088a7:	3c 2b                	cmp    $0x2b,%al
c01088a9:	75 06                	jne    c01088b1 <strtol+0x3e>
        s ++;
c01088ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01088af:	eb 15                	jmp    c01088c6 <strtol+0x53>
    }
    else if (*s == '-') {
c01088b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01088b4:	0f b6 00             	movzbl (%eax),%eax
c01088b7:	3c 2d                	cmp    $0x2d,%al
c01088b9:	75 0b                	jne    c01088c6 <strtol+0x53>
        s ++, neg = 1;
c01088bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01088bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01088c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088ca:	74 06                	je     c01088d2 <strtol+0x5f>
c01088cc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01088d0:	75 24                	jne    c01088f6 <strtol+0x83>
c01088d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01088d5:	0f b6 00             	movzbl (%eax),%eax
c01088d8:	3c 30                	cmp    $0x30,%al
c01088da:	75 1a                	jne    c01088f6 <strtol+0x83>
c01088dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01088df:	83 c0 01             	add    $0x1,%eax
c01088e2:	0f b6 00             	movzbl (%eax),%eax
c01088e5:	3c 78                	cmp    $0x78,%al
c01088e7:	75 0d                	jne    c01088f6 <strtol+0x83>
        s += 2, base = 16;
c01088e9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01088ed:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01088f4:	eb 2a                	jmp    c0108920 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01088f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088fa:	75 17                	jne    c0108913 <strtol+0xa0>
c01088fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ff:	0f b6 00             	movzbl (%eax),%eax
c0108902:	3c 30                	cmp    $0x30,%al
c0108904:	75 0d                	jne    c0108913 <strtol+0xa0>
        s ++, base = 8;
c0108906:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010890a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108911:	eb 0d                	jmp    c0108920 <strtol+0xad>
    }
    else if (base == 0) {
c0108913:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108917:	75 07                	jne    c0108920 <strtol+0xad>
        base = 10;
c0108919:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108920:	8b 45 08             	mov    0x8(%ebp),%eax
c0108923:	0f b6 00             	movzbl (%eax),%eax
c0108926:	3c 2f                	cmp    $0x2f,%al
c0108928:	7e 1b                	jle    c0108945 <strtol+0xd2>
c010892a:	8b 45 08             	mov    0x8(%ebp),%eax
c010892d:	0f b6 00             	movzbl (%eax),%eax
c0108930:	3c 39                	cmp    $0x39,%al
c0108932:	7f 11                	jg     c0108945 <strtol+0xd2>
            dig = *s - '0';
c0108934:	8b 45 08             	mov    0x8(%ebp),%eax
c0108937:	0f b6 00             	movzbl (%eax),%eax
c010893a:	0f be c0             	movsbl %al,%eax
c010893d:	83 e8 30             	sub    $0x30,%eax
c0108940:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108943:	eb 48                	jmp    c010898d <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108945:	8b 45 08             	mov    0x8(%ebp),%eax
c0108948:	0f b6 00             	movzbl (%eax),%eax
c010894b:	3c 60                	cmp    $0x60,%al
c010894d:	7e 1b                	jle    c010896a <strtol+0xf7>
c010894f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108952:	0f b6 00             	movzbl (%eax),%eax
c0108955:	3c 7a                	cmp    $0x7a,%al
c0108957:	7f 11                	jg     c010896a <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108959:	8b 45 08             	mov    0x8(%ebp),%eax
c010895c:	0f b6 00             	movzbl (%eax),%eax
c010895f:	0f be c0             	movsbl %al,%eax
c0108962:	83 e8 57             	sub    $0x57,%eax
c0108965:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108968:	eb 23                	jmp    c010898d <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010896a:	8b 45 08             	mov    0x8(%ebp),%eax
c010896d:	0f b6 00             	movzbl (%eax),%eax
c0108970:	3c 40                	cmp    $0x40,%al
c0108972:	7e 3d                	jle    c01089b1 <strtol+0x13e>
c0108974:	8b 45 08             	mov    0x8(%ebp),%eax
c0108977:	0f b6 00             	movzbl (%eax),%eax
c010897a:	3c 5a                	cmp    $0x5a,%al
c010897c:	7f 33                	jg     c01089b1 <strtol+0x13e>
            dig = *s - 'A' + 10;
c010897e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108981:	0f b6 00             	movzbl (%eax),%eax
c0108984:	0f be c0             	movsbl %al,%eax
c0108987:	83 e8 37             	sub    $0x37,%eax
c010898a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010898d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108990:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108993:	7c 02                	jl     c0108997 <strtol+0x124>
            break;
c0108995:	eb 1a                	jmp    c01089b1 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108997:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010899b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010899e:	0f af 45 10          	imul   0x10(%ebp),%eax
c01089a2:	89 c2                	mov    %eax,%edx
c01089a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089a7:	01 d0                	add    %edx,%eax
c01089a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01089ac:	e9 6f ff ff ff       	jmp    c0108920 <strtol+0xad>

    if (endptr) {
c01089b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01089b5:	74 08                	je     c01089bf <strtol+0x14c>
        *endptr = (char *) s;
c01089b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089ba:	8b 55 08             	mov    0x8(%ebp),%edx
c01089bd:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01089bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01089c3:	74 07                	je     c01089cc <strtol+0x159>
c01089c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01089c8:	f7 d8                	neg    %eax
c01089ca:	eb 03                	jmp    c01089cf <strtol+0x15c>
c01089cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01089cf:	c9                   	leave  
c01089d0:	c3                   	ret    

c01089d1 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01089d1:	55                   	push   %ebp
c01089d2:	89 e5                	mov    %esp,%ebp
c01089d4:	57                   	push   %edi
c01089d5:	83 ec 24             	sub    $0x24,%esp
c01089d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089db:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01089de:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01089e2:	8b 55 08             	mov    0x8(%ebp),%edx
c01089e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01089e8:	88 45 f7             	mov    %al,-0x9(%ebp)
c01089eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01089ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01089f1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01089f4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01089f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01089fb:	89 d7                	mov    %edx,%edi
c01089fd:	f3 aa                	rep stos %al,%es:(%edi)
c01089ff:	89 fa                	mov    %edi,%edx
c0108a01:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108a04:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108a07:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108a0a:	83 c4 24             	add    $0x24,%esp
c0108a0d:	5f                   	pop    %edi
c0108a0e:	5d                   	pop    %ebp
c0108a0f:	c3                   	ret    

c0108a10 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108a10:	55                   	push   %ebp
c0108a11:	89 e5                	mov    %esp,%ebp
c0108a13:	57                   	push   %edi
c0108a14:	56                   	push   %esi
c0108a15:	53                   	push   %ebx
c0108a16:	83 ec 30             	sub    $0x30,%esp
c0108a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a22:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108a25:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a28:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108a31:	73 42                	jae    c0108a75 <memmove+0x65>
c0108a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a42:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108a45:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a48:	c1 e8 02             	shr    $0x2,%eax
c0108a4b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108a4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108a53:	89 d7                	mov    %edx,%edi
c0108a55:	89 c6                	mov    %eax,%esi
c0108a57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108a59:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108a5c:	83 e1 03             	and    $0x3,%ecx
c0108a5f:	74 02                	je     c0108a63 <memmove+0x53>
c0108a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108a63:	89 f0                	mov    %esi,%eax
c0108a65:	89 fa                	mov    %edi,%edx
c0108a67:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108a6a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108a6d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a73:	eb 36                	jmp    c0108aab <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a78:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a7e:	01 c2                	add    %eax,%edx
c0108a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a83:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a89:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a8f:	89 c1                	mov    %eax,%ecx
c0108a91:	89 d8                	mov    %ebx,%eax
c0108a93:	89 d6                	mov    %edx,%esi
c0108a95:	89 c7                	mov    %eax,%edi
c0108a97:	fd                   	std    
c0108a98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108a9a:	fc                   	cld    
c0108a9b:	89 f8                	mov    %edi,%eax
c0108a9d:	89 f2                	mov    %esi,%edx
c0108a9f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108aa2:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108aa5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108aab:	83 c4 30             	add    $0x30,%esp
c0108aae:	5b                   	pop    %ebx
c0108aaf:	5e                   	pop    %esi
c0108ab0:	5f                   	pop    %edi
c0108ab1:	5d                   	pop    %ebp
c0108ab2:	c3                   	ret    

c0108ab3 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108ab3:	55                   	push   %ebp
c0108ab4:	89 e5                	mov    %esp,%ebp
c0108ab6:	57                   	push   %edi
c0108ab7:	56                   	push   %esi
c0108ab8:	83 ec 20             	sub    $0x20,%esp
c0108abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108ac7:	8b 45 10             	mov    0x10(%ebp),%eax
c0108aca:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ad0:	c1 e8 02             	shr    $0x2,%eax
c0108ad3:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108ad5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108adb:	89 d7                	mov    %edx,%edi
c0108add:	89 c6                	mov    %eax,%esi
c0108adf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108ae1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108ae4:	83 e1 03             	and    $0x3,%ecx
c0108ae7:	74 02                	je     c0108aeb <memcpy+0x38>
c0108ae9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108aeb:	89 f0                	mov    %esi,%eax
c0108aed:	89 fa                	mov    %edi,%edx
c0108aef:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108af2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108af5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108afb:	83 c4 20             	add    $0x20,%esp
c0108afe:	5e                   	pop    %esi
c0108aff:	5f                   	pop    %edi
c0108b00:	5d                   	pop    %ebp
c0108b01:	c3                   	ret    

c0108b02 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108b02:	55                   	push   %ebp
c0108b03:	89 e5                	mov    %esp,%ebp
c0108b05:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b11:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108b14:	eb 30                	jmp    c0108b46 <memcmp+0x44>
        if (*s1 != *s2) {
c0108b16:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108b19:	0f b6 10             	movzbl (%eax),%edx
c0108b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108b1f:	0f b6 00             	movzbl (%eax),%eax
c0108b22:	38 c2                	cmp    %al,%dl
c0108b24:	74 18                	je     c0108b3e <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108b29:	0f b6 00             	movzbl (%eax),%eax
c0108b2c:	0f b6 d0             	movzbl %al,%edx
c0108b2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108b32:	0f b6 00             	movzbl (%eax),%eax
c0108b35:	0f b6 c0             	movzbl %al,%eax
c0108b38:	29 c2                	sub    %eax,%edx
c0108b3a:	89 d0                	mov    %edx,%eax
c0108b3c:	eb 1a                	jmp    c0108b58 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108b3e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108b42:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108b46:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b49:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b4c:	89 55 10             	mov    %edx,0x10(%ebp)
c0108b4f:	85 c0                	test   %eax,%eax
c0108b51:	75 c3                	jne    c0108b16 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108b58:	c9                   	leave  
c0108b59:	c3                   	ret    
