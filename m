From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: possible circular locking dependency in ucma
Date: Mon, 27 Feb 2012 11:20:52 +0200
Message-ID: <alpine.LRH.2.00.1202271115070.22652@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I run into the below ucma related warnings from the kernel with 3.3-rc5
when I stepped over crash of process as of wrong libs/etc (not the point
here...). Do you see here a real bug? basically the process was exiting
and the cleanup code in the kernel was running rdma_destroy_id when a
callback on that id was arriving from the IB CM. I saw that you lately
touched that/similar area in commit 9ced69ca5296567033804950d8d2161f454c5012
"RDMA/ucma: Discard all events for new connections until accepted"

Or.

======================================================
[ INFO: possible circular locking dependency detected ]
3.3.0-rc5-00008-g79f1e43-dirty #34 Tainted: G          I
-------------------------------------------------------
tgtd/9018 is trying to acquire lock:
 (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0359a41>] rdma_destroy_id+0x33/0x1f0 [rdma_cm]

but task is already holding lock:
 (&file->mut){+.+.+.}, at: [<ffffffffa02470fe>] ucma_free_ctx+0xb6/0x196 [rdma_ucm]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&file->mut){+.+.+.}:
       [<ffffffff810682f3>] lock_acquire+0xf0/0x116
       [<ffffffff8135f179>] mutex_lock_nested+0x64/0x2e6
       [<ffffffffa0247636>] ucma_event_handler+0x148/0x1dc [rdma_ucm]
       [<ffffffffa035a79a>] cma_ib_handler+0x1a7/0x1f7 [rdma_cm]
       [<ffffffffa0333e88>] cm_process_work+0x32/0x119 [ib_cm]
       [<ffffffffa03362ab>] cm_work_handler+0xfb8/0xfe5 [ib_cm]
       [<ffffffff810423e2>] process_one_work+0x2bd/0x4a6
       [<ffffffff810429e2>] worker_thread+0x1d6/0x350
       [<ffffffff810462a6>] kthread+0x84/0x8c
       [<ffffffff81369624>] kernel_thread_helper+0x4/0x10

-> #0 (&id_priv->handler_mutex){+.+.+.}:
       [<ffffffff81067b86>] __lock_acquire+0x10d5/0x1752
       [<ffffffff810682f3>] lock_acquire+0xf0/0x116
       [<ffffffff8135f179>] mutex_lock_nested+0x64/0x2e6
       [<ffffffffa0359a41>] rdma_destroy_id+0x33/0x1f0 [rdma_cm]
       [<ffffffffa024715f>] ucma_free_ctx+0x117/0x196 [rdma_ucm]
       [<ffffffffa0247255>] ucma_close+0x77/0xb4 [rdma_ucm]
       [<ffffffff810df6ef>] fput+0x117/0x1cf
       [<ffffffff810dc76e>] filp_close+0x6d/0x78
       [<ffffffff8102b667>] put_files_struct+0xbd/0x17d
       [<ffffffff8102b76d>] exit_files+0x46/0x4e
       [<ffffffff8102d057>] do_exit+0x299/0x75d
       [<ffffffff8102d599>] do_group_exit+0x7e/0xa9
       [<ffffffff8103ae4b>] get_signal_to_deliver+0x536/0x555
       [<ffffffff81001717>] do_signal+0x39/0x634
       [<ffffffff81001d39>] do_notify_resume+0x27/0x69
       [<ffffffff81361c03>] retint_signal+0x46/0x83

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&file->mut);
                               lock(&id_priv->handler_mutex);
                               lock(&file->mut);
  lock(&id_priv->handler_mutex);

 *** DEADLOCK ***

1 lock held by tgtd/9018:
 #0:  (&file->mut){+.+.+.}, at: [<ffffffffa02470fe>] ucma_free_ctx+0xb6/0x196 [rdma_ucm]

stack backtrace:
Pid: 9018, comm: tgtd Tainted: G          I  3.3.0-rc5-00008-g79f1e43-dirty #34
Call Trace:
 [<ffffffff81029e9c>] ? console_unlock+0x18e/0x207
 [<ffffffff81066433>] print_circular_bug+0x28e/0x29f
 [<ffffffff81067b86>] __lock_acquire+0x10d5/0x1752
 [<ffffffff810682f3>] lock_acquire+0xf0/0x116
 [<ffffffffa0359a41>] ? rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffff8135f179>] mutex_lock_nested+0x64/0x2e6
 [<ffffffffa0359a41>] ? rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffff8106546d>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffff810654b1>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa0359a41>] rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffffa024715f>] ucma_free_ctx+0x117/0x196 [rdma_ucm]
 [<ffffffffa0247255>] ucma_close+0x77/0xb4 [rdma_ucm]
 [<ffffffff810df6ef>] fput+0x117/0x1cf
 [<ffffffff810dc76e>] filp_close+0x6d/0x78
 [<ffffffff8102b667>] put_files_struct+0xbd/0x17d
 [<ffffffff8102b5cc>] ? put_files_struct+0x22/0x17d
 [<ffffffff8102b76d>] exit_files+0x46/0x4e
 [<ffffffff8102d057>] do_exit+0x299/0x75d
 [<ffffffff8102d599>] do_group_exit+0x7e/0xa9
 [<ffffffff8103ae4b>] get_signal_to_deliver+0x536/0x555
 [<ffffffff810654b1>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81001717>] do_signal+0x39/0x634
 [<ffffffff8135e037>] ? printk+0x3c/0x45
 [<ffffffff8106546d>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffff810654b1>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff81361803>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff81039011>] ? set_current_blocked+0x44/0x49
 [<ffffffff81361bce>] ? retint_signal+0x11/0x83
 [<ffffffff81001d39>] do_notify_resume+0x27/0x69
 [<ffffffff8118a1fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81361c03>] retint_signal+0x46/0x83

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
