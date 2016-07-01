From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 16/18] IB/hfi1: Add hfi1 post send tables
Date: Fri, 01 Jul 2016 16:02:13 -0700
Message-ID: <20160701230212.20160.17469.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add initial table for table driven post_send support.

Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c    |   44 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/qp.h    |    2 ++
 drivers/infiniband/hw/hfi1/verbs.c |    3 ++
 3 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 1a942ff..a8b3fc9 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -52,6 +52,7 @@
 #include <linux/seq_file.h>
 #include <rdma/rdma_vt.h>
 #include <rdma/rdmavt_qp.h>
+#include <rdma/ib_verbs.h>
 
 #include "hfi.h"
 #include "qp.h"
@@ -115,6 +116,49 @@ static const u16 credit_table[31] = {
 	32768                   /* 1E */
 };
 
+const struct rvt_operation_params hfi1_post_parms[RVT_OPERATION_MAX] = {
+[IB_WR_RDMA_WRITE] = {
+	.length = sizeof(struct ib_rdma_wr),
+	.qpt_support = BIT(IB_QPT_UC) | BIT(IB_QPT_RC),
+},
+
+[IB_WR_RDMA_READ] = {
+	.length = sizeof(struct ib_rdma_wr),
+	.qpt_support = BIT(IB_QPT_RC),
+	.flags = RVT_OPERATION_ATOMIC,
+},
+
+[IB_WR_ATOMIC_CMP_AND_SWP] = {
+	.length = sizeof(struct ib_atomic_wr),
+	.qpt_support = BIT(IB_QPT_RC),
+	.flags = RVT_OPERATION_ATOMIC | RVT_OPERATION_ATOMIC_SGE,
+},
+
+[IB_WR_ATOMIC_FETCH_AND_ADD] = {
+	.length = sizeof(struct ib_atomic_wr),
+	.qpt_support = BIT(IB_QPT_RC),
+	.flags = RVT_OPERATION_ATOMIC | RVT_OPERATION_ATOMIC_SGE,
+},
+
+[IB_WR_RDMA_WRITE_WITH_IMM] = {
+	.length = sizeof(struct ib_rdma_wr),
+	.qpt_support = BIT(IB_QPT_UC) | BIT(IB_QPT_RC),
+},
+
+[IB_WR_SEND] = {
+	.length = sizeof(struct ib_send_wr),
+	.qpt_support = BIT(IB_QPT_UD) | BIT(IB_QPT_SMI) | BIT(IB_QPT_GSI) |
+		       BIT(IB_QPT_UC) | BIT(IB_QPT_RC),
+},
+
+[IB_WR_SEND_WITH_IMM] = {
+	.length = sizeof(struct ib_send_wr),
+	.qpt_support = BIT(IB_QPT_UD) | BIT(IB_QPT_SMI) | BIT(IB_QPT_GSI) |
+		       BIT(IB_QPT_UC) | BIT(IB_QPT_RC),
+},
+
+};
+
 static void flush_tx_list(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
diff --git a/drivers/infiniband/hw/hfi1/qp.h b/drivers/infiniband/hw/hfi1/qp.h
index e7bc8d6..ddf8298 100644
--- a/drivers/infiniband/hw/hfi1/qp.h
+++ b/drivers/infiniband/hw/hfi1/qp.h
@@ -54,6 +54,8 @@
 
 extern unsigned int hfi1_qp_table_size;
 
+extern const struct rvt_operation_params hfi1_post_parms[];
+
 /*
  * free_ahg - clear ahg from QP
  */
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 6ad3f9d..a89055f 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1683,6 +1683,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = hfi1_get_npkeys(dd);
 
+	/* post send table */
+	dd->verbs_dev.rdi.post_parms = hfi1_post_parms;
+
 	ppd = dd->pport;
 	for (i = 0; i < dd->num_pports; i++, ppd++)
 		rvt_init_port(&dd->verbs_dev.rdi,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
