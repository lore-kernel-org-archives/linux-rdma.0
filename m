From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCHv2 for-4.1 4/4] iw_cxgb4: enforce qp/cq id requirements
Date: Wed, 22 Apr 2015 01:45:01 +0530
Message-ID: <1429647301-6832-5-git-send-email-hariprasad@chelsio.com>
References: <1429647301-6832-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429647301-6832-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently the iw_cxgb4 implementation requires the qp and cq qid densities
to match as well as the qp and cq id ranges.  So fail a device open if
the device configuration doesn't meet the requirements.

The reason for these restictions has to do with the fact that IQ qid X
has a UGTS register in the same bar2 page as EQ qid X.  Thus both qids
need to be allocated to the same user process for security reasons.
The logic that does this (the qpid allocator in iw_cxgb4/resource.c)
handles this but requires the above restrictions.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 33bd1ac..3f782f9 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -765,6 +765,29 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	c4iw_init_dev_ucontext(rdev, &rdev->uctx);
 
 	/*
+	 * This implementation assumes udb_density == ucq_density!  Eventually
+	 * we might need to support this but for now fail the open. Also the
+	 * cqid and qpid range must match for now.
+	 */
+	if (rdev->lldi.udb_density != rdev->lldi.ucq_density) {
+		pr_err(MOD "%s: unsupported udb/ucq densities %u/%u\n",
+		       pci_name(rdev->lldi.pdev), rdev->lldi.udb_density,
+		       rdev->lldi.ucq_density);
+		err = -EINVAL;
+		goto err1;
+	}
+	if (rdev->lldi.vr->qp.start != rdev->lldi.vr->cq.start ||
+	    rdev->lldi.vr->qp.size != rdev->lldi.vr->cq.size) {
+		pr_err(MOD "%s: unsupported qp and cq id ranges "
+		       "qp start %u size %u cq start %u size %u\n",
+		       pci_name(rdev->lldi.pdev), rdev->lldi.vr->qp.start,
+		       rdev->lldi.vr->qp.size, rdev->lldi.vr->cq.size,
+		       rdev->lldi.vr->cq.size);
+		err = -EINVAL;
+		goto err1;
+	}
+
+	/*
 	 * qpshift is the number of bits to shift the qpid left in order
 	 * to get the correct address of the doorbell for that qp.
 	 */
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
