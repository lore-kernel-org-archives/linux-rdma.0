From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: WARNING in cma_exit_net
Date: Tue, 02 Apr 2019 16:39:12 -0700
Message-ID: <1554248352.118779.171.camel@acm.org>
References: <0000000000008096f305857b74d1@google.com>
         <20190401174554.GE6209@ziepe.ca> <20190401182923.GK3201@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190401182923.GK3201@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: syzbot <syzbot+2e3e485d5697ea610460@syzkaller.appspotmail.com>, Matthew Wilcox <willy@infradead.org>, danielj@mellanox.com, danitg@mellanox.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, parav@mellanox.com, swise@opengridcomputing.com, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Mon, 2019-04-01 at 21:29 +-0300, Leon Romanovsky wrote:
+AD4 On Mon, Apr 01, 2019 at 02:45:54PM -0300, Jason Gunthorpe wrote:
+AD4 +AD4 On Mon, Apr 01, 2019 at 10:36:05AM -0700, syzbot wrote:
+AD4 +AD4 +AD4 Hello,
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 syzbot found the following crash on:
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 HEAD commit:    e3ecb83e Add linux-next specific files for 20190401
+AD4 +AD4 +AD4 git tree:       linux-next
+AD4 +AD4 +AD4 console output: https://syzkaller.appspot.com/x/log.txt?x+AD0-13bc36cd200000
+AD4 +AD4 +AD4 kernel config:  https://syzkaller.appspot.com/x/.config?x+AD0-db6c9f2bfeb91a99
+AD4 +AD4 +AD4 dashboard link: https://syzkaller.appspot.com/bug?extid+AD0-2e3e485d5697ea610460
+AD4 +AD4 +AD4 compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 Unfortunately, I don't have any reproducer for this crash yet.
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 IMPORTANT: if you fix the bug, please add the following tag to the commit:
+AD4 +AD4 +AD4 Reported-by: syzbot+-2e3e485d5697ea610460+AEA-syzkaller.appspotmail.com
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 WARNING: CPU: 1 PID: 7 at drivers/infiniband/core/cma.c:4674
+AD4 +AD4 +AD4 cma+AF8-exit+AF8-net+-0x327/0x390 drivers/infiniband/core/cma.c:4674
+AD4 +AD4 +AD4 Kernel panic - not syncing: panic+AF8-on+AF8-warn set ...
+AD4 +AD4 
+AD4 +AD4 Matt: This is why the WARN+AF8-ON(+ACE-xa+AF8-empty()) is so valuable. Magically
+AD4 +AD4 syzkaller can find something in this code is buggy.
+AD4 +AD4 
+AD4 +AD4 Mellanox is also showing a different testing failure over the weekend
+AD4 +AD4 (use after free or something) from your 'cma: Convert portspace IDRs
+AD4 +AD4 to XArray'
+AD4 
+AD4 This is what I see in my environment.
+AD4 
+AD4 +AFs   72.725596+AF0
+AD4 +AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9
+AD4 +AFs   72.726017+AF0 BUG: KASAN: use-after-free in cma+AF8-check+AF8-port+-0x86a/0xa20 +AFs-rdma+AF8-cm+AF0
+AD4 +AFs   72.726263+AF0 Read of size 8 at addr ffff888069fde998 by task ucmatose/387
+AD4 +AFs   72.726460+AF0
+AD4 +AFs   72.726550+AF0 CPU: 3 PID: 387 Comm: ucmatose Not tainted 5.1.0-rc2+- +ACM-253
+AD4 +AFs   72.726751+AF0 Hardware name: QEMU Standard PC (Q35 +- ICH9, 2009), BIOS
+AD4 rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
+AD4 +AFs   72.727119+AF0 Call Trace:
+AD4 +AFs   72.727210+AF0  dump+AF8-stack+-0x7c/0xc0
+AD4 +AFs   72.727342+AF0  print+AF8-address+AF8-description+-0x6c/0x23c
+AD4 +AFs   72.727505+AF0  ? cma+AF8-check+AF8-port+-0x86a/0xa20 +AFs-rdma+AF8-cm+AF0
+AD4 +AFs   72.727666+AF0  kasan+AF8-report.cold.3+-0x1c/0x35
+AD4 +AFs   72.727805+AF0  ? cma+AF8-check+AF8-port+-0x86a/0xa20 +AFs-rdma+AF8-cm+AF0
+AD4 +AFs   72.727977+AF0  ? cma+AF8-check+AF8-port+-0x86a/0xa20 +AFs-rdma+AF8-cm+AF0
+AD4 +AFs   72.728138+AF0  cma+AF8-check+AF8-port+-0x86a/0xa20 +AFs-rdma+AF8-cm+AF0
+AD4 +AFs   72.728306+AF0  rdma+AF8-bind+AF8-addr+-0x11bc/0x1b00 +AFs-rdma+AF8-cm+AF0
+AD4 +AFs   72.728465+AF0  ? find+AF8-held+AF8-lock+-0x33/0x1c0
+AD4 +AFs   72.728597+AF0  ? cma+AF8-ndev+AF8-work+AF8-handler+-0x180/0x180 +AFs-rdma+AF8-cm+AF0
+AD4 +AFs   72.728756+AF0  ? wait+AF8-for+AF8-completion+-0x3d0/0x3d0
+AD4 +AFs   72.728928+AF0  ucma+AF8-bind+-0x120/0x160 +AFs-rdma+AF8-ucm+AF0
+AD4 +AFs   72.729089+AF0  ? ucma+AF8-resolve+AF8-addr+-0x1a0/0x1a0 +AFs-rdma+AF8-ucm+AF0
+AD4 +AFs   72.729256+AF0  ucma+AF8-write+-0x1f8/0x2b0 +AFs-rdma+AF8-ucm+AF0
+AD4 +AFs   72.729409+AF0  ? ucma+AF8-open+-0x260/0x260 +AFs-rdma+AF8-ucm+AF0
+AD4 +AFs   72.729571+AF0  vfs+AF8-write+-0x157/0x460
+AD4 +AFs   72.729688+AF0  ksys+AF8-write+-0xb8/0x170
+AD4 +AFs   72.729828+AF0  ? +AF8AXw-ia32+AF8-sys+AF8-read+-0xb0/0xb0
+AD4 +AFs   72.729954+AF0  ? trace+AF8-hardirqs+AF8-off+AF8-caller+-0x5b/0x160
+AD4 +AFs   72.730107+AF0  ? do+AF8-syscall+AF8-64+-0x18/0x3c0
+AD4 +AFs   72.730243+AF0  do+AF8-syscall+AF8-64+-0x95/0x3c0
+AD4 +AFs   72.730363+AF0  entry+AF8-SYSCALL+AF8-64+AF8-after+AF8-hwframe+-0x49/0xbe
+AD4 +AFs   72.730508+AF0 RIP: 0033:0x7f6f1758fff8
+AD4 +AFs   72.730624+AF0 Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00
+AD4 00 f3 0f 1e fa 48 8d 05 25 77 0d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f
+AD4 05 +ADw-48+AD4 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4
+AD4  55
+AD4  +AFs   72.731146+AF0 RSP: 002b:00007fff99f99088 EFLAGS: 00000246 ORIG+AF8-RAX: 0000000000000001
+AD4  +AFs   72.731365+AF0 RAX: ffffffffffffffda RBX: 00007fff99f99090 RCX: 00007f6f1758fff8
+AD4  +AFs   72.731579+AF0 RDX: 0000000000000090 RSI: 00007fff99f99090 RDI: 0000000000000003
+AD4  +AFs   72.731814+AF0 RBP: 0000564942bd8ec0 R08: 0000564942bd9180 R09: 0000000000000000
+AD4  +AFs   72.732043+AF0 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
+AD4  +AFs   72.732262+AF0 R13: 0000000000000001 R14: 0000000000000000 R15: 00005649413cc470
+AD4  +AFs   72.732494+AF0
+AD4  +AFs   72.732572+AF0 Allocated by task 381:
+AD4  +AFs   72.732692+AF0  +AF8AXw-kasan+AF8-kmalloc.constprop.5+-0xc1/0xd0
+AD4  +AFs   72.732857+AF0  cma+AF8-alloc+AF8-port+-0x4d/0x160 +AFs-rdma+AF8-cm+AF0
+AD4  +AFs   72.733006+AF0  rdma+AF8-bind+AF8-addr+-0x14e7/0x1b00 +AFs-rdma+AF8-cm+AF0
+AD4  +AFs   72.733153+AF0  ucma+AF8-bind+-0x120/0x160 +AFs-rdma+AF8-ucm+AF0
+AD4  +AFs   72.733299+AF0  ucma+AF8-write+-0x1f8/0x2b0 +AFs-rdma+AF8-ucm+AF0
+AD4  +AFs   72.733452+AF0  vfs+AF8-write+-0x157/0x460
+AD4  +AFs   72.733569+AF0  ksys+AF8-write+-0xb8/0x170
+AD4  +AFs   72.733675+AF0  do+AF8-syscall+AF8-64+-0x95/0x3c0
+AD4  +AFs   72.733800+AF0  entry+AF8-SYSCALL+AF8-64+AF8-after+AF8-hwframe+-0x49/0xbe
+AD4  +AFs   72.733956+AF0
+AD4  +AFs   72.734029+AF0 Freed by task 381:
+AD4  +AFs   72.734133+AF0  +AF8AXw-kasan+AF8-slab+AF8-free+-0x12e/0x180
+AD4  +AFs   72.734284+AF0  kfree+-0xed/0x290
+AD4  +AFs   72.734399+AF0  rdma+AF8-destroy+AF8-id+-0x6b6/0x9e0 +AFs-rdma+AF8-cm+AF0
+AD4  +AFs   72.734559+AF0  ucma+AF8-close+-0x110/0x300 +AFs-rdma+AF8-ucm+AF0
+AD4  +AFs   72.734701+AF0  +AF8AXw-fput+-0x25a/0x740
+AD4  +AFs   72.734832+AF0  task+AF8-work+AF8-run+-0x10e/0x190
+AD4  +AFs   72.734959+AF0  do+AF8-exit+-0x85e/0x29e0
+AD4  +AFs   72.735071+AF0  do+AF8-group+AF8-exit+-0xf0/0x2e0
+AD4  +AFs   72.735182+AF0  get+AF8-signal+-0x2e0/0x17e0
+AD4  +AFs   72.735304+AF0  do+AF8-signal+-0x94/0x1570
+AD4  +AFs   72.735424+AF0  exit+AF8-to+AF8-usermode+AF8-loop+-0xfa/0x130
+AD4  +AFs   72.735612+AF0  do+AF8-syscall+AF8-64+-0x327/0x3c0
+AD4  +AFs   72.735756+AF0  entry+AF8-SYSCALL+AF8-64+AF8-after+AF8-hwframe+-0x49/0xbe
+AD4  +AFs   72.735941+AF0
+AD4  +AFs   72.736033+AF0 The buggy address belongs to the object at ffff888069fde990
+AD4  +AFs   72.736033+AF0  which belongs to the cache kmalloc-32 of size 32
+AD4  +AFs   72.736414+AF0 The buggy address is located 8 bytes inside of
+AD4  +AFs   72.736414+AF0  32-byte region +AFs-ffff888069fde990, ffff888069fde9b0)
+AD4  +AFs   72.736777+AF0 The buggy address belongs to the page:
+AD4  +AFs   72.736940+AF0 page:ffffea0001a7f780 count:1 mapcount:0 mapping:ffff88806bc03980 index:0x0
+AD4  +AFs   72.737171+AF0 flags: 0x4000000000000200(slab)
+AD4  +AFs   72.737295+AF0 raw: 4000000000000200 dead000000000100 dead000000000200 ffff88806bc03980
+AD4  +AFs   72.737525+AF0 raw: 0000000000000000 0000000000550055 00000001ffffffff 0000000000000000
+AD4  +AFs   72.737786+AF0 page dumped because: kasan: bad access detected
+AD4  +AFs   72.737948+AF0
+AD4  +AFs   72.738019+AF0 Memory state around the buggy address:
+AD4  +AFs   72.738164+AF0  ffff888069fde880: fb fb fc fc fb fb fb fb fc fc fb fb  fb fb fc fc
+AD4  +AFs   72.738396+AF0  ffff888069fde900: fb fb fb fb fc fc fb fb fb fb fc fc  fb fb fb fb
+AD4  +AFs   72.738627+AF0 +AD4-ffff888069fde980: fc fc fb fb fb fb fc fc fb fb fb fb  fc fc fb fb
+AD4  +AFs   72.738869+AF0                             +AF4
+AD4  +AFs   72.738999+AF0  ffff888069fdea00: fb fb fc fc fb fb fb fb fc fc fb fb  fb fb fc fc
+AD4  +AFs   72.739213+AF0  ffff888069fdea80: fb fb fb fb fc fc fb fb fb fb fc fc fb fb fb fb
+AD4  +AFs   72.739431+AF0
+AD4  +AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9
+AD4  +AFs   72.739667+AF0 Disabling lock debugging due to kernel taint

This is what I encountered while running blktests:

nvmet: adding nsid 1 to subsystem nvme-test
+AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9
BUG: KASAN: use-after-free in cma+AF8-check+AF8-port+-0x28/0x400 +AFs-rdma+AF8-cm+AF0
Read of size 8 at addr ffff8880ba96f818 by task ln/10510

CPU: 5 PID: 10510 Comm: ln Not tainted 5.1.0-rc3-dbg+- +ACM-9
Hardware name: QEMU Standard PC (i440FX +- PIIX, 1996), BIOS 1.10.2-1 04/01/2014
Call Trace:
 dump+AF8-stack+-0x86/0xca
 print+AF8-address+AF8-description+-0x71/0x239
 ? cma+AF8-check+AF8-port+-0x28/0x400 +AFs-rdma+AF8-cm+AF0
 kasan+AF8-report.cold.3+-0x1b/0x3e
 ? cma+AF8-check+AF8-port+-0x28/0x400 +AFs-rdma+AF8-cm+AF0
 +AF8AXw-asan+AF8-load8+-0x54/0x90
 cma+AF8-check+AF8-port+-0x28/0x400 +AFs-rdma+AF8-cm+AF0
 rdma+AF8-bind+AF8-addr+-0xc13/0xe80 +AFs-rdma+AF8-cm+AF0
 ? cma+AF8-ndev+AF8-work+AF8-handler+-0xf0/0xf0 +AFs-rdma+AF8-cm+AF0
 ? lockdep+AF8-hardirqs+AF8-on+-0x185/0x260
 ? +AF8-raw+AF8-spin+AF8-unlock+AF8-irqrestore+-0x57/0x70
 ? trace+AF8-hardirqs+AF8-on+-0x24/0x130
 ? preempt+AF8-count+AF8-sub+-0x18/0xd0
 ? +AF8-raw+AF8-spin+AF8-unlock+AF8-irqrestore+-0x42/0x70
 nvmet+AF8-rdma+AF8-add+AF8-port+-0x143/0x1a0 +AFs-nvmet+AF8-rdma+AF0
 ? nvmet+AF8-rdma+AF8-remove+AF8-port+-0x40/0x40 +AFs-nvmet+AF8-rdma+AF0
 nvmet+AF8-enable+AF8-port+-0x85/0x180 +AFs-nvmet+AF0
 nvmet+AF8-port+AF8-subsys+AF8-allow+AF8-link+-0x1bc/0x1e0 +AFs-nvmet+AF0
 ? do+AF8-raw+AF8-spin+AF8-unlock+-0xa8/0x140
 configfs+AF8-symlink+-0x2b6/0x650
 ? configfs+AF8-get+AF8-link+-0x3e0/0x3e0
 ? inode+AF8-permission+-0x69/0x200
 vfs+AF8-symlink+-0x163/0x230
 do+AF8-symlinkat+-0xeb/0x160
 ? +AF8AXw-ia32+AF8-sys+AF8-unlink+-0x40/0x40
 ? do+AF8-syscall+AF8-64+-0x19/0x210
 ? entry+AF8-SYSCALL+AF8-64+AF8-after+AF8-hwframe+-0x49/0xbe
 +AF8AXw-x64+AF8-sys+AF8-symlinkat+-0x43/0x50
 do+AF8-syscall+AF8-64+-0x71/0x210
 entry+AF8-SYSCALL+AF8-64+AF8-after+AF8-hwframe+-0x49/0xbe
RIP: 0033:0x7f35b984d9e7
Code: 73 01 c3 48 8b 0d a9 84 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0a 01 00 00 0f 05 +ADw-48+AD4 3d 01 f0 ff ff 73 01 c3 48 8b 0d 79 84 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffcc3a88af8 EFLAGS: 00000246 ORIG+AF8-RAX: 000000000000010a
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f35b984d9e7
RDX: 000055c1855f82b0 RSI: 00000000ffffff9c RDI: 00007ffcc3a8a7a6
RBP: 00000000ffffff9c R08: 000055c1855f8010 R09: 0000000000000000
R10: fffffffffffff000 R11: 0000000000000246 R12: 000055c1855f82b0
R13: 00007ffcc3a8a7a6 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 10270:
 save+AF8-stack+-0x43/0xd0
 +AF8AXw-kasan+AF8-kmalloc.constprop.9+-0xc7/0xd0
 kasan+AF8-kmalloc+-0x9/0x10
 kmem+AF8-cache+AF8-alloc+AF8-trace+-0x143/0x350
 cma+AF8-alloc+AF8-port+-0x3d/0xf0 +AFs-rdma+AF8-cm+AF0
 rdma+AF8-bind+AF8-addr+-0xdf9/0xe80 +AFs-rdma+AF8-cm+AF0
 nvmet+AF8-clear+AF8-ctrl+-0x43/0x70 +AFs-nvmet+AF0
 rxe+AF8-opcode+-0x15f5/0xfffffffffffef380 +AFs-rdma+AF8-rxe+AF0
 rxe+AF8-wr+AF8-opcode+AF8-info+-0xa4c/0xfffffffffffeb360 +AFs-rdma+AF8-rxe+AF0
 configfs+AF8-symlink+-0x2b6/0x650
 vfs+AF8-symlink+-0x163/0x230
 do+AF8-symlinkat+-0xeb/0x160
 +AF8AXw-x64+AF8-sys+AF8-symlinkat+-0x43/0x50
 do+AF8-syscall+AF8-64+-0x71/0x210
 entry+AF8-SYSCALL+AF8-64+AF8-after+AF8-hwframe+-0x49/0xbe

Freed by task 10340:
 save+AF8-stack+-0x43/0xd0
 +AF8AXw-kasan+AF8-slab+AF8-free+-0x139/0x190
 kasan+AF8-slab+AF8-free+-0xe/0x10
 kfree+-0x103/0x320
 rdma+AF8-destroy+AF8-id+-0x42c/0x460 +AFs-rdma+AF8-cm+AF0
 nvmet+AF8-ctrl+AF8-fatal+AF8-error+-0x31/0x80 +AFs-nvmet+AF0
 rxe+AF8-opcode+-0x175d/0xfffffffffffef380 +AFs-rdma+AF8-rxe+AF0
 rxe+AF8-wr+AF8-opcode+AF8-info+-0x644/0xfffffffffffeb360 +AFs-rdma+AF8-rxe+AF0
 configfs+AF8-unlink+-0x216/0x350
 vfs+AF8-unlink+-0x171/0x260
 do+AF8-unlinkat+-0x347/0x490
 +AF8AXw-x64+AF8-sys+AF8-unlinkat+-0x60/0x90
 do+AF8-syscall+AF8-64+-0x71/0x210
 entry+AF8-SYSCALL+AF8-64+AF8-after+AF8-hwframe+-0x49/0xbe

The buggy address belongs to the object at ffff8880ba96f810
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 8 bytes inside of
 32-byte region +AFs-ffff8880ba96f810, ffff8880ba96f830)
The buggy address belongs to the page:
page:ffffea0002ea5bc0 count:1 mapcount:0 mapping:ffff88811b003800 index:0x0
flags: 0x1fff000000000200(slab)
raw: 1fff000000000200 ffffea0004319200 0000000900000009 ffff88811b003800
raw: 0000000000000000 0000000000550055 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880ba96f700: fb fb fc fc fb fb fb fb fc fc fb fb fb fb fc fc
 ffff8880ba96f780: fb fb fb fb fc fc fb fb fb fb fc fc fb fb fb fb
+AD4-ffff8880ba96f800: fc fc fb fb fb fb fc fc fb fb fb fb fc fc fb fb
                            +AF4
 ffff8880ba96f880: fb fb fc fc fb fb fb fb fc fc fb fb fb fb fc fc
 ffff8880ba96f900: fb fb fb fb fc fc fb fb fb fb fc fc fb fb fb fb
+AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9AD0APQA9
Disabling lock debugging due to kernel taint
nvmet+AF8-rdma: enabling port 1 (192.168.122.49:7777)
