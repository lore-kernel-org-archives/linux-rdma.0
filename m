From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 03/17] RDMA/ocrdma: read ASIC_ID register to select asic_gen
Date: Tue, 4 Feb 2014 11:56:56 +0530
Message-ID: <6b974771-8bb8-4e66-8cb1-21bfcc601374@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391495230-28021-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ocrdma driver selects execution path based on sli_family and asic generation number.
this introduces reading asic gen number from pci register instead of obtining from emulex NIC driver.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   13 +++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    6 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   17 +++++++++++++++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    6 +++---
 5 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 1b51e67..24fe248 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -197,6 +197,7 @@ struct ocrdma_dev {
 	int id;
 	struct ocrdma_mr *stag_arr[OCRDMA_MAX_STAG];
 	u16 pvid;
+	u32 asic_id;
 };
 
 struct ocrdma_cq {
@@ -443,4 +444,16 @@ static inline int ocrdma_get_eq_table_index(struct ocrdma_dev *dev,
 	return -EINVAL;
 }
 
+static inline u8 ocrdma_get_asic_type(struct ocrdma_dev *dev)
+{
+	if (dev->nic_info.dev_family == 0xF && !dev->asic_id) {
+		pci_read_config_dword(
+			dev->nic_info.pdev,
+			OCRDMA_SLI_ASIC_ID_OFFSET, &dev->asic_id);
+	}
+
+	return (dev->asic_id & OCRDMA_SLI_ASIC_GEN_NUM_MASK) >>
+				OCRDMA_SLI_ASIC_GEN_NUM_SHIFT;
+}
+
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 7b4688e..15d1ab1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1037,7 +1037,7 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_inline_data =
 	    attr->wqe_size - (sizeof(struct ocrdma_hdr_wqe) +
 			      sizeof(struct ocrdma_sge));
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
+	if (ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R) {
 		attr->ird = 1;
 		attr->ird_page_size = OCRDMA_MIN_Q_PAGE_SIZE;
 		attr->num_ird_pages = MAX_OCRDMA_IRD_PAGES;
@@ -1379,7 +1379,7 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 		       __func__, dev->id, dev->attr.max_cqe, entries);
 		return -EINVAL;
 	}
-	if (dpp_cq && (dev->nic_info.dev_family != OCRDMA_GEN2_FAMILY))
+	if (dpp_cq && (ocrdma_get_asic_type(dev) != OCRDMA_ASIC_GEN_SKH_R))
 		return -EINVAL;
 
 	if (dpp_cq) {
@@ -1439,7 +1439,7 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	}
 	/* shared eq between all the consumer cqs. */
 	cmd->cmd.eqn = cq->eqn;
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
+	if (ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R) {
 		if (dpp_cq)
 			cmd->cmd.pgsz_pgcnt |= OCRDMA_CREATE_CQ_DPP <<
 				OCRDMA_CREATE_CQ_TYPE_SHIFT;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 2ca86ca..4243566 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -286,7 +286,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 
 	dev->ibdev.process_mad = ocrdma_process_mad;
 
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
+	if (ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R) {
 		dev->ibdev.uverbs_cmd_mask |=
 		     OCRDMA_UVERBS(CREATE_SRQ) |
 		     OCRDMA_UVERBS(MODIFY_SRQ) |
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index e71685a..de4ebfc 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -30,8 +30,16 @@
 
 #define Bit(_b) (1 << (_b))
 
-#define OCRDMA_GEN1_FAMILY	0xB
-#define OCRDMA_GEN2_FAMILY	0x0F
+enum {
+	OCRDMA_ASIC_GEN_SKH_R = 0x04,
+	OCRDMA_ASIC_GEN_LANCER = 0x0B
+};
+
+enum {
+	OCRDMA_ASIC_REV_A0 = 0x00,
+	OCRDMA_ASIC_REV_B0 = 0x10,
+	OCRDMA_ASIC_REV_C0 = 0x20
+};
 
 #define OCRDMA_SUBSYS_ROCE 10
 enum {
@@ -141,6 +149,11 @@ enum {
 #define OCRDMA_MIN_Q_PAGE_SIZE (4096)
 #define OCRDMA_MAX_Q_PAGES     (8)
 
+#define OCRDMA_SLI_ASIC_ID_OFFSET      0x9C
+#define OCRDMA_SLI_ASIC_REV_MASK       0x000000FF
+#define OCRDMA_SLI_ASIC_GEN_NUM_MASK   0x0000FF00
+#define OCRDMA_SLI_ASIC_GEN_NUM_SHIFT  0x08
+
 /*
 # 0: 4K Bytes
 # 1: 8K Bytes
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index ead59d5..ef4e92e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -267,7 +267,7 @@ static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
 
 	if (udata && uctx) {
 		pd->dpp_enabled =
-			dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY;
+			ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R;
 		pd->num_dpp_qp =
 			pd->dpp_enabled ? OCRDMA_PD_MAX_DPP_ENABLED_QP : 0;
 	}
@@ -1161,7 +1161,7 @@ err:
 static void ocrdma_set_qp_db(struct ocrdma_dev *dev, struct ocrdma_qp *qp,
 			     struct ocrdma_pd *pd)
 {
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
+	if (ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R) {
 		qp->sq_db = dev->nic_info.db +
 			(pd->id * dev->nic_info.db_page_size) +
 			OCRDMA_DB_GEN2_SQ_OFFSET;
@@ -1688,7 +1688,7 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_dev *dev, struct ocrdma_srq *srq,
 	    (srq->pd->id * dev->nic_info.db_page_size);
 	uresp.db_page_size = dev->nic_info.db_page_size;
 	uresp.num_rqe_allocated = srq->rq.max_cnt;
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
+	if (ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R) {
 		uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ_OFFSET;
 		uresp.db_shift = 24;
 	} else {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
