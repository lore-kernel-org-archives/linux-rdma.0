From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 3/5] mlx4: Don't nest container_of
Date: Thu, 14 Dec 2017 15:35:41 -0700
Message-ID: <20171214223544.30117-4-jgg@ziepe.ca>
References: <20171214223544.30117-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171214223544.30117-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Makes no sense, just use the full path to the substructure member.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index ef0c7cb9c9a733..a71e42f5c6e25f 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -275,14 +275,12 @@ static inline struct mlx4_cq *to_mcq(struct ibv_cq *ibcq)
 
 static inline struct mlx4_srq *to_msrq(struct ibv_srq *ibsrq)
 {
-	return container_of(container_of(ibsrq, struct verbs_srq, srq),
-			    struct mlx4_srq, verbs_srq);
+	return container_of(ibsrq, struct mlx4_srq, verbs_srq.srq);
 }
 
 static inline struct mlx4_qp *to_mqp(struct ibv_qp *ibqp)
 {
-	return container_of(container_of(ibqp, struct verbs_qp, qp),
-			    struct mlx4_qp, verbs_qp);
+	return container_of(ibqp, struct mlx4_qp, verbs_qp.qp);
 }
 
 static inline struct mlx4_qp *wq_to_mqp(struct ibv_wq *ibwq)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
