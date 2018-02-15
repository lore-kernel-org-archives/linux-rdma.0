From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2 rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Wed, 14 Feb 2018 18:43:36 -0800
Message-ID: <20180216165919.997D72BB6D@smtp.opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

uaccess_kernel() isn't sufficient to determine if an rdma resource is
user-mode or not.  For example, resources allocated in the add_one()
function of an ib_client get falsely labeled as user mode, when they
are kernel mode allocations.  EG: mad qps.

The result is that these qps are skipped over during a nldev query
because of an erroneous namespace mismatch.

So now we determine if the resource is user-mode by looking at the object
struct's uobject or similar pointer to know if it was allocated for user
mode applications.

Fixes: 02d8883f520e ("RDMA/restrack: Add general infrastructure to track RDMA resources")
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

---

Changes since v1:

changed _create_qp() to take the qp ib_uobject ptr so it is availble to
rdma_restrack_add()

---
 drivers/infiniband/core/core_priv.h  |  4 +++-
 drivers/infiniband/core/restrack.c   | 35 +++++++++++++++++++++++++++++++++--
 drivers/infiniband/core/uverbs_cmd.c |  4 ++--
 drivers/infiniband/core/verbs.c      |  3 +--
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index c4560d8..39b8332 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -305,7 +305,8 @@ static inline int ib_mad_enforce_security(struct ib_mad_agent_private *map,
 static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
 					  struct ib_pd *pd,
 					  struct ib_qp_init_attr *attr,
-					  struct ib_udata *udata)
+					  struct ib_udata *udata,
+					  struct ib_uobject *uobj)
 {
 	struct ib_qp *qp;
 
@@ -315,6 +316,7 @@ static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
 
 	qp->device = dev;
 	qp->pd = pd;
+	qp->uobject = uobj;
 	/*
 	 * We don't track XRC QPs for now, because they don't have PD
 	 * and more importantly they are created internaly by driver,
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 857637b..d268184 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -7,7 +7,6 @@
 #include <rdma/restrack.h>
 #include <linux/mutex.h>
 #include <linux/sched/task.h>
-#include <linux/uaccess.h>
 #include <linux/pid_namespace.h>
 
 void rdma_restrack_init(struct rdma_restrack_root *res)
@@ -93,6 +92,38 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 	return dev;
 }
 
+static bool res_is_user(struct rdma_restrack_entry *res)
+{
+	enum rdma_restrack_type type = res->type;
+	struct ib_xrcd *xrcd;
+	struct ib_pd *pd;
+	struct ib_cq *cq;
+	struct ib_qp *qp;
+	bool is_user = false;
+
+	switch (type) {
+	case RDMA_RESTRACK_PD:
+		pd = container_of(res, struct ib_pd, res);
+		is_user = pd->uobject;
+		break;
+	case RDMA_RESTRACK_CQ:
+		cq = container_of(res, struct ib_cq, res);
+		is_user = cq->uobject;
+		break;
+	case RDMA_RESTRACK_QP:
+		qp = container_of(res, struct ib_qp, res);
+		is_user = qp->uobject;
+		break;
+	case RDMA_RESTRACK_XRCD:
+		xrcd = container_of(res, struct ib_xrcd, res);
+		is_user = xrcd->inode;
+		break;
+	default:
+		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
+	}
+	return is_user;
+}
+
 void rdma_restrack_add(struct rdma_restrack_entry *res)
 {
 	struct ib_device *dev = res_to_dev(res);
@@ -100,7 +131,7 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
 	if (!dev)
 		return;
 
-	if (!uaccess_kernel()) {
+	if (res_is_user(res)) {
 		get_task_struct(current);
 		res->task = current;
 		res->kern_name = NULL;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 256934d..2d573da 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1518,7 +1518,8 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
-		qp = _ib_create_qp(device, pd, &attr, uhw);
+		qp = _ib_create_qp(device, pd, &attr, uhw,
+				   &obj->uevent.uobject);
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
@@ -1551,7 +1552,6 @@ static int create_qp(struct ib_uverbs_file *file,
 		if (ind_tbl)
 			atomic_inc(&ind_tbl->usecnt);
 	}
-	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 16ebc63..93025d2 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -887,7 +887,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	if (qp_init_attr->cap.max_rdma_ctxs)
 		rdma_rw_init_qp(device, qp_init_attr);
 
-	qp = _ib_create_qp(device, pd, qp_init_attr, NULL);
+	qp = _ib_create_qp(device, pd, qp_init_attr, NULL, NULL);
 	if (IS_ERR(qp))
 		return qp;
 
@@ -898,7 +898,6 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	}
 
 	qp->real_qp    = qp;
-	qp->uobject    = NULL;
 	qp->qp_type    = qp_init_attr->qp_type;
 	qp->rwq_ind_tbl = qp_init_attr->rwq_ind_tbl;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
