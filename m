From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/5] mlx5: Add read_flow_tag implementation
Date: Wed,  5 Apr 2017 18:19:24 +0300
Message-ID: <1491405564-19735-6-git-send-email-yishaih@mellanox.com>
References: <1491405564-19735-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491405564-19735-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Each steering flow may be marked with a tag which exposed in the
completion. Implement read_flow_tag which allows reading the flow tag
from the work completion.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c    | 9 +++++++++
 providers/mlx5/mlx5.h  | 4 ++++
 providers/mlx5/verbs.c | 3 ++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 85d0c33..2e8b584 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -1196,6 +1196,13 @@ static inline uint16_t mlx5_cq_read_wc_cvlan(struct ibv_cq_ex *ibcq)
 	return be16toh(cq->cqe64->vlan_info);
 }
 
+static inline uint32_t mlx5_cq_read_flow_tag(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return be32toh(cq->cqe64->sop_drop_qpn) & MLX5_FLOW_TAG_MASK;
+}
+
 #define BIT(i) (1UL << (i))
 
 #define SINGLE_THREADED BIT(0)
@@ -1270,6 +1277,8 @@ void mlx5_cq_fill_pfns(struct mlx5_cq *cq, const struct ibv_cq_init_attr_ex *cq_
 		cq->ibv_cq.read_completion_ts = mlx5_cq_read_wc_completion_ts;
 	if (cq_attr->wc_flags & IBV_WC_EX_WITH_CVLAN)
 		cq->ibv_cq.read_cvlan = mlx5_cq_read_wc_cvlan;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_FLOW_TAG)
+		cq->ibv_cq.read_flow_tag = mlx5_cq_read_flow_tag;
 }
 
 int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index bb383d4..0de40a8 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -184,6 +184,10 @@ enum mlx5_vendor_cap_flags {
 	MLX5_VENDOR_CAP_FLAGS_MPW		= 1 << 0,
 };
 
+enum {
+	MLX5_FLOW_TAG_MASK	= 0x000fffff,
+};
+
 struct mlx5_resource {
 	enum mlx5_rsc_type	type;
 	uint32_t		rsn;
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index b7a8502..f0e4aab 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -328,7 +328,8 @@ static int qp_sig_enabled(void)
 enum {
 	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS	|
 				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
-				       IBV_WC_EX_WITH_CVLAN
+				       IBV_WC_EX_WITH_CVLAN |
+				       IBV_WC_EX_WITH_FLOW_TAG
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
