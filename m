From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Thu, 8 Feb 2018 12:09:43 -0800
Message-ID: <eac01039be8c0518e37928e5b003a911c32e53a7.1518468700.git.swise@opengridcomputing.com>
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
 drivers/infiniband/core/restrack.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 857637b..83bce7e 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -7,7 +7,6 @@
 #include <rdma/restrack.h>
 #include <linux/mutex.h>
 #include <linux/sched/task.h>
-#include <linux/uaccess.h>
 #include <linux/pid_namespace.h>
 
 void rdma_restrack_init(struct rdma_restrack_root *res)
@@ -93,6 +92,39 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
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
+		if (qp->pd)
+			is_user = qp->pd->uobject;
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
@@ -100,7 +132,7 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
 	if (!dev)
 		return;
 
-	if (!uaccess_kernel()) {
+	if (res_is_user(res)) {
 		get_task_struct(current);
 		res->task = current;
 		res->kern_name = NULL;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
