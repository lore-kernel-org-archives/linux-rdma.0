From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 09/10] IB/uverbs: Extend create QP to get RX HASH configuration
Date: Sun, 17 Apr 2016 17:27:16 +0300
Message-ID: <1460903237-16870-10-git-send-email-yishaih@mellanox.com>
References: <1460903237-16870-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460903237-16870-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

User applications that spread QP traffic between several WQs should
create a QP which contains an indirection table and hashing
parameters.

Extend create QP to get RX HASH configuration (that includes the
receive Work Queue indirection table and the hashing parameters).

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 56 +++++++++++++++++++++++++++++++++---
 include/uapi/rdma/ib_user_verbs.h    | 10 +++++++
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 1b31195..ce8b1dc 100644
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
@@ -1764,6 +1775,9 @@ static int create_qp(struct ib_uverbs_file *file,
 	struct ib_qp_init_attr		attr;
 	struct ib_uverbs_ex_create_qp_resp resp;
 	int				ret;
+	struct ib_rx_hash_conf  rx_hash_conf;
+	struct ib_rwq_ind_table *ind_tbl = NULL;
+	bool rx_hash_qp = 0;
 
 	if (cmd->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
 		return -EPERM;
@@ -1775,6 +1789,9 @@ static int create_qp(struct ib_uverbs_file *file,
 	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext,
 		  &qp_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
+	rx_hash_qp = (cmd_sz >= (offsetof(typeof(*cmd), rx_hash_conf) +
+				sizeof(cmd->rx_hash_conf)) &&
+			cmd->rx_hash_conf.rx_hash_function);
 
 	if (cmd->qp_type == IB_QPT_XRC_TGT) {
 		xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
@@ -1807,11 +1824,11 @@ static int create_qp(struct ib_uverbs_file *file,
 				}
 			}
 		}
-
-		scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
+		if (!rx_hash_qp)
+			scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
 		rcq = rcq ?: scq;
 		pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
-		if (!pd || !scq) {
+		if (!pd || (!scq && !rx_hash_qp)) {
 			ret = -EINVAL;
 			goto err_put;
 		}
@@ -1844,6 +1861,29 @@ static int create_qp(struct ib_uverbs_file *file,
 		      sizeof(cmd->create_flags))
 		attr.create_flags = cmd->create_flags;
 
+	attr.rx_hash_conf = NULL;
+	if (rx_hash_qp) {
+		if (memchr_inv(cmd->rx_hash_conf.reserved, 0,
+			       sizeof(cmd->rx_hash_conf.reserved))) {
+			ret = -EOPNOTSUPP;
+			goto err_put;
+		}
+
+		ind_tbl = idr_read_rwq_indirection_table(cmd->rx_hash_conf.rwq_ind_tbl_handle,
+							 file->ucontext);
+		if (!ind_tbl) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+
+		rx_hash_conf.rwq_ind_tbl = ind_tbl;
+		rx_hash_conf.rx_hash_fields_mask = cmd->rx_hash_conf.rx_hash_fields_mask;
+		rx_hash_conf.rx_hash_function = cmd->rx_hash_conf.rx_hash_function;
+		rx_hash_conf.rx_hash_key = cmd->rx_hash_conf.rx_hash_key;
+		rx_hash_conf.rx_key_len = cmd->rx_hash_conf.rx_key_len;
+		attr.rx_hash_conf = &rx_hash_conf;
+	}
+
 	if (attr.create_flags & ~(IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK |
 				IB_QP_CREATE_CROSS_CHANNEL |
 				IB_QP_CREATE_MANAGED_SEND |
@@ -1877,16 +1917,20 @@ static int create_qp(struct ib_uverbs_file *file,
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
+		if (!rx_hash_qp)
+			atomic_inc(&attr.send_cq->usecnt);
 		if (attr.recv_cq)
 			atomic_inc(&attr.recv_cq->usecnt);
 		if (attr.srq)
 			atomic_inc(&attr.srq->usecnt);
+		if (ind_tbl)
+			atomic_inc(&ind_tbl->usecnt);
 	}
 	qp->uobject = &obj->uevent.uobject;
 
@@ -1926,6 +1970,8 @@ static int create_qp(struct ib_uverbs_file *file,
 		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
+	if (ind_tbl)
+		put_rwq_indirection_table_read(ind_tbl);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
@@ -1953,6 +1999,8 @@ err_put:
 		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
+	if (ind_tbl)
+		put_rwq_indirection_table_read(ind_tbl);
 
 	put_uobj_write(&obj->uevent.uobject);
 	return ret;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index ea12a98..5ed680e 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -522,6 +522,15 @@ struct ib_uverbs_create_qp {
 	__u64 driver_data[0];
 };
 
+struct ib_uverbs_hash_conf {
+	__u64 rx_hash_fields_mask; /* enum ib_rx_hash_fields */
+	__u32 rwq_ind_tbl_handle;
+	__u8 rx_hash_function; /* enum ib_rx_hash_function_flags */
+	__u8 rx_key_len; /* valid only for Toeplitz */
+	__u8 rx_hash_key[128]; /* valid only for Toeplitz */
+	__u8 reserved[18];
+};
+
 struct ib_uverbs_ex_create_qp {
 	__u64 user_handle;
 	__u32 pd_handle;
@@ -539,6 +548,7 @@ struct ib_uverbs_ex_create_qp {
 	__u8 reserved;
 	__u32 comp_mask;
 	__u32 create_flags;
+	struct ib_uverbs_hash_conf rx_hash_conf;
 };
 
 struct ib_uverbs_open_qp {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
