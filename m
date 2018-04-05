From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 08/13] IB/hfi1: Use after free race condition in
 send context error path
Date: Wed, 04 Apr 2018 20:02:35 -0700
Message-ID: <20180405030232.18766.89603.stgit@scvm10.sc.intel.com>
References: <20180405025915.18766.41569.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180405025915.18766.41569.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

A pio send egress error can occur when the PSM library attempts to
to send a bad packet.  That issue is still being investigated.

The pio error interrupt handler then attempts to progress the recovery
of the errored pio send context.

Code inspection reveals that the handling lacks the necessary locking
if that recovery interleaves with a PSM close of the "context" object
contains the pio send context.

The lack of the locking can cause the recovery to access the already
freed pio send context object and incorrectly deduce that the pio
send context is actually a kernel pio send context as shown by the
NULL deref stack below:

[<ffffffff8143d78c>] _dev_info+0x6c/0x90
[<ffffffffc0613230>] sc_restart+0x70/0x1f0 [hfi1]
[<ffffffff816ab124>] ? __schedule+0x424/0x9b0
[<ffffffffc06133c5>] sc_halted+0x15/0x20 [hfi1]
[<ffffffff810aa3ba>] process_one_work+0x17a/0x440
[<ffffffff810ab086>] worker_thread+0x126/0x3c0
[<ffffffff810aaf60>] ? manage_workers.isra.24+0x2a0/0x2a0
[<ffffffff810b252f>] kthread+0xcf/0xe0
[<ffffffff810b2460>] ? insert_kthread_work+0x40/0x40
[<ffffffff816b8798>] ret_from_fork+0x58/0x90
[<ffffffff810b2460>] ? insert_kthread_work+0x40/0x40

This is the best case scenario and other scenarios can corrupt the
already freed memory.

Fix by adding the necessary locking in the pio send context error
handler.

Cc: <stable@vger.kernel.org> # 4.9.x
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index cb9095d..e5254f8 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5944,6 +5944,7 @@ static void is_sendctxt_err_int(struct hfi1_devdata *dd,
 	u64 status;
 	u32 sw_index;
 	int i = 0;
+	unsigned long irq_flags;
 
 	sw_index = dd->hw_to_sw[hw_context];
 	if (sw_index >= dd->num_send_contexts) {
@@ -5953,10 +5954,12 @@ static void is_sendctxt_err_int(struct hfi1_devdata *dd,
 		return;
 	}
 	sci = &dd->send_contexts[sw_index];
+	spin_lock_irqsave(&dd->sc_lock, irq_flags);
 	sc = sci->sc;
 	if (!sc) {
 		dd_dev_err(dd, "%s: context %u(%u): no sc?\n", __func__,
 			   sw_index, hw_context);
+		spin_unlock_irqrestore(&dd->sc_lock, irq_flags);
 		return;
 	}
 
@@ -5978,6 +5981,7 @@ static void is_sendctxt_err_int(struct hfi1_devdata *dd,
 	 */
 	if (sc->type != SC_USER)
 		queue_work(dd->pport->hfi1_wq, &sc->halt_work);
+	spin_unlock_irqrestore(&dd->sc_lock, irq_flags);
 
 	/*
 	 * Update the counters for the corresponding status bits.
