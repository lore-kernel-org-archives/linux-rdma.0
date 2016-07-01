From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 17/18] IB/qib: Add qib post send table
Date: Fri, 01 Jul 2016 16:02:18 -0700
Message-ID: <20160701230218.20160.65797.stgit@scvm10.sc.intel.com>
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
 drivers/infiniband/hw/qib/qib_qp.c    |   43 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_verbs.c |    2 ++
 drivers/infiniband/hw/qib/qib_verbs.h |    2 ++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 575b737..9cc0aae 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -106,6 +106,49 @@ static u32 credit_table[31] = {
 	32768                   /* 1E */
 };
 
+const struct rvt_operation_params qib_post_parms[RVT_OPERATION_MAX] = {
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
 static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map,
 			 gfp_t gfp)
 {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index cbf6200..fd1dfbc 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1582,6 +1582,8 @@ static void qib_fill_device_attr(struct qib_devdata *dd)
 	rdi->dparms.props.max_total_mcast_qp_attach =
 					rdi->dparms.props.max_mcast_qp_attach *
 					rdi->dparms.props.max_mcast_grp;
+	/* post send table */
+	dd->verbs_dev.rdi.post_parms = qib_post_parms;
 }
 
 /**
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 4f87815..736ced6 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -497,4 +497,6 @@ extern unsigned int ib_qib_max_srq_wrs;
 
 extern const u32 ib_qib_rnr_table[];
 
+extern const struct rvt_operation_params qib_post_parms[];
+
 #endif                          /* QIB_VERBS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
