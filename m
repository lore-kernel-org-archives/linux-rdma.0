From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 5/7] Add bind/unbind support for Memory Window type two
Date: Mon,  8 Feb 2016 14:43:20 +0200
Message-ID: <1454935402-15192-6-git-send-email-yishaih@mellanox.com>
References: <1454935402-15192-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454935402-15192-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To bind:
Application should directly post bind WR to the
QP using ibv_post_send.

To unbind/invalidate there are 2 options, local and remote
invalidations.

Local invalidation:
Send a work request where the immediate data contains the
MW's R_key and the opcode is IBV_WR_LOCAL_INV.

Upon success a completion with opcode of IBV_WC_LOCAL_INV is polled.

Remote invalidation:
Send with invalidate can be used to invalidate a remote memory
key.

The invalidation is done by posting a send work request, where the
opcode is IBV_WR_SEND_WITH_INV and the immediate data
contains the R_key.

Upon success, the responder's work completion will contain the
invalidated R_key in its immediate data.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 81cc3d9..b9102a6 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -344,6 +344,7 @@ enum ibv_wc_opcode {
 	IBV_WC_COMP_SWAP,
 	IBV_WC_FETCH_ADD,
 	IBV_WC_BIND_MW,
+	IBV_WC_LOCAL_INV,
 /*
  * Set value of IBV_WC_RECV so consumers can test if a completion is a
  * receive by testing (opcode & IBV_WC_RECV).
@@ -359,7 +360,8 @@ enum {
 enum ibv_wc_flags {
 	IBV_WC_GRH		= 1 << 0,
 	IBV_WC_WITH_IMM		= 1 << 1,
-	IBV_WC_IP_CSUM_OK	= 1 << IBV_WC_IP_CSUM_OK_SHIFT
+	IBV_WC_IP_CSUM_OK	= 1 << IBV_WC_IP_CSUM_OK_SHIFT,
+	IBV_WC_WITH_INV         = 1 << 3
 };
 
 struct ibv_wc {
@@ -368,7 +370,10 @@ struct ibv_wc {
 	enum ibv_wc_opcode	opcode;
 	uint32_t		vendor_err;
 	uint32_t		byte_len;
-	uint32_t		imm_data;	/* in network byte order */
+	/* When (wc_flags & IBV_WC_WITH_IMM): Immediate data in network byte order.
+	 * When (wc_flags & IBV_WC_WITH_INV): Stores the invalidated rkey.
+	 */
+	uint32_t		imm_data;
 	uint32_t		qp_num;
 	uint32_t		src_qp;
 	int			wc_flags;
@@ -701,7 +706,10 @@ enum ibv_wr_opcode {
 	IBV_WR_SEND_WITH_IMM,
 	IBV_WR_RDMA_READ,
 	IBV_WR_ATOMIC_CMP_AND_SWP,
-	IBV_WR_ATOMIC_FETCH_AND_ADD
+	IBV_WR_ATOMIC_FETCH_AND_ADD,
+	IBV_WR_LOCAL_INV,
+	IBV_WR_BIND_MW,
+	IBV_WR_SEND_WITH_INV,
 };
 
 enum ibv_send_flags {
@@ -748,6 +756,12 @@ struct ibv_send_wr {
 			uint32_t    remote_srqn;
 		} xrc;
 	} qp_type;
+	struct {
+		struct ibv_mw	*mw;
+		uint32_t		rkey;
+		struct ibv_mw_bind_info	bind_info;
+	} bind_mw;
+
 };
 
 struct ibv_recv_wr {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
