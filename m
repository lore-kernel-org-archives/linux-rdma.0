From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.35 3/3] RDMA/cxgb4: Avoid false GTS CIDX_INC overflows.
Date: Thu, 10 Jun 2010 14:03:06 -0500
Message-ID: <20100610190306.18331.87083.stgit@build.ogc.int>
References: <20100610190255.18331.20027.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100610190255.18331.20027.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The T4 IQ hw design assumes CIDX_INC credits will be returned on a regular
basis and always before the CIDX counter crosses over the PIDX counter.
For RDMA CQs, however, returning CIDX_INC credits is only needed and
desired when and if the CQ is armed for notification.  This can lead
to a GTS write returning credits that causes the HW to reject the
credit update because it causes CIDX to pass PIDX.  Once this happens,
the CIDX/PIDX counters get out of whack and an application can miss a
notification and get stuck blocked awaiting a notification.

To avoid this,  we allocate the HW IQ 2x times the requested size.
This seems to avoid the false overflow failures.  If we see more issues
with this, then we'll have to add code in the poll path to return credits
periodically like when the amount reaches 1/2 the queue depth).  I would
like to avoid this as it adds a PCI write transaction for applications
that never arm the CQ (like most MPIs).

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cq.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 2447f52..4311501 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -764,7 +764,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 	struct c4iw_create_cq_resp uresp;
 	struct c4iw_ucontext *ucontext = NULL;
 	int ret;
-	size_t memsize;
+	size_t memsize, hwentries;
 	struct c4iw_mm_entry *mm, *mm2;
 
 	PDBG("%s ib_dev %p entries %d\n", __func__, ibdev, entries);
@@ -788,14 +788,29 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 	 * entries must be multiple of 16 for HW.
 	 */
 	entries = roundup(entries, 16);
-	memsize = entries * sizeof *chp->cq.queue;
+
+	/*
+	 * Make actual HW queue 2x to avoid cdix_inc overflows.
+	 */
+	hwentries = entries * 2;
+
+	/*
+	 * Make HW queue at least 64 entries so GTS updates aren't too
+	 * frequent.
+	 */
+	if (hwentries < 64)
+		hwentries = 64;
+
+	memsize = hwentries * sizeof *chp->cq.queue;
 
 	/*
 	 * memsize must be a multiple of the page size if its a user cq.
 	 */
-	if (ucontext)
+	if (ucontext) {
 		memsize = roundup(memsize, PAGE_SIZE);
-	chp->cq.size = entries;
+		hwentries = memsize / sizeof *chp->cq.queue;
+	}
+	chp->cq.size = hwentries;
 	chp->cq.memsize = memsize;
 
 	ret = create_cq(&rhp->rdev, &chp->cq,
@@ -805,7 +820,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 
 	chp->rhp = rhp;
 	chp->cq.size--;				/* status page */
-	chp->ibcq.cqe = chp->cq.size - 1;
+	chp->ibcq.cqe = entries - 2;
 	spin_lock_init(&chp->lock);
 	atomic_set(&chp->refcnt, 1);
 	init_waitqueue_head(&chp->wait);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
