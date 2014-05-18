From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] mlx5: Simplify signature handover wqe for interleaved buffers
Date: Sun, 18 May 2014 18:32:39 +0300
Message-ID: <1400427160-11314-3-git-send-email-sagig@mellanox.com>
References: <1400427160-11314-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400427160-11314-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

No need for repetition format pattern in case the data and
protection are already interleaved in the memory domain
since the pattern already exists. A single key entry is
sufficient and may save some extra fetch ops.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 410d3a0..242fb2d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2119,9 +2119,13 @@ static int set_sig_data_segment(struct ib_send_wr *wr, struct mlx5_ib_qp *qp,
 	int ret;
 	int wqe_size;
 
-	if (!wr->wr.sig_handover.prot) {
+	if (!wr->wr.sig_handover.prot ||
+	    (data_key == wr->wr.sig_handover.prot->lkey &&
+	     data_va == wr->wr.sig_handover.prot->addr &&
+	     data_len == wr->wr.sig_handover.prot->length)) {
 		/**
 		 * Source domain doesn't contain signature information
+		 * or data and protection are interleaved in memory.
 		 * So need construct:
 		 *                  ------------------
 		 *                 |     data_klm     |
@@ -2175,23 +2179,13 @@ static int set_sig_data_segment(struct ib_send_wr *wr, struct mlx5_ib_qp *qp,
 		data_sentry->bcount = cpu_to_be16(block_size);
 		data_sentry->key = cpu_to_be32(data_key);
 		data_sentry->va = cpu_to_be64(data_va);
+		data_sentry->stride = cpu_to_be16(block_size);
+
 		prot_sentry->bcount = cpu_to_be16(prot_size);
 		prot_sentry->key = cpu_to_be32(prot_key);
+		prot_sentry->va = cpu_to_be64(prot_va);
+		prot_sentry->stride = cpu_to_be16(prot_size);
 
-		if (prot_key == data_key && prot_va == data_va) {
-			/**
-			 * The data and protection are interleaved
-			 * in a single memory region
-			 **/
-			prot_sentry->va = cpu_to_be64(data_va + block_size);
-			prot_sentry->stride = cpu_to_be16(block_size + prot_size);
-			data_sentry->stride = prot_sentry->stride;
-		} else {
-			/* The data and protection are two different buffers */
-			prot_sentry->va = cpu_to_be64(prot_va);
-			data_sentry->stride = cpu_to_be16(block_size);
-			prot_sentry->stride = cpu_to_be16(prot_size);
-		}
 		wqe_size = ALIGN(sizeof(*sblock_ctrl) + sizeof(*data_sentry) +
 				 sizeof(*prot_sentry), 64);
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
