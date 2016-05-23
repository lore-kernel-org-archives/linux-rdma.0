From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 09/10] IB/uverbs: Extend create QP to get RWQ indirection table
Date: Mon, 23 May 2016 15:20:55 +0300
Message-ID: <1464006056-19653-10-git-send-email-yishaih@mellanox.com>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464006056-19653-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

User applications that want to spread incoming traffic between several WQs
should create a QP which contains an indirection table.

When such a QP is created other receive side parameters are not valid
and should not be given. Its send side is optional and assumed active
based on max_send_wr capability value.

Extend create QP to work accordingly.


Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 75 ++++++++++++++++++++++++++++++------
 include/uapi/rdma/ib_user_verbs.h    | 10 +++++
 2 files changed, 73 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 327a56c..65ab209 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -255,6 +255,17 @@ static void put_wq_read(struct ib_wq *wq)
 	put_uobj_read(wq->uobject);
 }
 
+static struct ib_rwq_ind_table *idr_read_rwq_indirection_table(int ind_table_handle,
+							       struct ib_ucontext *context)
+{
+	return idr_read_obj(&ib_uverbs_rwq_ind_tbl_idr, ind_table_handle, context, 0);
+}
+
+static void put_rwq_indirection_table_read(struct ib_rwq_ind_table *ind_table)
+{
+	put_uobj_read(ind_table->uobject);
+}
+
 static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
 {
 	struct ib_uobject *uobj;
@@ -1761,9 +1772,11 @@ static int create_qp(struct ib_uverbs_file *file,
 	struct ib_srq			*srq = NULL;
 	struct ib_qp			*qp;
 	char				*buf;
-	struct ib_qp_init_attr		attr;
+	struct ib_qp_init_attr		attr = {};
 	struct ib_uverbs_ex_create_qp_resp resp;
 	int				ret;
+	struct ib_rwq_ind_table *ind_tbl = NULL;
+	bool has_sq = true;
 
 	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
@@ -1775,6 +1788,32 @@ static int create_qp(struct ib_uverbs_file *file,
 	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
 		  &qp_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
+	if (cmd_sz >= offsetof(typeof(*cmd), rwq_ind_tbl_handle) +
+		      sizeof(cmd->rwq_ind_tbl_handle) &&
+		      (cmd->comp_mask & IB_UVERBS_CREATE_QP_MASK_IND_TABLE)) {
+		ind_tbl = idr_read_rwq_indirection_table(cmd->rwq_ind_tbl_handle,
+							 file->ucontext);
+		if (!ind_tbl) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+
+		attr.rwq_ind_tbl = ind_tbl;
+	}
+
+	if ((cmd_sz >= offsetof(typeof(*cmd), reserved1) +
+		       sizeof(cmd->reserved1)) && cmd->reserved1) {
+		ret = -EOPNOTSUPP;
+		goto err_put;
+	}
+
+	if (ind_tbl && (cmd->max_recv_wr || cmd->max_recv_sge || cmd->is_srq)) {
+		ret = -EINVAL;
+		goto err_put;
+	}
+
+	if (ind_tbl && !cmd->max_send_wr)
+		has_sq = false;
 
 	if (cmd->qp_type == IB_QPT_XRC_TGT) {
 		xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
@@ -1798,20 +1837,24 @@ static int create_qp(struct ib_uverbs_file *file,
 				}
 			}
 
-			if (cmd->recv_cq_handle != cmd->send_cq_handle) {
-				rcq = idr_read_cq(cmd->recv_cq_handle,
-						  file->ucontext, 0);
-				if (!rcq) {
-					ret = -EINVAL;
-					goto err_put;
+			if (!ind_tbl) {
+				if (cmd->recv_cq_handle != cmd->send_cq_handle) {
+					rcq = idr_read_cq(cmd->recv_cq_handle,
+							  file->ucontext, 0);
+					if (!rcq) {
+						ret = -EINVAL;
+						goto err_put;
+					}
 				}
 			}
 		}
 
-		scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
-		rcq = rcq ?: scq;
+		if (has_sq)
+			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
+		if (!ind_tbl)
+			rcq = rcq ?: scq;
 		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
-		if (!pd || !scq) {
+		if (!pd || (!scq && has_sq)) {
 			ret = -EINVAL;
 			goto err_put;
 		}
@@ -1878,16 +1921,20 @@ static int create_qp(struct ib_uverbs_file *file,
 		qp->send_cq	  = attr.send_cq;
 		qp->recv_cq	  = attr.recv_cq;
 		qp->srq		  = attr.srq;
+		qp->rwq_ind_tbl	  = ind_tbl;
 		qp->event_handler = attr.event_handler;
 		qp->qp_context	  = attr.qp_context;
 		qp->qp_type	  = attr.qp_type;
 		atomic_set(&qp->usecnt, 0);
 		atomic_inc(&pd->usecnt);
-		atomic_inc(&attr.send_cq->usecnt);
+		if (attr.send_cq)
+			atomic_inc(&attr.send_cq->usecnt);
 		if (attr.recv_cq)
 			atomic_inc(&attr.recv_cq->usecnt);
 		if (attr.srq)
 			atomic_inc(&attr.srq->usecnt);
+		if (ind_tbl)
+			atomic_inc(&ind_tbl->usecnt);
 	}
 	qp->uobject = &obj->uevent.uobject;
 
@@ -1927,6 +1974,8 @@ static int create_qp(struct ib_uverbs_file *file,
 		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
+	if (ind_tbl)
+		put_rwq_indirection_table_read(ind_tbl);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
@@ -1954,6 +2003,8 @@ err_put:
 		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
+	if (ind_tbl)
+		put_rwq_indirection_table_read(ind_tbl);
 
 	put_uobj_write(&obj->uevent.uobject);
 	return ret;
@@ -2047,7 +2098,7 @@ int ib_uverbs_ex_create_qp(struct ib_uverbs_file *file,
 	if (err)
 		return err;
 
-	if (cmd.comp_mask)
+	if (cmd.comp_mask & ~IB_UVERBS_CREATE_QP_SUP_COMP_MASK)
 		return -EINVAL;
 
 	if (cmd.reserved)
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 2cf7c95..2c8bca8 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -523,6 +523,14 @@ struct ib_uverbs_create_qp {
 	__u64 driver_data[0];
 };
 
+enum ib_uverbs_create_qp_mask {
+	IB_UVERBS_CREATE_QP_MASK_IND_TABLE = 1UL << 0,
+};
+
+enum {
+	IB_UVERBS_CREATE_QP_SUP_COMP_MASK = IB_UVERBS_CREATE_QP_MASK_IND_TABLE,
+};
+
 struct ib_uverbs_ex_create_qp {
 	__u64 user_handle;
 	__u32 pd_handle;
@@ -540,6 +548,8 @@ struct ib_uverbs_ex_create_qp {
 	__u8 reserved;
 	__u32 comp_mask;
 	__u32 create_flags;
+	__u32 rwq_ind_tbl_handle;
+	__u32  reserved1;
 };
 
 struct ib_uverbs_open_qp {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
