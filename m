From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/7] mlx5: Add read_cvlan support
Date: Tue, 14 Mar 2017 13:15:41 +0200
Message-ID: <1489490143-29018-6-git-send-email-yishaih@mellanox.com>
References: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489490143-29018-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When a WQ or a QP is created with cvlan stripping option, the cvlan
is stripped from the packet by the hardware and included in the work
completion.

Add a function to allow reading the cvlan from the work completion.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c    | 9 +++++++++
 providers/mlx5/verbs.c | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 4ecd482..85d0c33 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -1189,6 +1189,13 @@ static inline uint64_t mlx5_cq_read_wc_completion_ts(struct ibv_cq_ex *ibcq)
 	return be64toh(cq->cqe64->timestamp);
 }
 
+static inline uint16_t mlx5_cq_read_wc_cvlan(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return be16toh(cq->cqe64->vlan_info);
+}
+
 #define BIT(i) (1UL << (i))
 
 #define SINGLE_THREADED BIT(0)
@@ -1261,6 +1268,8 @@ void mlx5_cq_fill_pfns(struct mlx5_cq *cq, const struct ibv_cq_init_attr_ex *cq_
 		cq->ibv_cq.read_dlid_path_bits = mlx5_cq_read_wc_dlid_path_bits;
 	if (cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)
 		cq->ibv_cq.read_completion_ts = mlx5_cq_read_wc_completion_ts;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_CVLAN)
+		cq->ibv_cq.read_cvlan = mlx5_cq_read_wc_cvlan;
 }
 
 int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 4d8f26c..67f9748 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -327,7 +327,8 @@ static int qp_sig_enabled(void)
 
 enum {
 	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS	|
-				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
+				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
+				       IBV_WC_EX_WITH_CVLAN
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
