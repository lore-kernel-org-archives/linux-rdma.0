From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC internal rdma-next 1/2] IB/core: Introduce vendor QP type
Date: Sun, 26 Nov 2017 19:45:12 +0200
Message-ID: <1511718317-3381-2-git-send-email-alexma@mellanox.com>
References: <1511718317-3381-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511718317-3381-1-git-send-email-alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Vendors can implement type of QPs that are not described in the
Infiniband specification. To still be able to use the IB/core layer
services (e.g. user object management) without tainting this layer with
vendor proprietary logic a new QP type is added - IB_QPT_VENDOR. This
will be a general QP type that core layer doesn't know about its true nature.
When a command like create_qp() is passed to vendor driver the extra data
that is required is taken from the vendor channel.
Although IB/core layer doesn't know the details of the vendor QP it can
assume that all vendor QP has some things in common that seperate them
from standard QPs and therefore code is allowed to make decisions based
on this QP type.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 9 ++++++---
 drivers/infiniband/core/verbs.c      | 3 +++
 include/rdma/ib_verbs.h              | 2 ++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 52a2cf2..21d8f55 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1374,6 +1374,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	int				ret;
 	struct ib_rwq_ind_table *ind_tbl = NULL;
 	bool has_sq = true;
+	bool has_rq = true;
 
 	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
@@ -1412,8 +1413,10 @@ static int create_qp(struct ib_uverbs_file *file,
 		goto err_put;
 	}
 
-	if (ind_tbl && !cmd->max_send_wr)
+	if ((ind_tbl || cmd->qp_type == IB_QPT_VENDOR) && !cmd->max_send_wr)
 		has_sq = false;
+	if (cmd->qp_type == IB_QPT_VENDOR && !cmd->max_recv_wr)
+		has_rq = false;
 
 	if (cmd->qp_type == IB_QPT_XRC_TGT) {
 		xrcd_uobj = uobj_get_read(uobj_get_type(xrcd), cmd->pd_handle,
@@ -1445,7 +1448,7 @@ static int create_qp(struct ib_uverbs_file *file,
 			}
 
 			if (!ind_tbl) {
-				if (cmd->recv_cq_handle != cmd->send_cq_handle) {
+				if (cmd->recv_cq_handle != cmd->send_cq_handle && has_rq) {
 					rcq = uobj_get_obj_read(cq, cmd->recv_cq_handle,
 								file->ucontext);
 					if (!rcq) {
@@ -1459,7 +1462,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		if (has_sq)
 			scq = uobj_get_obj_read(cq, cmd->send_cq_handle,
 						file->ucontext);
-		if (!ind_tbl)
+		if (!ind_tbl && has_rq)
 			rcq = rcq ?: scq;
 		pd  = uobj_get_obj_read(pd, cmd->pd_handle, file->ucontext);
 		if (!pd || (!scq && has_sq)) {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index de57d6c..9b5afeb5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1196,6 +1196,9 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 {
 	enum ib_qp_attr_mask req_param, opt_param;
 
+	if (type >= IB_QPT_MAX)
+		return 0;
+
 	if (cur_state  < 0 || cur_state  > IB_QPS_ERR ||
 	    next_state < 0 || next_state > IB_QPS_ERR)
 		return 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e8608b2..93a305b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1069,7 +1069,9 @@ enum ib_qp_type {
 	IB_QPT_RAW_PACKET = 8,
 	IB_QPT_XRC_INI = 9,
 	IB_QPT_XRC_TGT,
+	/* IB_QPT_MAX is the higher value for QP types that the InfiniBand spec describes */
 	IB_QPT_MAX,
+	IB_QPT_VENDOR =0xFFF,
 	/* Reserve a range for qp types internal to the low level driver.
 	 * These qp types will not be visible at the IB core layer, so the
 	 * IB_QPT_MAX usages should not be affected in the core layer
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
