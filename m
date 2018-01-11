From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 05/17] verbs: Remove kernel ABI v2 compat cruft
Date: Thu, 11 Jan 2018 15:13:28 -0700
Message-ID: <20180111221340.965-6-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When verbs extensions were introduced the minimum ABI version was
changed to v3 and abi_ver <= 2 was no longer possible.

Remove everything to do with this support since it hasn't even
been runnable for 5 years.

Fixes: 6be16586e081 ("Infrastructure to support verbs extensions")
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      |  3 ---
 libibverbs/ibverbs.h  | 18 +++-----------
 libibverbs/kern-abi.h | 67 ---------------------------------------------------
 libibverbs/verbs.c    | 33 -------------------------
 4 files changed, 4 insertions(+), 117 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index fc58de768d0011..fbd87d475a2751 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -48,9 +48,6 @@ int ibv_cmd_get_context(struct verbs_context *context_ex,
 			struct ibv_get_context *cmd, size_t cmd_size,
 			struct ibv_get_context_resp *resp, size_t resp_size)
 {
-	if (abi_ver < IB_USER_VERBS_MIN_ABI_VERSION)
-		return ENOSYS;
-
 	IBV_INIT_CMD_RESP(cmd, cmd_size, GET_CONTEXT, resp, resp_size);
 
 	if (write(context_ex->context.cmd_fd, cmd, cmd_size) != cmd_size)
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index 97d3a4b8dbab91..7755393fe4f3ce 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -64,20 +64,14 @@ struct verbs_ex_private {
 
 #define IBV_INIT_CMD(cmd, size, opcode)					\
 	do {								\
-		if (abi_ver > 2)					\
-			(cmd)->command = IB_USER_VERBS_CMD_##opcode;	\
-		else							\
-			(cmd)->command = IB_USER_VERBS_CMD_##opcode##_V2; \
+		(cmd)->command = IB_USER_VERBS_CMD_##opcode;		\
 		(cmd)->in_words  = (size) / 4;				\
 		(cmd)->out_words = 0;					\
 	} while (0)
 
 #define IBV_INIT_CMD_RESP(cmd, size, opcode, out, outsize)		\
 	do {								\
-		if (abi_ver > 2)					\
-			(cmd)->command = IB_USER_VERBS_CMD_##opcode;	\
-		else							\
-			(cmd)->command = IB_USER_VERBS_CMD_##opcode##_V2; \
+		(cmd)->command = IB_USER_VERBS_CMD_##opcode;		\
 		(cmd)->in_words  = (size) / 4;				\
 		(cmd)->out_words = (outsize) / 4;			\
 		(cmd)->response  = (uintptr_t) (out);			\
@@ -94,12 +88,8 @@ static inline uint32_t _cmd_ex(uint32_t cmd)
 		outsize)						   \
 	do {                                                               \
 		size_t c_size = cmd_size - sizeof(struct ex_hdr);	   \
-		if (abi_ver > 2)					   \
-			(cmd)->hdr.command =				   \
-				_cmd_ex(IB_USER_VERBS_EX_CMD_##opcode);    \
-		else							   \
-			(cmd)->hdr.command =				   \
-				IB_USER_VERBS_CMD_##opcode##_V2;	   \
+		(cmd)->hdr.command =					   \
+			_cmd_ex(IB_USER_VERBS_EX_CMD_##opcode);		   \
 		(cmd)->hdr.in_words  = ((c_size) / 8);                     \
 		(cmd)->hdr.out_words = ((resp_size) / 8);                  \
 		(cmd)->hdr.provider_in_words   = (((size) - (cmd_size))/8);\
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 92d750e1d26b09..52b6c8f5b3d621 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -1093,73 +1093,6 @@ struct ibv_destroy_srq_resp {
 	__u32 events_reported;
 };
 
-/*
- * Compatibility with older ABI versions
- */
-
-enum {
-	IB_USER_VERBS_CMD_QUERY_PARAMS_V2,
-	IB_USER_VERBS_CMD_GET_CONTEXT_V2,
-	IB_USER_VERBS_CMD_QUERY_DEVICE_V2,
-	IB_USER_VERBS_CMD_QUERY_PORT_V2,
-	IB_USER_VERBS_CMD_QUERY_GID_V2,
-	IB_USER_VERBS_CMD_QUERY_PKEY_V2,
-	IB_USER_VERBS_CMD_ALLOC_PD_V2,
-	IB_USER_VERBS_CMD_DEALLOC_PD_V2,
-	IB_USER_VERBS_CMD_CREATE_AH_V2,
-	IB_USER_VERBS_CMD_MODIFY_AH_V2,
-	IB_USER_VERBS_CMD_QUERY_AH_V2,
-	IB_USER_VERBS_CMD_DESTROY_AH_V2,
-	IB_USER_VERBS_CMD_REG_MR_V2,
-	IB_USER_VERBS_CMD_REG_SMR_V2,
-	IB_USER_VERBS_CMD_REREG_MR_V2,
-	IB_USER_VERBS_CMD_QUERY_MR_V2,
-	IB_USER_VERBS_CMD_DEREG_MR_V2,
-	IB_USER_VERBS_CMD_ALLOC_MW_V2,
-	IB_USER_VERBS_CMD_BIND_MW_V2,
-	IB_USER_VERBS_CMD_DEALLOC_MW_V2,
-	IB_USER_VERBS_CMD_CREATE_CQ_V2,
-	IB_USER_VERBS_CMD_RESIZE_CQ_V2,
-	IB_USER_VERBS_CMD_DESTROY_CQ_V2,
-	IB_USER_VERBS_CMD_POLL_CQ_V2,
-	IB_USER_VERBS_CMD_PEEK_CQ_V2,
-	IB_USER_VERBS_CMD_REQ_NOTIFY_CQ_V2,
-	IB_USER_VERBS_CMD_CREATE_QP_V2,
-	IB_USER_VERBS_CMD_QUERY_QP_V2,
-	IB_USER_VERBS_CMD_MODIFY_QP_V2,
-	IB_USER_VERBS_CMD_DESTROY_QP_V2,
-	IB_USER_VERBS_CMD_POST_SEND_V2,
-	IB_USER_VERBS_CMD_POST_RECV_V2,
-	IB_USER_VERBS_CMD_ATTACH_MCAST_V2,
-	IB_USER_VERBS_CMD_DETACH_MCAST_V2,
-	IB_USER_VERBS_CMD_CREATE_SRQ_V2,
-	IB_USER_VERBS_CMD_MODIFY_SRQ_V2,
-	IB_USER_VERBS_CMD_QUERY_SRQ_V2,
-	IB_USER_VERBS_CMD_DESTROY_SRQ_V2,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV_V2,
-	/*
-	 * Set commands that didn't exist to -1 so our compile-time
-	 * trick opcodes in IBV_INIT_CMD() doesn't break.
-	 */
-	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL_V2 = -1,
-	IB_USER_VERBS_CMD_OPEN_XRCD_V2 = -1,
-	IB_USER_VERBS_CMD_CLOSE_XRCD_V2 = -1,
-	IB_USER_VERBS_CMD_CREATE_XSRQ_V2 = -1,
-	IB_USER_VERBS_CMD_OPEN_QP_V2 = -1,
-	IB_USER_VERBS_CMD_CREATE_FLOW_V2 = -1,
-	IB_USER_VERBS_CMD_DESTROY_FLOW_V2 = -1,
-	IB_USER_VERBS_CMD_QUERY_DEVICE_EX_V2 = -1,
-	IB_USER_VERBS_CMD_CREATE_QP_EX_V2 = -1,
-	IB_USER_VERBS_CMD_CREATE_CQ_EX_V2 = -1,
-	IB_USER_VERBS_CMD_CREATE_WQ_V2 = -1,
-	IB_USER_VERBS_CMD_MODIFY_WQ_V2 = -1,
-	IB_USER_VERBS_CMD_DESTROY_WQ_V2 = -1,
-	IB_USER_VERBS_CMD_CREATE_RWQ_IND_TBL_V2 = -1,
-	IB_USER_VERBS_CMD_DESTROY_RWQ_IND_TBL_V2 = -1,
-	IB_USER_VERBS_CMD_MODIFY_QP_EX_V2 = -1,
-	IB_USER_VERBS_CMD_MODIFY_CQ_V2 = -1,
-};
-
 struct ibv_modify_srq_v3 {
 	__u32 command;
 	__u16 in_words;
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index c772335e06d71a..4b2696e2aac020 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -315,33 +315,12 @@ LATEST_SYMVER_FUNC(ibv_dereg_mr, 1_1, "IBVERBS_1.1",
 	return ret;
 }
 
-static struct ibv_comp_channel *ibv_create_comp_channel_v2(struct ibv_context *context)
-{
-	struct ibv_abi_compat_v2 *t = context->abi_compat;
-	static int warned;
-
-	if (!pthread_mutex_trylock(&t->in_use))
-		return &t->channel;
-
-	if (!warned) {
-		fprintf(stderr, PFX "Warning: kernel's ABI version %d limits capacity.\n"
-			"    Only one completion channel can be created per context.\n",
-			abi_ver);
-		++warned;
-	}
-
-	return NULL;
-}
-
 struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context)
 {
 	struct ibv_comp_channel            *channel;
 	struct ibv_create_comp_channel      cmd;
 	struct ibv_create_comp_channel_resp resp;
 
-	if (abi_ver <= 2)
-		return ibv_create_comp_channel_v2(context);
-
 	channel = malloc(sizeof *channel);
 	if (!channel)
 		return NULL;
@@ -361,13 +340,6 @@ struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context)
 	return channel;
 }
 
-static int ibv_destroy_comp_channel_v2(struct ibv_comp_channel *channel)
-{
-	struct ibv_abi_compat_v2 *t = (struct ibv_abi_compat_v2 *) channel;
-	pthread_mutex_unlock(&t->in_use);
-	return 0;
-}
-
 int ibv_destroy_comp_channel(struct ibv_comp_channel *channel)
 {
 	struct ibv_context *context;
@@ -381,11 +353,6 @@ int ibv_destroy_comp_channel(struct ibv_comp_channel *channel)
 		goto out;
 	}
 
-	if (abi_ver <= 2) {
-		ret = ibv_destroy_comp_channel_v2(channel);
-		goto out;
-	}
-
 	close(channel->fd);
 	free(channel);
 	ret = 0;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
