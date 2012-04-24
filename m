From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: possible recursive locking detected in tne cma?
Date: Tue, 24 Apr 2012 14:36:38 +0300
Message-ID: <alpine.LRH.2.00.1203061550210.10585@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I hitted this one few days ago, problem is that I'm not sure
what **exactly** was the kernel I was using... surely it was
upstream post 3.3 something but not clear whose tree.

Specifically, I see that your commit 186834b5de69 "RDMA/ucma: Fix
AB-BA deadlock" deals only with the ucma and this trace doesn't
have ucma  symbols, so is that a different race? or false alarm?

Or.

=============================================
[ INFO: possible recursive locking detected ]
3.3.0-32035-g1b2649e-dirty #4 Not tainted
---------------------------------------------
kworker/5:1/418 is trying to acquire lock:
 (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0138a41>] rdma_destroy_id+0x33/0x1f0 [rdma_cm]

but task is already holding lock:
 (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0135130>] cma_disable_callback+0x24/0x45 [rdma_cm]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&id_priv->handler_mutex);
  lock(&id_priv->handler_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/5:1/418:
 #0:  (ib_cm){.+.+.+}, at: [<ffffffff81042ac1>] process_one_work+0x210/0x4a6
 #1:  ((&(&work->work)->work)){+.+.+.}, at: [<ffffffff81042ac1>] process_one_work+0x210/0x4a6
 #2:  (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0135130>] cma_disable_callback+0x24/0x45 [rdma_cm]

stack backtrace:
Pid: 418, comm: kworker/5:1 Not tainted 3.3.0-32035-g1b2649e-dirty #4
Call Trace:
 [<ffffffff8102b0fb>] ? console_unlock+0x1f4/0x204
 [<ffffffff81068771>] __lock_acquire+0x16b5/0x174e
 [<ffffffff8106461f>] ? save_trace+0x3f/0xb3
 [<ffffffff810688fa>] lock_acquire+0xf0/0x116
 [<ffffffffa0138a41>] ? rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffff81364351>] mutex_lock_nested+0x64/0x2ce
 [<ffffffffa0138a41>] ? rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffff81065a78>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffff81065abc>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa0138a41>] rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffffa0139c02>] cma_req_handler+0x418/0x644 [rdma_cm]
 [<ffffffffa012ee88>] cm_process_work+0x32/0x119 [ib_cm]
 [<ffffffffa0130299>] cm_req_handler+0x928/0x982 [ib_cm]
 [<ffffffffa01302f3>] ? cm_req_handler+0x982/0x982 [ib_cm]
 [<ffffffffa0130326>] cm_work_handler+0x33/0xfe5 [ib_cm]
 [<ffffffff81065a78>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffffa01302f3>] ? cm_req_handler+0x982/0x982 [ib_cm]
 [<ffffffff81042b6e>] process_one_work+0x2bd/0x4a6
 [<ffffffff81042ac1>] ? process_one_work+0x210/0x4a6
 [<ffffffff813669f3>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff8104316e>] worker_thread+0x1d6/0x350
 [<ffffffff81042f98>] ? rescuer_thread+0x241/0x241
 [<ffffffff81046a32>] kthread+0x84/0x8c
 [<ffffffff8136e854>] kernel_thread_helper+0x4/0x10
 [<ffffffff81366d59>] ? retint_restore_args+0xe/0xe
 [<ffffffff810469ae>] ? __init_kthread_worker+0x56/0x56
 [<ffffffff8136e850>] ? gs_change+0xb/0xb
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
