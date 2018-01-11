From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 15/17] verbs: Use kernel uapi header for ibv_modify_qp_common
Date: Thu, 11 Jan 2018 15:13:38 -0700
Message-ID: <20180111221340.965-16-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The kernel header has a redundant driver_data.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      |  2 +-
 libibverbs/kern-abi.h | 33 ++-------------------------------
 2 files changed, 3 insertions(+), 32 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index f73af7b7a92d80..0e1589e1c8963e 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1273,7 +1273,7 @@ int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 
 static void copy_modify_qp_fields(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 				  int attr_mask,
-				  struct ibv_modify_qp_common *cmd)
+				  struct ib_uverbs_modify_qp *cmd)
 {
 	cmd->qp_handle = qp->handle;
 	cmd->attr_mask = attr_mask;
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 57ef1dd6ff6beb..8400ce1c47e92d 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -337,46 +337,17 @@ struct ibv_query_qp {
 	__u64 driver_data[0];
 };
 
-struct ibv_modify_qp_common {
-	struct ib_uverbs_qp_dest dest;
-	struct ib_uverbs_qp_dest alt_dest;
-	__u32 qp_handle;
-	__u32 attr_mask;
-	__u32 qkey;
-	__u32 rq_psn;
-	__u32 sq_psn;
-	__u32 dest_qp_num;
-	__u32 qp_access_flags;
-	__u16 pkey_index;
-	__u16 alt_pkey_index;
-	__u8  qp_state;
-	__u8  cur_qp_state;
-	__u8  path_mtu;
-	__u8  path_mig_state;
-	__u8  en_sqd_async_notify;
-	__u8  max_rd_atomic;
-	__u8  max_dest_rd_atomic;
-	__u8  min_rnr_timer;
-	__u8  port_num;
-	__u8  timeout;
-	__u8  retry_cnt;
-	__u8  rnr_retry;
-	__u8  alt_port_num;
-	__u8  alt_timeout;
-	__u8  reserved[2];
-};
-
 struct ibv_modify_qp {
 	__u32 command;
 	__u16 in_words;
 	__u16 out_words;
-	struct ibv_modify_qp_common base;
+	struct ib_uverbs_modify_qp base;
 	__u64 driver_data[0];
 };
 
 struct ibv_modify_qp_ex {
 	struct ex_hdr		    hdr;
-	struct ibv_modify_qp_common base;
+	struct ib_uverbs_modify_qp base;
 	__u32  rate_limit;
 	__u32  reserved;
 };
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
