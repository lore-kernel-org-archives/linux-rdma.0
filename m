From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 libibverbs 5/7] Create a single threaded CQ
Date: Sun, 29 May 2016 17:51:13 +0300
Message-ID: <1464533475-18949-6-git-send-email-yishaih@mellanox.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464533475-18949-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When a CQ is used only from one thread, there's no need to waste cycles
on locking. Since this series introduces a mechanism which allows the
vendor to introduce different polling functions per CQ, it allows the
vendor to implement both locking and lockless CQs and assign them
accordingly.

Adding a new creation flag for this.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 12 +++++++++++-
 man/ibv_create_cq_ex.3     |  8 ++++++++
 src/cmd.c                  |  4 ++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 2bcc70d..6642336 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -1193,7 +1193,13 @@ struct ibv_context {
 };
 
 enum ibv_cq_init_attr_mask {
-	IBV_CQ_INIT_ATTR_MASK_RESERVED	= 0 << 1
+	IBV_CQ_INIT_ATTR_MASK_FLAGS	= 1 << 0,
+	IBV_CQ_INIT_ATTR_MASK_RESERVED	= 1 << 1
+};
+
+enum ibv_create_cq_attr_flags {
+	IBV_CREATE_CQ_ATTR_SINGLE_THREADED = 1 << 0,
+	IBV_CREATE_CQ_ATTR_RESERVED = 1 << 1,
 };
 
 struct ibv_cq_init_attr_ex {
@@ -1215,6 +1221,10 @@ struct ibv_cq_init_attr_ex {
 	 * enum ibv_cq_init_attr_mask
 	 */
 	uint32_t		comp_mask;
+	/* create cq attr flags - one or more flags from
+	 * enum ibv_create_cq_attr_flags
+	 */
+	uint32_t		flags;
 };
 
 enum verbs_context_mask {
diff --git a/man/ibv_create_cq_ex.3 b/man/ibv_create_cq_ex.3
index b0b5e2d..93a1a38 100644
--- a/man/ibv_create_cq_ex.3
+++ b/man/ibv_create_cq_ex.3
@@ -42,6 +42,14 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 8,  /* Require completion timestamp in WC /*
 };
 
+enum ibv_cq_init_attr_mask {
+        IBV_CQ_INIT_ATTR_MASK_FLAGS             = 1 << 0,
+};
+
+enum ibv_create_cq_attr_flags {
+        IBV_CREATE_CQ_ATTR_SINGLE_THREADED      = 1 << 0, /* This CQ is used from a single threaded, thus no locking is required */
+};
+
 .SH "Polling an extended CQ"
 In order to poll an extended CQ efficiently, a user could use the following functions.
 
diff --git a/src/cmd.c b/src/cmd.c
index 647fbbb..5cd3e78 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -486,6 +486,10 @@ int ibv_cmd_create_cq_ex(struct ibv_context *context,
 
 	if (cmd_core_size >= offsetof(struct ibv_create_cq_ex, flags) +
 	    sizeof(cmd->flags)) {
+		if ((cq_attr->comp_mask & IBV_CQ_INIT_ATTR_MASK_FLAGS) &&
+		    (cq_attr->flags & ~(IBV_CREATE_CQ_ATTR_RESERVED - 1)))
+			return EOPNOTSUPP;
+
 		if (cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)
 			cmd->flags |= IBV_CREATE_CQ_EX_KERNEL_FLAG_COMPLETION_TIMESTAMP;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
