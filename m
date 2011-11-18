From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: dapltest-server segfault seen on recent OFED-1.5.4 daily build
Date: Fri, 18 Nov 2011 14:31:57 +0530
Message-ID: <20111118090155.GB17346@kumars-PC.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

I am trying to debug a segfault observed on dapltest-server with OFED-1.5.4.
I am using the daily-build OFED-1.5.4-20111116-0600 for this test.
The test setup involves 4 machines connected via switch.
1 machine acts as dapltest-server while rest 3 machines act as dapltest clients.

We are running several different kinds of RDMA read/write tests on dapl in continuous
loop using a script. The test runs fine for around 2 hours or so. And after that, the
dapltest-server segfaults with below stack trace:

-----------
Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff6e30710 (LWP 2397)]
dapl_llist_remove_entry (head=0x636960, entry=0x7ffff0004bf8) at
dapl/common/dapl_llist.c:272
272     dapl/common/dapl_llist.c: No such file or directory.
        in dapl/common/dapl_llist.c
Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.7.el6.x86_64
libgcc-4.4.4-13.el6.x86_64
(gdb) bt
#0  dapl_llist_remove_entry (head=0x636960, entry=0x7ffff0004bf8) at
dapl/common/dapl_llist.c:272
#1  0x00007ffff799fb09 in dapl_sp_remove_cr (sp_ptr=0x6368c0,
cr_ptr=0x7ffff0004be0) at dapl/common/dapl_sp_util.c:229
#2  0x00007ffff7998148 in dapli_connection_request (ib_cm_handle=<value
optimized out>, sp_ptr=0x6368c0, prd_ptr=<value optimized out>, 
    private_data_size=<value optimized out>, evd_ptr=0x633fb0) at
dapl/common/dapl_cr_callback.c:424
#3  0x00007ffff799851e in dapls_cr_callback (ib_cm_handle=0x7ffff0004880,
ib_cm_event=IB_CME_CONNECTION_REQUEST_PENDING, 
    private_data_ptr=0x0, private_data_size=0, context=0x6368c0) at
dapl/common/dapl_cr_callback.c:178
#4  0x00007ffff79a4c33 in dapli_cm_passive_cb () at dapl/openib_cma/cm.c:524
#5  dapli_cma_event_cb () at dapl/openib_cma/cm.c:1207
#6  0x00007ffff79a6657 in dapli_thread (arg=<value optimized out>) at
dapl/openib_cma/device.c:692
#7  0x00007ffff79971d1 in dapli_thread_init (thread_draft=0x630320) at
dapl/udapl/linux/dapl_osd.c:590
#8  0x0000003b156077e1 in start_thread () from /lib64/libpthread.so.0
#9  0x0000003b14ee153d in clone () from /lib64/libc.so.6
(gdb) p
The history is empty.
(gdb) info args
head = 0x636960
entry = 0x7ffff0004bf8
(gdb) p *head
$1 = (DAPL_LLIST_HEAD) 0x7ffff00107d8
(gdb) p *entry
$2 = {flink = 0x0, blink = 0x7ffff0003cf8, data = 0x7ffff0004be0, list_head =
0x0}
(gdb) info thread
  950 Thread 0x7ffff7fef710 (LWP 3924)  0x0000003b1560b43c in
pthread_cond_wait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
  949 Thread 0x7ffff5f76710 (LWP 3923)  0x0000003b1560eced in nanosleep () from
/lib64/libpthread.so.0
* 2 Thread 0x7ffff6e30710 (LWP 2397)  dapl_llist_remove_entry (head=0x636960,
entry=0x7ffff0004bf8) at dapl/common/dapl_llist.c:272
  1 Thread 0x7ffff7bb0700 (LWP 2394)  0x0000003b14ed7e33 in poll () from
/lib64/libc.so.6
(gdb) p head
$3 = (DAPL_LLIST_HEAD *) 0x636960
(gdb) p entry
$4 = (DAPL_LLIST_ENTRY *) 0x7ffff0004bf8
(gdb) p *entry
$5 = {flink = 0x0, blink = 0x7ffff0003cf8, data = 0x7ffff0004be0, list_head =
0x0}
(gdb) p *head
$6 = (DAPL_LLIST_HEAD) 0x7ffff00107d8
(gdb) 
-----------


The problematic line in dapl source code is:
-------------
File dapl/common/dapl_llist.c#dapl_llist_remove_entry function:
....
        dapl_os_assert(entry->list_head == head);
        entry->list_head = NULL;

        entry->flink->blink = entry->blink; <===== Problem line. flink is NULL
        entry->blink->flink = entry->flink;
....
--------------

Now, it seems that some time back, a new release of dapl (dapl-2.0.34-1.src.rpm) was
introduced in OFED-1.5.4. So, I am just wondering if this is a regression in the new
release of dapl?
Or if anyone is aware of this issue and what could possibly lead to this
dapltest-server segfault then, it would be helpful if someone can shed some light.


Thanks,
Kumar.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
