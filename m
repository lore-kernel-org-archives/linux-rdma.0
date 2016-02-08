From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 2/7] Add alloc/dealloc Memory Window verbs
Date: Mon,  8 Feb 2016 14:43:17 +0200
Message-ID: <1454935402-15192-3-git-send-email-yishaih@mellanox.com>
References: <1454935402-15192-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454935402-15192-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add alloc/dealloc Memory Window verbs, those verbs
are used by both MW types one and two.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/driver.h   |  6 ++++++
 include/infiniband/kern-abi.h | 23 +++++++++++++++++++++++
 include/infiniband/verbs.h    | 27 +++++++++++++++++++++++++++
 src/cmd.c                     | 37 +++++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |  3 +++
 5 files changed, 96 insertions(+)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 5226784..1b0802d 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -144,6 +144,12 @@ int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
 		     size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
 		     size_t resp_sz);
 int ibv_cmd_dereg_mr(struct ibv_mr *mr);
+int ibv_cmd_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type,
+		     struct ibv_mw *mw, struct ibv_alloc_mw *cmd,
+		     size_t cmd_size,
+		     struct ibv_alloc_mw_resp *resp, size_t resp_size);
+int ibv_cmd_dealloc_mw(struct ibv_mw *mw,
+		       struct ibv_dealloc_mw *cmd, size_t cmd_size);
 int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      struct ibv_comp_channel *channel,
 		      int comp_vector, struct ibv_cq *cq,
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 8bab69f..d4ef58e 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -389,6 +389,29 @@ struct ibv_dereg_mr {
 	__u32 mr_handle;
 };
 
+struct ibv_alloc_mw {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u64 response;
+	__u32 pd_handle;
+	__u8  mw_type;
+	__u8  reserved[3];
+};
+
+struct ibv_alloc_mw_resp {
+	__u32 mw_handle;
+	__u32 rkey;
+};
+
+struct ibv_dealloc_mw {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	__u32 mw_handle;
+	__u32 reserved;
+};
+
 struct ibv_create_comp_channel {
 	__u32 command;
 	__u16 in_words;
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 69e4e29..7d67cc8 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -434,6 +434,8 @@ struct ibv_mw {
 	struct ibv_context     *context;
 	struct ibv_pd	       *pd;
 	uint32_t		rkey;
+	uint32_t		handle;
+	enum ibv_mw_type	type;
 };
 
 struct ibv_global_route {
@@ -1240,6 +1242,31 @@ int ibv_rereg_mr(struct ibv_mr *mr, int flags,
 int ibv_dereg_mr(struct ibv_mr *mr);
 
 /**
+ * ibv_alloc_mw - Allocate a memory window
+ */
+static inline struct ibv_mw *ibv_alloc_mw(struct ibv_pd *pd,
+					  enum ibv_mw_type type)
+{
+	struct ibv_mw *mw;
+
+	if (!pd->context->ops.alloc_mw) {
+		errno = ENOSYS;
+		return NULL;
+	}
+
+	mw = pd->context->ops.alloc_mw(pd, type);
+	return mw;
+}
+
+/**
+ * ibv_dealloc_mw - Free a memory window
+ */
+static inline int ibv_dealloc_mw(struct ibv_mw *mw)
+{
+	return mw->context->ops.dealloc_mw(mw);
+}
+
+/**
  * ibv_create_comp_channel - Create a completion event channel
  */
 struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context);
diff --git a/src/cmd.c b/src/cmd.c
index e5a32bc..9aa072e 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -376,6 +376,43 @@ int ibv_cmd_dereg_mr(struct ibv_mr *mr)
 	return 0;
 }
 
+int ibv_cmd_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type,
+		     struct ibv_mw *mw, struct ibv_alloc_mw *cmd,
+		     size_t cmd_size,
+		     struct ibv_alloc_mw_resp *resp, size_t resp_size)
+{
+	IBV_INIT_CMD_RESP(cmd, cmd_size, ALLOC_MW, resp, resp_size);
+	cmd->pd_handle	= pd->handle;
+	cmd->mw_type	= type;
+	memset(cmd->reserved, 0, sizeof(cmd->reserved));
+
+	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	mw->context = pd->context;
+	mw->pd      = pd;
+	mw->rkey    = resp->rkey;
+	mw->handle  = resp->mw_handle;
+	mw->type    = type;
+
+	return 0;
+}
+
+int ibv_cmd_dealloc_mw(struct ibv_mw *mw,
+		       struct ibv_dealloc_mw *cmd, size_t cmd_size)
+{
+	IBV_INIT_CMD(cmd, cmd_size, DEALLOC_MW);
+	cmd->mw_handle = mw->handle;
+	cmd->reserved = 0;
+
+	if (write(mw->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	return 0;
+}
+
 int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      struct ibv_comp_channel *channel,
 		      int comp_vector, struct ibv_cq *cq,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index cbccca7..d934b50 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -102,6 +102,9 @@ IBVERBS_1.1 {
 		ibv_event_type_str;
 		ibv_wc_status_str;
 
+		ibv_cmd_alloc_mw;
+		ibv_cmd_dealloc_mw;
+
 		ibv_rate_to_mbps;
 		mbps_to_ibv_rate;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
