From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/3] ibverbs: Add support for packet pacing
Date: Sun,  8 Jan 2017 18:32:27 +0200
Message-ID: <1483893148-8211-3-git-send-email-yishaih@mellanox.com>
References: <1483893148-8211-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483893148-8211-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

New command ibv_cmd_modify_qp_ex is added to support more QP attributes
such as packet pacing rate limit. Drivers which support packet pacing
should use this command to call the kernel.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c               | 55 ++++++++++++++++++++++++++++++++++++++----
 libibverbs/driver.h            |  5 ++++
 libibverbs/kern-abi.h          | 27 ++++++++++++++++++---
 libibverbs/libibverbs.map      |  5 ++++
 libibverbs/man/ibv_modify_qp.3 |  2 ++
 libibverbs/verbs.h             |  4 ++-
 6 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index a702d67..362c488 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1215,12 +1215,10 @@ int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	return 0;
 }
 
-int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-		      int attr_mask,
-		      struct ibv_modify_qp *cmd, size_t cmd_size)
+static void copy_modify_qp_fields(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+				  int attr_mask,
+				  struct ibv_modify_qp_common *cmd)
 {
-	IBV_INIT_CMD(cmd, cmd_size, MODIFY_QP);
-
 	cmd->qp_handle = qp->handle;
 	cmd->attr_mask = attr_mask;
 
@@ -1344,6 +1342,22 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		cmd->dest_qp_num = 0;
 
 	cmd->reserved[0] = cmd->reserved[1] = 0;
+}
+
+int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+		      int attr_mask,
+		      struct ibv_modify_qp *cmd, size_t cmd_size)
+{
+	/*
+	 * Masks over IBV_QP_DEST_QPN are only supported by
+	 * ibv_cmd_modify_qp_ex.
+	 */
+	if (attr_mask & ~((IBV_QP_DEST_QPN << 1) -1))
+		return EOPNOTSUPP;
+
+	IBV_INIT_CMD(cmd, cmd_size, MODIFY_QP);
+
+	copy_modify_qp_fields(qp, attr, attr_mask, &cmd->base);
 
 	if (write(qp->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
@@ -1351,6 +1365,37 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	return 0;
 }
 
+int ibv_cmd_modify_qp_ex(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+			 int attr_mask, struct ibv_modify_qp_ex *cmd,
+			 size_t cmd_core_size, size_t cmd_size,
+			 struct ibv_modify_qp_resp_ex *resp,
+			 size_t resp_core_size, size_t resp_size)
+{
+	if (resp_core_size < offsetof(struct ibv_modify_qp_resp_ex,
+			     response_length) + sizeof(resp->response_length))
+		return EINVAL;
+
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, MODIFY_QP_EX,
+			       resp, resp_core_size, resp_size);
+
+	copy_modify_qp_fields(qp, attr, attr_mask, &cmd->base);
+
+	if (attr_mask & IBV_QP_RATE_LIMIT) {
+		if (cmd_size >= offsetof(struct ibv_modify_qp_ex, rate_limit) +
+		    sizeof(cmd->rate_limit))
+			cmd->rate_limit = attr->rate_limit;
+		else
+			return EINVAL;
+	}
+
+	if (write(qp->context->cmd_fd, cmd, cmd_size) != cmd_size)
+		return errno;
+
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+
+	return 0;
+}
+
 int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		      struct ibv_send_wr **bad_wr)
 {
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index ea3dade..53e4409 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -225,6 +225,11 @@ int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *qp_attr,
 int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		      int attr_mask,
 		      struct ibv_modify_qp *cmd, size_t cmd_size);
+int ibv_cmd_modify_qp_ex(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+			 int attr_mask, struct ibv_modify_qp_ex *cmd,
+			 size_t cmd_core_size, size_t cmd_size,
+			 struct ibv_modify_qp_resp_ex *resp,
+			 size_t resp_core_size, size_t resp_size);
 int ibv_cmd_destroy_qp(struct ibv_qp *qp);
 int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		      struct ibv_send_wr **bad_wr);
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index bb57495..210dd3e 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -114,6 +114,8 @@ enum {
 					 IB_USER_VERBS_CMD_CREATE_QP,
 	IB_USER_VERBS_CMD_CREATE_CQ_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
 						IB_USER_VERBS_CMD_CREATE_CQ,
+	IB_USER_VERBS_CMD_MODIFY_QP_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
+						IB_USER_VERBS_CMD_MODIFY_QP,
 	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_EXTENDED_MASK +
 					IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_CMD_DESTROY_FLOW,
@@ -745,10 +747,7 @@ struct ibv_query_qp_resp {
 	__u64 driver_data[0];
 };
 
-struct ibv_modify_qp {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+struct ibv_modify_qp_common {
 	struct ibv_qp_dest dest;
 	struct ibv_qp_dest alt_dest;
 	__u32 qp_handle;
@@ -775,9 +774,28 @@ struct ibv_modify_qp {
 	__u8  alt_port_num;
 	__u8  alt_timeout;
 	__u8  reserved[2];
+};
+
+struct ibv_modify_qp {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+	struct ibv_modify_qp_common base;
 	__u64 driver_data[0];
 };
 
+struct ibv_modify_qp_ex {
+	struct ex_hdr		    hdr;
+	struct ibv_modify_qp_common base;
+	__u32  rate_limit;
+	__u32  reserved;
+};
+
+struct ibv_modify_qp_resp_ex {
+	__u32  comp_mask;
+	__u32  response_length;
+};
+
 struct ibv_destroy_qp {
 	__u32 command;
 	__u16 in_words;
@@ -1187,6 +1205,7 @@ enum {
 	IB_USER_VERBS_CMD_DESTROY_WQ_V2 = -1,
 	IB_USER_VERBS_CMD_CREATE_RWQ_IND_TBL_V2 = -1,
 	IB_USER_VERBS_CMD_DESTROY_RWQ_IND_TBL_V2 = -1,
+	IB_USER_VERBS_CMD_MODIFY_QP_EX_V2 = -1,
 };
 
 struct ibv_modify_srq_v3 {
diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map
index 33cd6b6..f697b69 100644
--- a/libibverbs/libibverbs.map
+++ b/libibverbs/libibverbs.map
@@ -131,3 +131,8 @@ IBVERBS_1.3 {
 		ibv_cmd_destroy_rwq_ind_table;
 		ibv_query_gid_type;
 } IBVERBS_1.1;
+
+IBVERBS_1.4 {
+	global:
+		ibv_cmd_modify_qp_ex;
+} IBVERBS_1.3;
diff --git a/libibverbs/man/ibv_modify_qp.3 b/libibverbs/man/ibv_modify_qp.3
index 66a4974..487aa94 100644
--- a/libibverbs/man/ibv_modify_qp.3
+++ b/libibverbs/man/ibv_modify_qp.3
@@ -49,6 +49,7 @@ uint8_t                 retry_cnt;              /* Retry count (valid only for R
 uint8_t                 rnr_retry;              /* RNR retry (valid only for RC QPs) */
 uint8_t                 alt_port_num;           /* Alternate port number */
 uint8_t                 alt_timeout;            /* Local ack timeout for alternate path (valid only for RC QPs) */
+uint32_t                rate_limit;             /* Rate limit in kbps for packet pacing */
 .in -8
 };
 .fi
@@ -105,6 +106,7 @@ The argument is either 0 or the bitwise OR of one or more of the following flags
 .B IBV_QP_CAP \fR Set cap
 .TP
 .B IBV_QP_DEST_QPN \fR Set dest_qp_num
+.B IBV_QP_RATE_LIMIT \fR Set rate_limit
 .SH "RETURN VALUE"
 .B ibv_modify_qp()
 returns 0 on success, or the value of errno on failure (which indicates the failure reason).
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 6606196..27726b5 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -829,7 +829,8 @@ enum ibv_qp_attr_mask {
 	IBV_QP_MAX_DEST_RD_ATOMIC	= 1 << 17,
 	IBV_QP_PATH_MIG_STATE		= 1 << 18,
 	IBV_QP_CAP			= 1 << 19,
-	IBV_QP_DEST_QPN			= 1 << 20
+	IBV_QP_DEST_QPN			= 1 << 20,
+	IBV_QP_RATE_LIMIT		= 1 << 25,
 };
 
 enum ibv_qp_state {
@@ -875,6 +876,7 @@ struct ibv_qp_attr {
 	uint8_t			rnr_retry;
 	uint8_t			alt_port_num;
 	uint8_t			alt_timeout;
+	uint32_t		rate_limit;
 };
 
 enum ibv_wr_opcode {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
