From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rc 2/6] RDMA/bnxt_re: Maintain GID index mapping between stack and hardware
Date: Thu, 15 Feb 2018 21:20:09 -0800
Message-ID: <1518758413-20850-3-git-send-email-selvin.xavier@broadcom.com>
References: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518758413-20850-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Every GID has a duplicate entry in the stack for RoCE v2.
HW table maintain only single entries. Currently the hw index
is calculated by dividing the stack index by two. This is prone to
failure after a series of add/delete gid operation in random order.

Maintain a mapping between stack GID index and hardware
index to avoid failure.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  3 +++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 21 ++++++++++-----------
 drivers/infiniband/hw/bnxt_re/main.c     | 13 +++++++++++++
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index ca32057..5692335 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -109,6 +109,7 @@ struct bnxt_re_sqp_entries {
 #define BNXT_RE_MAX_MSIX		9
 #define BNXT_RE_AEQ_IDX			0
 #define BNXT_RE_NQ_IDX			1
+#define BNXT_RE_MAX_SGID_ENTRIES	256
 
 struct bnxt_re_dev {
 	struct ib_device		ibdev;
@@ -170,6 +171,8 @@ struct bnxt_re_dev {
 	u32 is_virtfn;
 	u32 num_vfs;
 	struct bnxt_qplib_roce_stats	stats;
+	/* Array to handle gid mapping */
+	char				*gid_map;
 };
 
 #define to_bnxt_re_dev(ptr, member)	\
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ce2a6d0..7943707 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -348,6 +348,7 @@ int bnxt_re_del_gid(struct ib_device *ibdev, u8 port_num,
 			return -EFAULT;
 		}
 		ctx->refcnt--;
+		rdev->gid_map[index] = -1;
 		if (!ctx->refcnt) {
 			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del, true);
 			if (rc) {
@@ -386,6 +387,8 @@ int bnxt_re_add_gid(struct ib_device *ibdev, u8 port_num,
 		ctx_tbl = sgid_tbl->ctx;
 		ctx_tbl[tbl_idx]->refcnt++;
 		*context = ctx_tbl[tbl_idx];
+		/* tbl_idx is the HW table index and index is the stack index */
+		rdev->gid_map[index] = tbl_idx;
 		return 0;
 	}
 
@@ -401,6 +404,8 @@ int bnxt_re_add_gid(struct ib_device *ibdev, u8 port_num,
 	ctx->idx = tbl_idx;
 	ctx->refcnt = 1;
 	ctx_tbl[tbl_idx] = ctx;
+	/* tbl_idx is the HW table index and index is the stack index */
+	rdev->gid_map[index] = tbl_idx;
 	*context = ctx;
 
 	return rc;
@@ -691,12 +696,8 @@ struct ib_ah *bnxt_re_create_ah(struct ib_pd *ib_pd,
 	/* Supply the configuration for the HW */
 	memcpy(ah->qplib_ah.dgid.data, grh->dgid.raw,
 	       sizeof(union ib_gid));
-	/*
-	 * If RoCE V2 is enabled, stack will have two entries for
-	 * each GID entry. Avoiding this duplicte entry in HW. Dividing
-	 * the GID index by 2 for RoCE V2
-	 */
-	ah->qplib_ah.sgid_index = grh->sgid_index / 2;
+	/* Retrieve the HW index from the driver SGID map */
+	ah->qplib_ah.sgid_index = rdev->gid_map[ah_attr->grh.sgid_index];
 	ah->qplib_ah.host_sgid_index = grh->sgid_index;
 	ah->qplib_ah.traffic_class = grh->traffic_class;
 	ah->qplib_ah.flow_label = grh->flow_label;
@@ -1641,11 +1642,9 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 		memcpy(qp->qplib_qp.ah.dgid.data, grh->dgid.raw,
 		       sizeof(qp->qplib_qp.ah.dgid.data));
 		qp->qplib_qp.ah.flow_label = grh->flow_label;
-		/* If RoCE V2 is enabled, stack will have two entries for
-		 * each GID entry. Avoiding this duplicte entry in HW. Dividing
-		 * the GID index by 2 for RoCE V2
-		 */
-		qp->qplib_qp.ah.sgid_index = grh->sgid_index / 2;
+		/* Retrieve the HW index from the driver SGID map */
+		qp->qplib_qp.ah.sgid_index =
+			rdev->gid_map[qp_attr->ah_attr.grh.sgid_index];
 		qp->qplib_qp.ah.host_sgid_index = grh->sgid_index;
 		qp->qplib_qp.ah.hop_limit = grh->hop_limit;
 		qp->qplib_qp.ah.traffic_class = grh->traffic_class;
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 508d00a..3d5bbf9 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -658,6 +658,7 @@ static void bnxt_re_dev_remove(struct bnxt_re_dev *rdev)
 	synchronize_rcu();
 	flush_workqueue(bnxt_re_wq);
 
+	kfree(rdev->gid_map);
 	ib_dealloc_device(&rdev->ibdev);
 	/* rdev is gone */
 }
@@ -666,6 +667,7 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
 					   struct bnxt_en_dev *en_dev)
 {
 	struct bnxt_re_dev *rdev;
+	u32 count;
 
 	/* Allocate bnxt_re_dev instance here */
 	rdev = (struct bnxt_re_dev *)ib_alloc_device(sizeof(*rdev));
@@ -689,6 +691,17 @@ static struct bnxt_re_dev *bnxt_re_dev_add(struct net_device *netdev,
 	rdev->cosq[0] = 0xFFFF;
 	rdev->cosq[1] = 0xFFFF;
 
+	rdev->gid_map = kzalloc(sizeof(*rdev->gid_map) *
+				BNXT_RE_MAX_SGID_ENTRIES,
+				GFP_KERNEL);
+	if (!rdev->gid_map) {
+		ib_dealloc_device(&rdev->ibdev);
+		return NULL;
+	}
+
+	for (count = 0; count < BNXT_RE_MAX_SGID_ENTRIES; count++)
+		rdev->gid_map[count] = -1;
+
 	mutex_lock(&bnxt_re_dev_lock);
 	list_add_tail_rcu(&rdev->list, &bnxt_re_dev_list);
 	mutex_unlock(&bnxt_re_dev_lock);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
