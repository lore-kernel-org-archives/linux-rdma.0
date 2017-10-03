From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH 2/2] IB/hfi1: Handle packets in the theaded handler only
Date: Tue,  3 Oct 2017 12:49:20 -0300
Message-ID: <20171003154920.31566-3-acme@kernel.org>
References: <20171003154920.31566-1-acme@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171003154920.31566-1-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bigeasy@linutronix.de
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Julia Cartwright <julia@ni.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The hfi1 driver calls request_threaded_irq with two parameters:

      handler = receive_context_interrupt;
      thread = receive_context_thread;
      request_threaded_irq(me->msix.vector, handler, thread, 0, me->name, arg);

And tries to process packets on the hard irq one, receive_context_interrupt(),
only waking up the thread (returning IRQ_WAKE_THREAD) when some threshold is
crossed in the number of packets available in the NIC, trying to balance
latency and bandwidth.

But in a CONFIG_PREEMPT_RT_FULL kernel it ends up calling spin locks from the
hard irq handler (receive_context_interrupt) which causes BUGs like this:

  [ 1002.740581] hfi1 0000:21:00.0: hfi1_0: set_link_state: current ARMED, new ACTIVE
  [ 1002.740583] hfi1 0000:21:00.0: hfi1_0: logical state changed to PORT_ACTIVE (0x4)
  [ 1002.740599] hfi1 0000:21:00.0: hfi1_0: send_idle_message: sending idle message 0x203
  [ 1002.741873] hfi1 0000:21:00.0: hfi1_0: read_idle_message: read idle message 0x203
  [ 1002.741874] hfi1 0000:21:00.0: hfi1_0: handle_sma_message: SMA message 0x2
  [ 1002.741923] hfi1 0000:21:00.0: hfi1_0: Switching to NO_DMA_RTAIL
  [ 1004.744192] IPv6: ADDRCONF(NETDEV_CHANGE): hfi1_opa0: link becomes ready
  [ 1167.907754] ------------[ cut here ]------------
  [ 1167.907756] kernel BUG at kernel/rtmutex.c:902!
  [ 1167.907758] invalid opcode: 0000 [#1] PREEMPT SMP
  <SNIP>
  [ 1167.907805] CPU: 10 PID: 1505 Comm: hfi1_cq0 Not tainted 3.10.0-708.rt56.635.test.el7.x86_64 #1
  <SNIP>
  [ 1167.907823] Call Trace:
  [ 1167.907826]  <IRQ>
  [ 1167.907850]  [<ffffffffc06e4981>] ? hfi1_rvt_get_rwqe+0x141/0x400 [hfi1]
  [ 1167.907852]  [<ffffffff816b7625>] rt_spin_lock+0x25/0x30
  [ 1167.907856]  [<ffffffff810aa774>] queue_kthread_work+0x24/0x60
  [ 1167.907861]  [<ffffffffc068845b>] rvt_cq_enter+0x17b/0x250 [rdmavt]
  [ 1167.907869]  [<ffffffffc06e391a>] hfi1_rc_rcv+0x67a/0x1260 [hfi1]
  [ 1167.907878]  [<ffffffffc06fefc8>] hfi1_ib_rcv+0x2c8/0x400 [hfi1]
  [ 1167.907886]  [<ffffffffc06c381c>] process_receive_ib+0x6c/0x150 [hfi1]
  [ 1167.907888]  [<ffffffff810cee9d>] ? enqueue_pushable_task+0x6d/0x90
  [ 1167.907895]  [<ffffffffc06c1f31>] handle_receive_interrupt_nodma_rtail+0x161/0x310 [hfi1]
  [ 1167.907914]  [<ffffffffc06b49d3>] receive_context_interrupt+0x53/0x390 [hfi1]
  [ 1167.907917]  [<ffffffff8112fb26>] __handle_irq_event_percpu+0x56/0x240
  [ 1167.907919]  [<ffffffff816b7616>] ? rt_spin_lock+0x16/0x30
  [ 1167.907920]  [<ffffffff8112fd59>] handle_irq_event_percpu+0x49/0xa0
  [ 1167.907922]  [<ffffffff8112fe28>] handle_irq_event+0x78/0xb0
  [ 1167.907924]  [<ffffffff81132d29>] handle_edge_irq+0x99/0x1a0
  [ 1167.907926]  [<ffffffff8101ea7b>] handle_irq+0xbb/0x150
  [ 1167.907929]  [<ffffffff816c298d>] do_IRQ+0x4d/0xe0
  [ 1167.907931]  [<ffffffff816b7fad>] common_interrupt+0x6d/0x6d
  [ 1167.907931]  <EOI>
  [ 1167.907932]  [<ffffffff816b7616>] ? rt_spin_lock+0x16/0x30
  [ 1167.907934]  [<ffffffff810aaa55>] ? kthread_worker_fn+0xb5/0x170
  [ 1167.907935]  [<ffffffff810aa9a0>] ? flush_kthread_work+0x130/0x130
  [ 1167.907937]  [<ffffffff810aabdf>] kthread+0xcf/0xe0
  [ 1167.907938]  [<ffffffff810aab10>] ? kthread_worker_fn+0x170/0x170
  [ 1167.907940]  [<ffffffff816c0498>] ret_from_fork+0x58/0x90
  [ 1167.907941]  [<ffffffff810aab10>] ? kthread_worker_fn+0x170/0x170
  [ 1167.907951] Code: 90 e8 eb f0 ff ff e9 d4 fd ff ff 66 0f 1f 44 00 00 e8 db f0 ff ff eb b6 0f 0b 0f 1f 80 00 00 00 00 e8 0b f7 a3 ff e8 46 86 9c ff <0f> 0b 0f 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 65 4c 8b 3c
  [ 1167.907952] RIP  [<ffffffff816b62fa>] rt_spin_lock_slowlock+0x34a/0x350
  [ 1167.907952]  RSP <ffff880c3f403ad0>

To get it to work on RT just keep the prologue that clears the chip receive
interrupt and immediately return IRQ_WAKE_THREAD, deferring all packet
processing, with its locking, to the thread.

With this test systems are able to pass traffic over this hardware using a
CONFIG_PREEMPT_RT_FULL patched kernel without triggering these BUGs.

Cc: Clark Williams <williams@redhat.com>
Cc: Dean Luick <dean.luick@intel.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Julia Cartwright <julia@ni.com>
Cc: Kaike Wan <kaike.wan@intel.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: linux-rdma@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>
Cc: Sebastian Sanchez <sebastian.sanchez@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 drivers/infiniband/hw/hfi1/chip.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 121a4c920f1b..733a00d8ea4c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8226,15 +8226,17 @@ static irqreturn_t receive_context_interrupt(int irq, void *data)
 {
 	struct hfi1_ctxtdata *rcd = data;
 	struct hfi1_devdata *dd = rcd->dd;
-	int disposition;
-	int present;
 
 	trace_hfi1_receive_interrupt(dd, rcd->ctxt);
 	this_cpu_inc(*dd->int_counter);
 	aspm_ctx_disable(rcd);
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+	return IRQ_WAKE_THREAD;
+#else
+{
 	/* receive interrupt remains blocked while processing packets */
-	disposition = rcd->do_interrupt(rcd, 0);
+	int disposition = rcd->do_interrupt(rcd, 0), present;
 
 	/*
 	 * Too many packets were seen while processing packets in this
@@ -8257,6 +8259,8 @@ static irqreturn_t receive_context_interrupt(int irq, void *data)
 
 	return IRQ_HANDLED;
 }
+#endif
+}
 
 /*
  * Receive packet thread handler.  This expects to be invoked with the
-- 
2.13.6
