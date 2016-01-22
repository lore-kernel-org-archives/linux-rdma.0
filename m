From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/6] IB/rdmavt: add modify queue pair driver helpers
Date: Fri, 22 Jan 2016 13:04:38 -0800
Message-ID: <20160122210437.9932.87891.stgit@scvm10.sc.intel.com>
References: <20160122210251.9932.46251.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122210251.9932.46251.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Low level drivers need to be able to check incoming attributes as well as be
able to adjust their private data on queue pair modification.  Add 2 driver
callbacks, check_modify_qp and modify_qp, to facilitate this.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    7 +++++++
 include/rdma/rdma_vt.h            |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 64b9c01..615358e 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -970,6 +970,10 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				attr_mask, link))
 		goto inval;
 
+	if (rdi->driver_f.check_modify_qp &&
+	    rdi->driver_f.check_modify_qp(qp, attr, attr_mask, udata))
+		goto inval;
+
 	if (attr_mask & IB_QP_AV) {
 		if (attr->ah_attr.dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
@@ -1166,6 +1170,9 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC)
 		qp->s_max_rd_atomic = attr->max_rd_atomic;
 
+	if (rdi->driver_f.modify_qp)
+		rdi->driver_f.modify_qp(qp, attr, attr_mask, udata);
+
 	spin_unlock(&qp->s_lock);
 	spin_unlock_irq(&qp->r_lock);
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 04e9019..e382cca 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -256,6 +256,13 @@ struct rvt_driver_provided {
 			      struct rvt_ah *);
 	int (*alloc_qpn)(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 			 enum ib_qp_type type, u8 port, gfp_t gfp);
+	/**
+	 * Return 0 if modification is valid, -errno otherwise
+	 */
+	int (*check_modify_qp)(struct rvt_qp *qp, struct ib_qp_attr *attr,
+			       int attr_mask, struct ib_udata *udata);
+	void (*modify_qp)(struct rvt_qp *qp, struct ib_qp_attr *attr,
+			  int attr_mask, struct ib_udata *udata);
 };
 
 struct rvt_dev_info {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
