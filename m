From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 5/7] IB/hfi1: Close race condition on user context
 disable and close
Date: Thu, 17 Jan 2019 12:41:54 -0800
Message-ID: <20190117204148.30826.53799.stgit@scvm10.sc.intel.com>
References: <20190117203920.30826.76720.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190117203920.30826.76720.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

When disabling and removing a receive context, it is possible for an
asynchronous event (i.e IRQ) to occur.  Because of this there is a
race between cleaning up the context, and the context being used by
the asynchronous event.

cpu 0  (context cleanup)
    rc->ref_count-- (ref_count == 0)
    hfi1_rcd_free()
cpu 1  (IRQ (with rcd index))
	rcd_get_by_index()
	lock
	ref_count+++     <-- reference count race (WARNING)
	return rcd
	unlock
cpu 0
    hfi1_free_ctxtdata() <-- incorrect free location
    lock
    remove rcd from array
    unlock
    free rcd

This race will cause the following WARNING trace:

WARNING: CPU: 0 PID: 175027 at include/linux/kref.h:52 hfi1_rcd_get_by_index+0x84/0xa0 [hfi1]
CPU: 0 PID: 175027 Comm: IMB-MPI1 Kdump: loaded Tainted: G OE ------------ 3.10.0-957.el7.x86_64 #1
Hardware name: Intel Corporation S2600KP/S2600KP, BIOS SE5C610.86B.11.01.0076.C4.111920150602 11/19/2015
Call Trace:
  dump_stack+0x19/0x1b
  __warn+0xd8/0x100
  warn_slowpath_null+0x1d/0x20
  hfi1_rcd_get_by_index+0x84/0xa0 [hfi1]
  is_rcv_urgent_int+0x24/0x90 [hfi1]
  general_interrupt+0x1b6/0x210 [hfi1]
  __handle_irq_event_percpu+0x44/0x1c0
  handle_irq_event_percpu+0x32/0x80
  handle_irq_event+0x3c/0x60
  handle_edge_irq+0x7f/0x150
  handle_irq+0xe4/0x1a0
  do_IRQ+0x4d/0xf0
  common_interrupt+0x162/0x162

The race can also lead to a use after free which could be similar
to:

general protection fault: 0000 1 SMP
CPU: 71 PID: 177147 Comm: IMB-MPI1 Kdump: loaded Tainted: G W OE ------------ 3.10.0-957.el7.x86_64 #1
Hardware name: Intel Corporation S2600KP/S2600KP, BIOS SE5C610.86B.11.01.0076.C4.111920150602 11/19/2015
task: ffff9962a8098000 ti: ffff99717a508000 task.ti: ffff99717a508000 __kmalloc+0x94/0x230
Call Trace:
  ? hfi1_user_sdma_process_request+0x9c8/0x1250 [hfi1]
  hfi1_user_sdma_process_request+0x9c8/0x1250 [hfi1]
  hfi1_aio_write+0xba/0x110 [hfi1]
  do_sync_readv_writev+0x7b/0xd0
  do_readv_writev+0xce/0x260
  ? handle_mm_fault+0x39d/0x9b0
  ? pick_next_task_fair+0x5f/0x1b0
  ? sched_clock_cpu+0x85/0xc0
  ? __schedule+0x13a/0x890
  vfs_writev+0x35/0x60
  SyS_writev+0x7f/0x110
  system_call_fastpath+0x22/0x27

Introduce a context enable flag to indicate if the context is enabled.

Reorder context cleanup to ensure context removal before cleanup
occurs correctly.

Cc: stable@vger.kernel.org # v4.14.0+
Fixes: f683c80ca68e ("IB/hfi1: Resolve kernel panics by reference counting receive contexts")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/file_ops.c |    2 ++
 drivers/infiniband/hw/hfi1/hfi.h      |    3 ++-
 drivers/infiniband/hw/hfi1/init.c     |    8 +++++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index c22ebc7..0ba0cf5 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -671,6 +671,8 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	}
 	spin_unlock_irqrestore(&dd->uctxt_lock, flags);
 
+	uctxt->del_pend = 1;
+
 	/*
 	 * Disable receive context and interrupt available, reset all
 	 * RcvCtxtCtrl bits to default values.
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index dc8ba43..ea99768 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -284,7 +284,8 @@ struct hfi1_ctxtdata {
 	u16 expected_base;
 	/* Device context index */
 	u8 ctxt;
-
+	/* ctxt deletion is pending */
+	u8 del_pend;
 	/* PSM Specific fields */
 	/* lock protecting all Expected TID data */
 	struct mutex exp_mutex;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 044d9a8..d2ac3ef 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -215,12 +215,11 @@ static void hfi1_rcd_free(struct kref *kref)
 	struct hfi1_ctxtdata *rcd =
 		container_of(kref, struct hfi1_ctxtdata, kref);
 
-	hfi1_free_ctxtdata(rcd->dd, rcd);
-
 	spin_lock_irqsave(&rcd->dd->uctxt_lock, flags);
 	rcd->dd->rcd[rcd->ctxt] = NULL;
 	spin_unlock_irqrestore(&rcd->dd->uctxt_lock, flags);
 
+	hfi1_free_ctxtdata(rcd->dd, rcd);
 	kfree(rcd);
 }
 
@@ -326,7 +325,10 @@ struct hfi1_ctxtdata *hfi1_rcd_get_by_index(struct hfi1_devdata *dd, u16 ctxt)
 	spin_lock_irqsave(&dd->uctxt_lock, flags);
 	if (dd->rcd[ctxt]) {
 		rcd = dd->rcd[ctxt];
-		hfi1_rcd_get(rcd);
+		if (rcd->del_pend)
+			rcd = NULL;
+		else
+			hfi1_rcd_get(rcd);
 	}
 	spin_unlock_irqrestore(&dd->uctxt_lock, flags);
 
