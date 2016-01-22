From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/7] IB/rdmavt: Export reset_qp in rdmavt
Date: Fri, 22 Jan 2016 12:50:24 -0800
Message-ID: <20160122205022.4351.22769.stgit@scvm10.sc.intel.com>
References: <20160122204807.4351.24569.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204807.4351.24569.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Until all queue pair functionality is moved to rdmavt we need to provide
access to the reset function. This is only temporary and will be reverted
back to a static, non exported function in the end.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    7 ++++---
 include/rdma/rdma_vt.h            |    3 +++
 include/rdma/rdmavt_qp.h          |    1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 7d1f02e..44485ad 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -357,8 +357,8 @@ static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
  * @qp: the QP to reset
  * @type: the QP type
  */
-static void reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
-		     enum ib_qp_type type)
+void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+		  enum ib_qp_type type)
 {
 	qp->remote_qpn = 0;
 	qp->qkey = 0;
@@ -409,6 +409,7 @@ static void reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 	}
 	qp->r_sge.num_sge = 0;
 }
+EXPORT_SYMBOL(rvt_reset_qp);
 
 /**
  * rvt_create_qp - create a queue pair for a device
@@ -543,7 +544,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		}
 		qp->ibqp.qp_num = err;
 		qp->port_num = init_attr->port_num;
-		reset_qp(rdi, qp, init_attr->qp_type);
+		rvt_reset_qp(rdi, qp, init_attr->qp_type);
 		break;
 
 	default:
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 3bdeac7..e412e67 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -338,4 +338,7 @@ struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
 void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
 			  u32 size, void *obj);
 
+/* Temporary export */
+void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+		  enum ib_qp_type type);
 #endif          /* DEF_RDMA_VT_H */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 1aa8b5b..bce0a03 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -48,6 +48,7 @@
  *
  */
 
+#include <rdma/rdma_vt.h>
 #include <rdma/ib_pack.h>
 /*
  * Atomic bit definitions for r_aflags.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
