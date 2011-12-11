From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 2/4] use Ethernet 8021q vlans related fields with
 CQE
Date: Sun, 11 Dec 2011 16:42:22 +0200
Message-ID: <alpine.LRH.2.00.1112111641100.32736@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1112111638020.32736@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1112111638020.32736-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When running IBoE traffic, the hardware places Ethernet
fields into the CQE. This patch enhances the code to include
the ones related to vlans.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8226b6b..14f2f4d 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -61,6 +61,11 @@ enum {
 #define MLX4_CQ_DB_REQ_NOT			(2 << 24)

 enum {
+	MLX4_CQE_VLAN_PRESENT_MASK	= 1 << 29,
+	MLX4_CQE_QPN_MASK		= 0xffffff,
+};
+
+enum {
 	MLX4_CQE_OWNER_MASK			= 0x80,
 	MLX4_CQE_IS_SEND_MASK			= 0x40,
 	MLX4_CQE_OPCODE_MASK			= 0x1f
@@ -83,11 +88,10 @@ enum {
 };

 struct mlx4_cqe {
-	uint32_t	my_qpn;
+	uint32_t	vlan_my_qpn;
 	uint32_t	immed_rss_invalid;
 	uint32_t	g_mlpath_rqpn;
-	uint8_t		sl;
-	uint8_t		reserved1;
+	uint16_t	sl_vid;
 	uint16_t	rlid;
 	uint32_t	reserved2;
 	uint32_t	byte_cnt;
@@ -98,7 +102,7 @@ struct mlx4_cqe {
 };

 struct mlx4_err_cqe {
-	uint32_t	my_qpn;
+	uint32_t	vlan_my_qpn;
 	uint32_t	reserved1[5];
 	uint16_t	wqe_index;
 	uint8_t		vendor_err;
@@ -136,7 +140,7 @@ static void mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe, struct ibv_wc *wc)
 		printf(PFX "local QP operation err "
 		       "(QPN %06x, WQE index %x, vendor syndrome %02x, "
 		       "opcode = %02x)\n",
-		       htonl(cqe->my_qpn), htonl(cqe->wqe_index),
+		       htonl(cqe->vlan_my_qpn), htonl(cqe->wqe_index),
 		       cqe->vendor_err,
 		       cqe->owner_sr_opcode & ~MLX4_CQE_OWNER_MASK);

@@ -215,21 +219,20 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	 */
 	rmb();

-	qpn = ntohl(cqe->my_qpn);
+	qpn = ntohl(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK;

 	is_send  = cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
 	is_error = (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
 		MLX4_CQE_OPCODE_ERROR;

 	if (!*cur_qp ||
-	    (ntohl(cqe->my_qpn) & 0xffffff) != (*cur_qp)->ibv_qp.qp_num) {
+	    (qpn != (*cur_qp)->ibv_qp.qp_num)) {
 		/*
 		 * We do not have to take the QP table lock here,
 		 * because CQs will be locked while QPs are removed
 		 * from the table.
 		 */
-		*cur_qp = mlx4_find_qp(to_mctx(cq->ibv_cq.context),
-				       ntohl(cqe->my_qpn) & 0xffffff);
+		*cur_qp = mlx4_find_qp(to_mctx(cq->ibv_cq.context), qpn);
 		if (!*cur_qp)
 			return CQ_POLL_ERR;
 	}
@@ -314,7 +317,7 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		}

 		wc->slid	   = ntohs(cqe->rlid);
-		wc->sl		   = cqe->sl >> 4;
+		wc->sl		   = ntohs(cqe->sl_vid) >> 12;
 		g_mlpath_rqpn	   = ntohl(cqe->g_mlpath_rqpn);
 		wc->src_qp	   = g_mlpath_rqpn & 0xffffff;
 		wc->dlid_path_bits = (g_mlpath_rqpn >> 24) & 0x7f;
@@ -405,7 +408,7 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 	 */
 	while ((int) --prod_index - (int) cq->cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibv_cq.cqe);
-		if ((ntohl(cqe->my_qpn) & 0xffffff) == qpn) {
+		if ((ntohl(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK) == qpn) {
 			if (srq && !(cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK))
 				mlx4_free_srq_wqe(srq, ntohs(cqe->wqe_index));
 			++nfreed;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
