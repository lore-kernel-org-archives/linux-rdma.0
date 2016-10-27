From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V5 10/10] IB/core: Add modify_qp command to the new ABI
Date: Thu, 27 Oct 2016 17:43:18 +0300
Message-ID: <1477579398-6875-11-git-send-email-matanb@mellanox.com>
References: <1477579398-6875-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477579398-6875-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Partially tested.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h        |  14 +++
 drivers/infiniband/core/uverbs_cmd.c       |  14 ---
 drivers/infiniband/core/uverbs_ioctl_cmd.c | 161 +++++++++++++++++++++++++++++
 include/rdma/uverbs_ioctl_cmd.h            |  32 ++++++
 include/uapi/rdma/ib_user_verbs.h          |   7 ++
 5 files changed, 214 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..fccc7bc 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -153,4 +153,18 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
 			     struct netlink_callback *cb);
 
+/* Remove ignored fields set in the attribute mask */
+static inline int modify_qp_mask(enum ib_qp_type qp_type, int mask)
+{
+	switch (qp_type) {
+	case IB_QPT_XRC_INI:
+		return mask & ~(IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER);
+	case IB_QPT_XRC_TGT:
+		return mask & ~(IB_QP_MAX_QP_RD_ATOMIC | IB_QP_RETRY_CNT |
+				IB_QP_RNR_RETRY);
+	default:
+		return mask;
+	}
+}
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b1baa67..f4704bc 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2303,20 +2303,6 @@ out:
 	return ret ? ret : in_len;
 }
 
-/* Remove ignored fields set in the attribute mask */
-static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
-{
-	switch (qp_type) {
-	case IB_QPT_XRC_INI:
-		return mask & ~(IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER);
-	case IB_QPT_XRC_TGT:
-		return mask & ~(IB_QP_MAX_QP_RD_ATOMIC | IB_QP_RETRY_CNT |
-				IB_QP_RNR_RETRY);
-	default:
-		return mask;
-	}
-}
-
 ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
index e0c1af9..519b5e3 100644
--- a/drivers/infiniband/core/uverbs_ioctl_cmd.c
+++ b/drivers/infiniband/core/uverbs_ioctl_cmd.c
@@ -37,6 +37,7 @@
 #include <linux/file.h>
 #include "rdma_core.h"
 #include "uverbs.h"
+#include "core_priv.h"
 
 int ib_uverbs_std_dist(__u16 *id, void *priv)
 {
@@ -917,6 +918,164 @@ DECLARE_UVERBS_ACTION(uverbs_action_create_qp_xrc_tgt, uverbs_create_qp_xrc_tgt_
 		      NULL, &uverbs_create_qp_spec);
 EXPORT_SYMBOL(uverbs_action_create_qp_xrc_tgt);
 
+DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_modify_qp_spec,
+	UVERBS_ATTR_IDR(MODIFY_QP_HANDLE, UVERBS_TYPE_QP, UVERBS_IDR_ACCESS_WRITE),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_STATE, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_CUR_STATE, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_EN_SQD_ASYNC_NOTIFY, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_ACCESS_FLAGS, sizeof(__u32)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_PKEY_INDEX, sizeof(__u16)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_PORT, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_QKEY, sizeof(__u32)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_AV, sizeof(struct ib_uverbs_qp_dest)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_PATH_MTU, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_TIMEOUT, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_RETRY_CNT, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_RNR_RETRY, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_RQ_PSN, sizeof(__u32)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_MAX_RD_ATOMIC, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_ALT_PATH, sizeof(struct ib_uverbs_qp_alt_path)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_MIN_RNR_TIMER, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_SQ_PSN, sizeof(__u32)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_MAX_DEST_RD_ATOMIC, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_PATH_MIG_STATE, sizeof(__u8)),
+	UVERBS_ATTR_PTR_IN(MODIFY_QP_DEST_QPN, sizeof(__u32)));
+EXPORT_SYMBOL(uverbs_modify_qp_spec);
+
+int uverbs_modify_qp_handler(struct ib_device *ib_dev,
+			     struct ib_ucontext *ucontext,
+			     struct uverbs_attr_array *common,
+			     struct uverbs_attr_array *vendor,
+			     void *priv)
+{
+	struct ib_udata            uhw;
+	struct ib_qp              *qp;
+	struct ib_qp_attr         *attr;
+	struct ib_uverbs_qp_dest  av;
+	struct ib_uverbs_qp_alt_path alt_path;
+	__u32 attr_mask = 0;
+	int ret;
+
+	if (!common->attrs[MODIFY_QP_HANDLE].valid)
+		return -EINVAL;
+
+	qp = common->attrs[MODIFY_QP_HANDLE].obj_attr.uobject->object;
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+#define MODIFY_QP_CPY(_param, _fld, _attr)				\
+	({								\
+		int ret = UVERBS_COPY_FROM(_fld, common, _param);	\
+		if (!ret)						\
+			attr_mask |= _attr;				\
+		ret == -EFAULT ? ret : 0;				\
+	})
+
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_STATE, &attr->qp_state,
+				   IB_QP_STATE);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_CUR_STATE, &attr->cur_qp_state,
+				   IB_QP_CUR_STATE);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_EN_SQD_ASYNC_NOTIFY,
+				   &attr->en_sqd_async_notify,
+				   IB_QP_EN_SQD_ASYNC_NOTIFY);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_ACCESS_FLAGS,
+				   &attr->qp_access_flags, IB_QP_ACCESS_FLAGS);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_PKEY_INDEX, &attr->pkey_index,
+				   IB_QP_PKEY_INDEX);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_PORT, &attr->port_num, IB_QP_PORT);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_QKEY, &attr->qkey, IB_QP_QKEY);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_PATH_MTU, &attr->path_mtu,
+				   IB_QP_PATH_MTU);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_TIMEOUT, &attr->timeout,
+				   IB_QP_TIMEOUT);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_RETRY_CNT, &attr->retry_cnt,
+				   IB_QP_RETRY_CNT);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_RNR_RETRY, &attr->rnr_retry,
+				   IB_QP_RNR_RETRY);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_RQ_PSN, &attr->rq_psn,
+				   IB_QP_RQ_PSN);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_MAX_RD_ATOMIC,
+				   &attr->max_rd_atomic,
+				   IB_QP_MAX_QP_RD_ATOMIC);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_MIN_RNR_TIMER,
+				   &attr->min_rnr_timer, IB_QP_MIN_RNR_TIMER);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_SQ_PSN, &attr->sq_psn,
+				   IB_QP_SQ_PSN);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_MAX_DEST_RD_ATOMIC,
+				   &attr->max_dest_rd_atomic,
+				   IB_QP_MAX_DEST_RD_ATOMIC);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_PATH_MIG_STATE,
+				   &attr->path_mig_state, IB_QP_PATH_MIG_STATE);
+	ret = ret ?: MODIFY_QP_CPY(MODIFY_QP_DEST_QPN, &attr->dest_qp_num,
+				   IB_QP_DEST_QPN);
+
+	if (ret)
+		goto err;
+
+	ret = UVERBS_COPY_FROM(&av, common, MODIFY_QP_AV);
+	if (!ret) {
+		attr_mask |= IB_QP_AV;
+		attr->ah_attr.grh.flow_label        = av.flow_label;
+		attr->ah_attr.grh.sgid_index        = av.sgid_index;
+		attr->ah_attr.grh.hop_limit         = av.hop_limit;
+		attr->ah_attr.grh.traffic_class     = av.traffic_class;
+		attr->ah_attr.dlid		    = av.dlid;
+		attr->ah_attr.sl		    = av.sl;
+		attr->ah_attr.src_path_bits	    = av.src_path_bits;
+		attr->ah_attr.static_rate	    = av.static_rate;
+		attr->ah_attr.ah_flags		    = av.is_global ? IB_AH_GRH : 0;
+		attr->ah_attr.port_num		    = av.port_num;
+	} else if (ret == -EFAULT) {
+		goto err;
+	}
+
+	ret = UVERBS_COPY_FROM(&alt_path, common, MODIFY_QP_ALT_PATH);
+	if (!ret) {
+		attr_mask |= IB_QP_ALT_PATH;
+		attr->alt_ah_attr.grh.flow_label    = alt_path.dest.flow_label;
+		attr->alt_ah_attr.grh.sgid_index    = alt_path.dest.sgid_index;
+		attr->alt_ah_attr.grh.hop_limit     = alt_path.dest.hop_limit;
+		attr->alt_ah_attr.grh.traffic_class = alt_path.dest.traffic_class;
+		attr->alt_ah_attr.dlid		    = alt_path.dest.dlid;
+		attr->alt_ah_attr.sl		    = alt_path.dest.sl;
+		attr->alt_ah_attr.src_path_bits     = alt_path.dest.src_path_bits;
+		attr->alt_ah_attr.static_rate       = alt_path.dest.static_rate;
+		attr->alt_ah_attr.ah_flags	    = alt_path.dest.is_global ? IB_AH_GRH : 0;
+		attr->alt_ah_attr.port_num	    = alt_path.dest.port_num;
+		attr->alt_pkey_index		    = alt_path.pkey_index;
+		attr->alt_port_num		    = alt_path.port_num;
+		attr->alt_timeout		    = alt_path.timeout;
+	} else if (ret == -EFAULT) {
+		goto err;
+	}
+
+	create_udata(vendor, &uhw);
+
+	if (qp->real_qp == qp) {
+		ret = ib_resolve_eth_dmac(qp, attr, &attr_mask);
+		if (ret)
+			goto err;
+		ret = qp->device->modify_qp(qp, attr,
+			modify_qp_mask(qp->qp_type, attr_mask), &uhw);
+	} else {
+		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, attr_mask));
+	}
+
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	kfree(attr);
+	return ret;
+}
+EXPORT_SYMBOL(uverbs_modify_qp_handler);
+
+DECLARE_UVERBS_ACTION(uverbs_action_modify_qp, uverbs_modify_qp_handler, NULL,
+		      &uverbs_modify_qp_spec, &uverbs_uhw_compat_spec);
+
 DECLARE_UVERBS_ACTIONS(
 	uverbs_actions_comp_channel,
 	ADD_UVERBS_ACTION_PTR(UVERBS_COMP_CHANNEL_CREATE, &uverbs_action_create_comp_channel),
@@ -933,6 +1092,7 @@ DECLARE_UVERBS_ACTIONS(
 	uverbs_actions_qp,
 	ADD_UVERBS_ACTION_PTR(UVERBS_QP_CREATE, &uverbs_action_create_qp),
 	ADD_UVERBS_ACTION_PTR(UVERBS_QP_CREATE_XRC_TGT, &uverbs_action_create_qp_xrc_tgt),
+	ADD_UVERBS_ACTION_PTR(UVERBS_QP_MODIFY, &uverbs_action_modify_qp),
 );
 EXPORT_SYMBOL(uverbs_actions_qp);
 
@@ -1000,6 +1160,7 @@ DECLARE_UVERBS_TYPES(uverbs_types,
 		     ADD_UVERBS_TYPE(UVERBS_TYPE_MR, uverbs_type_mr),
 		     ADD_UVERBS_TYPE(UVERBS_TYPE_COMP_CHANNEL, uverbs_type_comp_channel),
 		     ADD_UVERBS_TYPE(UVERBS_TYPE_CQ, uverbs_type_cq),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_QP, uverbs_type_qp),
 );
 EXPORT_SYMBOL(uverbs_types);
 
diff --git a/include/rdma/uverbs_ioctl_cmd.h b/include/rdma/uverbs_ioctl_cmd.h
index ca82138..50fdaba 100644
--- a/include/rdma/uverbs_ioctl_cmd.h
+++ b/include/rdma/uverbs_ioctl_cmd.h
@@ -144,6 +144,30 @@ enum uverbs_create_qp_xrc_tgt_cmd_attr {
 	CREATE_QP_XRC_TGT_RESP
 };
 
+enum uverbs_modify_qp_cmd_attr {
+	MODIFY_QP_HANDLE,
+	MODIFY_QP_STATE,
+	MODIFY_QP_CUR_STATE,
+	MODIFY_QP_EN_SQD_ASYNC_NOTIFY,
+	MODIFY_QP_ACCESS_FLAGS,
+	MODIFY_QP_PKEY_INDEX,
+	MODIFY_QP_PORT,
+	MODIFY_QP_QKEY,
+	MODIFY_QP_AV,
+	MODIFY_QP_PATH_MTU,
+	MODIFY_QP_TIMEOUT,
+	MODIFY_QP_RETRY_CNT,
+	MODIFY_QP_RNR_RETRY,
+	MODIFY_QP_RQ_PSN,
+	MODIFY_QP_MAX_RD_ATOMIC,
+	MODIFY_QP_ALT_PATH,
+	MODIFY_QP_MIN_RNR_TIMER,
+	MODIFY_QP_SQ_PSN,
+	MODIFY_QP_MAX_DEST_RD_ATOMIC,
+	MODIFY_QP_PATH_MIG_STATE,
+	MODIFY_QP_DEST_QPN
+};
+
 enum uverbs_create_comp_channel_cmd_attr {
 	CREATE_COMP_CHANNEL_FD,
 };
@@ -236,6 +260,12 @@ int uverbs_create_qp_xrc_tgt_handler(struct ib_device *ib_dev,
 				     struct uverbs_attr_array *vendor,
 				     void *priv);
 
+int uverbs_modify_qp_handler(struct ib_device *ib_dev,
+			     struct ib_ucontext *ucontext,
+			     struct uverbs_attr_array *common,
+			     struct uverbs_attr_array *vendor,
+			     void *priv);
+
 extern const struct uverbs_action uverbs_action_get_context;
 extern const struct uverbs_action uverbs_action_create_cq;
 extern const struct uverbs_action uverbs_action_create_comp_channel;
@@ -245,6 +275,7 @@ extern const struct uverbs_action uverbs_action_reg_mr;
 extern const struct uverbs_action uverbs_action_dereg_mr;
 extern const struct uverbs_action uverbs_action_create_qp;
 extern const struct uverbs_action uverbs_action_create_qp_xrc_tgt;
+extern const struct uverbs_action uverbs_action_modify_qp;
 
 enum uverbs_actions_mr_ops {
 	UVERBS_MR_REG,
@@ -268,6 +299,7 @@ extern const struct uverbs_type_actions_group uverbs_actions_cq;
 enum uverbs_actions_qp_ops {
 	UVERBS_QP_CREATE,
 	UVERBS_QP_CREATE_XRC_TGT,
+	UVERBS_QP_MODIFY,
 };
 
 extern const struct uverbs_type_actions_group uverbs_actions_qp;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 14aff5f..0b06c4d 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -645,6 +645,13 @@ struct ib_uverbs_qp_dest {
 	__u8  port_num;
 };
 
+struct ib_uverbs_qp_alt_path {
+	struct ib_uverbs_qp_dest dest;
+	__u16 pkey_index;
+	__u8  port_num;
+	__u8  timeout;
+};
+
 struct ib_uverbs_query_qp {
 	__u64 response;
 	__u32 qp_handle;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
