From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/7] RDMA/cxgb4: Make ord/ird max for T4 match T3.
Date: Thu, 06 May 2010 18:06:20 -0500
Message-ID: <20100506230619.25362.97591.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Until I implement the MPA extensions Internet Draft, make the ord/ird
max values for T4 match those of T3 (8).  Also add a module option to
allow upping the value for pure T4 environments.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c       |   13 +++++++++++--
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 +
 drivers/infiniband/hw/cxgb4/provider.c |    4 ++--
 drivers/infiniband/hw/cxgb4/qp.c       |    4 ++--
 drivers/infiniband/hw/cxgb4/t4.h       |    1 -
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 07b068b..cf6dbf4 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -61,6 +61,10 @@ static char *states[] = {
 	NULL,
 };
 
+int c4iw_max_read_depth = 8;
+module_param(c4iw_max_read_depth, int, 0644);
+MODULE_PARM_DESC(c4iw_max_read_depth, "Per-connection max ORD/IRD (default=8)");
+
 static int enable_tcp_timestamps;
 module_param(enable_tcp_timestamps, int, 0644);
 MODULE_PARM_DESC(enable_tcp_timestamps, "Enable tcp timestamps (default=0)");
@@ -1904,8 +1908,8 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	BUG_ON(state_read(&ep->com) != MPA_REQ_RCVD);
 	BUG_ON(!qp);
 
-	if ((conn_param->ord > T4_MAX_READ_DEPTH) ||
-	    (conn_param->ird > T4_MAX_READ_DEPTH)) {
+	if ((conn_param->ord > c4iw_max_read_depth) ||
+	    (conn_param->ird > c4iw_max_read_depth)) {
 		abort_connection(ep, NULL, GFP_KERNEL);
 		err = -EINVAL;
 		goto err;
@@ -1968,6 +1972,11 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct net_device *pdev;
 	int step;
 
+	if ((conn_param->ord > c4iw_max_read_depth) ||
+	    (conn_param->ird > c4iw_max_read_depth)) {
+		err = -EINVAL;
+		goto out;
+	}
 	ep = alloc_ep(sizeof(*ep), GFP_KERNEL);
 	if (!ep) {
 		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __func__);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index ccce6fe..c3ea5a2 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -739,5 +739,6 @@ void c4iw_ev_dispatch(struct c4iw_dev *dev, struct t4_cqe *err_cqe);
 
 extern struct cxgb4_client t4c_client;
 extern c4iw_handler_func c4iw_handlers[NUM_CPL_CMDS];
+extern int c4iw_max_read_depth;
 
 #endif
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 3cb50af..dfc4902 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -267,8 +267,8 @@ static int c4iw_query_device(struct ib_device *ibdev,
 	props->max_qp_wr = T4_MAX_QP_DEPTH;
 	props->max_sge = T4_MAX_RECV_SGE;
 	props->max_sge_rd = 1;
-	props->max_qp_rd_atom = T4_MAX_READ_DEPTH;
-	props->max_qp_init_rd_atom = T4_MAX_READ_DEPTH;
+	props->max_qp_rd_atom = c4iw_max_read_depth;
+	props->max_qp_init_rd_atom = c4iw_max_read_depth;
 	props->max_cq = T4_MAX_NUM_CQ;
 	props->max_cqe = T4_MAX_CQ_DEPTH;
 	props->max_mr = c4iw_num_stags(&dev->rdev);
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index bd56c84..7ff6aea 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1130,14 +1130,14 @@ int c4iw_modify_qp(struct c4iw_dev *rhp, struct c4iw_qp *qhp,
 		if (mask & C4IW_QP_ATTR_ENABLE_RDMA_BIND)
 			newattr.enable_bind = attrs->enable_bind;
 		if (mask & C4IW_QP_ATTR_MAX_ORD) {
-			if (attrs->max_ord > T4_MAX_READ_DEPTH) {
+			if (attrs->max_ord > c4iw_max_read_depth) {
 				ret = -EINVAL;
 				goto out;
 			}
 			newattr.max_ord = attrs->max_ord;
 		}
 		if (mask & C4IW_QP_ATTR_MAX_IRD) {
-			if (attrs->max_ird > T4_MAX_READ_DEPTH) {
+			if (attrs->max_ird > c4iw_max_read_depth) {
 				ret = -EINVAL;
 				goto out;
 			}
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 3f0d217..aeeb005 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -36,7 +36,6 @@
 #include "t4_msg.h"
 #include "t4fw_ri_api.h"
 
-#define T4_MAX_READ_DEPTH 16
 #define T4_QID_BASE 1024
 #define T4_MAX_QIDS 256
 #define T4_MAX_NUM_QP (1<<16)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
