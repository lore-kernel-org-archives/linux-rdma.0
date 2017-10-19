From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/6] IB/uverbs: Allow CQ moderation with modify CQ
Date: Thu, 19 Oct 2017 08:35:19 +0300
Message-ID: <20171019053524.11135-2-leon@kernel.org>
References: <20171019053524.11135-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019053524.11135-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Uverbs support in modify_cq for CQ moderation only.
Gives ability to change cq_max_count and cq_period.
CQ moderation enhance performance by moderating the number
of cookies needed to create an event instead of application
having to suffer from event per cookie.
To achieve CQ moderation the application needs to set cq_max_count
and cq_period.
cq_max_count - defines the number of cookies
               needed to create an event.
cq_period - defines the timeout (micro seconds) between last
            event and a new one that will occur even if
	    cq_max_count was not satisfied

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_cmd.c  | 36 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |  1 +
 include/rdma/ib_verbs.h               |  4 ++++
 include/uapi/rdma/ib_user_verbs.h     | 11 ++++++++++-
 5 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index ee2739ae4305..deccefb71a6b 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -306,5 +306,6 @@ IB_UVERBS_DECLARE_EX_CMD(destroy_wq);
 IB_UVERBS_DECLARE_EX_CMD(create_rwq_ind_table);
 IB_UVERBS_DECLARE_EX_CMD(destroy_rwq_ind_table);
 IB_UVERBS_DECLARE_EX_CMD(modify_qp);
+IB_UVERBS_DECLARE_EX_CMD(modify_cq);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ab29a0327831..c7819e5540f1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3856,3 +3856,39 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
 }
+
+int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
+			   struct ib_device *ib_dev,
+			   struct ib_udata *ucore,
+			   struct ib_udata *uhw)
+{
+	struct ib_uverbs_ex_modify_cq cmd = {};
+	struct ib_cq *cq;
+	int ret;
+
+	/* sanity checks */
+	if (ucore->inlen > sizeof(cmd) &&
+	    !ib_is_udata_cleared(ucore, sizeof(cmd),
+				 ucore->inlen - sizeof(cmd)))
+		return -EOPNOTSUPP;
+
+	ret = ib_copy_from_udata(&cmd, ucore, min(sizeof(cmd), ucore->inlen));
+	if (ret)
+		return ret;
+
+	if (cmd.attr_mask != IB_CQ_MODERATE)
+		return -EINVAL;
+
+	if (!cmd.comp_mask)
+		return -EINVAL;
+
+	cq = uobj_get_obj_read(cq, cmd.cq_handle, file->ucontext);
+	if (!cq)
+		return -EINVAL;
+
+	ret = ib_modify_cq(cq, cmd.cq_count, cmd.cq_period);
+
+	uobj_put_obj_read(cq);
+
+	return ret;
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index b5febfd84ee5..381fd9c096ae 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -128,6 +128,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL] = ib_uverbs_ex_create_rwq_ind_table,
 	[IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL] = ib_uverbs_ex_destroy_rwq_ind_table,
 	[IB_USER_VERBS_EX_CMD_MODIFY_QP]        = ib_uverbs_ex_modify_qp,
+	[IB_USER_VERBS_EX_CMD_MODIFY_CQ]        = ib_uverbs_ex_modify_cq,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4c0a539cd2a2..ec80fec2d113 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -311,6 +311,10 @@ struct ib_cq_init_attr {
 	u32		flags;
 };
 
+enum ib_cq_attr_mask {
+	IB_CQ_MODERATE = 1 << 0,
+};
+
 struct ib_device_attr {
 	u64			fw_ver;
 	__be64			sys_image_guid;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index d4e0b53bfc75..854aaafc60d0 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -100,7 +100,8 @@ enum {
 	IB_USER_VERBS_EX_CMD_MODIFY_WQ,
 	IB_USER_VERBS_EX_CMD_DESTROY_WQ,
 	IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL,
-	IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL
+	IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL,
+	IB_USER_VERBS_EX_CMD_MODIFY_CQ
 };
 
 /*
@@ -1150,6 +1151,14 @@ struct ib_uverbs_ex_destroy_rwq_ind_table  {
 	__u32 ind_tbl_handle;
 };
 
+struct ib_uverbs_ex_modify_cq {
+	__u32 cq_handle;
+	__u32 attr_mask;
+	__u16 cq_count;
+	__u16 cq_period;
+	__u32 comp_mask;
+};
+
 #define IB_DEVICE_NAME_MAX 64
 
 #endif /* IB_USER_VERBS_H */
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
