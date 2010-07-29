From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 2/3] libibverbs: Add reg/unreg I/O memory commands to kern
	ABI
Date: Thu, 29 Jul 2010 11:31:57 -0500
Message-ID: <20100729163157.14901.72351.stgit@build.ogc.int>
References: <20100729163030.14901.87547.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729163030.14901.87547.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Add the commands to register and unregister I/O memory to the Kernel ABI.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 include/infiniband/kern-abi.h |   32 +++++++++++++++++++++++++++++++-
 src/cmd.c                     |   41 +++++++++++++++++++++++++++++++++++++++++
 src/libibverbs.map            |    5 +++++
 3 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 0db083a..56b538f 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -85,7 +85,9 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_REG_IO_MR,
+	IB_USER_VERBS_CMD_DEREG_IO_MR,
 };
 
 /*
@@ -271,6 +273,32 @@ struct ibv_dereg_mr {
 	__u32 mr_handle;
 };
 
+struct ibv_reg_io_mr {
+        __u32 command;
+        __u16 in_words;
+        __u16 out_words;
+        __u64 response;
+        __u64 start;
+        __u64 length;
+        __u64 hca_va;
+        __u32 pd_handle;
+        __u32 access_flags;
+        __u64 driver_data[0];
+};
+
+struct ibv_reg_io_mr_resp {
+        __u32 mr_handle;
+        __u32 lkey;
+        __u32 rkey;
+};
+
+struct ibv_dereg_io_mr {
+        __u32 command;
+        __u16 in_words;
+        __u16 out_words;
+        __u32 mr_handle;
+};
+
 struct ibv_create_comp_channel {
 	__u32 command;
 	__u16 in_words;
@@ -803,6 +831,8 @@ enum {
 	 * trick opcodes in IBV_INIT_CMD() doesn't break.
 	 */
 	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
+	IB_USER_VERBS_CMD_REG_IO_MR_V2 = -1,
+	IB_USER_VERBS_CMD_DEREG_IO_MR_V2 = -1,
 };
 
 struct ibv_destroy_cq_v1 {
diff --git a/src/cmd.c b/src/cmd.c
index cbd5288..f8fe6d5 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -271,6 +271,47 @@ int ibv_cmd_dereg_mr(struct ibv_mr *mr)
 	return 0;
 }
 
+int ibv_cmd_reg_io_mr(struct ibv_pd *pd, void *addr, size_t length,
+		      uint64_t hca_va, int access,
+		      struct ibv_mr *mr, struct ibv_reg_io_mr *cmd,
+		      size_t cmd_size,
+		      struct ibv_reg_io_mr_resp *resp, size_t resp_size)
+{
+
+	IBV_INIT_CMD_RESP(cmd, cmd_size, REG_IO_MR, resp, resp_size);
+
+	cmd->start 	  = (uintptr_t) addr;
+	cmd->length 	  = length;
+	cmd->hca_va 	  = hca_va;
+	cmd->pd_handle 	  = pd->handle;
+	cmd->access_flags = access;
+
+	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	mr->handle  = resp->mr_handle;
+	mr->lkey    = resp->lkey;
+	mr->rkey    = resp->rkey;
+	mr->context = pd->context;
+
+	return 0;
+}
+
+int ibv_cmd_dereg_io_mr(struct ibv_mr *mr)
+{
+	struct ibv_dereg_io_mr cmd;
+
+	IBV_INIT_CMD(&cmd, sizeof cmd, DEREG_IO_MR);
+	cmd.mr_handle = mr->handle;
+
+	if (write(mr->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
+		return errno;
+
+	return 0;
+}
+
 static int ibv_cmd_create_cq_v2(struct ibv_context *context, int cqe,
 				struct ibv_cq *cq,
 				struct ibv_create_cq *new_cmd, size_t new_cmd_size,
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 1827da0..bc8a251 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -84,6 +84,11 @@ IBVERBS_1.1 {
 		ibv_open_device;
 		ibv_close_device;
 
+                ibv_reg_io_mr;
+                ibv_cmd_reg_io_mr;
+                ibv_dereg_io_mr;
+                ibv_cmd_dereg_io_mr;
+
 		ibv_init_ah_from_wc;
 		ibv_create_ah_from_wc;
 		ibv_copy_ah_attr_from_kern;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
