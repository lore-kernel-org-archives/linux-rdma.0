From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 10/17] verbs: Use kernel uapi header for ibv_kern_wc and ibv_poll_cq_resp
Date: Thu, 11 Jan 2018 15:13:33 -0700
Message-ID: <20180111221340.965-11-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The kern_wc is slightly different, and the kernel API version is
missing a be32 (patch going to Linux separately)

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/fixup-include/rdma-ib_user_verbs.h |  2 +-
 libibverbs/cmd.c                            |  6 +++---
 libibverbs/kern-abi.h                       | 24 ------------------------
 3 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/buildlib/fixup-include/rdma-ib_user_verbs.h b/buildlib/fixup-include/rdma-ib_user_verbs.h
index 7e11bb8651b641..0573c0bb9fd059 100644
--- a/buildlib/fixup-include/rdma-ib_user_verbs.h
+++ b/buildlib/fixup-include/rdma-ib_user_verbs.h
@@ -449,7 +449,7 @@ struct ib_uverbs_wc {
 	__u32 vendor_err;
 	__u32 byte_len;
 	union {
-		__u32 imm_data;
+		__be32 imm_data;
 		__u32 invalidate_rkey;
 	} ex;
 	__u32 qp_num;
diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index d7ca35b924a81c..62ac7df0dfc57b 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -562,12 +562,12 @@ int ibv_cmd_create_cq_ex(struct ibv_context *context,
 int ibv_cmd_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 {
 	struct ibv_poll_cq       cmd;
-	struct ibv_poll_cq_resp *resp;
+	struct ib_uverbs_poll_cq_resp *resp;
 	int                      i;
 	int                      rsize;
 	int                      ret;
 
-	rsize = sizeof *resp + ne * sizeof(struct ibv_kern_wc);
+	rsize = sizeof *resp + ne * sizeof(struct ib_uverbs_wc);
 	resp  = malloc(rsize);
 	if (!resp)
 		return -1;
@@ -589,7 +589,7 @@ int ibv_cmd_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 		wc[i].opcode 	     = resp->wc[i].opcode;
 		wc[i].vendor_err     = resp->wc[i].vendor_err;
 		wc[i].byte_len 	     = resp->wc[i].byte_len;
-		wc[i].imm_data 	     = resp->wc[i].imm_data;
+		wc[i].imm_data 	     = resp->wc[i].ex.imm_data;
 		wc[i].qp_num 	     = resp->wc[i].qp_num;
 		wc[i].src_qp 	     = resp->wc[i].src_qp;
 		wc[i].wc_flags 	     = resp->wc[i].wc_flags;
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 96b98ebc229980..a9e6b5461abd83 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -240,24 +240,6 @@ struct ibv_create_cq_ex {
 	__u32		reserved;
 };
 
-struct ibv_kern_wc {
-	__u64  wr_id;
-	__u32  status;
-	__u32  opcode;
-	__u32  vendor_err;
-	__u32  byte_len;
-	__be32  imm_data;
-	__u32  qp_num;
-	__u32  src_qp;
-	__u32  wc_flags;
-	__u16  pkey_index;
-	__u16  slid;
-	__u8   sl;
-	__u8   dlid_path_bits;
-	__u8   port_num;
-	__u8   reserved;
-};
-
 struct ibv_poll_cq {
 	__u32 command;
 	__u16 in_words;
@@ -267,12 +249,6 @@ struct ibv_poll_cq {
 	__u32 ne;
 };
 
-struct ibv_poll_cq_resp {
-	__u32 count;
-	__u32 reserved;
-	struct ibv_kern_wc wc[0];
-};
-
 struct ibv_req_notify_cq {
 	__u32 command;
 	__u16 in_words;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
