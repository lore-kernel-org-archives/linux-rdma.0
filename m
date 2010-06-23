From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2 3/3] RDMA/cxgb4: Obtain RDMA QID ranges from LLD/FW.
Date: Wed, 23 Jun 2010 10:46:55 -0500
Message-ID: <20100623154654.22600.13525.stgit@build.ogc.int>
References: <20100623154643.22600.20003.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100623154643.22600.20003.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c   |    9 +++++++--
 drivers/infiniband/hw/cxgb4/resource.c |    7 ++++---
 drivers/infiniband/hw/cxgb4/t4.h       |    2 --
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index d870f9c..9bbf491 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -250,12 +250,17 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	rdev->cqshift = PAGE_SHIFT - ilog2(rdev->lldi.ucq_density);
 	rdev->cqmask = rdev->lldi.ucq_density - 1;
 	PDBG("%s dev %s stag start 0x%0x size 0x%0x num stags %d "
-	     "pbl start 0x%0x size 0x%0x rq start 0x%0x size 0x%0x\n",
+	     "pbl start 0x%0x size 0x%0x rq start 0x%0x size 0x%0x "
+	     "qp qid start %u size %u cq qid start %u size %u\n",
 	     __func__, pci_name(rdev->lldi.pdev), rdev->lldi.vr->stag.start,
 	     rdev->lldi.vr->stag.size, c4iw_num_stags(rdev),
 	     rdev->lldi.vr->pbl.start,
 	     rdev->lldi.vr->pbl.size, rdev->lldi.vr->rq.start,
-	     rdev->lldi.vr->rq.size);
+	     rdev->lldi.vr->rq.size,
+	     rdev->lldi.vr->qp.start,
+	     rdev->lldi.vr->qp.size,
+	     rdev->lldi.vr->cq.start,
+	     rdev->lldi.vr->cq.size);
 	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
 	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
 	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
index fb195d1..83b23df 100644
--- a/drivers/infiniband/hw/cxgb4/resource.c
+++ b/drivers/infiniband/hw/cxgb4/resource.c
@@ -110,11 +110,12 @@ static int c4iw_init_qid_fifo(struct c4iw_rdev *rdev)
 
 	spin_lock_init(&rdev->resource.qid_fifo_lock);
 
-	if (kfifo_alloc(&rdev->resource.qid_fifo, T4_MAX_QIDS * sizeof(u32),
-			GFP_KERNEL))
+	if (kfifo_alloc(&rdev->resource.qid_fifo, rdev->lldi.vr->qp.size *
+			sizeof(u32), GFP_KERNEL))
 		return -ENOMEM;
 
-	for (i = T4_QID_BASE; i < T4_QID_BASE + T4_MAX_QIDS; i++)
+	for (i = rdev->lldi.vr->qp.start;
+	     i < rdev->lldi.vr->qp.start + rdev->lldi.vr->qp.size; i++)
 		if (!(i & rdev->qpmask))
 			kfifo_in(&rdev->resource.qid_fifo,
 				    (unsigned char *) &i, sizeof(u32));
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 97798d4..e0b4ae0 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -36,8 +36,6 @@
 #include "t4_msg.h"
 #include "t4fw_ri_api.h"
 
-#define T4_QID_BASE 1024
-#define T4_MAX_QIDS 256
 #define T4_MAX_NUM_QP (1<<16)
 #define T4_MAX_NUM_CQ (1<<15)
 #define T4_MAX_NUM_PD (1<<15)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
