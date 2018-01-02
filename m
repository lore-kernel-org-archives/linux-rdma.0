From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 2/7] RDMA/core: Add helper function to create named QPs
Date: Tue,  2 Jan 2018 10:18:27 +0200
Message-ID: <20180102081832.5264-3-leon@kernel.org>
References: <20180102081832.5264-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102081832.5264-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The QPs in the RDMA stack can be created by kernel
or users space, but the owner is not visible to users
after that.

The added helper keeps track of newly created QP together
with the name of the owner. In case of kernel, the caller to
create_qp is supposed to update QP's attribute with the name.
For user space callers no change is needed and the name will
be taken from the process name.

This helper sets qp->device field for all QP types including
XRC_TGT, which RDMA/core didn't do before.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h | 19 +++++++++++++++++++
 include/rdma/ib_verbs.h             |  6 ++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index a39c53c22988..0b62ff4bbb25 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -299,4 +299,23 @@ struct ib_device *ib_device_get_by_index(u32 ifindex);
 /* RDMA device netlink */
 void nldev_init(void);
 void nldev_exit(void);
+
+static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
+					  struct ib_pd *pd,
+					  struct ib_qp_init_attr *attr,
+					  struct ib_udata *udata)
+{
+	struct ib_qp *qp;
+
+	qp = dev->create_qp(pd, attr, udata);
+	if (!IS_ERR(qp)) {
+		qp->device = dev;
+		if (attr->qp_type < IB_QPT_MAX)
+			rdma_restrack_add(&qp->res,
+					  RDMA_RESTRACK_QP,
+					  attr->comm);
+	}
+
+	return qp;
+}
 #endif /* _CORE_PRIV_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d8ae52920a41..b9a0a4c4818c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1140,6 +1140,12 @@ struct ib_qp_init_attr {
 	u8			port_num;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	u32			source_qpn;
+
+	/*
+	 * Name of entity which created this QP, empty string means that
+	 * it will be taken automatically from task_struct.
+	 */
+	char comm[TASK_COMM_LEN];
 };
 
 struct ib_qp_open_attr {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
