From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.6] iw_cxgb4: Fix bar2 virtual address calculation for T4 adapters
Date: Tue,  5 Apr 2016 10:23:05 +0530
Message-ID: <1459831985-27803-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For T4, kernel mode qps don't use the user doorbell. User mode qps during
flow control db ringing are forced into kernel, where user doorbell is
treated as kernel doorbell and proper bar2 offset in bar2 virtual space is
calculated, which incase of T4 is a bogus address, causing a kernel panic
due to illegal write during doorbell ringing.
In case of T4, kernel mode qp bar2 virtual address should be 0. Added T4
check during bar2 virtual address calculation to return 0. Fixed Bar2
range checks based on bar2 physical address.

Based on original work by Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c | 2 +-
 drivers/infiniband/hw/cxgb4/qp.c | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index b4eeb783573c..b0b955724458 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -162,7 +162,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	cq->bar2_va = c4iw_bar2_addrs(rdev, cq->cqid, T4_BAR2_QTYPE_INGRESS,
 				      &cq->bar2_qid,
 				      user ? &cq->bar2_pa : NULL);
-	if (user && !cq->bar2_va) {
+	if (user && !cq->bar2_pa) {
 		pr_warn(MOD "%s: cqid %u not in BAR2 range.\n",
 			pci_name(rdev->lldi.pdev), cq->cqid);
 		ret = -EINVAL;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index e17fb5d5e033..48ca455d057b 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -185,6 +185,10 @@ void __iomem *c4iw_bar2_addrs(struct c4iw_rdev *rdev, unsigned int qid,
 
 	if (pbar2_pa)
 		*pbar2_pa = (rdev->bar2_pa + bar2_qoffset) & PAGE_MASK;
+
+	if (is_t4(rdev->lldi.adapter_type))
+		return NULL;
+
 	return rdev->bar2_kva + bar2_qoffset;
 }
 
@@ -270,7 +274,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	/*
 	 * User mode must have bar2 access.
 	 */
-	if (user && (!wq->sq.bar2_va || !wq->rq.bar2_va)) {
+	if (user && (!wq->sq.bar2_pa || !wq->rq.bar2_pa)) {
 		pr_warn(MOD "%s: sqid %u or rqid %u not in BAR2 range.\n",
 			pci_name(rdev->lldi.pdev), wq->sq.qid, wq->rq.qid);
 		goto free_dma;
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
