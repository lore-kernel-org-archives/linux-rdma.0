From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 13/17] verbs: Use kernel uapi header for IBV_CREATE_QP_EX_KERNEL_MASK_IND_TABLE
Date: Thu, 11 Jan 2018 15:13:36 -0700
Message-ID: <20180111221340.965-14-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Kernel calls it IB_UVERBS_CREATE_QP_MASK_IND_TABLE

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      | 2 +-
 libibverbs/kern-abi.h | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 99e94233f320d1..dfa3fe6e113e98 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1014,7 +1014,7 @@ int ibv_cmd_create_qp_ex2(struct ibv_context *context,
 				    sizeof(cmd->ind_tbl_handle))
 			return EINVAL;
 		cmd->ind_tbl_handle = qp_attr->rwq_ind_tbl->ind_tbl_handle;
-		cmd->comp_mask = IBV_CREATE_QP_EX_KERNEL_MASK_IND_TABLE;
+		cmd->comp_mask = IB_UVERBS_CREATE_QP_MASK_IND_TABLE;
 	}
 
 	err = write(context->cmd_fd, cmd, cmd_size);
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 6284d0e45e9784..277d968f0bcc2c 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -318,11 +318,6 @@ struct ibv_open_qp {
 	__u64 driver_data[0];
 };
 
-
-enum ibv_create_qp_ex_kernel_mask {
-	IBV_CREATE_QP_EX_KERNEL_MASK_IND_TABLE = 1 << 0,
-};
-
 struct ibv_create_qp_ex {
 	struct ex_hdr	hdr;
 	struct ibv_create_qp_common base;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
