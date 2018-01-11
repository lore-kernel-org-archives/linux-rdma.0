From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 03/17] verbs: Delete extended command definitions from kern-abi.h
Date: Thu, 11 Jan 2018 15:13:26 -0700
Message-ID: <20180111221340.965-4-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The kernel definition is not quite the same, the names are slightly
different and the kernel enum does not include the flags bit.

Revise IBV_INIT_CMD_RESP_EX_V to use the kernel name and include the
flag bits.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      |  8 ++++----
 libibverbs/ibverbs.h  | 10 +++++++++-
 libibverbs/kern-abi.h | 26 --------------------------
 3 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index bcec94f5b0ce72..fc58de768d0011 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -156,7 +156,7 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		return EINVAL;
 
 	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size,
-			       QUERY_DEVICE_EX, resp, resp_core_size,
+			       QUERY_DEVICE, resp, resp_core_size,
 			       resp_size);
 	cmd->comp_mask = 0;
 	cmd->reserved = 0;
@@ -527,7 +527,7 @@ int ibv_cmd_create_cq_ex(struct ibv_context *context,
 	int err;
 
 	memset(cmd, 0, cmd_core_size);
-	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, CREATE_CQ_EX, resp,
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, CREATE_CQ, resp,
 			       resp_core_size, resp_size);
 
 	if (cq_attr->comp_mask & ~(IBV_CQ_INIT_ATTR_MASK_RESERVED - 1))
@@ -993,7 +993,7 @@ int ibv_cmd_create_qp_ex2(struct ibv_context *context,
 
 	memset(cmd, 0, cmd_core_size);
 
-	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, CREATE_QP_EX, resp,
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, CREATE_QP, resp,
 			       resp_core_size, resp_size);
 
 	err = create_qp_ex_common(qp, qp_attr, vxrcd, &cmd->base);
@@ -1389,7 +1389,7 @@ int ibv_cmd_modify_qp_ex(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 			     response_length) + sizeof(resp->response_length))
 		return EINVAL;
 
-	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, MODIFY_QP_EX,
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, MODIFY_QP,
 			       resp, resp_core_size, resp_size);
 
 	copy_modify_qp_fields(qp, attr, attr_mask, &cmd->base);
diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index 2da44967c4f1c0..97d3a4b8dbab91 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -83,12 +83,20 @@ struct verbs_ex_private {
 		(cmd)->response  = (uintptr_t) (out);			\
 	} while (0)
 
+static inline uint32_t _cmd_ex(uint32_t cmd)
+{
+	return (IB_USER_VERBS_CMD_FLAG_EXTENDED
+		<< IB_USER_VERBS_CMD_FLAGS_SHIFT) |
+	       cmd;
+}
+
 #define IBV_INIT_CMD_RESP_EX_V(cmd, cmd_size, size, opcode, out, resp_size,\
 		outsize)						   \
 	do {                                                               \
 		size_t c_size = cmd_size - sizeof(struct ex_hdr);	   \
 		if (abi_ver > 2)					   \
-			(cmd)->hdr.command = IB_USER_VERBS_CMD_##opcode;   \
+			(cmd)->hdr.command =				   \
+				_cmd_ex(IB_USER_VERBS_EX_CMD_##opcode);    \
 		else							   \
 			(cmd)->hdr.command =				   \
 				IB_USER_VERBS_CMD_##opcode##_V2;	   \
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index d7acdaa9a4bca9..f67ddb10548880 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -53,32 +53,6 @@
 #define IB_USER_VERBS_MIN_ABI_VERSION	3
 #define IB_USER_VERBS_MAX_ABI_VERSION	6
 
-/* use this mask for creating extended commands */
-#define IB_USER_VERBS_CMD_EXTENDED_MASK \
-	(IB_USER_VERBS_CMD_FLAG_EXTENDED << \
-	 IB_USER_VERBS_CMD_FLAGS_SHIFT)
-
-
-enum {
-	IB_USER_VERBS_CMD_QUERY_DEVICE_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
-					    IB_USER_VERBS_CMD_QUERY_DEVICE,
-	IB_USER_VERBS_CMD_CREATE_QP_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
-					 IB_USER_VERBS_CMD_CREATE_QP,
-	IB_USER_VERBS_CMD_CREATE_CQ_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
-						IB_USER_VERBS_CMD_CREATE_CQ,
-	IB_USER_VERBS_CMD_MODIFY_QP_EX = IB_USER_VERBS_CMD_EXTENDED_MASK |
-						IB_USER_VERBS_CMD_MODIFY_QP,
-	IB_USER_VERBS_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_EXTENDED_MASK +
-					IB_USER_VERBS_CMD_THRESHOLD,
-	IB_USER_VERBS_CMD_DESTROY_FLOW,
-	IB_USER_VERBS_CMD_CREATE_WQ,
-	IB_USER_VERBS_CMD_MODIFY_WQ,
-	IB_USER_VERBS_CMD_DESTROY_WQ,
-	IB_USER_VERBS_CMD_CREATE_RWQ_IND_TBL,
-	IB_USER_VERBS_CMD_DESTROY_RWQ_IND_TBL,
-	IB_USER_VERBS_CMD_MODIFY_CQ,
-};
-
 /*
  * Make sure that all structs defined in this file remain laid out so
  * that they pack the same way on 32-bit and 64-bit architectures (to
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
