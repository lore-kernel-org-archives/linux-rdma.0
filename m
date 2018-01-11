From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 17/17] verbs: Tidy up the remaining structs in kern-abi.h
Date: Thu, 11 Jan 2018 15:13:40 -0700
Message-ID: <20180111221340.965-18-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

These are almost now all the manual wrapper structs around the
kernel ABI struct.

- Include the header using struct ib_uverbs_cmd_hdr
  and revise the macros to use it
- Delete driver_data[0] VLA. The driver data following the
  command data is implied for all commands.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      |   2 +-
 libibverbs/ibverbs.h  |  12 ++--
 libibverbs/kern-abi.h | 164 +++++++++++---------------------------------------
 providers/rxe/rxe.c   |   6 +-
 4 files changed, 46 insertions(+), 138 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 0e1589e1c8963e..b89b1bdd366bc6 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -793,7 +793,7 @@ static int ibv_cmd_modify_srq_v3(struct ibv_srq *srq,
 
 	cmd_size = sizeof *cmd + new_cmd_size - sizeof *new_cmd;
 	cmd      = alloca(cmd_size);
-	memcpy(cmd->driver_data, new_cmd->driver_data, new_cmd_size - sizeof *new_cmd);
+	memcpy(cmd + 1, new_cmd + 1, new_cmd_size - sizeof *new_cmd);
 
 	IBV_INIT_CMD(cmd, cmd_size, MODIFY_SRQ);
 
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index ceb6c5bfd4e3f9..7238d79168733f 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -64,16 +64,16 @@ struct verbs_ex_private {
 
 #define IBV_INIT_CMD(cmd, size, opcode)					\
 	do {								\
-		(cmd)->command = IB_USER_VERBS_CMD_##opcode;		\
-		(cmd)->in_words  = (size) / 4;				\
-		(cmd)->out_words = 0;					\
+		(cmd)->hdr.command = IB_USER_VERBS_CMD_##opcode;	\
+		(cmd)->hdr.in_words  = (size) / 4;			\
+		(cmd)->hdr.out_words = 0;				\
 	} while (0)
 
 #define IBV_INIT_CMD_RESP(cmd, size, opcode, out, outsize)		\
 	do {								\
-		(cmd)->command = IB_USER_VERBS_CMD_##opcode;		\
-		(cmd)->in_words  = (size) / 4;				\
-		(cmd)->out_words = (outsize) / 4;			\
+		(cmd)->hdr.command = IB_USER_VERBS_CMD_##opcode;	\
+		(cmd)->hdr.in_words  = (size) / 4;			\
+		(cmd)->hdr.out_words = (outsize) / 4;			\
 		(cmd)->response  = (uintptr_t) (out);			\
 	} while (0)
 
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index ca7ba14dfdb580..8e264b00db46b5 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -78,19 +78,13 @@ struct ex_hdr {
  */
 
 struct ibv_get_context {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
-	__u64 driver_data[0];
 };
 
 struct ibv_query_device {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
-	__u64 driver_data[0];
 };
 
 struct ibv_query_device_ex {
@@ -100,64 +94,46 @@ struct ibv_query_device_ex {
 };
 
 struct ibv_query_port {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u8  port_num;
 	__u8  reserved[7];
-	__u64 driver_data[0];
 };
 
 struct ibv_alloc_pd {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
-	__u64 driver_data[0];
 };
 
 struct ibv_dealloc_pd {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u32 pd_handle;
 };
 
 struct ibv_open_xrcd {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 fd;
 	__u32 oflags;
-	__u64 driver_data[0];
 };
 
 struct ibv_close_xrcd {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u32 xrcd_handle;
 };
 
 struct ibv_reg_mr {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u64 start;
 	__u64 length;
 	__u64 hca_va;
 	__u32 pd_handle;
 	__u32 access_flags;
-	__u64 driver_data[0];
 };
 
 struct ibv_rereg_mr {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 mr_handle;
 	__u32 flags;
@@ -166,20 +142,15 @@ struct ibv_rereg_mr {
 	__u64 hca_va;
 	__u32 pd_handle;
 	__u32 access_flags;
-	__u64 driver_data[0];
 };
 
 struct ibv_dereg_mr {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u32 mr_handle;
 };
 
 struct ibv_alloc_mw {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 pd_handle;
 	__u8  mw_type;
@@ -187,31 +158,24 @@ struct ibv_alloc_mw {
 };
 
 struct ibv_dealloc_mw {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u32 mw_handle;
 	__u32 reserved;
 };
 
 struct ibv_create_comp_channel {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 };
 
 struct ibv_create_cq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u64 user_handle;
 	__u32 cqe;
 	__u32 comp_vector;
 	__s32 comp_channel;
 	__u32 reserved;
-	__u64 driver_data[0];
 };
 
 enum ibv_create_cq_ex_kernel_flags {
@@ -230,36 +194,27 @@ struct ibv_create_cq_ex {
 };
 
 struct ibv_poll_cq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 cq_handle;
 	__u32 ne;
 };
 
 struct ibv_req_notify_cq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u32 cq_handle;
 	__u32 solicited;
 };
 
 struct ibv_resize_cq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 cq_handle;
 	__u32 cqe;
-	__u64 driver_data[0];
 };
 
 struct ibv_destroy_cq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 cq_handle;
 	__u32 reserved;
@@ -282,12 +237,9 @@ struct ibv_destroy_cq {
 	__u8  reserved
 
 struct ibv_create_qp {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	IBV_CREATE_QP_COMMON;
-	__u64 driver_data[0];
 };
 
 struct ibv_create_qp_common {
@@ -295,16 +247,13 @@ struct ibv_create_qp_common {
 };
 
 struct ibv_open_qp {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u64 user_handle;
 	__u32 pd_handle;
 	__u32 qpn;
 	__u8  qp_type;
 	__u8  reserved[7];
-	__u64 driver_data[0];
 };
 
 struct ibv_create_qp_ex {
@@ -317,21 +266,15 @@ struct ibv_create_qp_ex {
 };
 
 struct ibv_query_qp {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 qp_handle;
 	__u32 attr_mask;
-	__u64 driver_data[0];
 };
 
 struct ibv_modify_qp {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	struct ib_uverbs_modify_qp base;
-	__u64 driver_data[0];
 };
 
 struct ibv_modify_qp_ex {
@@ -342,9 +285,7 @@ struct ibv_modify_qp_ex {
 };
 
 struct ibv_destroy_qp {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 qp_handle;
 	__u32 reserved;
@@ -378,9 +319,7 @@ struct ibv_kern_spec {
 };
 
 struct ibv_post_send {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 qp_handle;
 	__u32 wr_count;
@@ -390,9 +329,7 @@ struct ibv_post_send {
 };
 
 struct ibv_post_recv {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 qp_handle;
 	__u32 wr_count;
@@ -402,9 +339,7 @@ struct ibv_post_recv {
 };
 
 struct ibv_post_srq_recv {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 srq_handle;
 	__u32 wr_count;
@@ -414,9 +349,7 @@ struct ibv_post_srq_recv {
 };
 
 struct ibv_create_ah {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u64 user_handle;
 	__u32 pd_handle;
@@ -425,21 +358,16 @@ struct ibv_create_ah {
 };
 
 struct ibv_destroy_ah {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u32 ah_handle;
 };
 
 struct ibv_attach_mcast {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u8  gid[16];
 	__u32 qp_handle;
 	__u16 mlid;
 	__u16 reserved;
-	__u64 driver_data[0];
 };
 
 struct ibv_create_flow  {
@@ -456,33 +384,25 @@ struct ibv_destroy_flow  {
 };
 
 struct ibv_detach_mcast {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u8  gid[16];
 	__u32 qp_handle;
 	__u16 mlid;
 	__u16 reserved;
-	__u64 driver_data[0];
 };
 
 struct ibv_create_srq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u64 user_handle;
 	__u32 pd_handle;
 	__u32 max_wr;
 	__u32 max_sge;
 	__u32 srq_limit;
-	__u64 driver_data[0];
 };
 
 struct ibv_create_xsrq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u64 user_handle;
 	__u32 srq_type;
@@ -493,50 +413,38 @@ struct ibv_create_xsrq {
 	__u32 max_num_tags;
 	__u32 xrcd_handle;
 	__u32 cq_handle;
-	__u64 driver_data[0];
 };
 
 struct ibv_modify_srq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u32 srq_handle;
 	__u32 attr_mask;
 	__u32 max_wr;
 	__u32 srq_limit;
-	__u64 driver_data[0];
 };
 
 struct ibv_query_srq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 srq_handle;
 	__u32 reserved;
-	__u64 driver_data[0];
 };
 
 struct ibv_destroy_srq {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u64 response;
 	__u32 srq_handle;
 	__u32 reserved;
 };
 
 struct ibv_modify_srq_v3 {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
+	struct ib_uverbs_cmd_hdr hdr;
 	__u32 srq_handle;
 	__u32 attr_mask;
 	__u32 max_wr;
 	__u32 max_sge;
 	__u32 srq_limit;
 	__u32 reserved;
-	__u64 driver_data[0];
 };
 
 struct ibv_create_qp_resp_v3 {
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index c6ec95c2bcf80d..5978df3abfa7b5 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -672,9 +672,9 @@ static int post_send_db(struct ibv_qp *ibqp)
 	struct ibv_post_send cmd;
 	struct ib_uverbs_post_send_resp resp;
 
-	cmd.command	= IB_USER_VERBS_CMD_POST_SEND;
-	cmd.in_words	= sizeof(cmd)/4;
-	cmd.out_words	= sizeof(resp)/4;
+	cmd.hdr.command	= IB_USER_VERBS_CMD_POST_SEND;
+	cmd.hdr.in_words = sizeof(cmd) / 4;
+	cmd.hdr.out_words = sizeof(resp) / 4;
 	cmd.response	= (uintptr_t)&resp;
 	cmd.qp_handle	= ibqp->handle;
 	cmd.wr_count	= 0;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
