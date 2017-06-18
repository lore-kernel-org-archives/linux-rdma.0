From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 1/2] RDMA/qedr: Notify user application if DPM is supported
Date: Sun, 18 Jun 2017 16:01:10 +0300
Message-ID: <1497790871-23945-2-git-send-email-Ram.Amrani@cavium.com>
References: <1497790871-23945-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497790871-23945-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Direct Packet Mode support may be disabled, e.g, due to limited BAR
resources. Notifying the user application prevents wasting cycles
on attempting to send these kind of packets.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/main.c  | 1 +
 drivers/infiniband/hw/qedr/qedr.h  | 2 ++
 drivers/infiniband/hw/qedr/verbs.c | 6 ++++++
 include/uapi/rdma/qedr-abi.h       | 1 +
 4 files changed, 10 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 6a72095..d228718 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -778,6 +778,7 @@ static struct qedr_dev *qedr_add(struct qed_dev *cdev, struct pci_dev *pdev,
 	if (rc)
 		goto init_err;
 
+	dev->user_dpm_enabled = dev_info.user_dpm_enabled;
 	dev->num_hwfns = dev_info.common.num_hwfns;
 	dev->rdma_ctx = dev->ops->rdma_get_rdma_ctx(cdev);
 
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index aa08c76..42af9b6 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -158,6 +158,8 @@ struct qedr_dev {
 	struct qedr_qp		*gsi_qp;
 
 	unsigned long enet_state;
+
+	u8 user_dpm_enabled;
 };
 
 #define QEDR_MAX_SQ_PBL			(0x8000)
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 17685cf..6a0acfa 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -335,6 +335,9 @@ static bool qedr_search_mmap(struct qedr_ucontext *uctx, u64 phy_addr,
 	return found;
 }
 
+#define QEDR_LIB_UCXT_SUPPORT(field, udata, value)			      \
+	((offsetof(struct qedr_alloc_ucontext_resp, field) < udata->outlen) ? \
+	 (value) : 0)
 struct ib_ucontext *qedr_alloc_ucontext(struct ib_device *ibdev,
 					struct ib_udata *udata)
 {
@@ -368,6 +371,9 @@ struct ib_ucontext *qedr_alloc_ucontext(struct ib_device *ibdev,
 
 	memset(&uresp, 0, sizeof(uresp));
 
+	uresp.dpm_enabled = QEDR_LIB_UCXT_SUPPORT(dpm_enabled, udata,
+						  dev->user_dpm_enabled);
+
 	uresp.db_pa = ctx->dpi_phys_addr;
 	uresp.db_size = ctx->dpi_size;
 	uresp.max_send_wr = dev->attr.max_sqe;
diff --git a/include/uapi/rdma/qedr-abi.h b/include/uapi/rdma/qedr-abi.h
index 75c270d..2684004 100644
--- a/include/uapi/rdma/qedr-abi.h
+++ b/include/uapi/rdma/qedr-abi.h
@@ -49,6 +49,7 @@ struct qedr_alloc_ucontext_resp {
 	__u32 sges_per_recv_wr;
 	__u32 sges_per_srq_wr;
 	__u32 max_cqes;
+	__u8 dpm_enabled;
 };
 
 struct qedr_alloc_pd_ureq {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
