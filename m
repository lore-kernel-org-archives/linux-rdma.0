From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 11/14] RDMA/bnxt_re: Report supported value to IB stack in query_device
Date: Wed, 10 May 2017 03:45:36 -0700
Message-ID: <1494413139-11883-12-git-send-email-selvin.xavier@broadcom.com>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494413139-11883-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 - Report supported value for max_mr_size to IB stack in query_device.
   Also, check and log if MR size requested by application in
   reg_user_mr() is greater than value currently supported by driver.
 - Report only 4K page size support for now
 - Fix Max_QP value returned by ibv_devinfo -vv.
   In case of PF, FW reserves 129 QPs for creating QP1s of VFs
   and PF. So the max_qp value reported by FW for PF doesn'tt include
   the QP1. Fixing this issue by adding 1 with the value reported
   by Bono.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  2 ++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 12 ++++++++----
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |  2 ++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 12950ec..30bff05 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -51,6 +51,8 @@
 #define BNXT_RE_PAGE_SIZE_8M		BIT(23)
 #define BNXT_RE_PAGE_SIZE_1G		BIT(30)
 
+#define BNXT_RE_MAX_MR_SIZE		BIT(30)
+
 #define BNXT_RE_MAX_QPC_COUNT		(64 * 1024)
 #define BNXT_RE_MAX_MRW_COUNT		(64 * 1024)
 #define BNXT_RE_MAX_SRQC_COUNT		(64 * 1024)
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 5a8b17e..34aa09e 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -145,10 +145,8 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->fw_ver = (u64)(unsigned long)(dev_attr->fw_ver);
 	bnxt_qplib_get_guid(rdev->netdev->dev_addr,
 			    (u8 *)&ib_attr->sys_image_guid);
-	ib_attr->max_mr_size = ~0ull;
-	ib_attr->page_size_cap = BNXT_RE_PAGE_SIZE_4K | BNXT_RE_PAGE_SIZE_8K |
-				 BNXT_RE_PAGE_SIZE_64K | BNXT_RE_PAGE_SIZE_2M |
-				 BNXT_RE_PAGE_SIZE_8M | BNXT_RE_PAGE_SIZE_1G;
+	ib_attr->max_mr_size = BNXT_RE_MAX_MR_SIZE;
+	ib_attr->page_size_cap = BNXT_RE_PAGE_SIZE_4K;
 
 	ib_attr->vendor_id = rdev->en_dev->pdev->vendor;
 	ib_attr->vendor_part_id = rdev->en_dev->pdev->device;
@@ -3314,6 +3312,12 @@ struct ib_mr *bnxt_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
 	struct scatterlist *sg;
 	int entry;
 
+	if (length > BNXT_RE_MAX_MR_SIZE) {
+		dev_err(rdev_to_dev(rdev), "MR Size: %lld > Max supported:%ld\n",
+			length, BNXT_RE_MAX_MR_SIZE);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 3744d33..168e0cc 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -81,6 +81,8 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 
 	/* Extract the context from the side buffer */
 	attr->max_qp = le32_to_cpu(sb->max_qp);
+	/* max_qp value reported by FW for PF doesn't include the QP1 for PF */
+	attr->max_qp += 1;
 	attr->max_qp_rd_atom =
 		sb->max_qp_rd_atom > BNXT_QPLIB_MAX_OUT_RD_ATOM ?
 		BNXT_QPLIB_MAX_OUT_RD_ATOM : sb->max_qp_rd_atom;
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
