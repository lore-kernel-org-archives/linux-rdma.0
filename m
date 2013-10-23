From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 5/9] IB/mlx5: Fix srq free in destroy qp
Date: Wed, 23 Oct 2013 09:53:17 +0300
Message-ID: <1382511201-7061-6-git-send-email-eli@mellanox.com>
References: <1382511201-7061-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382511201-7061-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On destroy QP the driver walks over the relevant CQ and removes CQEs reported
for the destroyed QP. It also frees the related SRQ entry without checking that
this is actually SRQ related CQE.  In case of a CQ used for both send and
receive QP, we could free srq entries for send CQEs.  This patch resolves this
issue by verifying that this is a SRQ related CQE by checking the SRQ number in
the CQE is not zero.

Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index e7c64c5..8459186 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -750,17 +750,9 @@ int mlx5_ib_destroy_cq(struct ib_cq *cq)
 	return 0;
 }
 
-static int is_equal_rsn(struct mlx5_cqe64 *cqe64, struct mlx5_ib_srq *srq,
-			u32 rsn)
+static int is_equal_rsn(struct mlx5_cqe64 *cqe64, u32 rsn)
 {
-	u32 lrsn;
-
-	if (srq)
-		lrsn = be32_to_cpu(cqe64->srqn) & 0xffffff;
-	else
-		lrsn = be32_to_cpu(cqe64->sop_drop_qpn) & 0xffffff;
-
-	return rsn == lrsn;
+	return rsn == (ntohl(cqe64->sop_drop_qpn) & 0xffffff);
 }
 
 void __mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 rsn, struct mlx5_ib_srq *srq)
@@ -790,8 +782,8 @@ void __mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 rsn, struct mlx5_ib_srq *srq)
 	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibcq.cqe);
 		cqe64 = (cq->mcq.cqe_sz == 64) ? cqe : cqe + 64;
-		if (is_equal_rsn(cqe64, srq, rsn)) {
-			if (srq)
+		if (is_equal_rsn(cqe64, rsn)) {
+			if (srq && (ntohl(cqe64->srqn) & 0xffffff))
 				mlx5_ib_free_srq_wqe(srq, be16_to_cpu(cqe64->wqe_counter));
 			++nfreed;
 		} else if (nfreed) {
-- 
1.8.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
